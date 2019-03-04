--[====================[

    装备分解返还材料预览面板

]====================]
local RecycleReturnBaseLayer = require("app.scenes.recycle.RecycleReturnBaseLayer")
local RecycleReturnEquipMaterialLayer = class("RecycleReturnEquipMaterialLayer", RecycleReturnBaseLayer)
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"

local PopupBase = require("app.popup.common.PopupBase")

-- static
function RecycleReturnEquipMaterialLayer.popup(returnResource, call,type)
    PopupBase.newPopup(function()
        return RecycleReturnEquipMaterialLayer.new(returnResource, call,type)
    end)
end

--
function RecycleReturnEquipMaterialLayer:ctor(returnResource, call,type)
    RecycleReturnEquipMaterialLayer.super.ctor(self, returnResource, call)

    self._type = type
end

-- 初始化界面
function RecycleReturnEquipMaterialLayer:_initWidget()
    RecycleReturnEquipMaterialLayer.super._initWidget(self)
	
    --
    self._content:updateLabel("Text_title", G_LangScrap.get("recycle_confirm_decompose"))
    self._content:updateLabel("Text_top", G_LangScrap.get("recycle_you_will_get"))
    self._content:updateLabel("Text_top_desc", {text = "（分解后，已消耗洗练石不返回）",visible = (self._type and self._type ~= 2)})
    self._content:updateLabel("Text_bottom_recycle", G_LangScrap.get("recycle_confirm_tips_equip_material"))
    self._content:updateLabel("Text_bottom",{visible = false})
    self._content:updateLabel("Text_cost", {visible = false})
    self._content:updateImageView("Image_cost", {visible = false})

    UpdateButtonHelper.updateNormalButton(
        self:getSubNodeByName("Button_cancle"),{
        desc = G_LangScrap.get("recycle_next_time")})

    UpdateButtonHelper.updateNormalButton(
        self:getSubNodeByName("Button_confirm"),{
        desc = G_LangScrap.get("recycle_decompose")})
end

return RecycleReturnEquipMaterialLayer