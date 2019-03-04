--
-- Author: YouName
-- Date: 2015-10-22 15:55:10
--
--[[
	隐藏宝箱弹窗
]]
local HideBoxPop=class("HideBoxPop",function()
	return display.newNode()
end)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")

function HideBoxPop:ctor( onClose )
	-- body
	self:enableNodeEvents()
	self._onClose = onClose
	self._nodeAwards = nil
	self._csbNode = nil
	self._goldCost = 0
	self._leftCount = 0
	self._btnBack = nil
	self._btnBack2 = nil
	self._btnOpen = nil

	self._awardsList = {}
	self._isFirstOpen = true
end

--UI界面初始化
function HideBoxPop:_initUI( ... )
	-- body
	self:setPosition(display.cx, display.cy)
	self._csbNode = cc.CSLoader:createNode("csb/tower/HideBoxPop.csb")
	self:addChild(self._csbNode)

    self._nodeAwards = self._csbNode:getSubNodeByName("Node_awards")
    self._particle = self._csbNode:getSubNodeByName("Particle_light")
    self._particle:setVisible(false)
    
    local btnBack = self._csbNode:getSubNodeByName("ProjectNode_back")
    local btnBack2 = self._csbNode:getSubNodeByName("ProjectNode_back2")
    local btnOpen = self._csbNode:getSubNodeByName("ProjectNode_open")

    btnBack2:setVisible(false)
    btnOpen:setVisible(false)
	self._btnBack = btnBack
	self._btnBack2 = btnBack2
	self._btnOpen = btnOpen
	self._btnOpen_btn = self._btnOpen:getSubNodeByName("Button_common")--btn实体

    UpdateButtonHelper.updateBigButton(btnBack,{
    	desc = G_LangScrap.get("lang_tower_text_back"),
    	state = UpdateButtonHelper.STATE_NORMAL,
    	callback = function()
    		self:_onGiveUpTowerBox()
    		-- G_HandlersManager.thirtyThreeHandler:sendGiveUpTowerBox()
    	end
    })

    -- UpdateButtonHelper.updateBigButton(btnBack2,{
    -- 	desc = G_LangScrap.get("lang_tower_text_back"),
    -- 	state = UpdateButtonHelper.STATE_NORMAL,
    -- 	callback = function()
    -- 		self:_onGiveUpTowerBox()
    -- 		-- G_HandlersManager.thirtyThreeHandler:sendGiveUpTowerBox()
    -- 	end
    -- })
	
	local leftCount = G_Me.thirtyThreeData:getLeftCount()

	self._desNode = self._csbNode:getSubNodeByName("Node_des")
	self._panelOpen = self._csbNode:updatePanel("Panel_open", {
		callback = function()
	    	if(leftCount > 0)then
		    	require("app.responder.Responder").enoughGold(self._goldCost,function()
			    	self._nodeAwards:setVisible(true)
			    	self._nodeAwards:removeAllChildren(true)
			    	--local isFive = self._csbNode:getSubNodeByName("CheckBox_check_box"):isSelected()
			    	-- G_HandlersManager.thirtyThreeHandler:sendOpenTowerBox(isFive and 5 or 1)
			    	G_HandlersManager.thirtyThreeHandler:sendOpenTowerBox(1)
		    	end)
	    	end
    	end
		})
	self._panelOpen:setTouchEnabled(true)

    self:_refreshCost()

    -- UpdateButtonHelper.updateBigButton(btnOpen,{
    -- 	desc = G_LangScrap.get("lang_tower_text_open"),
    -- 	state = UpdateButtonHelper.STATE_ATTENTION,
    -- 	callback = function()
	   --  	if(leftCount > 0)then
		  --   	require("app.responder.Responder").enoughGold(self._goldCost,function()
			 --    	self._nodeAwards:setVisible(true)
			 --    	self._nodeAwards:removeAllChildren(true)
			 --    	local isFive = self._csbNode:getSubNodeByName("CheckBox_check_box"):isSelected()
			 --    	-- G_HandlersManager.thirtyThreeHandler:sendOpenTowerBox(isFive and 5 or 1)
			 --    	G_HandlersManager.thirtyThreeHandler:sendOpenTowerBox(1)
		  --   	end)
	   --  	end
    -- 	end
    -- })

    --宝箱待机动画
    if self._csbNode == nil then
    	return
    end
    local nodeEffect = self._csbNode:getSubNodeByName("Node_effect")
    local nodeEffect2 = self._csbNode:getSubNodeByName("Node_effect2")
	local nodeOpen = display.newNode()
	nodeOpen:setCascadeOpacityEnabled(true)
	nodeEffect:addChild(nodeOpen)
	nodeEffect:setLocalZOrder(5)
	self._boxEffect = require("app.effect.EffectNode").new("effect_slbx1")
	self._boxEffect:play()
	nodeOpen:addChild(self._boxEffect)

	--self:_playFinger()

	----------开5次
	-- local vipInfo = require("app.cfg.vip_function_info").get(428)
	-- assert(vipInfo,"vip_function_info can't find id = 428")
	-- local vipLevel = G_Me.vipData:getVipLevel()

	self._csbNode:getSubNodeByName("Node_vip_open"):setVisible(false)
	-- self._csbNode:getSubNodeByName("Node_vip_open"):setVisible(vipLevel >= vipInfo.level)

	
	-- 背景特效，置于上层 ---这个暂时不要
	local EffectMovingNode = require "app.effect.EffectMovingNode"
    local effect = EffectMovingNode.new("moving_choujiang_hude1", 
        function(effect)
            if effect == "txt" then
                return display.newSprite(G_Url:getText_system("txt_com_settl_get01"))
            -- elseif effect == "txt_bg" then
            --     local subEffect = EffectNode.new("effect_huode_a")
            --     subEffect:play()
            --     return subEffect
            -- elseif effect == "txt_shine" then
            --     local subEffect = EffectNode.new("effect_win_22")
            --     subEffect:play()
            --     return subEffect
            -- elseif effect == "frame_line" then
            --     return EffectNode.new("effect_win_1")
            elseif effect == "houzi" then
                local effectRole = require("app.effect.EffectNode").new("effect_huode_showgirl")
                effectRole:play()
                return effectRole
                --return display.newSprite(G_Url:getUI_common("icon_com_role03"))
            end
        end
    )

    nodeEffect2:addChild(effect)
    effect:setPosition(0, 256)
    effect:play()
    self._effect = effect
    self._effect:setVisible(false)

    self._topLine = self._csbNode:getSubNodeByName("reward_pop_top_line")
    self._bottomLine = self._csbNode:getSubNodeByName("reward_pop_bottom_line")
    self._topLine:setVisible(false)
    self._bottomLine:setVisible(false)
