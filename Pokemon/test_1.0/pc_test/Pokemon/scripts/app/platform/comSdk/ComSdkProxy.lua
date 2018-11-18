local ComSdkProxy = class("ComSdkProxy", require("app.platform.PlatformProxy"))


local GAMEDATA_SERVERID = "serverId"
local GAMEDATA_ROLENAME = "roleName"
local GAMEDATA_SERVERNAME = "serverName"
local GAMEDATA_ACCOUNT = "accountId"
local GAMEDATA_LEVEL = "roleLevel"
local GAMEDATA_ROLEID = "roleId"
local GAMEDATA_LOGINDATA = "loginData"
local GAMEDATA_APPSTORESANDBOX = "appStoreSandbox"

local ComSdkUtils = require("upgrade.ComSdkUtils")

local ComSdkProxyConfig = require("app.platform.comSdk.ComSdkProxyConfig")

function ComSdkProxy:ctor(...)
    self.super.ctor(self, ...)
    if patchMe and patchMe("ComSdkProxy", self) then return end
    self._loginData = ""
    self._everOpenedFloat = false
    self._loginExtraData = nil
    ComSdkUtils.registerNativeCallback(function(data) self:_onNativeComSdkCallback(data) end)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_SCENE_CHANGED, self._onReceiveSceneChanged, self)
    self:_init()
end



function ComSdkProxy:_init()
    local opId = self.getOpId()
    ComSdkProxyConfig.setSpecialRechargeList(opId)

    if G_Setting:get("useSpecialPay") == "1" then
        ComSdkUtils.call("useSpecialPay")
    end
end

function ComSdkProxy:_onNativeCallback(data)
    local event = data.event
    local ret = data.ret
    local paramStr = data.param
    -- print("## ComSdkProxy CALLBACK, " ..tostring(event) .. "," .. tostring(ret) .. "," .. tostring(info))

    if event == "onPause" then
        ComSdkUtils.call("onGameEvent", {{event="pauseGame"}})
        return true
    elseif event == "onResume" then
        ComSdkUtils.call("onGameEvent", {{event="resumeGame"}})

        local hasNetwork = G_NativeProxy.hasNetwork()
        if hasNetwork == false then
            uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_NETWORK_DEAD, nil, false, nil)
        end
        return true
    end
    return false
end


function ComSdkProxy:_canWhiteLogin(url, user_id)
    url = url .. "?user_id=" .. user_id
    local request = uf_netManager:createHTTPRequestGet(url, function(event)
        local request = event.request
        local errorCode = request:getErrorCode()
        if errorCode ~= 0 then
            MessageBoxEx.showOkMessage(nil,
                G_lang:get("LANG_ERROR_NETWORK"), false,
                function ( ... )
                end)
            return
        end

        local response = request:getResponseString()
        dump(response)
        local t=json.decode(response)
        if t then
            local ok = (event.name == "completed")
            if ok then
                --获得了token

                if t.ret == "ok" then
                    self.super.loginGame(self)

                else
                    MessageBoxEx.showOkMessage("",
                        "您的账号尚未激活, \n请联系GM"
                    )

                end

            end
        else
            MessageBoxEx.showOkMessage("",
                "网络繁忙,请稍后重试"
            )
        end

    end)
    request:start()
end

function ComSdkProxy:getDeviceId()
    local str = ComSdkUtils.call("getDeviceId", nil, "string")
    if str then
        return str
    else
        return "test device"
    end
end


function ComSdkProxy:getChanelId()
    if G_NativeProxy.platform == "android" then
        local ret, ok = ComSdkUtils.call("getMeta", {{metaKey="yzsdk_channelid"}}, "string")
        if ok then
            return ret
        end
    end

    return ""

end

function ComSdkProxy:getLoginExtraData()
    return self._loginExtraData
end

