g_package_loaded = {}
for k, _ in pairs(package.loaded) do
    if k ~= "src/main.lua" then
        table.insert(g_package_loaded, k)
    end
end
g_G = {}
for k, _ in pairs(_G) do
    table.insert(g_G, k)
end

-- require config
require("src/config")

local fu = cc.FileUtils:getInstance()
local writablePath = fu:getWritablePath()
fu:setPopupNotify(false)

--先获取 防止从内更新中获取
local target = fu:getStringFromFile("src/target")

local UPGRADE_DEAL_FULL_PATH = writablePath .. UPGRADE_DEAL_PATH

-- -- add search path
if APP_RUN_MODE == nil or APP_RUN_MODE == 1 or TEST_UPGRADE then
    local cjson = require("src.framework.json")
    local paths = fu:getSearchPaths()
    table.insert(paths, 1, UPGRADE_DEAL_FULL_PATH)
    table.insert(paths, 1, writablePath .. UPGRADE_PATH.."res/")
    table.insert(paths, 1, writablePath .. UPGRADE_PATH.."src/")
    fu:setSearchPaths(paths)

    local tempFile = UPGRADE_DEAL_FULL_PATH .. "project.manifest.temp"
    local normalFile = UPGRADE_DEAL_FULL_PATH .. "project.manifest"
    local copyFile = UPGRADE_DEAL_FULL_PATH .. "project.manifest.copy"
    if fu:isFileExist(tempFile) then
        local tempFileStr = fu:getStringFromFile(tempFile)
        local ret = string.find(tempFileStr,"downloadState")
        if ret == nil then--错的 需要删除
            fu:removeFile(tempFile)
            if fu:isFileExist(copyFile) then
                local copyFileStr = fu:getStringFromFile(copyFile)
                fu:writeStringToFile(copyFileStr,normalFile)
            end
        else
            
        end
    end

    if fu:isFileExist(normalFile) then
        local zipError = false--上次解压失败

        local jsonString=fu:getStringFromFile(normalFile)
        local copyFiles = cjson.decode(jsonString)
        local fullPathRead = nil
        local assetsManagerEx = nil
        local assetsName = nil
        if copyFiles and copyFiles.assets and type(copyFiles.assets) == "table" then
            for assetsName,v in pairs(copyFiles.assets) do
                fullPathRead = UPGRADE_DEAL_FULL_PATH..assetsName
                if fu:isFileExist(fullPathRead) then
                    if copyFiles.assets[assetsName].compressed then
                        fu:removeFile(fullPathRead)
                        zipError = true
                    end
                end
            end
        end
        fullPathRead = nil

        if zipError == false then
            fu:writeStringToFile(jsonString,copyFile)
        else
            fu:removeFile(normalFile)
            if fu:isFileExist(copyFile) then
                local copyFileStr = fu:getStringFromFile(copyFile)
                fu:writeStringToFile(copyFileStr,normalFile)
            end
        end
    end
end
fu:addSearchPath("src/")
fu:addSearchPath("res/")

-- -------------------------------
-- checkUpdateDone = function( ... )
--     if fu:isDirectoryExist(UPGRADE_DEAL_FULL_PATH) then
--         if fu:isFileExist(UPGRADE_DEAL_FULL_PATH.."project.manifest") then
            
--         end
--     end
-- end

----------------------平台配置----------------------
-- --有客户端会报不能全局的错  这里先开个全局
-- setmetatable(_G, {
--     __newindex = function(_, name, value)
--         rawset(_G, name, value)
--     end
-- })
-- require platform --平台配置信息
if target and tonumber(target) then
    TARGET_SPECIFIC = tonumber(target)
end

local channelType = TARGET_SPECIFIC--见config.lua
if channelType == -1 then
    channelType = QuickSDK:getChannelType()
end
local platform_config_name = SPECIFIC_CONFIG[channelType]

require(platform_config_name)
-----------------------平台配置-----------------------

-----------------------------------

local function main()
    require("app.MyApp").new():run()
end

main()