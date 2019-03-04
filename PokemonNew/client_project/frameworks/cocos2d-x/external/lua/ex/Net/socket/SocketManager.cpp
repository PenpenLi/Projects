/************************************************************************/
/*                                                                      */
/************************************************************************/
#include "SocketManager.h"
#include "cocos2d.h"
#include <iostream>

USING_NS_CC;

namespace net 
{
    const unsigned int kRecvBufHeaderLen = sizeof(unsigned int) + sizeof(int);
    
    //
    ClientSocket::ClientSocket()
    : _port(0)
    , _isConnected(false)
    , _isConnecting(false)
    , _recvBuffer(NULL)
    , _totalRecvBuffer(NULL)
    , _recvBufferLen(0)
    , _recvBufferOffset(0)
    , _socketManager(nullptr)
    {
        
    }
    
    //
    ClientSocket::~ClientSocket()
    {
        if (NULL != _totalRecvBuffer)
        {
            delete [] _totalRecvBuffer;
            _totalRecvBuffer = NULL;
        }
    }
    
    //
    void ClientSocket::init(SocketManager* socketManager, eSocketType type, const std::string &ip, unsigned short port)
    {
        _ip = ip;
        _port = port;
        _type = type;
        _socketManager = socketManager;

        _recvBufferLen = kRECV_BUFF_LEN;
        // this adding sizeof(uint) buffer is inorder to enough space for save current
        // received from connection index, while, to
        _totalRecvBuffer = new char[_recvBufferLen + kRecvBufHeaderLen];
        _recvBuffer = _totalRecvBuffer + kRecvBufHeaderLen;
        _recvBufferOffset = 0;
    }
    
    //
    bool ClientSocket::open(eSocketType type, const std::string &ip, unsigned short port)
    {
        if (Create(AF_INET, type, 0))
        {
            setIpPort(ip, port);
            if (!Connect(_ip.c_str(), _port))
            {
                Close();
                return false;
            }
            return true;
        }
        return false;
    }
    
    //
    SOCKET ClientSocket::getSocket() const
    {
        return m_sock;
    }
    
    //
    void ClientSocket::setIpPort(const std::string &ip, unsigned short port)
    {
        _ip = ip;
        _port = port;
    }
    
    //
    const char * ClientSocket::getIp() const
    {
        return _ip.c_str();
    }
    
    //
    unsigned short ClientSocket::getPort() const
    {
        return _port;
    }
    
    //
    bool ClientSocket::isConnected()
    {
        return _isConnected;
    }
    
    //
    void ClientSocket::setConnected(bool connected)
    {
        _isConnected = connected;
    }
    
    //
    bool ClientSocket::isConnecting()
    {
        return _isConnecting;
    }
    
    //
    void ClientSocket::setConnecting(bool connecting)
    {
        _isConnecting = connecting;
    }
    
    //
    eSocketType ClientSocket::getSocketType()
    {
        return _type;
    }
    
    //
    bool ClientSocket::parseBufferLen(unsigned int connIndex, const char *szBuff, size_t size, unsigned int &len)
    {
        if (size >= 4)
        {
            len = ntohl(*reinterpret_cast<const unsigned int*>(szBuff));
            return true;
            
        }
        return false;
    }
    
    //
    bool ClientSocket::PostRecvMessageFrom(unsigned int connIndex)
    {
        if ( NULL == _recvBuffer)
        {
            return false;
        }
        int len = _recvBufferLen - _recvBufferOffset;
        int readLen = 0;
        unsigned int msg_len;
        int curLen = 0;
        char *pStart = _recvBuffer;
        char *pEnd = _recvBuffer;

        while (len > 0)
        {
            readLen = len > _recvBufferLen - _recvBufferOffset ? _recvBufferLen - _recvBufferOffset : len;
            readLen = this->Recv(_recvBuffer + _recvBufferOffset, readLen, kSocketFlag_NOSIGNAL);
            
            //CCLOG("recv buff zzzzzzzz %d size.", readLen);
            if (readLen <= 0)
            {
                _recvBufferOffset = 0;
                _socketManager->_check_error_on_sock(connIndex, this, readLen);
                return false;
            }
            if (readLen < len)
            {
                len = readLen;
            }
            
            pStart = _recvBuffer;
            pEnd = _recvBuffer + _recvBufferOffset + readLen;
            while (pStart < pEnd)
            {
                curLen = int(pEnd - pStart);
                
                bool ret = parseBufferLen(connIndex, pStart, curLen, msg_len);
                
                if (msg_len == 0 || msg_len > (unsigned int)_recvBufferLen)
                {
                    CCLOG("Fatal: parsed body len bigger than limit: parsedLen:[%d] limit:[%d]", msg_len, _recvBufferLen);
                    _recvBufferOffset = 0;
                    _socketManager->_check_error_on_sock(connIndex, this, 0);
                    return false;
                }
                
                if (!ret || msg_len > (unsigned int)curLen)
                {
                    _recvBufferOffset = curLen;
                    memmove(_recvBuffer, pStart, _recvBufferOffset);
                    break;
                }
                
                if (!_socketManager->_do_post_recved_buff(pStart, msg_len, kSockStatus_OK, connIndex))
                {
                    return false;
                }
                
                pStart += msg_len;
                
                if (pStart == pEnd)
                {
                    _recvBufferOffset = 0;
                    break;
                }
            }
            
            len -= readLen;
            if (len > 0)
            {
                readLen = len > _recvBufferLen ? _recvBufferLen : len;
            }
        }
        return true;
    }
    
