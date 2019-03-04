--NetManager.lua
local NetManager = class("NetManager")

--
function NetManager:ctor()
    print("[NetManager] ctor")
	self._socketArr = {}
	self._netMsgHandler = nil
	self._netEventHook = nil
end

--
function NetManager:init()
    print("[NetManager] init")
	if self._netMsgHandler == nil then 
        local connIndex = 0
        print("[NetManager] new socket")
        self._netMsgHandler = require("src.uf.socket").new(connIndex)

        local handler = function(event, msgId, msgBuf, msgLen)
            print("[NetManager] onEventListener = " .. event)
        	if event == "netmsg" then
            	self:onReceiveNetMsg(connIndex, msgBuf, msgLen, msgId)
        	elseif event == "connect_success" then
            	self:onConnectSuccess(connIndex)
        	elseif event == "connect_fail" then
            	self:onConnectFailed(connIndex)
        	elseif event == "connect_broken" then
            	self:onConnectBroken(connIndex)
            	-- now we move download to DownloadManager.lua, so here comment it
        	--elseif event == "download" then
            --	self:onDownloadFinish(connIndex, msgBuf)
            elseif event == "connect_close" then
                self:onConnectClose(connIndex)
        	elseif event == "exception" then
            	self:onNetException(connIndex, msgBuf)
        	end
        end

        self._netMsgHandler:addEventListener(handler)
	end
end

-- 连接服务器
function NetManager:connectToServer(connIndex, ip, port)
    print("[NetManager] connectToServer connIndex=" .. connIndex .. ", ip=" .. ip .. ", port=" .. port)
    if buglyLog then
        buglyLog(3, "NetManager", "connectToServer connIndex=" .. connIndex .. ", ip=" .. ip .. ", port=" .. port)
    end
	self:init()

	if self:checkConnection(connIndex) then 
		return
	end

    self._netMsgHandler:connect(ip, port)
end

-- 
function NetManager:removeConnect(connIndex)
    print("[NetManager] removeConnect connIndex=" .. connIndex)
    if buglyLog then
        buglyLog(3, "NetManager", "removeConnect connIndex=" .. connIndex)
    end
	self:init()
	if self._netMsgHandler ~= nil then
        self._netMsgHandler:disconnect()
		self:setConnection(connIndex, false)
	else
		print("[NetManager] removeConnect _netMsgHandler = nil")
	end
end

-- 协议处理
function NetManager:onReceiveNetMsg(connIndex, msgBuf, msgLen, msgId)
    print("[NetManager] onReceiveNetMsg connIndex=" .. connIndex .. ", msgId=" .. msgId)
    if buglyLog then
        buglyLog(3, "NetManager", "onReceiveNetMsg connIndex=" .. connIndex .. ", msgId=" .. msgId)
    end
	uf_messageDispatcher:onNetMessage(msgId, msgBuf, msgLen)
    self:onNetReceiveEvent( msgId, msgBuf )
end

--
function NetManager:onConnectSuccess(connIndex)
    print("[NetManager] onConnectSuccess connIndex=" .. connIndex)
    if buglyLog then
        buglyLog(3, "NetManager", "onConnectSuccess connIndex=" .. connIndex)
    end
	self:setConnection(connIndex, true)
	uf_messageDispatcher:onConnectSuccess(connIndex)
end

--
function NetManager:onConnectFailed(connIndex)
    print("[NetManager] onConnectFailed connIndex=" .. connIndex)
    if buglyLog then
        buglyLog(3, "NetManager", "onConnectFailed connIndex=" .. connIndex)
    end
	self:setConnection(connIndex, false)
	uf_messageDispatcher:onConnectFailed(connIndex)
end

--
function NetManager:onConnectBroken(connIndex)
    print("[NetManager] onConnectBroken connIndex=" .. connIndex)
    if buglyLog then
        buglyLog(3, "NetManager", "onConnectBroken connIndex=" .. connIndex)
    end
	self:setConnection(connIndex, false)
	uf_messageDispatcher:onConnectBroken(connIndex)
end

--
function NetManager:onConnectClose(connIndex)
    print("[NetManager] onConnectClose connIndex=" .. connIndex)
    if buglyLog then
        buglyLog(3, "NetManager", "onConnectClose connIndex=" .. connIndex)
    end
    self:setConnection(connIndex, false)
    uf_messageDispatcher:onConnectClose(connIndex)
end

--
function NetManager:onNetException(connIndex, reason)
    print("[NetManager] onNetException connIndex=" .. connIndex)
    if buglyLog then
        buglyLog(3, "NetManager", "onNetException connIndex=" .. connIndex)
    end
	self:setConnection(connIndex, false)
	uf_messageDispatcher:onNetException(connIndex)
end

--
function NetManager:sendMsg(msgId, content)
    print("[NetManager] sendMsg msgId= " .. msgId)
--	if type(content) ~= "string" or type(msgId) ~= "number" then 
--		assert(0, "invalid param type!")
--		return 
--	end
    if buglyLog then
        buglyLog(3, "NetManager", "sendMsg msgId= " .. msgId)
    end
	local ret = self._netMsgHandler:send(msgId, content)
	self:onNetSendEvent(msgId, content)
end

--
function NetManager:hookNetEvent(func)
	self._netEventHook = func
end

--
function NetManager:onNetSendEvent(msgId, content)
    print("[NetManager] onNetSendEvent msgId= " .. msgId)
	if self._netEventHook ~= nil then
		self._netEventHook(1, msgId, content)
	end
end

--
function NetManager:onNetReceiveEvent(msgId, content)
    print("[NetManager] onNetReceiveEvent msgId= " .. msgId)
	if self._netEventHook ~= nil then
		self._netEventHook(0, msgId, content)
	end
end

--
function NetManager:checkConnection(connIndex)
	if type(connIndex) ~= "number" then 
		assert(0, "invalid parameter!")
		return true
	end

--	local strConn = ""..connIndex
--	if self._socketArr[strConn] ~= nil then
--		return true
--	end

    if self._netMsgHandler == nil then return end
    
    return self._netMsgHandler:isConnected()
end

--
function NetManager:setConnection(connIndex, connect)
    print("[NetManager] setConnection connIndex=" .. connIndex)
    if buglyLog then
        buglyLog(3, "NetManager", "setConnection connIndex=" .. connIndex)
    end
	local strConn = "" .. connIndex
	if connect then
		self._socketArr[strConn] = true
	else
		self._socketArr[strConn] = nil
	end
end

--
function NetManager:setSession(uid,sid)
    self._netMsgHandler:setHeader(uid,sid)
end

--
function NetManager:createHTTPRequestGet(url, callback, target)
	print("get =====================================================================================")
	print("url: " .. url)
  	local httpHandler = function (event)
        if target ~= nil and callback ~= nil then
            callback(target, event)
        elseif callback ~= nil then
            callback(event)
        end
    end

  	local request = network.createHTTPRequest(httpHandler, url, "GET")
    return request
end

--
function NetManager:createHttpRequestPost(url, callback, target)
	print("post =====================================================================================")
	print("url: " .. url)
  	local httpHandler = function (event)
        if target ~= nil and callback ~= nil then
            callback(target, event)
        elseif callback ~= nil then
            callback(event)
        end
    end

  	local request = network.createHTTPRequest(httpHandler, url, "POST")
    return request
end

return NetManager