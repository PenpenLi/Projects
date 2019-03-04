--[====================[

    武将置换选择面板

]====================]
local RecycleChooseBaseLayerTab = require("app.scenes.recycle.RecycleChooseBaseLayerTab")
local RecycleChooseKnightRebornLayer_tab = class("RecycleChooseKnightRebornLayer_tab", RecycleChooseBaseLayerTab)

--
function RecycleChooseKnightRebornLayer_tab:ctor()
    RecycleChooseKnightRebornLayer_tab.super.ctor(self)
    
    self._tipsWord = G_LangScrap.get("recycle_no_knights_2_reborn")
end

-- 初始化界面
function RecycleChooseKnightRebornLayer_tab:_initWidget()
    RecycleChooseKnightRebornLayer_tab.super._initWidget(self)
end

-- 创建Cell回调处理
function RecycleChooseKnightRebornLayer_tab:_onCreateCell(view, idx)
    return require("app.scenes.recycle.RecycleChooseKnightRebornCellTab").new(handler(self, self._onCellConfirm))
end

-- 更新Cell回调处理
function RecycleChooseKnightRebornLayer_tab:_onUpdateCell(view, cell, idx)
    local data = self._datas[idx + 1]
    print("test_han111")
    dump(data)
    cell:updateCell(data, idx)
end

-- 选择Cell回调处理
function RecycleChooseKnightRebornLayer_tab:_onCellConfirm(index)
    -- local data = self._datas[index + 1]
    G_Popup.tip(index.."")
    -- dump(selected)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_KNIGHT_EXCHANGE,nil,false,self._datas[index + 1])
    -- if data then
    --     G_Me.recycleData:setSelectedItems(data.serverData.id)
    G_ModuleDirector:popModule()
    --     return true
    -- end
    
    -- return false

end

--
function RecycleChooseKnightRebornLayer_tab:_updateWidget()
    if #self._datas == 0 then
        self:_addNoItemsTip()
    else
        self:_removeNoItemsTip()
    end
end

---点击返回按钮后调用
function RecycleChooseKnightRebornLayer_tab:_onBackClick()
    G_ModuleDirector:popModule()
end

return RecycleChooseKnightRebornLayer_tab