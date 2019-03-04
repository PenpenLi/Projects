local DNSCache = class("DNSCache")

function DNSCache.create(domain, callback)
    local gateway = DNSCache.new(domain, callback)
    return gateway
end

function DNSCache:ctor(domain, callback)
    self._domain = domain
    self._callback = callback
    self._time = 0
    self._url = "http://119.29.29.29/d?dn=" .. self._domain
    self._httpRequest = nil
end

function DNSCache:send()
    --if domain is pure ip?
    if string.find(self._domain, "^%d+%.%d+%.%d+%.%d+") ~= nil then
        self._callback(self._domain)
        return
    end
    self._time = ex_helper:getTickCount()
    self._httpRequest = cc.XMLHttpRequest:new()
    self._httpRequest.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    self._httpRequest:open("GET", self._url)
    self._httpRequest:registerScriptHandler(handler(self, self._onReadyStateChange))
    self._httpRequest:send()
end

function DNSCache:_onReadyStateChange()
    G_Report.addHttpLog(self._url, ex_helper:getTickCount()-self._time, self._httpRequest.readyState, self._httpRequest.status)
    if self._httpRequest.readyState == 4 and (self._httpRequest.status >= 200 and self._httpRequest.status < 207) then
        local response = self._httpRequest.response
        print("DNSCache = " .. response)
        local ips = string.split(response, ";")
        if ips and #ips >= 1 and string.match(ips[1] ,"^(%d+%.%d+%.%d+%.%d+)") then
            if self._callback then
                self._callback(ips[1])
            end
        else
            if self._callback then
                self._callback("")
            end
        end
    else
        if self._callback then
            self._callback("")
        end
    end
    self._httpRequest:unregisterScriptHandler()
    self._httpRequest = nil
end

function DNSCache:stop()
    self._callback = nil
end

return DNSCache