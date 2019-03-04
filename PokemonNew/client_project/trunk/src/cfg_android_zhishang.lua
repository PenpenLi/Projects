--
DEBUG_FPS = false

--[[ 

0   开发模式 内网测试模式
1   发布模式

]]
APP_RUN_MODE = 1

-- 运营商
SPECIFIC_OP_ID = SPECIFIC_OP_IDS.ZHISHANG

--0 无sdk  1 quicksdk 2 zhishang
SDK_TYPE = SDK_TYPES.ZHISHANG

-- 运营平台
SPECIFIC_GAME_OP_ID = 50000
local fu = cc.FileUtils:getInstance()
local fileName = "AsdkPublisher.txt"
if fu:isFileExist(fileName) then
	local content = fu:getStringFromFile(fileName)
	if string.find(content,"huaweisdk") then
		SPECIFIC_GAME_OP_ID = 24
	elseif string.find(content,"ucsdk") then
		SPECIFIC_GAME_OP_ID = 9
	elseif string.find(content,"migamesdk") then
		SPECIFIC_GAME_OP_ID = 60000
	end
end

-- 游戏id
SPECIFIC_GAME_ID = 1

CFG_NAME = "zhishang"

--------------------平台 游戏配置--------------------------
-- 开启新手引导
CONFIG_GUIDE_ENABLE = true

--显示打印
SHOW_PRINTINFO = false

-- 清空新手引导
CONFIG_GUIDE_CLEAR = false

-- 测试充值地址
RECHARGE_TEST_URL = "http://47.106.173.49:9999/zhishang/recharge"

--服务器列表覆盖config里面的地址
SERVERLIST_URL_TEMPLATE = "http://47.106.173.49/sgamesl/sl.php" .. "?op_id=" .. SPECIFIC_OP_ID .. "&sdk_type=" .. SDK_TYPE .. "&platform_id=" .. SPECIFIC_GAME_OP_ID .. "&game_id=" .. SPECIFIC_GAME_ID
print("SERVERLIST_URL_TEMPLATE",SERVERLIST_URL_TEMPLATE)
-- platform proxy
-- sdk  "app.platform.comsdk.ComSdkProxy"
-- PROXY_CLASS = "app.platform.comsdk.ComSdkProxy"
-- test "app.platform.testPlatform.TestProxy"
PROXY_CLASS = "app.platform.zhishang.ZhiShangsdkProxy"

PRODUCT_TYPE = 0--recharge_info 里面的读取相关

USE_MAJIA = false -- 使用马甲

PRODUCTCODE = ""

CONFIG_GAME_DEBUG = false--用于测试的debug配置 如战斗的控制