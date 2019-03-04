local M = {}
M.__index = M

local ufsocket = ex_socket
local inted_socket = false
local sockets = {}

--
function M._init()
    if inted_socket == true then
        return
    end
    print("[socket] init...")
    inted_socket = true
    ufsocket.init()
    ufsocket.registerHandler(function(event, connectIndex, msg, len, msgId) 
        --event:  connect_success, netmsg, connect_fail, connect_broken, exception
        for i,socket in ipairs(sockets) do 
            if socket.connectIndex == connectIndex then
                socket:onEvent(event, msgId, msg, len)
                break
            end
        end
    end )
end

--
function M.new(connectIndex)
    connectIndex = connectIndex or 0
    print("[socket] new index = " .. connectIndex)

    M._init()

    for i,socket in ipairs(sockets) do 
        if socket.connectIndex == connectIndex then
            assert("[socket] connectIndex " .. tostring(connectIndex) .. " has exists already")
            return nil
        end
    end

    local s = {
        ip = "",
        port = 0,
        connectIndex = connectIndex,
        _handler = nil,
        _connected = false,
    }

    setmetatable(s, M)
    table.insert(sockets, s)
    return s
end

--
function M:addEventListener(handler)
    if self._handler ~= nil then
        self:removeEventListener()
    end

    self._handler = handler
end

--
function M:removeEventListener()
    self._handler = nil
end

--
function M:onEvent(event, msgId, msg, len)
    print("[socket] onEvent = " .. event)
    if event == "connect_success" then
        self._connected =  true
    elseif event == "connect_fail" or event == "connect_broken" or event == "exception" then
        self:_onDisconnected()
    end

    if self._handler ~= nil then
       self._handler(event, msgId, msg, len) 
    end
end

--
function M:connect(ip, port)
    print("[socket] connect ip= " .. ip .. ", port=" .. port)
    if buglyLog then
        buglyLog(3, "socket", "connect ip= " .. ip .. ", port=" .. port)
    end
    self._ip = ip 
    self._port = port
    ufsocket.connect(self.connectIndex, ip, port) 
end

--
function M:send(msgId, msg)
    print("[socket] send msgId= " .. msgId)
    if buglyLog then
        buglyLog(3, "socket", "send msgId= " .. msgId)
    end
    if self:isConnected() then
        ufsocket.send(self.connectIndex, msgId, msg, #msg) 
    end
end

--
function M:disconnect()
    print("[socket] disconnect")
    if buglyLog then
        buglyLog(3, "socket", "disconnect")
    end
    ufsocket.disconnect(self.connectIndex) 
    self:_onDisconnected()
end

--
function M:_onDisconnected()
    print("[socket] _onDisconnected")
    if buglyLog then
        buglyLog(3, "socket", "_onDisconnected")
    end
    self._connected =  false
    ufsocket.setHeader(self.connectIndex, 0, 0)
end

--
function M:setHeader(userId, sessionId)
    ufsocket.setHeader(self.connectIndex, userId, sessionId)
end

--
function M:debug(bool)
    ufsocket.debug(bool)
end

--
function M:isConnected()
    return self._connected
end

--
function M:reConnect()
    print("[socket] reConnect")
    if buglyLog then
        buglyLog(3, "socket", "reConnect")
    end
    self:disconnect()
    if self._ip and self._port then
        self:connect(self._ip, self._port) 
    end
end

--
function M:cleanup()
    print("[socket] cleanup")
    if buglyLog then
        buglyLog(3, "socket", "cleanup")
    end
    self:disconnect()

    for i,socket in ipairs(sockets) do 
        if socket == self then
            table.remove(socket, i)
            break
        end
    end
end

return M