function ComSdkProxy:getToken(opId, params, callback, errCallback)
--[[
    local url =  server.login--'http://192.168.1.159/web/hook_login/login.php';
    url = url .. "?op_id=" .. opId .. "&uid=" .. params.uid

    trace("get token:" .. url)
    callback(params.uid)
    ]]

    local server = self:getLoginServer()
    local url =  server.login--'http://192.168.1.159/web/hook_login/login.php';
    --local url =  'http://192.168.2.133:8087/api'
    local sdkId = ComSdkUtils.getSdkId()
    ComSdkUtils.updateOpId()
    print("opid:" .. opId)
    print("sdkid:" .. sdkId)
    url = url .. "?op_id=" .. opId .. "&sdk_id=" .. sdkId  .. "&pid=" .. params.pid .. "&token=" .. params.token
    if G_NativeProxy.channelName ~= nil then
        url = url .. "&channel=" .. G_NativeProxy.channelName
    end
    print("getToken:", url)

    local request = uf_netManager:createHTTPRequestGet(url, function(event)
        local request = event.request
        local errorCode = request:getErrorCode()
        G_WaitingLayer:show(false)
        if errorCode ~= 0 then
            print("getToken err:", errorCode)
            MessageBoxEx.showOkMessage(nil,
                G_lang:get("LANG_ERROR_NETWORK"), false,
                errCallback
            )
            return
        end

        local response = request:getResponseString()
        print("out", response)
        local t=json.decode(response)
        if t then
            local ok = (event.name == "completed")
            if ok then
                --获得了token

                if t.ret == 0 then
                    local data = json.decode(t.data)

                    callback(data.token)
                 else
                    MessageBoxEx.showOkMessage(nil,
                       "\n该账号登录失败", false,
                        function ( ... )

                        end
                    )
                end

            end
        else
            CCMessageBox("token is wrong","error")
        end

    end)
    request:start()
end

function ComSdkProxy:_errLogin()
    G_WaitingLayer:show(false)
    ComSdkUtils.call("logout")
    --[[
    self._token = ""
    self._platform_uid = ""
    self._uid = ""
    local name = G_SceneObserver:getSceneName()
    if name == "LoginScene"  then
        self:setPlatformId("")
    else
        self:setPlatformId("")
        self:returnToLogin()
    end
    ]]
end


function ComSdkProxy:_onNativeComSdkCallback(data)
    print("fromJava++++++++++++++++++++++++++++++++++++++++++++++")
    local event = data.event
    local ret = data.ret
    local paramStr = data.param
    --trace("## ComSdkProxy CALLBACK, " ..tostring(event) .. "," .. tostring(ret) .. "," .. tostring(info))
    print("event:" .. event)
    print("ret:" .. ret)
    print("param:" .. paramStr)
    --print("data:" .. data)
    if event =="OPLoginPlatform" then
        if ret == 1 then
            track_event_start("10-logined_platform")
            print("+++++++++++++call success++++++++++++")
        --  ComSdkProxy:_loginPlatform()
        --MessageBoxEx.showOkMessage("登录成功", "登录成功", nil ,nil,nil)
            --GlobalFunc.uploadLog({{event_id="LoginOK"}})
            print("login_sdk_callback:", paramStr)
            local param = json.decode(paramStr)
            if param then
                if param.uid then
                    self:setPlatformId(tostring(param.uid))
                    self._sdk_uid = tostring(param.uid)
                end
                if param.data then
                    self._loginExtraData = param.data
                end

                if param.channelId then
                    G_NativeProxy.channelId = param.channelId
                end
                if param.subChannel then
                    G_NativeProxy.subChannelId = param.subChannel
                end
            end

            self._loginData = paramStr

            local opId = self.getOpId()
            self:getToken(opId, {pid = param.uid, token = param.token}, handler(self,self._onGetToken), handler(self, self._errLogin))
        else
            G_WaitingLayer:show(false)
        end
        return true
    elseif event == "OPLogout" then
        if ret == 1 then
            --[[
            self._token = ""
            self:setPlatformId("")
            self._uid = ""
            local name = G_SceneObserver:getSceneName()
            if name ~= "LoginScene"  then
                self:returnToLogin()
            end
            ]]
            self:returnToLogin()
        end
        return true
    elseif event == "OPExitGame" then
        if ret ==1 then
            --sdk has exite page already

            self:_exitGame()
        elseif  ret == 3 then
            --sdk doesenot have exit game  page
            self:_defaultExitGame()
        end
        return true
    elseif event == "OPPayResult" then
        if ret ==1 then
            G_NetworkManager:checkConnection()
            --OK--
            --bad hack, if it is in appstore

            if G_Setting:get('showRechargeTip') == '1' then
                trace("show tip")
                G_MovingTip:showMovingTip(G_lang:get("LANG_APPSTORE_BUY_TIPS"), {  movingStyle = "moving_texttip4_slow"})
            end
            --支付成功回调
            if IS_IPHON_ANDROID then
                TDGAVirtualCurrency:onChargeSuccess(paramStr)
                print("统计->支付订单[" .. paramStr)
            end
        elseif ret == 18 or ret == 19 or ret ==20 then
           if G_Setting:get('rechargeCurrencyTips') ~= "" then
               MessageBoxEx.showOkMessage(nil,  G_Setting:get('rechargeCurrencyTips'))
           end

        end
        return true
    elseif event == "weixinShareResult" then
        if ret == 0 then
           uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_NATIVE_WEIXIN_CALLBACK, nil, false, nil)
        end

    end
    return false