    //
    SocketManager::SocketManager()
        : m_maxsock(0)
    #ifdef _WIN32
        , m_wsainited(false)
    #endif
        , m_isRunning(false)
        , m_isDispatching(false)
        , m_pCodeBuffer(NULL)
        , m_iCodeBufferLen(0)
    {

        FD_ZERO(&m_rfds);
        FD_ZERO(&m_wfds);
        FD_ZERO(&m_efds);
    }

    //
    SocketManager::~SocketManager()
    {
        if (NULL != m_pCodeBuffer)
        {
            delete [] m_pCodeBuffer;
            m_pCodeBuffer = NULL;
        }
        if (m_isRunning)
        {
            m_isRunning = false;
            SLEEP_MS(1000);  // wait for thread close
        }
        for (ClientSocketMap_t::iterator iter = m_clientSocketMap.begin();
            iter != m_clientSocketMap.end(); ++iter)
        {
            if (iter->second)
            {
                //m_socketHandler.Remove(iter->second);
                iter->second->Close();
                delete iter->second;
                iter->second = NULL;
            }
        }
        m_clientSocketMap.clear();


        
    #ifdef _WIN32
        if (m_wsainited)
        {
            BSDSocket::Clean();
            m_wsainited = false;
        }
    #endif
    }

    //
    bool SocketManager::init()
    {
    #ifdef _WIN32
        if (!m_wsainited)
        {
            BSDSocket::Init();
            m_wsainited = true;
        }
    #endif
        
        //
        if (NULL != m_pCodeBuffer)
        {
            delete [] m_pCodeBuffer;
        }
        m_iCodeBufferLen = kSEND_BUFF_LEN;
        m_pCodeBuffer = new char[m_iCodeBufferLen];
        
        //
        InstallMessageQueue();

        return true;
    }

    //
    void SocketManager::Run()
    {
        int code = 0;
        int n = 0;
        //int nBytes;
        struct timeval _sel_tv;
        _sel_tv.tv_sec = 0;
        _sel_tv.tv_usec = 100;
        m_isRunning = true;
        while (m_isRunning)
        {
            _check_deleting();
            _check_adding();

            if (m_clientSocketMap.empty())
            {
                SLEEP_MS(100);
                continue;
            }
            PACKAGE msg;
            code = m_msgQueue.PeekMessage(CMessageQueue::enm_queue_client_send, &msg, 0, PM_NOREMOVE);
            if (code == 0)
            {
                // first 4-byte save for connection index
                const unsigned int *pIndex = (unsigned int *)(msg.buffer);
                ClientSocket *sock = getConnectByIndex(*pIndex);
                if (NULL != sock && sock->isConnected())
                {
                    // sending data start after the 4-byte
                    const char *sendBuff = msg.buffer + sizeof(unsigned int);
                    int len = sock->Send(sendBuff, msg.length - sizeof(unsigned int), kSocketFlag_NOSIGNAL);
                    if (len < 0)
                    {
                        _check_error_on_sock(*pIndex, sock, -1);
                    }
                    m_msgQueue.PeekMessage(CMessageQueue::enm_queue_client_send, &msg, 0, PM_REMOVE);
                    //CCLOG("send buff xxxxxxxx %d size.", len);
                }
            }

            n = sockes_select(&_sel_tv);

            SLEEP_MS(30);
        }
    }