end

--手指指示
function HideBoxPop:_playFinger( ... )
	self._finger = self._csbNode:getSubNodeByName("Image_finger")
	self._finger:setVisible(true)
	local beginPos = cc.p(self._finger:getPosition())
	local endPos = cc.p(beginPos.x-50,beginPos.y-50)

	local move1 = cc.MoveTo:create(1, endPos)
	local move2 = cc.MoveTo:create(0.2, beginPos)
	local ease = cc.EaseExponentialOut:create(move2)

	self._finger:runAction(cc.RepeatForever:create(cc.Sequence:create(move1,ease)))
end

--收到放弃开启隐藏宝箱通知
function HideBoxPop:_onGiveUpTowerBox( ... )
	-- body
	if(self._onClose ~= nil)then
		local list = clone(self._awardsList)
		self._onClose(list)
	end
	G_Me.thirtyThreeData:setToTempStage()
	self:removeFromParent(true)
	uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_MT_CHECK_AWARD_BUFF,nil,false)
end

--刷新界面
function HideBoxPop:_refreshCost( ... )
	-- body
	if(self._csbNode == nil)then return end
	local functionId = 11903
	local nowLayer = G_Me.thirtyThreeData:getNowLayer()
	local leftCount = G_Me.thirtyThreeData:getLeftCount()
	local goldCost = G_Me.thirtyThreeData:getOpenCost()

	self._leftCount = leftCount

	--常量描述
	for i=1,4 do
		self._csbNode:updateLabel("Text_desc_"..tostring(i), {
			textColor = G_Colors.getColor(11),
			fontSize = 22,
			})
	end
	self._csbNode:updateLabel("Text_leave", {
		text= tostring(leftCount),
		textColor = G_Colors.getColor(25),
		fontSize = 22,
		})
	

	self._desNode:setVisible(leftCount > 0)
	--leftCount = 0
	if(leftCount < 1)then
		--self._btnBack:setVisible(false)
		--self._btnBack2:setVisible(true)
		--self._btnOpen:setVisible(false)
		-- self._particle:setVisible(false)
		-- self._panelOpen:setTouchEnabled(false)
		self:_onGiveUpTowerBox()
		return
	end

	--获取掉落内容
	local openedCount,stageCfg = G_Me.thirtyThreeData:getOpenedCount()
	assert(stageCfg,"tower stage data error")
	dump(stageCfg)

	local drop_info = require("app.cfg.drop_info")
	local openCount = openedCount + 1
	local dropCfg = drop_info.get(stageCfg["hidechest"..tostring(openCount).."_drop"])
	assert(dropCfg,"drop_info data error")
	dump(dropCfg)
	print("sss",dropCfg.type_1,dropCfg.value_1,dropCfg.max_num_1)
	local rewardInfo = G_TypeConverter.convert({
		type = dropCfg.type_1,
		value = dropCfg.value_1,
		size = dropCfg.max_num_1,
		})
	dump(dropCfg.type_1)
	dump(dropCfg.value_1)
	local desc = rewardInfo.cfg.name
	self._csbNode:updateLabel("Text_desc", {
		text = desc,
		textColor = G_Colors.qualityColor2Color(rewardInfo.cfg.color,true),
		outlineColor = G_Colors.qualityColor2OutlineColor(rewardInfo.cfg.color),
		fontSize = 22,
		})

	--奖励数量
	self._csbNode:updateLabel("Text_item_num", {
		text = "x "..tostring(dropCfg.max_num_1),
		textColor = G_Colors.getColor(25),
		fontSize = 22,
		})

	--消费元宝
	self._csbNode:updateLabel("Text_cost", {
		text=tostring(goldCost),
		textColor = G_Colors.getColor(25),
		fontSize = 22,
		})
