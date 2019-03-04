
---================
---普通情况下招募单个成功展示界面
local RecruitingShowBaseSingleLayer = require "app.scenes.recruiting.RecruitingShowBaseSingleLayer"
local RecruitingShowNormalSingleLayer = class("RecruitingShowNormalSingleLayer", RecruitingShowBaseSingleLayer)

local TypeConverter = require "app.common.TypeConverter"
local ItemConst = require "app.const.ItemConst"


function RecruitingShowNormalSingleLayer:ctor(type)
	RecruitingShowNormalSingleLayer.super.ctor(self,type)
	self._prop = nil
	self._type = type
	self._oneMoreCost = 0
	self._coppor = 0
end

---设置招募消耗的道具，和道具数量
function RecruitingShowNormalSingleLayer:setProp(prop, value)
	self._prop = prop
	dump(prop)
	self._oneMoreCost = value
end

function RecruitingShowNormalSingleLayer:setBoughtCopper(value)
	self._coppor = value
end

--返回一个武将显示
function RecruitingShowNormalSingleLayer:_getAwardNode(award)
	dump(award)
	local param = TypeConverter.convert(award)
	local cfg = {
		knightData = param,
		scale = 1,
		fontSize = 28,
		isVoice = true
	}
	local node = self._type == 2 and self:_createEquipImg(cfg) or self:_createKnightImg(cfg)
	local nameLabel = node:getSubNodeByName("name_label")
	nameLabel:setVisible(false)

	---在武将节点上添加武将的其他信息显示
	--if self._type ~= 2 then
		local infoNode = self:_createKnightInfo(param)
		infoNode:setName("info_node")
		infoNode:setScale(0.6)
		infoNode:setPositionY(-40)
		node:addChild(infoNode)
	--end
	
	return node
end

function RecruitingShowNormalSingleLayer:_onAwardsPlayOver()
	RecruitingShowNormalSingleLayer.super._onAwardsPlayOver(self)

	print("dddddddddddddddd")
	--self:_createShineEffect()
	local seq = cc.Sequence:create(
		cc.DelayTime:create(0.3),
		cc.CallFunc:create(function()
			self:_showBottomNode()
		end)
	)
	self:runAction(seq)
end

function RecruitingShowNormalSingleLayer:_getAwardPos(index)
	
	return {x = display.cx, y = display.cy}
end

---获得描述文本以及位置
function RecruitingShowNormalSingleLayer:_getDescTxtAndPos()
	local txt = G_Lang.get("recruiting_money_desc", {num = self._coppor})
	local factor = display.height <= 853 and 1 or display.height/853 * 1.5
	local pos = cc.p(
		display.cx,
		display.height - display.height * 0.06 * factor
	)
	return txt, pos
end

function RecruitingShowNormalSingleLayer:_createBottomNode()
	local bottomNode = RecruitingShowNormalSingleLayer.super._createBottomNode(self)
	local propTotalNum = 0
	local iconUrl = ""
	
	if self._prop.type == TypeConverter.TYPE_GOLD then
		iconUrl = G_Url:getCommonResIcon("100011")
		propTotalNum = G_Me.userData.gold
	elseif self._prop.type == TypeConverter.TYPE_ITEM then
		if self._prop.value == ItemConst.ZHAO_XIAN_LING_ID then
			iconUrl = G_Url:getCommonResIcon("icon_mini_zhaomu1")
			propTotalNum = G_Me.recruitingData:getNormalPropNum()
		elseif self._prop.value == ItemConst.SS_ZHAO_JIANG_LING_ID then
			iconUrl = G_Url:getCommonResIcon("icon_mini_zhaomu2")
			propTotalNum = G_Me.recruitingData:getJPPropNum()
		elseif self._prop.value == ItemConst.SS_SHEN_QI_LING then
			iconUrl = G_Url:getCommonResIcon("icon_mini_zhuanshu1")
			propTotalNum = G_Me.propsData:getPropItemNum(ItemConst.SS_SHEN_QI_LING)
		elseif self._prop.value == ItemConst.CS_SHEN_QI_LING then
			iconUrl = G_Url:getCommonResIcon("icon_mini_zhuanshu2")
			propTotalNum = G_Me.propsData:getPropItemNum(ItemConst.CS_SHEN_QI_LING)
		end
	end

	bottomNode:updateLabel("Text_item_cost", tostring(propTotalNum).."/"..tostring(self._oneMoreCost))
	bottomNode:updateLabel("Text_item_value", propTotalNum)
	bottomNode:updateImageView("Image_item_icon", iconUrl)
	bottomNode:updateImageView("Image_item_icon_total", iconUrl)
	return bottomNode
end

--单抽不显示名字
function RecruitingShowNormalSingleLayer:_createKnightImg(param, withName, withVoice, scale, fontSize)
	return RecruitingShowNormalSingleLayer.super._createKnightImg(self, param, false, withVoice, scale)
end


--武将展示完后的效果添加。
function RecruitingShowNormalSingleLayer:_onShowKnigthOver(awardNode, param)
	---在武将节点上添加武将的其他信息显示
	local infoNode = self:_createKnightInfo(param)
	infoNode:setPositionY(-40)
	awardNode:addChild(infoNode)
end

return RecruitingShowNormalSingleLayer