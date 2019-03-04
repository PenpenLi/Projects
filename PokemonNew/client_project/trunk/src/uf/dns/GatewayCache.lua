local GatewayCache = class("GatewayCache")

local SchedulerHelper = require "app.common.SchedulerHelper"
function GatewayCache.create(url, callback)
    local gateway = GatewayCache.new(url, callback)
    return gateway
end

function GatewayCache:ctor(url, callback)
    self._url = url
    self._callback = callback
    self._time = 0
    self._httpRequest = nil
end

function GatewayCache:send()
    self._time = ex_helper:getTickCount()
    self._httpRequest = cc.XMLHttpRequest:new()
    self._httpRequest.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    self._httpRequest:open("GET", self._url)
    self._httpRequest:registerScriptHandler(handler(self, self._onReadyStateChange))
    self._httpRequest:send()
end

function GatewayCache:_onReadyStateChange()
    G_Report.addHttpLog(self._url, ex_helper:getTickCount()-self._time, self._httpRequest.readyState, self._httpRequest.status)
    if self._httpRequest.readyState == 4 and (self._httpRequest.status >= 200 and self._httpRequest.status < 207) then
        local response = self._httpRequest.response
        print("GatewayCache = " .. response)
        local gateways = string.split(response, ",")
        if gateways and #gateways >= 1 then
            local cache = {}
            for i,v in ipairs(gateways) do
                local ret = string.split(v, "|")
                local info = {}
                info.gateway = ret[1]
                info.port = 0
                if ret[2] ~= nil then
                    info.port = tonumber(ret[2])
                end
                cache[#cache + 1] = info
            end
            if self._callback then
                self._callback(cache[1])
            end
        else
            if self._callback then
                self._callback(nil)
            end
        end
    else
        if self._callback then
            self._callback(nil)
        end
    end
    self._httpRequest:unregisterScriptHandler()
    self._httpRequest = nil
end

function GatewayCache:stop()
    self._callback = nil
end

return GatewayCache