    //
    bool SocketManager::addConnect(unsigned int connIndex, const std::string &ip, unsigned short port)
    {
        ClientSocketMap_t::iterator iter = m_clientSocketMap.find(connIndex);
        if (iter != m_clientSocketMap.end())
        {
            CCLOG("client socket has find connindex[%d]", connIndex);
            return false;
        }
        iter = m_addingSocketMap.find(connIndex);
        if (iter != m_addingSocketMap.end())
        {
            CCLOG("adding socket has find connindex[%d]", connIndex);
            return false;
        }

        ClientSocket *s = new ClientSocket();
        s->SetNoBlock(false);

        s->init(this, kSockType_TCP, ip, port);

        m_addingSocketMap.insert(std::make_pair(connIndex, s));

        return true;
    }

    //
    bool SocketManager::removeConnect(unsigned int connIndex)
    {
        ClientSocketMap_t::iterator iter = m_clientSocketMap.find(connIndex);
        if (iter != m_clientSocketMap.end())
        {
            ClientSocket *sock = iter->second;
            SOCKET removeS = 0;
            if (sock)
            {
                sock->Close();
                removeS = sock->getSocket();
                m_deletingSocketMap[iter->first] = iter->second;
            }

            CCLOG("old maxsock:%d", m_maxsock);
            m_maxsock = 0;
            for (ClientSocketMap_t::iterator it = m_clientSocketMap.begin(); it != m_clientSocketMap.end(); ++it)
            {
                SOCKET s = it->second->getSocket();
                if (s != removeS)
                    m_maxsock = s > m_maxsock ? s : m_maxsock;
            }
            CCLOG("new maxsock:%d", m_maxsock);
        }

        return true;
    }

    //
    bool SocketManager::_remove_connect(unsigned int connIndex)
    {
        ClientSocketMap_t::iterator iter = m_clientSocketMap.find(connIndex);
        if (iter != m_clientSocketMap.end())
        {
            m_clientSocketMap.erase(iter);

            m_maxsock = 0;
            for (ClientSocketMap_t::iterator it = m_clientSocketMap.begin(); it != m_clientSocketMap.end(); ++it)
            {
                SOCKET s = it->second->getSocket();
                m_maxsock = s > m_maxsock ? s : m_maxsock;
            }
            return true;
        }
        return false;
    }

    //
    void SocketManager::InstallMessageQueue()
    {
        int len = kSEND_QUEUE_BUFF_LEN;
        char* p = new char[len];
        m_msgQueue.Install(CMessageQueue::enm_queue_client_send, p, len);
        len = kRECV_QUEUE_BUFF_LEN;
        p = new char[len];
        m_msgQueue.Install(CMessageQueue::enm_queue_client_recv, p, len);
    }

    //
    void SocketManager::clearSocket()
    {
        for (ClientSocketMap_t::iterator it = m_clientSocketMap.begin(); 
            it != m_clientSocketMap.end(); ++it)
        {
            if (it->second) {
                it->second->Close();
                delete it->second;
            }
        }

        m_clientSocketMap.clear();
    }

    //
    bool SocketManager::SendMessage(unsigned int connIndex, const char *szBuff, size_t len)
    {
        if (getConnectByIndex(connIndex) == NULL)
        {
            return false;
        }
        // first 4-bytes save the connection index
        unsigned int *pIndex = (unsigned int*)m_pCodeBuffer;
        *pIndex = connIndex;
        // the bellow buffer save the sending data
        char *pCursor = m_pCodeBuffer + sizeof(unsigned int);
        memcpy(pCursor, szBuff, len);
        pCursor += len;

        int code = m_msgQueue.PostMessage(CMessageQueue::enm_queue_client_send, m_pCodeBuffer, uint32_t(pCursor - m_pCodeBuffer));
        return (code == 0) ? true : false;
    }

