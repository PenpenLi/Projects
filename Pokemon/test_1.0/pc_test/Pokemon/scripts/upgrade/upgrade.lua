--upgrade.lua
--require("upgrade.Patcher")
require("app.common.tools.Tool")

require("upgrade.TrackManager")

cache_old_loadsting = loadstring 
local sharedApplication = CCApplication:sharedApplication()
local target = sharedApplication:getTargetPlatform()
if USE_FLAT_LUA == nil or USE_FLAT_LUA == "0" then 
	if target == kTargetIphone or target == kTargetIpad or target == kTargetAndroid or target == kTargetWindows or target == kTargetMacOS then
		FuncHelperUtil:loadChunkWithKeyAndSign("framework_precompiled.zip", "6d2a4052c2", "ZY")
	end
end 
if target ~= kTargetIphone and target ~= kTargetIpad and target ~= kTargetAndroid and target ~= kTargetWindows and target ~= kTargetMacOS then
	require("upgrade.config")
	require("cocos.init")
end

track_event_start("1-start_game")

require("upgrade.VersionUtils")

--nativeProxy 是对原生的各种调用
G_NativeProxy = require("upgrade.NativeProxy").new()
G_NativeProxy.registerNativeCallback( function(data) print("nativeProxy nil callback") end)

if G_NativeProxy.channelName == "test" then
    GAME_URL = GAME_URL_TEST
    print("this is test:" .. GAME_URL)
end

CCDirector:sharedDirector():runWithScene(require("upgrade.UpgradeScene").new())

