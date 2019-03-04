#include "LuaSocketManager.h"
#include "package.head.h"
#include "tolua_fix.h"

USING_NS_CC;

static LuaSocketManager* _p_ex_luasocket_instance = NULL;

//connectIndex, ip, port
TOLUA_API int ex_socket_connect(lua_State *L) {

	int connectIndex = lua_tointeger(L, -3);
	const char* ip = lua_tostring(L, -2);
	int port = lua_tointeger(L, -1);

	if (_p_ex_luasocket_instance != NULL){
		_p_ex_luasocket_instance->connectToServer(connectIndex,  ip, port);
	}

	lua_pop(L, 3);

	return 0;
}


TOLUA_API int ex_socket_disconnect(lua_State *L) {

	int connectIndex = lua_tointeger(L, -1);

	if (_p_ex_luasocket_instance != NULL){
		_p_ex_luasocket_instance->removeConnect(connectIndex);
	}
	lua_pop(L, 1);

	return 0;
}




TOLUA_API int ex_socket_register_handler(lua_State *L) {
	int top = lua_gettop(L);
	LUA_FUNCTION handler = (  toluafix_ref_function(L,top,0));
	if (handler == 0){
		//error
		CCLOG("ex_socket_register_handler error");
		return 0;
	}
	if (_p_ex_luasocket_instance != NULL){
		_p_ex_luasocket_instance->registerScriptHandler(handler);

	}
	lua_pop(L, 1);

	return 0;
}

TOLUA_API int ex_socket_send(lua_State *L) {
	int connectIndex = lua_tointeger(L, -4);
	int msgId = lua_tointeger(L, -3);
	const char* content = lua_tostring(L, -2);
	int len = lua_tointeger(L, -1);

	if (_p_ex_luasocket_instance != NULL){
		_p_ex_luasocket_instance->sendMessage(connectIndex, msgId, content, len);
	}
	lua_pop(L, 4);
	return 0;
}


TOLUA_API int ex_socket_set_header(lua_State *L) {
	int id = lua_tointeger(L, -3);
	uint64_t userId = lua_tonumber(L, -2);
	int sessionId = lua_tointeger(L, -1);

	if (_p_ex_luasocket_instance != NULL){
		_p_ex_luasocket_instance->setUserId(userId);
		_p_ex_luasocket_instance->setSessionId(sessionId);
	}
	lua_pop(L, 3);

	return 0;
}

TOLUA_API int ex_socket_debug(lua_State *L) {
	bool debug  = lua_toboolean(L, -1);
	if (_p_ex_luasocket_instance != NULL){
		_p_ex_luasocket_instance->showNetworkLog(debug);
	}
	lua_pop(L, 1);

	return 0;
}

TOLUA_API int ex_socket_init(lua_State *L) {
	if (_p_ex_luasocket_instance == NULL) {
		_p_ex_luasocket_instance = new LuaSocketManager();
	}

	return 0;
}


TOLUA_API int ex_socket_destroy(lua_State *L) {
	if (_p_ex_luasocket_instance != NULL) {
		delete _p_ex_luasocket_instance;
		_p_ex_luasocket_instance = NULL;
	}

	return 0;
}

TOLUA_API int luaopen_ex_socketmanager(lua_State* L) {

	luaL_Reg reg[] = {
		{"init" , ex_socket_init },
		{"destroy" , ex_socket_destroy },
		{"connect" , ex_socket_connect },
		{"disconnect" , ex_socket_disconnect },
		{"debug" , ex_socket_debug },
		{"registerHandler" , ex_socket_register_handler},
		{"send" , ex_socket_send },
		{"setHeader" , ex_socket_set_header },
		{NULL,NULL},
	};

	luaL_register(L,"ex_socket",reg);
	return 1;
}


LuaSocketManager::LuaSocketManager() 
: m_pRecvBuffer(NULL)
, m_iRecvBufferLen(kRECV_BUFF_LEN)
, m_pSendBuffer(NULL)
, m_iSendBufferLen(0)
, showLog_(false)
, m_defaultServerId(0)
, userId_(0) 
, sessionId_(0)
{
    m_iSendBufferLen = kSEND_BUFF_LEN;
	m_pSendBuffer = new char[m_iSendBufferLen];
	m_pRecvBuffer = new char[m_iRecvBufferLen];

	m_nScriptHandler=0;

	m_socketManager.init();
	m_socketManager.RunThread();

	Director::getInstance()->getScheduler()->scheduleUpdate(this, 0, false);
}

//
LuaSocketManager::~LuaSocketManager()
{
	if (m_pSendBuffer)
	{
		delete []m_pSendBuffer;
		m_pSendBuffer = NULL;
	}

	if (m_pRecvBuffer)
	{
		delete []m_pRecvBuffer;
		m_pRecvBuffer = NULL;
	}

	if (m_socketManager.isRuning()) {
		m_socketManager.stopThread();	
	}
	unregisterScriptHandler();

	Director::getInstance()->getScheduler()->unscheduleAllForTarget(this);
}

//
void LuaSocketManager::update(float dt)
{
    if (m_socketManager.isRuning())
    {
        m_tmpPeekLen = m_socketManager.PeekMessage(m_pRecvBuffer, m_iRecvBufferLen, m_tmpConnIndex, m_tmpConnStatus);
        if (net::kSockStatus_OK == m_tmpConnStatus)
        {
            process(m_tmpConnIndex, m_pRecvBuffer, m_tmpPeekLen);
        }
        else 
        {
            switch (m_tmpConnStatus)
            {
            case net::kSockStatus_ConnFailed:
            	//CCLOG("kSockStatus_ConnFailed");

                onConnectFail(m_tmpConnIndex);
                break;
            case net::kSockStatus_Broken:
            	//CCLOG("kSockStatus_Broken");

                onConnectBroken(m_tmpConnIndex);
                break;
			case net::kSockStatus_Connect:
			//CCLOG("kSockStatus_Connect");

				onConnectSuccess(m_tmpConnIndex);
				break;
            case net::kSockStatus_Close:
                onConnectClose(m_tmpConnIndex);
                break;
            }
        }
    }
}

