
local TestProxyLayer = class("TestProxyLayer",UFCCSModelLayer)
local storage = require("app.storage.storage")


function TestProxyLayer.create()
   return TestProxyLayer.new("ui_layout/platform_TestProxyLayer.json", require("app.setting.Colors").modelColor)
end



function TestProxyLayer:ctor(json, color)
    self.super.ctor(self)
    self._loginCallback = nil
    self:_initViews()
end


 

function TestProxyLayer:setLoginCallback(callback)
    self._loginCallback = callback
end


function TestProxyLayer:_initViews()
  
    self:registerBtnClickEvent("Button_ok",  function() 
         local txt = self:getTextFieldByName("TextField_userName"):getStringValue()
         if txt ~= "" then

            -- local badchar = string.match(txt,"([^%w]+)")
            -- if badchar ~= nil then
            --     G_MovingTip:showMovingTip("请只输入英文和数字,不超过10个字符")
            --     return
            -- end

            -- if string.len(txt) > 10 then
            --     G_MovingTip:showMovingTip("请只输入英文和数字,不超过10个字符")
            --     return
            -- end
            local params = {}

            print("inittttt:", txt)
            if #txt > 50 then
                local tokenDataStr = require("framework.crypto").decodeBase64(txt)
                local tokenData = json.decode(tokenDataStr)
                if tokenData ~= nil then
                    --uuid
                    params.uuid = tokenData.uuid 
                    local ps = string.split(tokenData.uuid, "_")
                    
                    params.opId = table.remove(ps,1)
                    params.uid = table.concat(ps, "_")

                    params.serverId = tokenData.serverId 
                    params.serverName = tokenData.serverName 
                    params.gateway = tokenData.gateway
                end
            else
                params.uid = txt 
                params.uuid = G_PlatformProxy:getOpId() .. "_" .. txt
            end
            


            self:startLoginPlatform(params)
            self:close()
         end
    end)


    self:onUpdateUserName()


end

function TestProxyLayer:onUpdateUserName()
    local lastUserName = G_PlatformProxy:getLoginUserName()
    if lastUserName == "" then
        --不设置标题
        self:getTextFieldByName("TextField_userName"):setText("test_" .. tostring(math.random(1, 99999)))
    else
        self:getTextFieldByName("TextField_userName"):setText(lastUserName)
    end
end

function TestProxyLayer:startLoginPlatform( params )
    --不需要跟服务器交互...因为这个是假平台, 直接认为登陆成功
   
    if self._loginCallback ~= nil then
        G_PlatformProxy:setPlatformId(params.uid)
        G_PlatformProxy:setUid(params.uuid)
        self._loginCallback(params)
    end
end


---销毁函数
function TestProxyLayer:onLayerUnload( ... )
    -- uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_UPDATE_UID, nil, false) 

    uf_eventManager:removeListenerWithTarget(self)
end


return TestProxyLayer
