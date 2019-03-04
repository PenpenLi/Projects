
-- CommonWidgets.lua

--[==========================[

    通用控件管理

    名字等机制暂时还没改，等方案确定

]==========================]

local TopBarWidget = import(".TopBarWidget")

local CommonWidgets=class("CommonWidgets")

local widgetsConst={
    ["mainmenu"]={mod_path="app.ui.components.MainMenuWidget",args=nil},
    ["topbar"]={mod_path="app.ui.components.TopBarWidget",args=TopBarWidget.STYLE_BASE},
    ["topbarBase"]={mod_path="app.ui.components.TopBarWidget",args=TopBarWidget.STYLE_BASE},
    ["topbarName"]={mod_path="app.ui.components.TopBarWidget",args=TopBarWidget.STYLE_NAME},
    ["topbarLevel1"]={mod_path="app.ui.components.TopBarWidget",args=TopBarWidget.STYLE_LEVEL1},
    ["topbarLevel2"]={mod_path="app.ui.components.TopBarWidget",args=TopBarWidget.STYLE_LEVEL2},
    ["topbarPower"]={mod_path="app.ui.components.TopBarWidget",args=TopBarWidget.STYLE_LEVEL3},
    ["topbarBaseBlock"]={mod_path="app.ui.components.TopBarWidget",args=TopBarWidget.STYLE_BASE_BLOCK},
    ["topbarLevel1Block"]={mod_path="app.ui.components.TopBarWidget",args=TopBarWidget.STYLE_LEVEL1_BLOCK},
    ["topbarLevel2Block"]={mod_path="app.ui.components.TopBarWidget",args=TopBarWidget.STYLE_LEVEL2_BLOCK},
    ["topbarLevel3Block"]={mod_path="app.ui.components.TopBarWidget",args=TopBarWidget.STYLE_LEVEL3_BLOCK},
    ["topbarPowerBlock"]={mod_path="app.ui.components.TopBarWidget",args=TopBarWidget.STYLE_POWER},
    ["topbarResBlock"]={mod_path="app.ui.components.TopBarWidget",args=TopBarWidget.STYLE_RES_BLOCK},
    ["topbarResMine"]={mod_path="app.ui.components.TopBarWidget",args=TopBarWidget.STYLE_RES_MINE},
    ["topbarResMatch"]={mod_path="app.ui.components.TopBarWidget",args=TopBarWidget.STYLE_RES_MATCH},
    ["topbarResSoul"]={mod_path="app.ui.components.TopBarWidget",args=TopBarWidget.STYLE_RES_SOUL_STONE},
    ["waiting"]={mod_path="app.ui.components.WaitingWidget"},
    ["backButton"]={mod_path="app.ui.components.BackButtonWidget"},
}

function CommonWidgets:ctor()
    
    -- 控件的缓存列表
    self._widgetList = {}

    -- 控件名映射缓存
    self._widgetName = {
        ["topbar"] = "topbar",
        ["mainmenu"] = "mainmenu",
        ["waiting"] = "waiting",
        ["backButton"] = "backButton",
    }

end

function CommonWidgets:getMainMenu()
    return self:getWidgetByName(self._widgetName["mainmenu"])
end

function CommonWidgets:getTopBar()
    return self:getWidgetByName(self._widgetName["topbar"])
end

function CommonWidgets:removeTopBar()
    local topbar = self:getTopBar()
    if topbar then
        topbar:removeFromParent(true)
        self._widgetList["topbar"] = nil
    end
end

function CommonWidgets:getBackButton()
    -- body
    return self:getWidgetByName(self._widgetName["backButton"])
end

function CommonWidgets:getWaiting()
    -- body
    return self:getWidgetByName(self._widgetName["waiting"])
end

function CommonWidgets:getWidgetByName(name,res_type)

    if not widgetsConst[name] then return nil end

    local widget = widgetsConst[name]

    local localName = name
    if string.find(name, "topbar") then
        localName = "topbar"
    end

    self._widgetName[localName] = name

    local w = self._widgetList[localName]

    if not w then
        w = require(widget.mod_path).new(widget.args)
        w:retain()
    end

    if string.find(name, "topbar") then
        w:setStyle(widget.args,res_type)
    end

    self._widgetList[localName] = w

    return w
end

function CommonWidgets:clear()
    for k,v in pairs(self._widgetList) do
        v:release()
    end
    self._widgetList = {}
end

return CommonWidgets