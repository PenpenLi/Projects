
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 1
DEBUG_FPS = false
DEBUG_MEM = true

-- design resolution
CONFIG_SCREEN_WIDTH  = 640
CONFIG_SCREEN_HEIGHT = 960

CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"
-- auto scale mode
--CONFIG_SCREEN_AUTOSCALE = function ( w, h )
--
--end

local sharedApplication = CCApplication:sharedApplication()
local target = sharedApplication:getTargetPlatform()
if target == kTargetAndroid then
	--JSON_ENCRYPT_POSTFIX = "encode"
	--JSON_ENCRYPT_KEY	= "905AC7969EC5"
	--PNG_ENCRYPT_KEY 		= "7917ACD719E8"
	--PNG_ENCRYPT_POSTFIX		= "encode"
	--USE_ENCRYPT_RES = true
else
	JSON_ENCRYPT_POSTFIX 	= ""
	JSON_ENCRYPT_KEY		= ""
	PNG_ENCRYPT_KEY 		= ""
	PNG_ENCRYPT_POSTFIX		= ""
	USE_ENCRYPT_RES = false
end

-- debug control flag
if target == kTargetWindows then
    SHOW_DEBUG_PANEL = 1
else
    SHOW_DEBUG_PANEL = 0
end

-- 更新模块开关，1表示打开，其它值为关闭
CONFIG_UPGRADE_MODULE = 1
-- windows 版本使用内更新的开关,1为打开,其它为关闭,开发人员最好关闭
WINDOWS_USE_UPGRADE	 = 1

LOAD_APP_ZIP = 0

-- 是否使用加密版本的lua代码（用于使用了对单个lua文件字节码和加密的对外的设备版本）
USE_ENCRYPT_LUA	= false

-- new user guide
SHOW_NEW_USER_GUIDE = true

-- flag which decide if to show exception tip layer
SHOW_EXCEPTION_TIP = true

--是否是和谐版
IS_HEXIE_VERSION = false

--是否是appstore版本
IS_APPSTORE_VERSION = false

--是否是渠道体验服
IS_TASTE_VERSION = false


GAME_VERSION_NAME = "0.0.2"
GAME_VERSION_NO	= 105
GAME_PACKAGE_NAME = "天天一击男"

USE_FLAT_LUA = "0"

--写死的OP ID, 如果包里没有接SDK,想额外制定OP ID
SPECIFIC_OP_ID = "1"
SPECIFIC_GAME_OP_ID = "1"
SPECIFIC_GAME_ID = "94"

local target = sharedApplication:getTargetPlatform()
if IS_TASTE_VERSION == false and (target == kTargetIphone or target == kTargetIpad or target == kTargetAndroid) then
    PROXY_CLASS= "app.platform.comSdk.ComSdkProxy"
else
    PROXY_CLASS= "app.platform.testPlatform.TestProxy"
end

--GAME_URL = "http://120.79.61.33:8087"

--GAME_URL = "http://192.168.1.23:8087"--内网测试
GAME_URL = "http://114.55.172.5:8087"--版属用

--GAME_URL = "http://114.55.42.27:8087"
 --GAME_URL = "http://47.97.37.193:8087"  --新的安卓包

VERSION_URL_TMPL = "http://localhost/nconfig/services/nconfig?action=get_config&game=#game#&op_game=#op_game#&op=#op#&v=#v#&iv=#iv#&d=#d#&platform=#platform#&t=#t#&model=#model#&m=#mem#&c=#cpu#&cm=#checkmodel#"
DEV_UPGRADE_ZIP_URL = ""

CC_USE_DEPRECATED_API = true
