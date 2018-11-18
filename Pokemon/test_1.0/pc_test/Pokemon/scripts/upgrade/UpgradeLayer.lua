--UpgradeLayer.lua
--require("lfs");
require("framework.debug")
require("upgrade.VersionUtils")
local EffectNode = require("upgrade.EffectNode_Upgrade")

local sharedApplication = CCApplication:sharedApplication()
local target = sharedApplication:getTargetPlatform()

function os.exists(path)
    return CCFileUtils:sharedFileUtils():isFileExist(path)
end
function os.mkdir(path)
    if not os.exists(path) then
        if target == kTargetWP8 or target == kTargetWinRT then
            CCFileUtils:sharedFileUtils():createDirectory(path)
        else
            require("lfs");
            return lfs.mkdir(path)
        end
    end
    return true
end

local function io_filesize(path)
    local size = false
    local file = io.open(path, "r")
    if file then
        local current = file:seek()
        size = file:seek("end")
        file:seek("set", current)
        io.close(file)
    end
    return size
end

local function string_split(str, delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(str, delimiter, pos, true) end do
        table.insert(arr, string.sub(str, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(str, pos))
    return arr
end

local function showGameAlert(content,  yesCallback, hasNo, noCallback)
    local msgbox = CCSModelLayer:create("ui_layout/common_NewMessageBox_Upgrade.json", ccc4(0, 0, 0, 178) )
    msgbox:showWidgetByName("Label_title", false)

    if hasNo then
        msgbox:showWidgetByName("Button_ok", false)

    else
        msgbox:showWidgetByName("Button_yes", false)
        msgbox:showWidgetByName("Button_no", false)

    end

    if hasNo then

        msgbox:registerBtnClickEvent("Button_yes", function ( ... )
            if  yesCallback  ~= nil  then
                yesCallback()
            end
            if msgbox then
                msgbox:removeFromParentAndCleanup(true)
            end

        end)

        msgbox:registerBtnClickEvent("Button_no", function ( ... )
            if  noCallback  ~= nil  then
                noCallback()
            end
            if msgbox then
                msgbox:removeFromParentAndCleanup(true)
            end

        end)
    else
      msgbox:registerBtnClickEvent("Button_ok", function ( ... )
          if  yesCallback  ~= nil  then
              yesCallback()
          end
          if msgbox then
              msgbox:removeFromParentAndCleanup(true)
          end

      end)
    end

    msgbox:showAtCenter(true)

    msgbox:showTextWithLabel("Label_content", content)
    CCDirector:sharedDirector():getRunningScene():addChild(msgbox)
end

function os.rmdir(path)
    if os.exists(path) then
        if target == kTargetWP8 or target == kTargetWinRT then
            CCFileUtils:sharedFileUtils():removeDirectory(path)
            CCFileUtils:sharedFileUtils():createDirectory(path)
        else
            require("lfs")
            local function _rmdir(path)
            local iter, dir_obj = lfs.dir(path)
            while true do
                local dir = iter(dir_obj)
                if dir == nil then break end
                if dir ~= "." and dir ~= ".." then
                   -- print("os.rmdir:", dir)
                    local curDir = path..dir
                    local mode = lfs.attributes(curDir, "mode")
                    if mode == "directory" then
                        _rmdir(curDir.."/")
                    elseif mode == "file" then
                        os.remove(curDir)
                       --  print(curDir)
                    end
                end
            end
            local succ, des = os.remove(path)
            if des then print(des) end
            return succ
         end
            _rmdir(path)
        end
    end
    return true
end

function __createHTTPRequestGet__( url, callback, target )
      local network = require("framework.network")
    local httpHandler = function ( event )
      if target ~= nil and callback ~= nil then
          callback(target, event)
      elseif callback ~= nil then
          callback(event)
      end
    end
    local request = network.createHTTPRequest(httpHandler, url, "GET")
    return request
end


local UpgradeLayer = class("UpgradeLayer", function ( ... )
    return CCSNormalLayer:create("ui_layout/common_upgradeLayer.json")
end)

local backup_domains = {} -- 备用的CDN域名, 如果URL域名是 cdn.m.uuzuonline.com, 那么就使用backup_domains轮流重试
local looking_domains = {}

local function final_url(url)

    if #backup_domains == 0 then
        return url
    end

    --[[if string.find(url, "http://cdn.m.uuzuonline.com" ) == 1 then
       local info = looking_domains[url]

       if info == nil then
          looking_domains[url] =  0
       end

       if looking_domains[url] ==  0 then
            return url
       end

       local index = looking_domains[url]
       local newurl = string.gsub(url, "http://cdn.m.uuzuonline.com", "http://" .. backup_domains[index] )

       print("change final url ->" .. tostring(newurl))
       return newurl
    end]]

    return url
end

local function remember_bad_url(url)
    if #backup_domains == 0 then
        return url
    end
end

function UpgradeLayer:ctor( ... )
    CCFileUtils:sharedFileUtils():purgeCachedEntries()

    --self._platformJsonUrl = ""
    self._upgradeJsonUrl = nil

    self._packageVerionNo = 0
    self._packageVerionName = ""
    self._localUpgradeVersionNo = 0
    self._upgradeList = nil
    self._curUpgradeItem = nil

    --[[
     local createStroke = function ( name )
        local label = self:getLabelByName(name)
        if label then
            label:createStroke(ccc3(51, 0, 0), 1)
        end
    end
    createStroke("Label_check_upgrade")
    ]]
    self:enableLabelStroke("Label_check_upgrade", ccc3(51, 0, 0), 1 )
    self:enableLabelStroke("Label_download_desc", ccc3(51, 0, 0), 1 )
    self:enableLabelStroke("Label_progress", ccc3(51, 0, 0), 1 )
    self:enableLabelStroke("Label_err_msg", ccc3(51, 0, 0), 1)
    self:enableLabelStroke("Label_game_init", ccc3(51, 0, 0), 1)
    local upgradeDir = getUpgradeDir()
    FuncHelperUtil:createDirectory(upgradeDir)

    local ComSdkUtils = require("upgrade.ComSdkUtils")
    ComSdkUtils.updateOpId()

    self:adapterWithScreen()
    self:_initLocalVersion()
    self:_initNodeEvent()
    self:_initEffect()
end

function UpgradeLayer:_initEffect( )
    --local upgradeFolder = getUpgradeDir() .. "res/"
    --[[
    local effectPatchFile =  getUpgradeDir() .. "/upgrade_patch.json"
    --if not(self ==nil)then return end
    local patched = false
    if os.exists(effectPatchFile) then

        local json = require "framework.json"
        local content  = json.decode( io.readfile(effectPatchFile)  )
        if content ~= nil and type(content) == "table" then

            if content['isUpgradeDir'] == "1" then
                self:_addUpgradeToResSearchPath(upgradeFolder)
            end
            if content['back_type'] == "image" then
                local image = CCSprite:create(content['back_name'])
                if image then
                    self:getWidgetByName("Image_back"):addNode(image)
                    patched = true
                end
            elseif content['back_type'] == "effect" then
                local effect = EffectNode.new(content['back_name'])
                effect:play()
                self:getWidgetByName("Image_back"):addNode(effect)
                patched = true
            end

            if content['logo_name'] then
                self:getImageViewByName("Image_logo"):loadTexture(content['logo_name'])
                patched = true
            end
        end
    end

    if patched then return end
    ]]

    if not IS_HEXIE_VERSION then
        local effect =     EffectNode.new("effect_signinew")
        effect:play()
        --effect:setPosition(ccp(0, 50))
        self:getWidgetByName("Image_back"):addNode(effect)
    end
end

function UpgradeLayer:_addUpgradeToResSearchPath(upgradeFolder )
    if self._addedSearchPath == nil then
        if G_NativeProxy.platform ~= "windows" or (G_NativeProxy.platform == "windows" and  WINDOWS_USE_UPGRADE == 1 ) then
            --CCFileUtils:sharedFileUtils():addSearchPath(upgradeFolder)
            AutoUpgradeHelper:setUpgradeFolder(upgradeFolder)
            --print("++++++++++++++++update+++++++++++++++++", upgradeFolder)
            self._addedSearchPath = true
        end
    end
end

function UpgradeLayer:_shouldResetUpgrade( )
    return false
    --has install_version and install_version != PACKAGE version then reset( save install_version, local_version)
    -- no install_version  then reset and save

    --对于国内版本,还是老的判断,对外其他海外版本,因为有小包存在,所以需要特殊判断
    --[[
    if LANG == nil or LANG == "cn" then
            print("aaaaa==")
        if self._localUpgradeVersionNo <= self._packageVerionNo  then
            return true
        else
            return false
        end
    else
            print("bbbb")
        local installNo = getInstallVersionNo()
        if tostring(installNo) == '0' then
            return true
        else
            if tostring(installNo) ~= tostring(GAME_VERSION_NO) then
                return true
            else
                return false
            end
        end
    end
    ]]
end

function UpgradeLayer:_initLocalVersion( ... )
    self._packageVerionNo = GAME_VERSION_NO
    self._packageVerionName = GAME_VERSION_NAME
    local localVersion = getLocalVersionNo()
    --local curVersionName = versionNoToName(self._localUpgradeVersionNo)

    --local upgradeFolder = getUpgradeDir() .."res/"
    --local upgradeScriptsFolder = getUpgradeDir() .."scripts/"

    --[[
    if isApp64Version() then
        upgradeScriptsFolder = getUpgradeDir() .."scripts64/"
    end
    ]]

    if self:_shouldResetUpgrade() then
    -- if self._localUpgradeVersionNo <= self._packageVerionNo then
            --clear
            --os.rmdir(upgradeScriptsFolder)
            --os.rmdir(upgradeFolder)
            --print("package version is higher: remove upgrade folder["..upgradeFolder.."]")
            --self._localUpgradeVersionNo = self._packageVerionNo
      setLocalVersionNo(self._localUpgradeVersionNo)
      setInstallVersionNo(GAME_VERSION_NO)
    end

    if localVersion == 0 then
      setInstallVersionNo(GAME_VERSION_NO)
    end
    if localVersion < self._packageVerionNo then
      setLocalVersionNo(self._packageVerionNo)
    end
    print("curVersionName===local:".. localVersion 
            .. ";packVersion:" .. self._packageVerionNo .. "," .. self._packageVerionName)
    self._localUpgradeVersionNo = localVersion

    --print("package_verion_no:["..self._packageVerionNo.."], package_verion_name:["..self._packageVerionName.."], local_upgrade_version:["..self._localUpgradeVersionNo.."]")
    self:_addUpgradeToResSearchPath(upgradeFolder)
    --设置lua 目录
    local m_package_path = package.path
    package.path = string.format("%s?.lua;%s", upgradeScriptsFolder, m_package_path)
    --print("new lua path: " .. package.path)

    --self:showWidgetByName("Image_back", true)
end

function UpgradeLayer:_initNodeEvent( ... )
    local handler = function(event, param1, param2)
        if event == "enter" then
            self:onLayerEnter()
        elseif event == "exit" then
            --self:onLayerExit()
        elseif event == "cleanup" then
            --self:onLayerUnload()
        end
    end
    self:registerScriptHandler(handler)
end

function UpgradeLayer:onLayerEnter( )
    self:showWidgetByName("Label_check_upgrade", true)
    self:showWidgetByName("Label_unzip_tip", false)
    self:_loadingText("Label_check_upgrade", true, "平台初始化中")

    self:_run()
    --[[
    local ComSdkUtils = require("upgrade.ComSdkUtils")

    --这里判断平台，如果是comsdk要调用init函数然后等待
    if PROXY_CLASS == "app.platform.comSdk.ComSdkProxy" then
        ComSdkUtils.registerNativeCallback(function(data)
            if data.event == "callback_init_ok" then
                self:_run()
            elseif data.event == "OPCheckVersion" then
                -- static int OP_CHECK_WITH_NEW_VERSION  = 100;//检查到有版本更新
                -- static int OP_CHECK_WITHOUT_NEW_VERSION = 101;//检查到没有版本更新
                -- static int OP_CHECK_WITHOUT_CHECK_VERSION = 102;//没有版本更新接口
                if data.ret == 100 then
                    --wait
                    return
                elseif data.ret == 101 then
                    --continue
                elseif data.ret == 102 then
                    --upgrade by game
                end
                --self._platformJsonUrl = ComSdkUtils.getVersionUrl(VERSION_URL_TMPL)
                self:_run()
            end
        end)
        ComSdkUtils.call("init")
        ComSdkUtils.call("stGameEvent", {{event_id="OpenGame"}, {param1=""}})
    else
        --self._platformJsonUrl = ComSdkUtils.getVersionUrl(VERSION_URL_TMPL)
        self:_run()
    end
    ]]
end

function UpgradeLayer:_loadingText( ctrlName, loading, text )
    if type(ctrlName) ~= "string" then
        return
    end
    local label = self:getLabelByName(ctrlName)
    if not label then
        return
    end
    if not loading then
        label:stopAllActions()
    else
        text = text or ""
        label:setText(text)
        local arr = CCArray:create()
        local delaytime = 0.4
        arr:addObject(CCDelayTime:create(delaytime))
        arr:addObject(CCCallFunc:create(function ( ... )
            self:showTextWithLabel(ctrlName, text.." .")
                end))
        arr:addObject(CCDelayTime:create(delaytime))
        arr:addObject(CCCallFunc:create(function ( ... )
            self:showTextWithLabel(ctrlName, text.." . .")
                end))
        arr:addObject(CCDelayTime:create(delaytime))
        arr:addObject(CCCallFunc:create(function ( ... )
            self:showTextWithLabel(ctrlName, text.." . . .")
                end))
        arr:addObject(CCDelayTime:create(delaytime))
        arr:addObject(CCCallFunc:create(function ( ... )
            self:showTextWithLabel(ctrlName, text)
                end))
        label:runAction(CCRepeatForever:create(CCSequence:create(arr)))
    end
end

function UpgradeLayer:_run( )
  --self:_initLocalVersion()
    self:showWidgetByName("Label_check_upgrade", false)
    self:showWidgetByName("Label_game_init", true)
    self:_loadingText("Label_game_init", true, "正在读取游戏信息")
    --added by adong, 为了方便在开发阶段真机测试，不用每次打包，强制内更新
    --[[if DEV_UPGRADE_ZIP_URL and DEV_UPGRADE_ZIP_URL ~= "" then
        FileDownloadUtil:getInstance():registerDownloadHandler(function ( ... )
            self:_onDownloadHandler(...)
        end)
        local upgradeFolder = getUpgradeDir() .."res/"

        os.rmdir(upgradeFolder)
        self:_doInnerUpgrade()
        --return
    end]]
    local costTime = 0
    self:scheduleUpdate(function ( deltaTime )
        costTime = costTime + deltaTime
        if costTime > 1 then
            self:unscheduleUpdate()
            if CONFIG_UPGRADE_MODULE ~= 1 then
                return self:_onUpgradeComplete( true)
            end
            self:_doCheckGameVersion()
        end
    end, 0)
end

-- 游戏整包更新检查
function UpgradeLayer:_doCheckGameVersion()

    local hasNetwork = G_NativeProxy.hasNetwork()
    if not hasNetwork then
        showGameAlert("您现在网络似乎没有连接，请打开网络后点击确定重试！", function()
            self:_doCheckGameVersion() 
        end)
        return
    end

    FileDownloadUtil:getInstance():registerDownloadHandler(function ( ... )
        self:_onDownloadHandler(...)
    end)

    local writePath = CCFileUtils:sharedFileUtils():getWritablePath()
    --writePath = writePath..FuncHelperUtil:queryFileName(self._platformJsonUrl)
    local ComSdkUtils = require("upgrade.ComSdkUtils")
    local url = GAME_URL .. "/check_version?op_id=" .. ComSdkUtils.getOpId()  .. "&sdk_id=" .. ComSdkUtils.getSdkId() .. "&version=" .. self._localUpgradeVersionNo
    print("check version:", url)

    local request = __createHTTPRequestGet__(url, function(self,event)
        local request = event.request
        local errorCode = request:getErrorCode()
        local errMsg = nil
        local response = request:getResponseString()
        print("upgrade_resp:", response)
        if errorCode ~= 0  then
            errMsg = "您的网络有点问题, 无法获取游戏初始化信息, 请点击确定重试("..errorCode..")。"
        end 
        if not check_json_format(response) then
            errMsg =  "更新配置错误，请重试！"
        end
        if errMsg ~= nil then
            showGameAlert(errMsg, function() 
                self:_doCheckGameVersion()
            end)
        else
            self:_onParsePlatformFile(response)
        end
    end, self)
    request:start()
    --self:_onUpgradeComplete(true)
end

function UpgradeLayer:_onParsePlatformFile( response )
    local ComSdkUtils = require("upgrade.ComSdkUtils")
    response = decodeJson(response)
    local versionContent = ComSdkUtils.setConfigContent(response)
    --[[
    if self:_checkShouldUpgradeGame(versionContent) then
        self:_doUpdateWholePackage(versionContent["version_url_type"], versionContent["version_url"],  versionContent["version_desc"])
    else
    ]]
    if not self:_doCheckInnerVersion( versionContent) then
        self:_onUpgradeComplete(true)
    end
end

function UpgradeLayer:_checkShouldUpgradeGame( versionContent )
    if type(versionContent) ~= "table" then
        return false
    end
    if not versionContent["version"] or not versionContent["version_url"] then
        return false
    end
    local versionNo = versionContent["version"]
    local versionNumber = versionNameToNo(versionNo)
    --print("versionNo:",versionNo)
    if versionNumber == 0 then
        return false
    end

    self._packageVerionNo = GAME_VERSION_NO
    return versionNumber > self._packageVerionNo
end

function UpgradeLayer:_doUpdateWholePackage( installType, url, desc )
    --print("start do whole package update: type=["..installType.."], url=["..url.."]")
    --installType = installType
    if desc == nil or desc == "" then
        desc = "检测到新版本需要更新"
    end
    showGameAlert(desc, function()
        if G_NativeProxy.platform  == "ios" then
            G_NativeProxy.openURL(url)
        elseif G_NativeProxy.platform == 'android' then
            if installType == "download_package" then
                G_NativeProxy.downloadAndInstallAPK(final_url(url))
            else
                G_NativeProxy.openURL(url)
            end
        elseif G_NativeProxy.platform == 'wp8' or G_NativeProxy.platform == 'winrt' then
            G_NativeProxy.openInnerUrl(url, "")
        else
            print("current platform doesn't support whole package upgrade!")
        end
    end)
end

-- 游戏内更新检查
function UpgradeLayer:_doCheckInnerVersion( versionContent )
    if not versionContent then
        return false
    end
    local newVersionStr = versionContent["upgrade_version"] or 0
    newVersion = versionNameToNo(newVersionStr)
    --self._localUpgradeVersionNo=GAME_VERSION_NO
    print("_doCheckInnerVersion:curVerion is:["..self._localUpgradeVersionNo.."], newVersion is:["..newVersion.."], no upgrade")
    if newVersion <= self._localUpgradeVersionNo then
        return false
    end
    self._upgradeJsonUrl = versionContent["upgrade_url"]
    print("self._upgradeJsonUrl:",self._upgradeJsonUrl)
    if type(self._upgradeJsonUrl) ~= "string" or #self._upgradeJsonUrl < 5 then
        print(self._upgradeJsonUrl, "_doCheckInnerVersion: url is invalid!")
        return false
    end
    --print("self.nextVersion:", newVersionStr)
    local ComSdkUtils = require("upgrade.ComSdkUtils")
    local url = self._upgradeJsonUrl .. "?op_id=" .. ComSdkUtils.getOpId() .. "&v=" .. self._localUpgradeVersionNo
    print("version_res_url:", url)
    local request = __createHTTPRequestGet__(url, function(self,event)
        local request = event.request
        local errorCode = request:getErrorCode()
        local response = request:getResponseString()
        self:_onDownloadUpgradeJsonFile(response)
    end, self)
    request:start()
    return true
end

function UpgradeLayer:_onDownloadUpgradeJsonFile( response )
    if type(response) ~= "string" then
        return
    end

    local ComSdkUtils = require("upgrade.ComSdkUtils")
    response = decodeJson(response)
    if not response or type(response["versions"]) ~= "table" then
        --print("[_onDownloadUpgradeJsonFile] invalid response:"..tostring(response))
        self:_onUpgradeComplete(true)
        return
    end
    local versions = response["versions"]
    --local curVersionName = versionNoToName(self._localUpgradeVersionNo)
    local list = {}
    local packSize = 0
    for k , v in pairs(versions) do 
        packSize = packSize + v.size
        list[ #list + 1] = v
    end
    self._upgradeList = list

    if packSize > 0 then
        local postfix = "B"
        local strSize = ""
        if packSize/(1024*1024) >= 1 then
            strSize = string.format("%.02f", packSize/(1024*1024))
            postfix = "MB"
        elseif packSize/1024 >= 1 then
            strSize = string.format("%.02f", packSize/1024)
            postfix = "KB"
        else
            strSize = 1
            postfix = "KB"
        end
        local text = string.format("有更新包可以更新了，大小%s%s, 点击确定开始更新！", strSize, postfix)
        showGameAlert(text, function() self:_doInnerUpgrade() end)
    else
    end
end

function UpgradeLayer:_doInnerUpgrade( ... )
    local list = self._upgradeList
    if list == nil or #list ==0 then
        self:_onUpgradeComplete(true)
    end
    local info = list[#list]
    --print("_doInnerUpgrade", info, self._upgradeList, self._upgradeIndex)
    if info == nil then
        self:_onUpgradeComplete(true)
        return 
    end
    self._curUpgradeItem = info
    local packUrl = info["url"]
    --self._upgradePackUrl = packUrl
    local fileName = FuncHelperUtil:queryFileName(packUrl)
    self:showWidgetByName("Label_game_init", false)
    self:_loadingText("Label_check_upgrade", false)
    self:showWidgetByName("Panel_inner_upgrade", true)
    self:showTextWithLabel("Label_download_desc", fileName)
    self:showTextWithLabel("Label_progress", "")
    self:showWidgetByName("Label_unzip_tip", false)
    self:showWidgetByName("Label_progress", true)

    local loadingBar = self:getLoadingBarByName("ProgressBar_download")
    if loadingBar then loadingBar:setPercent(0) end

    if target == kTargetWP8 or target == kTargetWinRT then
        local dir = CCFileUtils:sharedFileUtils():getWritablePath() .. "temp/"
        CCFileUtils:sharedFileUtils():removeDirectory(dir)
        CCFileUtils:sharedFileUtils():createDirectory(dir)
        local file = dir .. fileName
        io.writefile(file, json.encode({}), "w+b")
    end

    local writePath = getUpgradeDir() .. fileName
    print("start", packUrl)
    local downloadFile = FileDownloadUtil:getInstance():addDownloadTask(packUrl, writePath, "", true)
    if downloadFile then
        print("downloadFile:",downloadFile)
        io.writefile(downloadFile, json.encode({}), "w+b")
    end
end

function getUpgradeDir()
    local upgradeFolder = CCFileUtils:sharedFileUtils():getWritablePath()
    upgradeFolder = upgradeFolder.. "upgrade/"
    return upgradeFolder
end

function UpgradeLayer:_onDownloadHandler( eventName, ret, fileUrl, filePath, param1, param2 )
    if type(eventName) ~= "string" then
        return
    end
   --print("eventName:"..eventName..", ret:"..ret..", url:<"..fileUrl..">, path:<"..filePath..", param1:"..param1..", param2"..param2)
    if eventName == "start" then
        self:_onStartDownloadFile(fileUrl, filePath )
    elseif eventName == "progress" then
        self:_onUpgradeProgress(fileUrl, ret, param1, param2)
    elseif eventName == "success" then
        self:_onDownloadSuccess(fileUrl, filePath)
    elseif eventName == "failed" then
        self:_onUpgradeFailed(fileUrl, filePath, ret )
    elseif eventName == "inerrupt" then
    elseif eventName == "finish" then
    elseif eventName == "unzip" then
        self:_onUnzipFile(ret, fileUrl, filePath)
    end
end

function UpgradeLayer:_onDownloadSuccess( fileUrl, filePath )
    print("[_onDownloadSuccess] url="..fileUrl..", filePath="..filePath)

    local item = self._curUpgradeItem
    if item and item.url and item.url == fileUrl then
        --self:_onUpgradeComplete(true)
    elseif self._upgradeJsonUrl and self._upgradeJsonUrl == fileUrl then
        self:_onDownloadUpgradeJsonFile(filePath)
    end
end

function UpgradeLayer:_onUpgradeFailed( fileUrl, filePath, ret  )
    local errMsg = nil
    if ret == header_not_found_code then
        errMsg = "网络连不通或文件不存在!"
    elseif ret == download_couldnt_write_file then
        errMsg = "权限错误，文件无法写入!"
    elseif ret == download_result_over_count then
        errMsg = "下载失败次多过多，请稍后继续!"
    elseif ret == download_conn_init_failed then
        errMsg = "网络初始化失败！"
    elseif ret == 6 then
        errMsg = "您的网络有点问题!"
    else
        errMsg = "未知错误"
    end
    print("_onUpgradeFailed:fileurl="..fileUrl..", ret="..ret..", errMsg="..errMsg)

    errMsg = errMsg.."(错误码:"..(ret or -1).."), 点击确定重试."
    if errMsg then
        --remember_bad_url(self._upgradePackUrl)
        showGameAlert(errMsg, function()
            self:_doInnerUpgrade()
        end)
    end
end

function UpgradeLayer:_onUnzipFile( ret, fileUrl, filePath )
    ret = ret or 1
    --print("_onUnzipFile: ret="..ret..", fileurl:"..fileUrl)
    local item = self._curUpgradeItem
    if item and item.url and item.url == fileUrl then
        if ret == 0 then
            self:_loadingText("Label_unzip_tip", false)
            setLocalVersionNo(versionNameToNo(item["versions"]))
            table.remove(self._upgradeList, #self._upgradeList)
            self:_doInnerUpgrade()
            --self:_onUpgradeComplete(true)
        elseif ret == 1 then
            self:showWidgetByName("Label_unzip_tip", true)
            self:showWidgetByName("Label_progress", false)
            self:_loadingText("Label_unzip_tip", true, "解压缩")
        elseif ret == -4 then
            self:_loadingText("Label_unzip_tip", false, "解压缩")
            self:showTextWithLabel("Label_unzip_tip", "解压缩失败")
        else
            local errText = string.format("未知错误(%d)", ret)
            self:_loadingText("Label_unzip_tip", false, "解压缩")
            self:showTextWithLabel("Label_unzip_tip", errText)
        end
    end
end

function UpgradeLayer:_onUpgradeComplete( success )
    if success then
        --added by adong， 如果是开发快速内更新测试版本， 添加lua的搜索路径
        if DEV_UPGRADE_ZIP_URL and DEV_UPGRADE_ZIP_URL ~= ""  then
            local m_package_path = package.path
            package.path = string.format("%sscripts/?.lua;%s", getUpgradeDir(), m_package_path)
            print("new lua path: " .. package.path)
        end
        FileDownloadUtil:getInstance():unregisterDownloadHandler()
        require("upgrade.game")
    end
end

function UpgradeLayer:_onStartDownloadFile( fileUrl, filePath )
    print("_onStartDownloadFile:url=["..fileUrl.."], filePath=["..filePath.."]")
end

function UpgradeLayer:_onUpgradeProgress( fileUrl, progress, totalDownload, nowDownload )
    local item = self._curUpgradeItem
    if item and item.url and item.url == fileUrl then
        local maxSize = totalDownload
        local postfix = "B"
        if totalDownload/(1024*1024) >= 1 then
            totalDownload = totalDownload/(1024*1024)
            postfix = "MB"
        elseif totalDownload/1024 >= 1 then
            totalDownload = totalDownload/1024
            postfix = "KB"
        end
        local curDownload = totalDownload*progress/100
        curDownload = curDownload - curDownload%0.01
        totalDownload = totalDownload - totalDownload %0.01

        self:showTextWithLabel("Label_progress", curDownload.."/"..totalDownload..postfix)

        local loadingBar = self:getLoadingBarByName("ProgressBar_download")
        if loadingBar then
            loadingBar:setPercent(progress)
        end
    end
end

return UpgradeLayer