//
void LuaSocketManager::registerScriptHandler(int handler)
{
	unregisterScriptHandler();
	m_nScriptHandler = handler;
}

//
void LuaSocketManager::unregisterScriptHandler()
{
	if (m_nScriptHandler)
	{
		LuaEngine::getInstance()->removeScriptHandler(m_nScriptHandler);
		m_nScriptHandler = 0;
	}
}

//
bool LuaSocketManager::connectToServer(unsigned int connIndex, const char* ip, unsigned short port)
{
	if (ip != NULL)
	{
        CCLOG("[c++][LuaSocketManager] add connect [%s:%d] begin", ip, port);
		if (! m_socketManager.addConnect(connIndex, ip, port))
		{
            CCLOG("[c++][LuaSocketManager] add connect [%s:%d] failed", ip, port);
			m_defaultServerId = 0;
		}
		else
		{
			m_defaultServerId = connIndex;
			return true;
		}
	}

	return false;
}

//
bool LuaSocketManager::reconnectToServer(unsigned int connIndex)
{
	return false;
}

//
bool LuaSocketManager::removeConnect(unsigned int connIndex)
{
	return m_socketManager.removeConnect(connIndex);
}

//
bool LuaSocketManager::sendMessage( unsigned int connIndex, unsigned int msgId, const char *szBuff, unsigned int len )
{
	int totalLen = doSerializeMsg(msgId, szBuff, len);
	if (totalLen > 0)
    {
		std::string sendStr;
		sendStr.append(m_pSendBuffer, 0, totalLen);
        CCLOG("[c++][LuaSocketManager] sendMessage:id=%d, msg=%d", msgId, len);
		return m_socketManager.SendMessage(connIndex, m_pSendBuffer, totalLen);
	}

	return false;
}

//
void LuaSocketManager::showNetworkLog(bool show)
{
	showLog_ = show;
}

//
void LuaSocketManager::onScriptNetMsg(const char* eventID, uint32_t connIndex, const char* msg, uint32_t len, uint32_t msgId)
{
	if (eventID == NULL )
		return;

    LuaStack* stack = LuaEngine::getInstance()->getLuaStack();

	if (stack == NULL)
		return;

	stack->pushString(eventID);
	stack->pushInt(connIndex);
	if (len > 0)
		stack->pushString(msg, len);
	else
		stack->pushString(" ");
	stack->pushInt(len);
	stack->pushInt(msgId);

	stack->executeFunctionByHandler(m_nScriptHandler, 5);
	stack->clean();
}

//
void LuaSocketManager::process(unsigned int connIndex, const char *szBuff, size_t size)
{
	unsigned int msgId = 0;
	size_t msgLen = 0;

	initBuffer();
	const char* pStart = unSerializeMsg(msgId, szBuff, msgLen);
	if (pStart != NULL) {
		//char* temp = const_cast<char*>(pStart);
		//*(temp) = 'c';
		//*(temp + 1) = 'd';
		//std::string strMsg;
		//strMsg.append(pStart, 0, msgLen);
		if (showLog_)
			CCLOG("[c++][LuaSocketManager][process] receive data: , len=%zu, msgId=%d",  msgLen, msgId);
		onScriptNetMsg("netmsg", connIndex, pStart, msgLen, msgId);
	} else {
		if (showLog_)
			CCLOG("[c++][LuaSocketManager][process] receive invalid data!");
	}
}

//
void LuaSocketManager::onConnectSuccess(unsigned int connIndex)
{
	onScriptNetMsg("connect_success", connIndex);
}

//
void LuaSocketManager::onConnectFail(unsigned int connIndex)
{
	onScriptNetMsg("connect_fail", connIndex);
}

//
void LuaSocketManager::onConnectBroken(unsigned int connIndex)
{
	onScriptNetMsg("connect_broken", connIndex);
}

//
void LuaSocketManager::onConnectClose(unsigned int connIndex)
{
    onScriptNetMsg("connect_close", connIndex);
}

//
void LuaSocketManager::onException(const std::string &e_what)
{
	onScriptNetMsg("exception", 0, e_what.c_str(), e_what.length());
}

//
int LuaSocketManager::doSerializeMsg(unsigned int msgId, const char* szBuff, size_t len)
{
	if (szBuff != NULL && len > 0) {
		if (len > m_iSendBufferLen - PHDR_LEN)
			len = m_iSendBufferLen - PHDR_LEN;
		memcpy(m_pSendBuffer + PHDR_LEN, szBuff, len);
	}

	PHDR hdr;
	hdr.cmd = msgId;
	hdr.len = len + PHDR_LEN;
	hdr.uid = userId_;
	hdr.sid = sessionId_;
	push_pack_head(m_pSendBuffer, hdr);

	return hdr.len;
}

//
const char* LuaSocketManager::unSerializeMsg(unsigned int& msgId, const char* szBuff, size_t& len)
{
	if (szBuff != NULL) {
		PHDR hdr;
		pop_pack_head(szBuff, hdr);
		msgId = hdr.cmd;
		len = hdr.len - PHDR_LEN;
	}

	return szBuff + PHDR_LEN;
}

//
void LuaSocketManager::initBuffer()
{
	memset(m_pSendBuffer, 0, m_iSendBufferLen);
}