end

--收到开启隐藏宝箱通知
function HideBoxPop:_onOpenHideBox( buffValue )
	if(buffValue == nil or buffValue.awards == nil)then return end
	local nodeEffect = self._csbNode:getSubNodeByName("Node_effect")
	self._boxEffect:setVisible(false)
	self._particle:setVisible(false)
	local effectOpen = nil

	-- if self._finger:isVisible() then
	-- 	self._finger:stopAllActions()
	-- 	self._finger:setVisible(false)
	-- end

	local delay = self._isFirstOpen == true and 0.4 or 0.2
	local effectName = self._isFirstOpen == true and "effect_slbx2" or "effect_slbx3"
	effectOpen = require("app.effect.EffectNode").new(effectName,function(event,frame,node)
		if(event == "open")then
			--G_AudioManager:playSoundById(9042)

			self:_showAwards(buffValue.awards)

			self:performWithDelay(function( ... )
				self._panelOpen:setTouchEnabled(true)
				--self._csbNode:getSubNodeByName("Image_title"):setVisible(true)
				--self._particle:setVisible(true)
				self._boxEffect:setVisible(true)
				self:_refreshCost()
			end,0.4)
		end
	end)
	effectOpen:play()
	effectOpen:setAutoRelease(true)
	nodeEffect:addChild(effectOpen)

	self._panelOpen:setTouchEnabled(false)
	self._isFirstOpen = false
end