    //
    int SocketManager::PeekMessage(char *szDstBuff, size_t len, unsigned int &connIndex, int &sockStatus)
    {
        PACKAGE msg;
        int code = m_msgQueue.PeekMessage(CMessageQueue::enm_queue_client_recv, &msg, 0, PM_NOREMOVE);
        if (code == 0)
        {
            if (msg.length - kRecvBufHeaderLen <= len)
            {
                // real received data started from 4-byte after the msg.buffer,
                // the first 4-byte data saves the connection index
                memcpy(szDstBuff, msg.buffer + kRecvBufHeaderLen, msg.length - kRecvBufHeaderLen );
                sockStatus = *((int*)msg.buffer);
                connIndex = *((unsigned int*)(msg.buffer + sizeof(int)));
                m_msgQueue.PeekMessage(CMessageQueue::enm_queue_client_recv, &msg, 0, PM_REMOVE);
                return msg.length;
            }
            else
            {
                CCLOG("Error: PeekMessage(socket) buffer_len:[%zu] smaller than msg.length:[%d]",
                      len, msg.length - kRecvBufHeaderLen);
            }

            m_msgQueue.PeekMessage(CMessageQueue::enm_queue_client_recv, &msg, 0, PM_REMOVE);
            sockStatus = -1;
            return -1;
        }
        sockStatus = -1;
        return -1;
    }

    //
    ClientSocket* SocketManager::getConnectByIndex(unsigned int index)
    {
        ClientSocketMap_t::iterator iter = m_clientSocketMap.find(index);
        if (iter != m_clientSocketMap.end())
        {
            return iter->second;
        }
        return NULL;
    }

    //
    void SocketManager::onConnect(unsigned int connIndex, ClientSocket *sock)
    {
        do 
        {
            CC_BREAK_IF(!sock);

            ClientSocketMap_t::const_iterator iter = m_clientSocketMap.find(connIndex);
            CC_BREAK_IF(iter == m_clientSocketMap.end());
            
            sock->setConnected(true);

            CCLOG("onConnect connIndex:[%d] address:[%s:%d] connected success.", connIndex, sock->getIp(), sock->getPort());
            char buff[kRecvBufHeaderLen+1];
            _do_post_recved_buff(buff+kRecvBufHeaderLen, 0, kSockStatus_Connect, connIndex);

        } while (0);
    }

    //
    void SocketManager::onDisconnected(unsigned int connIndex, ClientSocket *sock, int sockStatus)
    {
        do 
        {
            CC_BREAK_IF(!sock);

            ClientSocketMap_t::iterator iter = m_clientSocketMap.find(connIndex);
            if (iter != m_clientSocketMap.end())
            {
                m_deletingSocketMap[iter->first] = iter->second;
            }

            CCLOG("onDisconnected connIndex:[%d] address:[%s:%d] disconnected.", connIndex, sock->getIp(), sock->getPort());
            char buff[kRecvBufHeaderLen+1];
            _do_post_recved_buff(buff+kRecvBufHeaderLen, 0, sockStatus, connIndex);
            

        } while (0);
    }

    //
    void SocketManager::onConnectFailed(unsigned int connIndex, ClientSocket *sock)
    {
        do 
        {
            CC_BREAK_IF(!sock);

            m_deletingSocketMap[connIndex] = sock;

            CCLOG("onConnectFailed connIndex:[%d] address:[%s:%d] connect failed.", connIndex, sock->getIp(), sock->getPort());
            char buff[kRecvBufHeaderLen+1];
            _do_post_recved_buff(buff+kRecvBufHeaderLen, 0, kSockStatus_ConnFailed, connIndex);

        } while (0);
    }

    //
    void SocketManager::_check_adding()
    {
        if (!m_addingSocketMap.empty())
        {
            ClientSocket *pSock = NULL;
            for (ClientSocketMap_t::iterator iter = m_addingSocketMap.begin(); iter != m_addingSocketMap.end(); ++iter)
            {
                pSock = iter->second;
                if (!pSock)
                {
                    continue;
                }
                if(!pSock->open(pSock->getSocketType(), pSock->getIp(), pSock->getPort()))
                {
                    onConnectFailed(iter->first, pSock);
                    continue;
                }

                set_socket_fd(pSock->getSocket(), true, false, true);
                m_maxsock = pSock->getSocket() > m_maxsock ? pSock->getSocket() : m_maxsock;
                m_clientSocketMap[iter->first] = pSock;	

                onConnect(iter->first, pSock);   
            }
            m_addingSocketMap.clear();
        }
    }

    //
    void SocketManager::_check_deleting()
    {
        if (!m_deletingSocketMap.empty())
        {
            ClientSocket *sock = NULL;
            for (ClientSocketMap_t::iterator iter = m_deletingSocketMap.begin(); iter != m_deletingSocketMap.end(); ++iter)
            {
                _remove_connect(iter->first);
                
                sock = iter->second;
                if (sock)
                {
                    set_socket_fd(sock->getSocket(), false, false, false);
                    sock->Close();
                    delete sock;
                }
            }
            m_deletingSocketMap.clear();
        }
    }

