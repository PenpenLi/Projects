--
-- Author: YouName
-- Date: 2016-03-01 22:25:22
--
---------------解锁新关卡弹框
local UnlockNewLayerPop=class("UnlockNewLayerPop",function()
	return cc.Layer:create()
end)

local UpdateNodeHelper = require("app.common.UpdateNodeHelper")

function UnlockNewLayerPop:ctor( layer,onClose)
	-- body
	self:enableNodeEvents()

	self._onClose = onClose
	self._layer = layer
	self._csbNode = nil

	self._canClose = false
	self:setTouchEnabled(true)
    self:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self:registerScriptTouchHandler(function(event)
    	if event == "began" then
    		return true
    	elseif event == "ended" then
    		if self._canClose == true then
    			if self._onClose ~= nil then
    				self._onClose()
    			end
    			self:setTouchEnabled(false)
    			self:removeFromParent(true)
    		end
    	end
    end)

end

function UnlockNewLayerPop:_initUI( ... )
	-- body
	--G_AudioManager:playSoundById(9048)
	self._csbNode = cc.CSLoader:createNode("csb/thirtyThree/UnlockNewLayerPop.csb")
	self:addChild(self._csbNode)
	self._csbNode:setPosition(display.cx,display.cy)

	self._csbNode:setScale(0)
	local action = cc.ScaleTo:create(0.3,1)
	action = cc.EaseBackOut:create(action)
	self._csbNode:runAction(action)

	local panelHolder = self._csbNode:getSubNodeByName("Panel_holder")

	local nextLayerData = G_Me.thirtyThreeData:getLayerData(self._layer + 1)
	local currLayerData = G_Me.thirtyThreeData:getLayerData(self._layer)
	if(nextLayerData == nil)then return end
	local userLevel = G_Me.userData.level
	local openLevel = nextLayerData.layerCfg.level
	local isOpen = openLevel <= userLevel
	local imageTitle = self._csbNode:getSubNodeByName("Image_title")

	if isOpen == true then
		panelHolder:setContentSize(640,410)
		ccui.Helper:doLayout(panelHolder)
		self._csbNode:updateImageView("Image_title", {texture = G_Url:getText_system("txt_com_settl_reward11")})

		local con = self._csbNode:getSubNodeByName("Node_con")
		local cell1 = self:_createCell(1,nextLayerData,currLayerData)
		cell1:setPositionY(0)
		con:addChild(cell1)

		local cell2 = self:_createCell(2,nextLayerData,currLayerData)
		cell2:setPositionY(-240)
		con:addChild(cell2)

		local cell3 = self:_createCell(3,nextLayerData,currLayerData)
		cell3:setPositionY(-120)
		con:addChild(cell3)

		self:_playCellActioin(cell1,0.5)
		self:_playCellActioin(cell2,0.7)
		self:_playCellActioin(cell3,0.6)
	else
		panelHolder:setContentSize(640,300)
		ccui.Helper:doLayout(panelHolder)
		self._csbNode:updateImageView("Image_title", {texture = G_Url:getText_system("txt_com_settl_reward10")})

		local con = self._csbNode:getSubNodeByName("Node_con")
		local cell1 = self:_createCell(1,nextLayerData,currLayerData)
		cell1:setPositionY(0)
		con:addChild(cell1)

		local cell2 = self:_createCell(2,nextLayerData,currLayerData)
		cell2:setPositionY(-120)
		con:addChild(cell2)

		self:_playCellActioin(cell1,0.5)
		self:_playCellActioin(cell2,0.6)
	end

	--------------------
	imageTitle:setVisible(false)
	imageTitle:setScale(2)
	local action = cc.ScaleTo:create(0.25,1)
	action = cc.EaseBackOut:create(action)
	local seq = cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(function(node,p)
		node:setVisible(true)
	end),action)
	
	imageTitle:runAction(seq)

	self:performWithDelay(function()
		self._canClose = true
		local nodeContinue = cc.CSLoader:createNode("csb/common/CommonContinueNode.csb")
		UpdateNodeHelper.updateCommonContinueNode(nodeContinue,true)
		self:addChild(nodeContinue)
		--nodeContinue:setPosition(320,120)
	end, 1)
end

function UnlockNewLayerPop:_playCellActioin( cell,delay )
	-- body
	local startPos = {x=cell:getPositionX(),y=cell:getPositionY()}
	cell:setVisible(false)
	cell:setPositionX(startPos.x - 100)
	local action = cc.MoveTo:create(0.3,startPos)
	action = cc.EaseBackOut:create(action)
	local seq = cc.Sequence:create(cc.DelayTime:create(delay or 0.1),cc.CallFunc:create(function(node,p)
		node:setVisible(true)
	end),action)

	cell:runAction(seq)
end