--收到开启隐藏宝箱通知
function HideBoxPop:_onOpenHideBoxOld( buffValue )
	-- body
	if(buffValue == nil or buffValue.awards == nil)then return end
	--local nodeEffect = self._csbNode:getSubNodeByName("Node_effect")
	self._nodeEffect:setVisible(false)
	local effectOpen = nil

	if(self._isFirstOpen == true)then

		--G_AudioManager:playSoundById(9041)

    	UpdateButtonHelper.updateBigButton(self._btnOpen,{
    		desc = G_LangScrap.get("lang_tower_text_open"),
    	})

		effectOpen = require("app.effect.EffectNode").new("effect_slbx2",function(event,frame,node)
			if(event == "open")then

				--G_AudioManager:playSoundById(9042)

				self:_showAwards(buffValue.awards)

				self:performWithDelay(function( ... )
					self._btnOpen_btn:setTouchEnabled(true)
					self._boxEffect:setVisible(true)
					self:_refreshCost()
				end,0.4)
			end
		end)
		effectOpen:play()
		effectOpen:setAutoRelease(true)
		nodeEffect:addChild(effectOpen)

		self._btnOpen_btn:setTouchEnabled(false)

	else
    	UpdateButtonHelper.updateBigButton(self._btnOpen,{
    		desc = G_LangScrap.get("lang_tower_text_continue_open"),
    	})

		effectOpen = require("app.effect.EffectNode").new("effect_slbx3",function(event,frame,node)
			if(event == "open")then

				--G_AudioManager:playSoundById(9042)

				self:_showAwards(buffValue.awards)

				self:performWithDelay(function( ... )
					self._btnOpen_btn:setTouchEnabled(true)
					self:_refreshCost()
				end,0.4)
			end
		end)
		effectOpen:play()
		effectOpen:setAutoRelease(true)
		nodeEffect:addChild(effectOpen)
		self._btnOpen_btn:setTouchEnabled(false)
	end



	self._isFirstOpen = false
	
end

function HideBoxPop:_showAwards( awards )
	-- self._effect:setVisible(true)
 --    self._topLine:setVisible(true)
 --    self._bottomLine:setVisible(true)
	-- body
	self._nodeAwards:removeAllChildren(true)
	
	--self._csbNode:getSubNodeByName("Image_title"):setVisible(false)
	-- self._csbNode:updateImageView("Image_title", {texture=G_Url:getText_system("txt_com_settl_get01")})
	if(awards == nil)then return end
	local TypeConverter = require("app.common.TypeConverter")

	for i=1,#awards do
		self._awardsList[#self._awardsList + 1] = awards[i]
	end


	table.sort(awards,function(a,b)
		local aFlag = a.type == TypeConverter.TYPE_TOWER_RESOURCE and 100 or 0
		local bFlag = b.type == TypeConverter.TYPE_TOWER_RESOURCE and 100 or 0
		if aFlag ~= bFlag then
			return aFlag > bFlag
		end
	end)

	local spaceX = 120
	local spaceY = 150

	--local lenAwards = #awards

	G_Popup.awardTips(awards)

	-- for i=1,lenAwards do
	-- 	local icon = cc.CSLoader:createNode("csb/common/CommonIconItemNode.csb")
	--     self._nodeAwards:addChild(icon)
	-- 	local updateNodeHelper = require("app.common.UpdateNodeHelper")
	-- 	local params = {}
	-- 	params.size = awards[i].size
	-- 	params.value = awards[i].value
	-- 	params.type = awards[i].type
	-- 	params.nameVisible = true
	-- 	params.sizeVisible = true
	-- 	params.needVisible = G_Me.equipData:isUpRankMaterialNeed(params.type, params.value),
	-- 	updateNodeHelper.updateCommonIconItemNode(icon,params)
	-- 	icon:setPosition(0,0)
	-- 	icon:setScale(0)

	-- 	local xpos = (i-1)*100 - (lenAwards-1)/2*100
	-- 	local ypos = 0
	-- 	local action = cc.MoveTo:create(0.25,cc.p(xpos,ypos))
	-- 	local scale = cc.ScaleTo:create(0.25,0.8)
	-- 	local spawn = cc.Spawn:create(action,scale)
	-- 	spawn = cc.Sequence:create(cc.DelayTime:create((i-1)*0.2),cc.CallFunc:create(function()
	-- 		--G_AudioManager:playSoundById(9043)
	-- 	end),spawn)
	-- 	icon:runAction(cc.EaseExponentialOut:create(spawn))
	-- end

end

function HideBoxPop:onEnter( ... )
	-- body
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MT_OPEN_TOWER_BOX,self._onOpenHideBox,self)
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MT_GIVEUP_TOWER_BOX,self._onGiveUpTowerBox,self)
	self:_initUI()
	--self:_onGiveUpTowerBox()
end
	 

function HideBoxPop:onExit( ... )
	-- body
	if(self._csbNode ~= nil)then
		self._csbNode:removeFromParent(true)
		self._csbNode = nil
	end
	uf_eventManager:removeListenerWithTarget(self)
end

return HideBoxPop