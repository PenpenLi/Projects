--[====================[

    装备重生返还材料预览面板

]====================]
local RecycleReturnBaseLayer = require("app.scenes.recycle.RecycleReturnBaseLayer")
local RecycleReturnBookWarRebornLayer = class("RecycleReturnBookWarRebornLayer", RecycleReturnBaseLayer)
local PopupBase = require("app.popup.common.PopupBase")
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"

-- static
function RecycleReturnBookWarRebornLayer.popup(returnResource, rebornMoney, call)
    PopupBase.newPopup(function()
        return RecycleReturnBookWarRebornLayer.new(returnResource, rebornMoney, call)
    end)
end

function RecycleReturnBookWarRebornLayer:ctor(returnResource, rebornMoney, call)
	 RecycleReturnBookWarRebornLayer.super.ctor(self, returnResource, call)

    -- 重生所需货币数量
    self._rebornMoney = rebornMoney
end


-- 初始化界面
function RecycleReturnBookWarRebornLayer:_initWidget()
    RecycleReturnBookWarRebornLayer.super._initWidget(self)
    
    --
    self._content:updateLabel("Text_title", G_LangScrap.get("recycle_confirm_rebron"))
    self._content:updateLabel("Text_top", G_LangScrap.get("recycle_rebron_you_will_get"))
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



return RecycleReturnBookWarRebornLayer