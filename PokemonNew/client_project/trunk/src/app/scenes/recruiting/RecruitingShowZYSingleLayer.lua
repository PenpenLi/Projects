--================================
--阵容招募单个招募展示面板

local RecruitingShowBaseSingleLayer = require "app.scenes.recruiting.RecruitingShowBaseSingleLayer"
local RecruitingShowZYSingleLayer = class("RecruitingShowZYSingleLayer", RecruitingShowBaseSingleLayer)

local UpdateNodeHelper = require "app.common.UpdateNodeHelper" 
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local RoundEffectHelper = require "app.common.RoundEffectHelper"

function RecruitingShowZYSingleLayer:ctor()
	RecruitingShowZYSingleLayer.super.ctor(self, 2)
	self._boughtScore = 0
	self._addAwards = nil
	self._brightItems = nil
end

--设置已购买的积分
function RecruitingShowZYSingleLayer:setBoughtScore(value, addAwards)
	self._boughtScore = value
	self._addAwards = addAwards
end

---设置需要被添加流光特效的道具信息
function RecruitingShowZYSingleLayer:setBrightAwards(items)
	self._brightItems = items
end

--返回一个icon显示
function RecruitingShowZYSingleLayer:_getAwardNode(award)
	local item = cc.CSLoader:createNode(G_Url:getCSB("CommonIconItemNode", "common"))
	award.disableTouch = true
	award.nameVisible = true
	UpdateNodeHelper.updateCommonIconItemNode(item, award)
	--判断是否要加流光
	for i = 1, #self._brightItems do
		local brightItem = self._brightItems[i]
		if award.type == brightItem.type and award.value == brightItem.value then
			RoundEffectHelper.addCommonIconRoundEffect(item)
			break
		end
	end
	return item
end

function RecruitingShowZYSingleLayer:_getAwardPos(index)
	local posIndex = #self._awards - index ---重置下标信息，让位置从上到下分布
	local xIndex = 1 - (posIndex % 2)
	local yIndex = math.floor(posIndex / 2)

	local xPos = display.width * 0.35 + xIndex * (display.width * 0.3)
	local yPos = display.height *0.64 + yIndex * 170
	return {x = xPos, y = yPos}
end

---获得描述文本以及位置
function RecruitingShowZYSingleLayer:_getDescTxtAndPos()
	local txt = G_LangScrap.get("recruiting_zy_buy_point", {num = self._boughtScore})
	local pos = cc.p(
		display.cx,
		display.height - display.height * 0.06 - 180
	)
	return txt, pos
end

function RecruitingShowZYSingleLayer:_onAwardsPlayOver()
	RecruitingShowZYSingleLayer.super._onAwardsPlayOver(self)

	local tagY = (display.width / display.height >= 0.75) and -70 or 0
	self._rootNode:runAction(cc.Spawn:create(
		cc.MoveBy:create(0.3, cc.p(0, - display.height * 0.17 + tagY)),
		cc.Sequence:create(
			cc.DelayTime:create(0.3 - 0.07),
			cc.CallFunc:create(function()
				self:_createShineEffect()
			end)
		),
		cc.Sequence:create(
			cc.DelayTime:create(0.3),
			cc.CallFunc:create(function()
				self:_showBottomNode()
				self:_updateAddAwardLabel()
			end)
		)
	))
end

function RecruitingShowZYSingleLayer:_createBottomNode()
	local bottomNode = RecruitingShowZYSingleLayer.super._createBottomNode(self)
	local currentPropNum = G_Me.recruitingData:getZYPropNum()
	local needPropOne = G_Me.recruitingData:getZYOneCostProp()

	local isEnoughItem = currentPropNum >= needPropOne

	bottomNode:updateLabel("Text_item_cost", isEnoughItem and needPropOne or G_Me.recruitingData:getZYOneCost())
	bottomNode:updateLabel("Text_item_value", isEnoughItem and currentPropNum or G_Me.userData.gold)
	bottomNode:updateImageView("Image_item_icon", G_Url:getCommonResIcon(isEnoughItem and "100093" or "100011"))
	bottomNode:updateImageView("Image_item_icon_total", G_Url:getCommonResIcon(isEnoughItem and "100093" or "100011"))

	return bottomNode
end

function RecruitingShowZYSingleLayer:_updateAddAwardLabel()
	if self._addAwards ~= nil then
		local descStr = "+" .. tostring(self._addAwards.award.size) .. G_LangScrap.get("lang_value_extra" .. self._addAwards.index)
		local addLable = display.newTTFLabel({
		    font = G_Path.getNormalFont(),
		    size = 28
		})

		local descPosX, descPosY = self._descTxt:getPosition()
		local descSize = self._descTxt:getContentSize()
		addLable:setPosition(descPosX + descSize.width, descPosY)
		self._endEffectNode:addChild(addLable, 3)
		

		addLable:setString(descStr)
		addLable:setColor(G_ColorsScrap.getCritColor(self._addAwards.index))
		addLable:enableOutline(G_ColorsScrap.getCritColorOutline(self._addAwards.index, true), 2)
	end
end

function RecruitingShowZYSingleLayer:_getKnightScaleAfterShow()
	return 0.65
end

return RecruitingShowZYSingleLayer