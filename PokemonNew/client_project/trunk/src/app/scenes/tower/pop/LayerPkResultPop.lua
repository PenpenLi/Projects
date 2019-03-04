--
-- Author: YouName
-- Date: 2015-10-22 16:59:58
--
local LayerPkResultPop=class("LayerPkResultPop",function()
	return display.newNode()
end)

local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local TypeConverter = require("app.common.TypeConverter")
local ItemConst = require("app.const.ItemConst")

-- params = {awards = {},layer = 1, isWin = true}
function LayerPkResultPop:ctor(params)
	-- body
	self:enableNodeEvents()
	self._params = params or {}
	self._csbNode = nil
end

function LayerPkResultPop:_initUI( ... )
	-- body
	--G_AudioManager:playSoundById(9045)
	self:setPosition(display.cx, display.cy)
	self._csbNode = cc.CSLoader:createNode("csb/thirtyThree/LayerPkResultPop.csb")
	self:addChild(self._csbNode)

	-- spine
	local spineKnight = require("app.common.KnightImg").new(3281)
	local nodeSpine = self._csbNode:getSubNodeByName("Node_spine")
	nodeSpine:addChild(spineKnight)
	spineKnight:setVisible(false)

	--总容器
	local nodeCon = self._csbNode:getSubNodeByName("Node_con")
	nodeCon:setVisible(false)
	--闯关成功
	local imageWin = self._csbNode:getSubNodeByName("Image_text_win")
	imageWin:setVisible(false)
	--对话框
	local nodeBubble = self._csbNode:getSubNodeByName("Node_bubble")
	nodeBubble:setVisible(false)
	local textBubbleDesc = self._csbNode:getSubNodeByName("Text_bubble_desc")
	if(self._params.isWin == true)then
		-- textBubbleDesc:setString(G_LangScrap.get("lang_tower_layer_success"))
		local bubbleInfoSuccess = require("app.cfg.bubble_info").get(78)
		assert(bubbleInfoSuccess,"bubble_info can't find id = 78")
		textBubbleDesc:setString(bubbleInfoSuccess.content)
	else
		-- textBubbleDesc:setString(G_LangScrap.get("lang_tower_layer_lose"))
		local bubbleInfoLose = require("app.cfg.bubble_info").get(79)
		assert(bubbleInfoLose,"bubble_info can't find id = 79")
		textBubbleDesc:setString(bubbleInfoLose.content)
	end
	----
	self._csbNode:updateLabel("Text_stage_progress", {text = ""})
	self._csbNode:updateLabel("Text_total_star", {text = ""})
	self._csbNode:updateLabel("Text_total_jinghun", {text = ""})
	self._csbNode:updateLabel("Text_total_money", {text = ""})
	---
	local scrollItems = self._csbNode:getSubNodeByName("ScrollView_items")
	local nodeAttr1 = self._csbNode:getSubNodeByName("Node_attr1")
	local nodeAttr2 = self._csbNode:getSubNodeByName("Node_attr2")
	local nodeAttr3 = self._csbNode:getSubNodeByName("Node_attr3")
	local nodeAttr4 = self._csbNode:getSubNodeByName("Node_attr4")
	local nodeTitle = self._csbNode:getSubNodeByName("Node_title")
	
	local textTitleOthers = self._csbNode:getSubNodeByName("Text_title_others")
	--奖励
	local scrollView = self._csbNode:getSubNodeByName("ScrollView_items")
	local scrollCon = display.newNode()
	scrollCon:setCascadeOpacityEnabled(true)
	scrollView:addChild(scrollCon)
	scrollView:setVisible(false)

	local textNoAwardDesc = self._csbNode:getSubNodeByName("Text_no_award_desc")
	textNoAwardDesc:setVisible(false)


	----------------绑定数据
	local isWin = self._params.isWin
	local layer = self._params.layer
	local nowStage,totalStage = G_Me.thirtyThreeData:getNowLayerProgress()
	if(isWin == false)then
		nowStage = nowStage -1
	end
	nodeAttr1:updateLabel("Text_stage_progress",tostring(nowStage).."/"..tostring(totalStage))

	local layerData = G_Me.thirtyThreeData:getLayerData(layer)
	local layerOwnStar = G_Me.thirtyThreeData:getNowStar()
	nodeAttr2:updateLabel("Text_total_star", {text = tostring(layerOwnStar).."/"..tostring(layerData.totalStar)})

	nodeAttr3:updateLabel("Text_total_jinghun", {text = "0"})
	nodeAttr4:updateLabel("Text_total_money", {text = "0"})

	local awards = self._params.awards or {}
	local awardParams = {}
	for i=1,#awards do
		local itemAward = awards[i]
		local params = {
			type = itemAward.type,
			size = itemAward.size,
			value = itemAward.value,
			disableTouch = true,
			needVisible = G_Me.equipData:isUpRankMaterialNeed(itemAward.type, itemAward.value),
		}
		awardParams[#awardParams + 1] = require("app.common.TypeConverter").convert(params)
	end

	table.sort(awardParams,function(a,b)
		local aType = 0 
		if a.type == TypeConverter.TYPE_ITEM then
			if a.cfg.item_type == ItemConst.ITEM_TYPE_PAPER then
				aType = 2
			elseif a.cfg.item_type == ItemConst.ITEM_TYPE_GEM then
				aType = 1
			end
		end
		local bType = 0 
		if b.type == TypeConverter.TYPE_ITEM then
			if b.cfg.item_type == ItemConst.ITEM_TYPE_PAPER then
				bType = 2
			elseif b.cfg.item_type == ItemConst.ITEM_TYPE_GEM then
				bType = 1
			end
		end

		if aType ~= bType then
			return aType > bType
		end

		if aType == bType and aType == 2 then
			return a.cfg.id > b.cfg.id
		end

		if aType == bType and aType == 1 then
			return a.cfg.color > b.cfg.color
		end

		if a.cfg.color ~= b.cfg.color then
			return a.cfg.color > b.cfg.color
		end

	end)

	local num = 0
	for i=1,#awardParams do
		local awardItem = awardParams[i]
		if(awardItem.type == TypeConverter.TYPE_TOWER_RESOURCE)then
			nodeAttr3:updateLabel("Text_total_jinghun", {text = tostring(awardItem.size)})
		elseif(awardItem.type == TypeConverter.TYPE_MONEY)then
			nodeAttr4:updateLabel("Text_total_money", {text = tostring(awardItem.size)})
		else
			local item = cc.CSLoader:createNode("csb/common/CommonIconItemNode.csb")
			item:setCascadeOpacityEnabled(true)
			item:setPosition(60 + 110*num,70)
			scrollCon:addChild(item)
			UpdateNodeHelper.updateCommonIconItemNode(item,awardItem)
			num = num + 1
		end
	end
	local innerW = num*110
	local scrollSize = scrollView:getContentSize()
	scrollView:setInnerContainerSize(cc.size(innerW,scrollSize.height))
	
	-----------------------------------------------------------------动画相关
	local function playOtherActions()
		nodeBubble:setVisible(true)
		nodeCon:setVisible(true)
		spineKnight:setVisible(true)
		--闯关成功动画
		-- if(self._params.isWin == true)then
			imageWin:setScale(2)
			imageWin:setVisible(true)
			local winAction = cc.ScaleTo:create(0.3,1)
			winAction = cc.EaseBackOut:create(winAction)
			imageWin:runAction(winAction)
		-- end
		--气泡动画
		nodeBubble:setScale(0)
		local actionBubble = cc.ScaleTo:create(0.3,1)
		actionBubble = cc.EaseBackOut:create(actionBubble)
		nodeBubble:runAction(actionBubble)

		--spine动画
		local startX = spineKnight:getPositionX()
		local startY = spineKnight:getPositionY()
		spineKnight:setPosition(startX - 80, startY + 50)
		spineKnight:setScale(1.2)
		local spineMoveAction = cc.MoveTo:create(0.3, cc.p(startX,startY))
		local spineScaleAction = cc.ScaleTo:create(0.3, 1)
		local spineSpawn = cc.Spawn:create(spineMoveAction,spineScaleAction)
		spineSpawn = cc.EaseBackOut:create(spineSpawn)
		spineKnight:runAction(spineSpawn)
	end
	
	self:performWithDelay(playOtherActions, 0.3)
	self:_playDelayShow(nodeTitle,0.5)
	self:_playAtcion(nodeAttr1,0.7)
	self:_playAtcion(nodeAttr2,0.9)
	self:_playAtcion(nodeAttr3,1)
	self:_playAtcion(nodeAttr4,1.2)
	self:_playDelayShow(textTitleOthers,1.3)
	if(#awards > 0)then
		scrollView:setVisible(true)
		self:_playDelayShow(scrollView,1.4)
	else
		textNoAwardDesc:setVisible(true)
		self:_playDelayShow(textNoAwardDesc,1.4)
	end
end


function LayerPkResultPop:_playDelayShow(node,delay )
	-- body
	node:setCascadeOpacityEnabled(true)
	node:setOpacity(0)
	local action = cc.FadeIn:create(0.2)
	local seq = cc.Sequence:create(cc.DelayTime:create(delay or 0),action)
	node:runAction(seq)
end

function LayerPkResultPop:_playAtcion(node,delay)
	-- body
	local startX = node:getPositionX()
	local startY = node:getPositionY()
	node:setPositionX(startX + 200)
	node:setVisible(false)
	local action = cc.MoveTo:create(0.3,cc.p(startX,startY))
	action = cc.EaseExponentialOut:create(action)
	local seq = cc.Sequence:create(cc.DelayTime:create(delay or 0),cc.CallFunc:create(function()
		node:setVisible(true)
	end),action)
	node:runAction(seq)
end

function LayerPkResultPop:onEnter( ... )
	-- body
	self:_initUI()
end

function LayerPkResultPop:onExit( ... )
	-- body
	if(self._csbNode ~= nil)then
		self._csbNode:removeFromParent(true)
		self._csbNode = nil
	end
end

return LayerPkResultPop