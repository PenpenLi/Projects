#include "BSDSocket.h"
#include <stdio.h>
#include <string.h>

#ifdef WIN32
	#pragma comment(lib, "wsock32")
#endif



static bool isIPV6Net(char* domainStr = "www.baidu.com")
{
    bool isIPV6Net = false;

    struct addrinfo *result = nullptr,*curr;

    struct sockaddr_in6 dest;
    memset(&dest,0, sizeof(dest));

    dest.sin6_family  = AF_INET6;

    int ret = getaddrinfo(domainStr,nullptr,nullptr,&result);
    if (ret == 0)
    {
        for (curr = result; curr != nullptr; curr = curr->ai_next)
        {
            switch (curr->ai_family)
            {
                case AF_INET6:
                {
                    isIPV6Net = true;
                    break;
                }
                case AF_INET:

                    break;

                default:
                    break;
            }
        }
    }

    freeaddrinfo(result);

    return isIPV6Net;
}

BSDSocket::BSDSocket(SOCKET sock)
{
	m_sock = sock;
}

BSDSocket::~BSDSocket()
{
}

int BSDSocket::Init()
{
#ifdef WIN32
	/*
	http://msdn.microsoft.com/zh-cn/vstudio/ms741563(en-us,VS.85).aspx

	typedef struct WSAData { 
		WORD wVersion;								//winsock version
		WORD wHighVersion;							//The highest version of the Windows Sockets specification that the Ws2_32.dll can support
		char szDescription[WSADESCRIPTION_LEN+1]; 
		char szSystemStatus[WSASYSSTATUS_LEN+1]; 
		unsigned short iMaxSockets; 
		unsigned short iMaxUdpDg; 
		char FAR * lpVendorInfo; 
	}WSADATA, *LPWSADATA; 
	*/
	WSADATA wsaData;
	//#define MAKEWORD(a,b) ((WORD) (((BYTE) (a)) | ((WORD) ((BYTE) (b))) << 8)) 
	WORD version = MAKEWORD(2, 0);
	int ret = WSAStartup(version, &wsaData);//win sock start up
	if ( ret ) {
//		cerr << "Initilize winsock error !" << endl;
		return -1;
	}
#endif
	
	return 0;
}
//this is just for windows
int BSDSocket::Clean()
{
#ifdef WIN32
		return (WSACleanup());
#endif
		return 0;
}

BSDSocket& BSDSocket::operator = (SOCKET s)
{
	m_sock = s;
	return (*this);
}

BSDSocket::operator SOCKET ()
{
	return m_sock;
}
//create a socket object win/lin is the same
// af:
bool BSDSocket::Create(int af, int type, int protocol)
{
    is_ipv6 = isIPV6Net();
	if (is_ipv6)
	{
		m_sock = socket(AF_INET6, type, protocol);
	}
	else{
		m_sock = socket(af, type, protocol);
	}
	if ( m_sock == INVALID_SOCKET ) {
		return false;
	}
	return true;
}

bool BSDSocket::Connect(const char* ip, unsigned short port)
{
    if (is_ipv6)
    {
        struct sockaddr_in6 svraddr;
        struct addrinfo *result;
        getaddrinfo(ip, NULL, NULL, &result);
        const struct sockaddr *sa = result->ai_addr;
        //&svraddr = (struct sockaddr_in6 *)sa;
        // newIp = inet_pton(*(struct in_addr *)*hostG->h_addr_list);
        socklen_t maxlen = 128;
        char* newIp = (char* )ip;
        inet_ntop(AF_INET6, &(((struct sockaddr_in6 *)sa)->sin6_addr),newIp,maxlen);
        memset(&svraddr,0,sizeof(svraddr));
        svraddr.sin6_family = AF_INET6;
        svraddr.sin6_port = htons(port);
        if(inet_pton(AF_INET6,newIp,&svraddr.sin6_addr) < 0){
            return false;
        }
        freeaddrinfo(result);
        int ret = connect(m_sock, (struct sockaddr*)&svraddr, sizeof(svraddr));
        if ( ret == SOCKET_ERROR ) {
            return false;
        }
    }
    else
    {
        struct sockaddr_in svraddr;
        svraddr.sin_family = AF_INET;
        const char* newIp = ip;
        struct hostent* hostG = gethostbyname(ip);
        if (hostG) {
            newIp = inet_ntoa(*(struct in_addr *)*hostG->h_addr_list);
        }
        svraddr.sin_addr.s_addr = inet_addr(newIp);
        svraddr.sin_port = htons(port);
        int ret = connect(m_sock, (struct sockaddr*)&svraddr, sizeof(svraddr));
        if ( ret == SOCKET_ERROR ) {
            return false;
        }
    }
	
	return true;
}

