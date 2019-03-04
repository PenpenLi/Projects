--
DEBUG_FPS = false

--[[ 

0   开发模式 内网测试模式
1   发布模式

]]
APP_RUN_MODE = 1

-- 运营商
SPECIFIC_OP_ID = SPECIFIC_OP_IDS.GAME29

--0 无sdk  1 quicksdk
SDK_TYPE = 2

-- 运营平台
SPECIFIC_GAME_OP_ID = SPECIFIC_GAME_OP_IDS.IOS_APP_STORE

-- 游戏id
SPECIFIC_GAME_ID = 1

CFG_NAME = "29game_ios"

--------------------平台 游戏配置--------------------------
-- 开启新手引导
CONFIG_GUIDE_ENABLE = true

--显示打印
SHOW_PRINTINFO = false

-- 清空新手引导
CONFIG_GUIDE_CLEAR = false

-- 测试充值地址
RECHARGE_TEST_URL = "http://47.106.173.49:9999/platform/recharge"

--服务器列表覆盖config里面的地址
SERVERLIST_URL_TEMPLATE = "http://47.106.173.49/sgamesl/sl.php" .. "?op_id=" .. SPECIFIC_OP_ID .. "&sdk_type=" .. SDK_TYPE .. "&platform_id=" .. SPECIFIC_GAME_OP_ID .. "&game_id=" .. SPECIFIC_GAME_ID
print("SERVERLIST_URL_TEMPLATE",SERVERLIST_URL_TEMPLATE)
-- platform proxy
-- sdk  "app.platform.comsdk.ComSdkProxy"
-- PROXY_CLASS = "app.platform.comsdk.ComSdkProxy"
-- test "app.platform.testPlatform.TestProxy"
PROXY_CLASS = "app.platform.game29.Game29SdkProxy"

PRODUCT_TYPE = 1--recharge_info 里面的读取相关

--平台自己的资源
PLATFORM_RES = {
	LOGIN_BG = "platform/game29/login.png",
	LOGIN_LOGO = "platform/game29/logo.png",
	--LOGIN_BG_ALIGN = 1,-- 0 中间 1 上 2 下
	CARD_FACE = "platform/game29/card.png",
}

USE_MAJIA = false -- 使用马甲

-- PRODUCTCODE = "74065005429221500460218572954591"

CONFIG_GAME_DEBUG = false--用于测试的debug配置 如战斗的控制