    //
    void SocketManager::set_socket_fd(SOCKET s, bool bRead, bool bWrite, bool bException)
    {
        if (s >= 0)
        {
            if (bRead)
            {
                if (!FD_ISSET(s, &m_rfds))
                {
                    FD_SET(s, &m_rfds);
                }
            }
            else
            {
                FD_CLR(s, &m_rfds);
            }
            if (bWrite)
            {
                if (!FD_ISSET(s, &m_wfds))
                {
                    FD_SET(s, &m_wfds);
                }
            }
            else
            {
                FD_CLR(s, &m_wfds);
            }
            if (bException)
            {
                if (!FD_ISSET(s, &m_efds))
                {
                    FD_SET(s, &m_efds);
                }
            }
            else
            {
                FD_CLR(s, &m_efds);
            }
        }
    }

    //
    void SocketManager::rebuild_fdset()
    {
        fd_set rfds;
        fd_set wfds;
        fd_set efds;
        // rebuild fd_set's from active sockets list (m_sockets) here
        FD_ZERO(&rfds);
        FD_ZERO(&wfds);
        FD_ZERO(&efds);

        std::vector<unsigned int> rmConnIndexVec;
        for (ClientSocketMap_t::iterator it = m_clientSocketMap.begin(); 
            it != m_clientSocketMap.end(); ++it)
        {
            SOCKET s = it->second->getSocket();;
            ClientSocket *p = it -> second;
            if (s >= 0)
            {
                fd_set fds;
                FD_ZERO(&fds);
                FD_SET(s, &fds);
                struct timeval tv;
                tv.tv_sec = 0;
                tv.tv_usec = 0;
                int n = select((int)s + 1, &fds, NULL, NULL, &tv);
                if (n == -1 && BSDSocket::GetError() == EBADF)
                {
                    // %! bad fd, remove
                    // DeleteSocket(p);
                    p->setConnected(false);
                    set_socket_fd(s, false, false, false);
                    rmConnIndexVec.push_back(it->first);
                }
                else
                {
                    if (FD_ISSET(s, &m_rfds))
                        FD_SET(s, &rfds);
                    if (FD_ISSET(s, &m_wfds))
                        FD_SET(s, &wfds);
                    if (FD_ISSET(s, &m_efds))
                        FD_SET(s, &efds);
                }
            }
            else
            {
                // %! mismatch
                // DeleteSocket(p);
                p->setConnected(false);
                set_socket_fd(s, false, false, false);
                rmConnIndexVec.push_back(it->first);
            }
        }
        m_rfds = rfds;
        m_wfds = wfds;
        m_efds = efds;
    }
    
