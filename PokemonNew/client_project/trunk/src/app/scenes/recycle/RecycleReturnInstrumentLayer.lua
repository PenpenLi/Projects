--[====================[

    法宝分解返还材料预览面板

]====================]
local RecycleReturnBaseLayer = require("app.scenes.recycle.RecycleReturnBaseLayer")
local RecycleReturnInstrumentLayer = class("RecycleReturnInstrumentLayer", RecycleReturnBaseLayer)
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"

local PopupBase = require("app.popup.common.PopupBase")

-- static
function RecycleReturnInstrumentLayer.popup(returnResource, call)
    PopupBase.newPopup(function()
        return RecycleReturnInstrumentLayer.new(returnResource, call)
    end)
end

--
function RecycleReturnInstrumentLayer:ctor(returnResource, call)
    RecycleReturnInstrumentLayer.super.ctor(self, returnResource, call)
end

-- 初始化界面
function RecycleReturnInstrumentLayer:_initWidget()
    RecycleReturnInstrumentLayer.super._initWidget(self)
	
    --
    self._content:updateLabel("Text_title", G_LangScrap.get("recycle_confirm_decompose"))
    self._content:updateLabel("Text_top", G_LangScrap.get("recycle_you_will_get"))
    self._content:updateLabel("Text_bottom_recycle", G_LangScrap.get("recycle_confirm_tips_instrument"))
    self._content:updateLabel("Text_bottom", {visible = false})
    self._content:updateLabel("Text_cost", {visible = false})
    self._content:updateImageView("Image_cost", {visible = false})

    UpdateButtonHelper.updateNormalButton(
        self:getSubNodeByName("Button_cancle"),{
        desc = G_LangScrap.get("recycle_next_time")})

     UpdateButtonHelper.updateNormalButton(
        self:getSubNodeByName("Button_confirm"),{
        desc = G_LangScrap.get("recycle_decompose")})
end

return RecycleReturnInstrumentLayer