--[====================[

    宝物重生选择面板

]====================]
local RecycleChooseBaseLayer = require("app.scenes.recycle.RecycleChooseBaseLayer")
local RecycleChooseTreasureRebornLayer = class("RecycleChooseTreasureRebornLayer", RecycleChooseBaseLayer)

--
function RecycleChooseTreasureRebornLayer:ctor()
    RecycleChooseTreasureRebornLayer.super.ctor(self)
    
    self._tipsWord = G_LangScrap.get("recycle_no_treasure_2_reborn")
end

-- 初始化界面
function RecycleChooseTreasureRebornLayer:_initWidget()
    RecycleChooseTreasureRebornLayer.super._initWidget(self)

    local tabNodes = self:getSubNodeByName("ProjectNode_tab_buttons")

    local params = {
        tabs = {{text = G_LangScrap.get("recycle_choose_treasure")}},
        defaultIndex = 1,
        isBig = true
    }

    local tabButtons = require("app.common.TabButtonsHelper").updateTabButtons(tabNodes, params, function (index) end)
end

-- 创建Cell回调处理
function RecycleChooseTreasureRebornLayer:_onCreateCell(view, idx)
    return require("app.scenes.recycle.RecycleChooseTreasureRebornCell").new(handler(self, self._onCellSelected))
end

-- 更新Cell回调处理
function RecycleChooseTreasureRebornLayer:_onUpdateCell(view, cell, idx)
    local data = self._datas[idx + 1]
    cell:updateCell(data, idx)
end

-- 选择Cell回调处理
function RecycleChooseTreasureRebornLayer:_onCellSelected(index, selected)
    local data = self._datas[index + 1]
    if data then
        G_Me.recycleData:setSelectedItems(data.id)
        G_ModuleDirector:popModule()
        return true
    end
    
    return false
end

--
function RecycleChooseTreasureRebornLayer:_updateWidget()
    if #self._datas == 0 then
        self:_addNoItemsTip()
    else
        self:_removeNoItemsTip()
    end
end

function RecycleChooseTreasureRebornLayer:_onBackClick()
    G_ModuleDirector:popModule()
end

return RecycleChooseTreasureRebornLayer