    //
    int SocketManager::sockes_select(struct timeval *tsel)
    {
    #ifdef MACOSX
        fd_set rfds;
        fd_set wfds;
        fd_set efds;
        FD_COPY(&m_rfds, &rfds);
        FD_COPY(&m_wfds, &wfds);
        FD_COPY(&m_efds, &efds);
    #else
        fd_set rfds = m_rfds;
        fd_set wfds = m_wfds;
        fd_set efds = m_efds;
    #endif
        int n;
        n = select( (int)(m_maxsock + 1),&rfds,&wfds,&efds,tsel);
        
        if (n == -1) // error on select
        {
            int err = BSDSocket::GetError();
            /*
                EBADF  An invalid file descriptor was given in one of the sets.
                EINTR  A non blocked signal was caught.
                EINVAL n is negative. Or struct timeval contains bad time values (<0).
                ENOMEM select was unable to allocate memory for internal tables.
            */
    #ifdef _WIN32
            switch (err)
            {
            case WSAENOTSOCK:
                rebuild_fdset();
                CCLOG("__XX_SOCK_ERROR__ select err: %d rebuild fdset", err);
                break;
            case WSAEINTR:
            case WSAEINPROGRESS:
                CCLOG("__XX_SOCK_ERROR__ select err WSAEINTR:%d|WSAEINPROGRESS:%d err:%d", WSAEINTR, WSAEINPROGRESS, err);
                break;
            case WSAEINVAL:
                CCLOG("__XX_SOCK_ERROR__ select err WSAEINVAL:%d", err);
                //throw Exception("select(n): n is negative. Or struct timeval contains bad time values (<0).");
                break;
            case WSAEFAULT:
                CCLOG("__XX_SOCK_ERROR__ select err WSAEFAULT:%d", err);
                //LogError(NULL, "SocketHandler::Select", err, StrError(err), LOG_LEVEL_ERROR);
                break;
            case WSANOTINITIALISED:
                CCLOG("__XX_SOCK_ERROR__ select err WSANOTINITIALISED:%d", err);
                //throw Exception("WSAStartup not successfully called");
                break;
            case WSAENETDOWN:
                CCLOG("__XX_SOCK_ERROR__ select err WSAENETDOWN:%d", err);
                //throw Exception("Network subsystem failure");
                break;
            }
    #else
            switch (err)
            {
            case EBADF:
                rebuild_fdset();
                CCLOG("__XX_SOCK_ERROR__ select err rebuild fdset EBADF:%d", err);
                break;
            case EINTR:
                CCLOG("__XX_SOCK_ERROR__ select err EINTR:%d", err);
                break;
            case EINVAL:
                CCLOG("__XX_SOCK_ERROR__ select err EINVAL:%d", err);
                //throw Exception("select(n): n is negative. Or struct timeval contains bad time values (<0).");
                break;
            case ENOMEM:
                CCLOG("__XX_SOCK_ERROR__ select err ENOMEM:%d", err);
                //LogError(NULL, "SocketHandler::Select", err, StrError(err), LOG_LEVEL_ERROR);
                break;
            }
    #endif
            //printf("error on select(): %d %s\n", Errno, StrError(err));
        }
        else if (!n) // timeout
        {
            rebuild_fdset();
        }
        else if (n > 0)
        {
            m_isDispatching = true;
            for (ClientSocketMap_t::iterator it = m_clientSocketMap.begin(); 
                it != m_clientSocketMap.end(); ++it)
            {
                SOCKET s = it->second->getSocket();
                ClientSocket *p = it -> second;
                if (FD_ISSET(s, &rfds))
                {
                    p->PostRecvMessageFrom(it->first);
                }
                if (FD_ISSET(s, &wfds))
                {
                    // used for non block mode
                    // 				if (p->is_connecting())
                    // 				{
                    // 					int err = BSDSocket::GetError();
                    // 					{
                    // 						set_socket_fd(s, true, false, true);
                    // 						p->_set_connecting(false);
                    // 						onConnect(it->first, p);
                    // 					}
                    // 				}
                }
                if (FD_ISSET(s, &efds))
                {
                    //p -> OnException();
                    int err = BSDSocket::GetError();
                    CCLOG("__SELECT_ERROR__ connIndex:%d sock:%d exception errorCode:%d", it->first, s, err);
                }
            } // m_sockets ...
            m_isDispatching = false;

        } // if (n > 0)
        return n;
    }
    
    //
    void SocketManager::_check_error_on_sock( unsigned int connIndex, ClientSocket *sock, int sockStatus )
    {
        // normal error codes:
        // WSAEWOULDBLOCK
        // EAGAIN or EWOULDBLOCK
        int err = BSDSocket::GetError();
    #ifdef _WIN32
        if (err != WSAEWOULDBLOCK)
    #else
        if (sockStatus == 0 || (err != EINTR && err != EWOULDBLOCK && err != EAGAIN))
    #endif
        {
            set_socket_fd(sock->getSocket(), false, false, false);
            if(sockStatus == 0)
                onDisconnected(connIndex, sock, kSockStatus_Close);
            else
                onDisconnected(connIndex, sock, kSockStatus_Broken);

			//m_msgQueue.clear();
        }
    }
    
    //
    bool SocketManager::_do_post_recved_buff( char *pStart, unsigned int msgLen , int sockStatus, unsigned int connIndex )
    {
        // format 4-byte connection status and 4-byte connection index
        // on the addres before pStart, thus, the 4-bytes space is enough
        // and dirty now before pStart, so, this operation is safe.
        char *pPostAddr = pStart - kRecvBufHeaderLen;
        *((int*)pPostAddr) = sockStatus;
        *((unsigned int*)(pPostAddr + sizeof(int))) = connIndex;

        if (m_msgQueue.PostMessage(CMessageQueue::enm_queue_client_recv, 
            pPostAddr, msgLen + kRecvBufHeaderLen) != 0)
        {
            return false;
        }
        return true;
    }

}   // namespace net
