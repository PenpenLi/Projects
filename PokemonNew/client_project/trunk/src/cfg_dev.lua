--
DEBUG_FPS = false

--[[ 

0   开发模式 内网测试模式
1   发布模式

]]
APP_RUN_MODE = 0

-- 运营商
SPECIFIC_OP_ID = 0

--0 无sdk  1 quicksdk
SDK_TYPE = 0

-- 运营平台
SPECIFIC_GAME_OP_ID = "yinhusdk2_lstd_001"

-- 游戏id
SPECIFIC_GAME_ID = 1

CFG_NAME = "develop"

--------------------平台 游戏配置--------------------------
-- 开启新手引导
CONFIG_GUIDE_ENABLE = true

-- 清空新手引导
CONFIG_GUIDE_CLEAR = false

--显示打印
SHOW_PRINTINFO = true

-- 测试充值地址
RECHARGE_TEST_URL = "http://10.104.24.78:9999/platform/recharge"
-- RECHARGE_TEST_URL = "http://47.106.173.49:9999/zhishang/recharge"

--服务器列表覆盖config里面的地址
SERVERLIST_URL_TEMPLATE = 
	"http://47.106.173.49/sgamesl/sl.php" .. 
--	"http://10.104.24.78/sgamesl/sl.php" .. 
	"?op_id=" .. 50000 .. 
	"&sdk_type=" .. 5 .. 
	"&platform_id=" .. 30000 .. 
	"&game_id=" .. SPECIFIC_GAME_ID


print("SERVERLIST_URL_TEMPLATE",SERVERLIST_URL_TEMPLATE)
-- platform proxy
-- sdk  "app.platform.comsdk.ComSdkProxy"
-- PROXY_CLASS = "app.platform.comsdk.ComSdkProxy"
-- test "app.platform.testPlatform.TestProxy"
PROXY_CLASS = "app.platform.testPlatform.TestProxy"

PRODUCT_TYPE = 0--recharge_info 里面的读取相关

USE_MAJIA = false -- 使用马甲

PRODUCTCODE = ""

CONFIG_GAME_DEBUG = true--用于测试的debug配置 如战斗的控制