function UnlockNewLayerPop:_createCell(cellType,layerData,currLayerData)
	-- body
	local cell = cc.CSLoader:createNode("csb/thirtyThree/UnlockCell.csb")

	local layerInfo = layerData.layerCfg
	local color = layerInfo.color
	local isOpen = layerInfo.level <= G_Me.userData.level
	local nodeCount = cell:getSubNodeByName("Node_count")
	local iconId = layerInfo.paper_icon

	local imageNew = cell:getSubNodeByName("Image_new")
	local fadeout = cc.FadeOut:create(0.5)
	local fadein = cc.FadeIn:create(0.5)
	local repeatAction = cc.Sequence:create(fadeout,fadein)
	repeatAction = cc.RepeatForever:create(repeatAction)
	imageNew:runAction(repeatAction)

	nodeCount:setVisible(false)
	nodeCount:updateLabel("Text_count_award", {outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,outlineSize = 2})
	cell:updateLabel("Text_icon_tips", {visible = false,outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,outlineSize = 2})
	if cellType == 1 then
		
		cell:updateLabel("Text_title1", {
			text = "解锁：",
			color = G_ColorsScrap.COLOR_SCENE_DESC_NORMAL,
			outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
			outlineSize = 2,
		})
		cell:updateLabel("Text_desc1", {
			text = layerInfo.chongtian,
			color = G_ColorsScrap.getColor(color),
			outlineColor = G_ColorsScrap.getColorOutline(color),
			outlineSize = 2,
		})
		
		cell:updateLabel("Text_title2", {
			text = isOpen == true and "掉落：" or "需主角",
			color = G_ColorsScrap.COLOR_SCENE_DESC_NORMAL,
			outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
			outlineSize = 2,
		})
		cell:updateLabel("Text_desc2", {
			text = isOpen == true and layerInfo.description or string.format("达到%d级",layerInfo.level),
			color = G_ColorsScrap.getColor(color),
			outlineColor = G_ColorsScrap.getColorOutline(color),
			outlineSize = 2,
		})

		cell:updateImageView("Image_icon", {visible = true,texture = G_Url:getIcon_item(iconId)})
	elseif cellType == 2 then
		nodeCount:setVisible(true)
		cell:updateLabel("Text_title1", {
			text = "首通：",
			color = G_ColorsScrap.COLOR_SCENE_DESC_NORMAL,
			outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
			outlineSize = 2,
		})
		cell:updateLabel("Text_desc1", {
			text = currLayerData.layerCfg.chongtian,
			color = G_ColorsScrap.getColor(currLayerData.layerCfg.color),
			outlineColor = G_ColorsScrap.getColorOutline(currLayerData.layerCfg.color),
			outlineSize = 2,
		})
		
		cell:updateLabel("Text_title2", {
			text = "获得：",
			color = G_ColorsScrap.COLOR_SCENE_DESC_NORMAL,
			outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
			outlineSize = 2,
		})
		cell:updateLabel("Text_desc2", {
			text = "闯关次数+1",
			color = G_ColorsScrap.COLOR_SCENE_NOTE,
			outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
			outlineSize = 2,
		})

		cell:updateImageView("Image_icon", {visible = false})
	elseif cellType == 3 then
		cell:updateLabel("Text_title1", {
			text = "解锁：",
			color = G_ColorsScrap.COLOR_SCENE_DESC_NORMAL,
			outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
			outlineSize = 2,
		})
		cell:updateLabel("Text_desc1", {
			text = layerInfo.chongtian,
			color = G_ColorsScrap.getColor(color),
			outlineColor = G_ColorsScrap.getColorOutline(color),
			outlineSize = 2,
		})
		
		cell:updateLabel("Text_title2", {
			text = "仙玉：",
			color = G_ColorsScrap.COLOR_SCENE_DESC_NORMAL,
			outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
			outlineSize = 2,
		})
		cell:updateLabel("Text_desc2", {
			text = "基础仙玉产量上升",
			color = G_ColorsScrap.COLOR_SCENE_NOTE,
			outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
			outlineSize = 2,
		})

		--类型3  掉落仙玉 id 200017
		cell:updateImageView("Image_icon", {visible = true,texture = G_Url:getIcon_item(200017)})
	end

	local textTitle1 = cell:getSubNodeByName("Text_title1")
	local textDesc1 = cell:getSubNodeByName("Text_desc1")
	local textTitle2 = cell:getSubNodeByName("Text_title2")
	local textDesc2 = cell:getSubNodeByName("Text_desc2")

	textDesc1:setPositionX(textTitle1:getPositionX() + textTitle1:getAutoRenderSize().width + 2)
	textDesc2:setPositionX(textTitle2:getPositionX() + textTitle2:getAutoRenderSize().width + 2)

	return cell
end

function UnlockNewLayerPop:onEnter( ... )
	-- body
	self:_initUI()
end

function UnlockNewLayerPop:onExit( ... )
	-- body
	if self._csbNode ~= nil then
		self._csbNode:removeFromParent(true)
		self._csbNode = nil
	end
end

return UnlockNewLayerPop