end



function ComSdkProxy:beforeLogin()
    uf_funcCallHelper:callAfterFrameCount(2, function ( ... )
        if self._firstLogin == nil then
            --self:loginPlatform()
            self_firstLogin = true
        end
    end)

end

-- 连接上游戏服务器后开始登陆游戏,
--[[
function ComSdkProxy:loginGame()
    local whiteurl = G_Setting:get("white_url")
    if whiteurl ~= nil and whiteurl ~= "" then
        --开启了白名单功能

        self:_canWhiteLogin(whiteurl, self._platform_uid)

        -- http://122.226.211.181/web/activate/add_user.php
    else
        self.super.loginGame(self)
    end
end
]]

function ComSdkProxy:_closeFloat()
    --print( "sen=" .. G_SceneObserver:getSceneName())
    local open_always_show_float = G_Setting:get("open_always_show_float")
    if open_always_show_float == "1" then
        return
    end

    local ComSdkUtils = require("upgrade.ComSdkUtils")

    local  has = ComSdkUtils.call("hasFloatWindow", nil, "boolean")
    if has then  -- and name ~= "LoginScene"
        ComSdkUtils.call("closeFloatWindow")
        self._everOpenedFloat = false
    end

end

function ComSdkProxy:_openFloat()
    --print( "sen=" .. G_SceneObserver:getSceneName())
    local  has = ComSdkUtils.call("hasFloatWindow", nil, "boolean")
    if has then  -- and name ~= "LoginScene"
        ComSdkUtils.call("openFloatWindow", {{x=display.sizeInPixels.width -100}, {y=150}})
        self._everOpenedFloat = true
    end

end

function ComSdkProxy:_onReceiveSceneChanged()
    --print( "sen=" .. G_SceneObserver:getSceneName())
    if not G_Me.isLogin then
        return
    end
    local name = G_SceneObserver:getSceneName()
    local  has = ComSdkUtils.call("hasFloatWindow", nil, "boolean")
    if name == "MainScene"  then
        self:_openFloat()
    else


        if self._everOpenedFloat then
            self:_closeFloat()
        end




    end

end



-- 登陆平台
function ComSdkProxy:loginPlatform()
    self._wantAutoEnterGame = false
    self:_loginPlatform()
end

function ComSdkProxy:_loginPlatform()
    track_event_start("9-login_platform")

    --硬弹出平台的login
    if not self:isAccountLogin() then
      --uf_funcCallHelper:callAfterDelayTime(0.1,nil,function()
        G_WaitingLayer:show(true)
        ComSdkUtils.call("showLogin")
      --end,nil)
    else
        --[[
        local logoutType, ok =  ComSdkUtils.call("getLogoutType", {}, "int")
        --115表示SDK内部有确认弹框
        print("loginPlatForm:", logoutType, ok)
        if ok and logoutType == 115 then
            print("call logout")
            ComSdkUtils.call("logout")
        else
        ]]
        MessageBoxEx.showYesNoMessage(G_lang:get("LANG_FRIEND_TISHI"), G_lang:get("LANG_EXIT_TIPS"), nil ,
            function(target)
                --MessageBoxEx:close()
                --GlobalFunc.sayAction(target,true)
                --uf_funcCallHelper:callAfterDelayTime(0.1,nil,function()
                    ComSdkUtils.call("logout")
                --end,nil)
            end,
            nil
        )

        --end

        -- if ComSdkUtils.call("hasPlatformCenter", nil, "boolean") then
        --     ComSdkUtils.call("enterPlatformCenter")
        -- else
        --     --logout and login again
        --     -- ComSdkUtils.call("logout")
        --     -- ComSdkUtils.call("showLoginMode2")

        -- end
    end
    --ComSdkUtils.call("showLoginMode2")
end

