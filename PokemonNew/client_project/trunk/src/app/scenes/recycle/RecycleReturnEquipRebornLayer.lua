--[====================[

    装备重生返还材料预览面板

]====================]
local RecycleReturnBaseLayer = require("app.scenes.recycle.RecycleReturnBaseLayer")
local RecycleReturnEquipRebornLayer = class("RecycleReturnEquipRebornLayer", RecycleReturnBaseLayer)
local PopupBase = require("app.popup.common.PopupBase")
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"

-- static
function RecycleReturnEquipRebornLayer.popup(returnResource, rebornMoney, call,type)
    PopupBase.newPopup(function()
        return RecycleReturnEquipRebornLayer.new(returnResource, rebornMoney, call,type)
    end)
end

function RecycleReturnEquipRebornLayer:ctor(returnResource, rebornMoney, call,type)
	 RecycleReturnEquipRebornLayer.super.ctor(self, returnResource, call)
     dump(type)
    -- 重生所需货币数量
    self._rebornMoney = rebornMoney
    self._type = type
end


-- 初始化界面
function RecycleReturnEquipRebornLayer:_initWidget()
    RecycleReturnEquipRebornLayer.super._initWidget(self)
    dump(self._type)
    --
    self._content:updateLabel("Text_title", G_LangScrap.get("recycle_confirm_rebron"))
    self._content:updateLabel("Text_top", G_LangScrap.get("recycle_rebron_you_will_get"))
    self._content:updateLabel("Text_top_desc", {text = "（重生后，已消耗洗练石不返回）",visible = (self._type and self._type ~= 2)})
    --self._content:updateLabel("Text_bottom", G_LangScrap.get("recycle_rebron_you_cost"))
    self._content:updateLabel("Text_cost", self._rebornMoney )--.. G_LangScrap.get("recycle_rebron_are_you_sure"))
    self._content:updateLabel("Text_bottom_recycle", {visible = false})

    UpdateButtonHelper.updateNormalButton(
        self:getSubNodeByName("Button_cancle"),{
        desc = G_LangScrap.get("recycle_next_time")})

     UpdateButtonHelper.updateNormalButton(
        self:getSubNodeByName("Button_confirm"),{
        desc = G_LangScrap.get("recycle_rebron")})

end



return RecycleReturnEquipRebornLayer