bool BSDSocket::Bind(unsigned short port)
{
	if (is_ipv6)
    {
        struct sockaddr_in6 svraddr;
		svraddr.sin6_family = AF_INET6;
		//svraddr.sin6_addr.s_addr = INADDR_ANY;
		svraddr.sin6_port = htons(port);
        
        int opt =  1;
        if ( setsockopt(m_sock, IPPROTO_IPV6, IPV6_V6ONLY, (char*)&opt, sizeof(opt)) < 0 )
            return false;
        
        int ret = bind(m_sock, (struct sockaddr*)&svraddr, sizeof(svraddr));
        if ( ret == SOCKET_ERROR ) {
            return false;
        }
	}
    else{
        struct sockaddr_in svraddr;
		svraddr.sin_family = AF_INET;
		svraddr.sin_addr.s_addr = INADDR_ANY;
		svraddr.sin_port = htons(port);
        
        int opt =  1;
        if ( setsockopt(m_sock, SOL_SOCKET, SO_REUSEADDR, (char*)&opt, sizeof(opt)) < 0 )
            return false;
        
        int ret = bind(m_sock, (struct sockaddr*)&svraddr, sizeof(svraddr));
        if ( ret == SOCKET_ERROR ) {
            return false;
        }
	}

	return true;
}
//for server
bool BSDSocket::Listen(int backlog)
{
	int ret = listen(m_sock, backlog);
	if ( ret == SOCKET_ERROR ) {
		return false;
	}
	return true;
}

bool BSDSocket::Accept(BSDSocket& s, char* fromip)
{
	struct sockaddr_in cliaddr;
	socklen_t addrlen = sizeof(cliaddr);
	SOCKET sock = accept(m_sock, (struct sockaddr*)&cliaddr, &addrlen);
	if ( sock == SOCKET_ERROR ) {
		return false;
	}

	s = sock;
	if ( fromip != NULL )
		sprintf(fromip, "%s", inet_ntoa(cliaddr.sin_addr));

	return true;
}

int BSDSocket::Send(const char* buf, int len, int flags)
{
	int bytes;
	int count = 0;

	while ( count < len ) {

		bytes = send(m_sock, buf + count, len - count, flags);
		if ( bytes == -1 || bytes == 0 )
			return -1;
		count += bytes;
	} 

	return count;
}

int BSDSocket::Recv(char* buf, int len, int flags)
{
	return (recv(m_sock, buf, len, flags));
}

int BSDSocket::Close()
{
#ifdef WIN32
	return (closesocket(m_sock));
#else
	return (close(m_sock));
#endif
}

int BSDSocket::GetError()
{
#ifdef WIN32
	return (WSAGetLastError());
#else
	return (errno);
#endif
}

bool BSDSocket::DnsParse(const char* domain, char* ip)
{
	struct hostent* p;
	if ( (p = gethostbyname(domain)) == NULL )
		return false;
		
	sprintf(ip, 
		"%u.%u.%u.%u",
		(unsigned char)p->h_addr_list[0][0], 
		(unsigned char)p->h_addr_list[0][1], 
		(unsigned char)p->h_addr_list[0][2], 
		(unsigned char)p->h_addr_list[0][3]);
	
	return true;
}
int BSDSocket::Select( int nfds,fd_set* readSet,fd_set* writeSet,fd_set* exceptSet, struct timeval * timeout )
{
	int result;
	result=select(nfds,readSet,writeSet,exceptSet,timeout);
	return result;
}

bool BSDSocket::SetNoBlock( bool on )
{
#ifndef WIN32 
	int flags = fcntl( m_sock , F_GETFL , 0 );
	if ( on )
		// make nonblocking fd
		flags |= O_NONBLOCK;
	else
		// make blocking fd
		flags &= ~O_NONBLOCK;
	fcntl(m_sock, F_SETFL, flags);  // set to non-blocking
#endif
	return true;
}