function ComSdkProxy:_onLoginedGame()
    self.super._onLoginedGame(self)
    self:_setGameData()
    ComSdkUtils.call("onGameEvent", {{event="enterGame"}})
    GlobalFunc.uploadLog({{event_id="EnterGame"}})

end


function ComSdkProxy:getLoginUserName()
    if self._platform_uid and self._platform_uid ~= "" then
        return  G_lang:get("LANG_PLATFORM_LOGINED") --self._platform_uid

    else
        return ""
    end
end


function ComSdkProxy:_exitGame()
    ComSdkUtils.call("onGameEvent", {{event="exitGame"}})
    self.super._exitGame(self)
end

function ComSdkProxy:wantExitGame()
    if G_NativeProxy.platform == "winrt" or G_NativeProxy.platform == "wp8" then
        self.super.wantExitGame(self)
    else
        ComSdkUtils.call("exitGame")
    end
end

function ComSdkProxy:_setGameData()
    --[[
    local serverId = self:getLoginServer().id
    local serverName = self:getLoginServer().name
    ComSdkUtils.call("setGameData", {{keyName=GAMEDATA_SERVERID}, {keyValue=tostring(serverId)}})
    ComSdkUtils.call("setGameData", {{keyName=GAMEDATA_ROLENAME}, {keyValue=tostring(G_Me.userData.name)}})
    ComSdkUtils.call("setGameData", {{keyName=GAMEDATA_SERVERNAME}, {keyValue=tostring(serverName)}})
    ComSdkUtils.call("setGameData", {{keyName=GAMEDATA_ACCOUNT}, {keyValue=tostring(self:getPlatformUid())}})
    ComSdkUtils.call("setGameData", {{keyName=GAMEDATA_LEVEL}, {keyValue=tostring(G_Me.userData.level)}})
    ComSdkUtils.call("setGameData", {{keyName=GAMEDATA_ROLEID}, {keyValue=tostring(G_Me.userData.id)}})
    ComSdkUtils.call("setGameData", {{keyName=GAMEDATA_LOGINDATA}, {keyValue=tostring(self._loginData)}})

    if G_Setting:get("appstore_sandbox") ~= ""  and G_Setting:get("appstore_sandbox") == "true" then
       ComSdkUtils.call("setGameData", {{keyName=GAMEDATA_APPSTORESANDBOX}, {keyValue=tostring(G_Setting:get("appstore_sandbox"))}})

    end

    ComSdkUtils.call("stAccountInfo", {{account=tostring(self:getPlatformUid())}, {server_id=tostring(serverId)},{role_id=tostring(G_Me.userData.id)}, {role_name=tostring(G_Me.userData.name)}, {server_name=tostring(serverName)}})

    ]]
	local serverId = self:getLoginServer().id
	local serverName = self:getLoginServer().name
	local _t ={}
	_t[GAMEDATA_SERVERID] = tostring(serverId)
	_t[GAMEDATA_ROLENAME] = tostring(G_Me.userData.name)
	_t[GAMEDATA_SERVERNAME] = tostring(serverName)
	_t[GAMEDATA_ACCOUNT] = tostring(self:getPlatformUid())
	_t[GAMEDATA_LEVEL] = tostring(G_Me.userData.level)
	_t[GAMEDATA_ROLEID] = tostring(G_Me.userData.id)
	_t[GAMEDATA_LOGINDATA] = tostring(self._loginData)

	ComSdkUtils.call("setGameData", {{keyName="userData"}, {keyValue=json.encode(_t)}})

end

function ComSdkProxy:_onCreatedRole()

    self:_setGameData()
    ComSdkUtils.call("onGameEvent", {{event="createRole"}})
    --GlobalFunc.uploadLog({{event_id="CreateRole"}})
    --GlobalFunc.save_event_log("CreateRole")

    if GAME_VERSION_NO  == 10200 then
        -- fuck , 平台在老包版本有问题，只能写死老包
        --ComSdkUtils.call( "startAd", {{eventid="e1"}} )
    end


    --ComSdkUtils.call( "startAd", {{eventid="e4"}} )

end


function ComSdkProxy:_onLevelUp()
    self:_setGameData()
    --ComSdkUtils.call("setGameData", {{keyName=GAMEDATA_LEVEL}, {keyValue=tostring(G_Me.userData.level)} })

    ComSdkUtils.call("onGameEvent", {{event="levelUp"}})

end

function ComSdkProxy:getOpId()
    return require("upgrade.ComSdkUtils").getOpId()
end

return ComSdkProxy
