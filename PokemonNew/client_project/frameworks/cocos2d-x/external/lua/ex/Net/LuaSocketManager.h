#ifndef _MSG_LUA_SOCKET_MANAGER_H_
#define _MSG_LUA_SOCKET_MANAGER_H_

#include "socket/IMessageProtocolDelegate.h"
#include "socket/SocketManager.h"
#include "CCLuaEngine.h"

TOLUA_API int luaopen_ex_socketmanager(lua_State* tolua_S);





class LuaSocketManager : 
	public IMessageProtocolDelegate {



public:
    LuaSocketManager();
    void update(float dt);
	~LuaSocketManager();



	virtual void process(unsigned int connIndex, const char *szBuff, size_t size) ;
	virtual void onConnectSuccess(unsigned int connIndex) ;
	virtual void onConnectFail(unsigned int connIndex);
	virtual void onConnectBroken(unsigned int connIndex);
    virtual void onConnectClose(unsigned int connIndex);
	//virtual void onDownloaded(const net::stDownloadUrl &downloaded) ;
	virtual void onException(const std::string &e_what);

	void registerScriptHandler(int handler);
	void unregisterScriptHandler();

	void setUserId(uint64_t uId) {
		userId_ = uId;
	}
	void setSessionId(unsigned int sId) {
		sessionId_ = sId;
	}

	void showNetworkLog(bool show);
	bool connectToServer(unsigned int connIndex, const char* ip, unsigned short port);
	bool reconnectToServer(unsigned int connIndex);
	bool removeConnect(unsigned int connIndex);

	bool sendMessage(unsigned int connIndex, unsigned int msgId, 
		const char *szBuff, unsigned int len);
	//bool sendMessageToDefault(PHDR header, const google::protobuf::Message& body );

protected:
	void onScriptNetMsg(const char* eventID, uint32_t connIndex, 
		const char* msg = "", uint32_t len = 0,
		uint32_t msgId = 0);

	int doSerializeMsg(unsigned int msgId, const char* szBuff, size_t len);
	const char* unSerializeMsg(unsigned int& msgId, const char* szBuff, size_t& len);
	void initBuffer();



private:

	/////////////
	net::SocketManager  m_socketManager;
	char* m_pRecvBuffer;    // recv temporary buffer
    int m_iRecvBufferLen;
    bool m_bIsRunning;

    unsigned int        m_tmpConnIndex;
    int                 m_tmpConnStatus;
    int                 m_tmpPeekLen;
	bool		m_networkConnect;
	int			m_networkConnectType;
	//////////////////


	int					m_nScriptHandler;

	uint64_t			userId_;
	uint32_t			sessionId_;
	bool				showLog_;
	char *m_pSendBuffer;
	int m_iSendBufferLen;
	//bool m_bInited;
	unsigned int m_defaultServerId;

 
};

#endif