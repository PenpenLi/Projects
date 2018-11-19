--HeroJingJieResult.lua


local EffectSingleMoving = require "app.common.effects.EffectSingleMoving"

local HeroJingJieResult = class("HeroJingJieResult", UFCCSModelLayer)

function HeroJingJieResult:ctor( ... )
	self._callback = nil
	self._clickToClose = false
	self._parentLayer = nil
	self._finishGuideClick = false

	self.super.ctor(self, ...)

	self:showWidgetByName("Image_click_continue", false)

	self:enableLabelStroke("Label_unlock_text", Colors.strokeBrown, 1 )
	self:enableLabelStroke("Label_unlock_desc", Colors.strokeBrown, 1 )
	self:enableLabelStroke("Label_old_knight", Colors.strokeBrown, 1 )
	self:enableLabelStroke("Label_new_knight", Colors.strokeBrown, 1 )
	-- self:enableLabelStroke("Label_old_attack", Colors.strokeBrown, 1 )
	-- self:enableLabelStroke("Label_old_hp", Colors.strokeBrown, 1 )
	-- self:enableLabelStroke("Label_old_def_p", Colors.strokeBrown, 1 )
	-- self:enableLabelStroke("Label_old_def_m", Colors.strokeBrown, 1 )
	-- self:enableLabelStroke("Label_new_attack", Colors.strokeBrown, 1 )
	-- self:enableLabelStroke("Label_new_hp", Colors.strokeBrown, 1 )
	-- self:enableLabelStroke("Label_new_def_p", Colors.strokeBrown, 1 )
	-- self:enableLabelStroke("Label_new_def_m", Colors.strokeBrown, 1 )

	-- local createStoke = function ( name )
 --        local label = self:getLabelByName(name)
 --        if label then 
 --            label:createStroke(Colors.strokeBrown, 1)
 --        end
 --    end
 --    createStoke("Label_attri_attack")
 --    createStoke("Label_attri_hp")
 --    createStoke("Label_attri_def_p")
 --    createStoke("Label_attri_def_m")

    self:adapterWithScreen()
    self:registerTouchEvent(false,true,0)
end

function HeroJingJieResult:onLayerEnter( ... )
    self:registerKeypadEvent(1, 0)

	if self.__EFFECT_FINISH_CALLBACK__ and self._parentLayer then 
		__Log("set __EFFECT_FINISH_CALLBACK__")
		self._parentLayer.__EFFECT_FINISH_CALLBACK__ = self.__EFFECT_FINISH_CALLBACK__
	else
		__Log("__EFFECT_FINISH_CALLBACK__ is nil")
	end

	local soundConst = require("app.const.SoundConst")
    G_SoundManager:playSound(soundConst.GameSound.KNIGHT_SPECIAL)

	self:showWidgetByName("Label_new_attack", false)
	self:showWidgetByName("Label_new_hp", false)
	self:showWidgetByName("Label_new_def_p", false)
	self:showWidgetByName("Label_new_def_m", false)
	self:showWidgetByName("Image_arrow_attack", false)
	self:showWidgetByName("Image_arrow_hp", false)
	self:showWidgetByName("Image_arrow_def_p", false)
	self:showWidgetByName("Image_arrow_def_m", false)

	self:showWidgetByName("Panel_border", false)

	GlobalFunc.flyDown({self:getWidgetByName("Image_title_back")}, 0.3, 0, 3, function ( ... )
		self:showWidgetByName("Panel_border", true)
		GlobalFunc.flyIntoScreenLR({self:getWidgetByName("Panel_attri1"), 
                    self:getWidgetByName("Panel_attri2"),
                    self:getWidgetByName("Panel_attri3"), 
                    self:getWidgetByName("Panel_attri4")}, true, 0.3, 2, 50, function ( ... )

                    	self:showWidgetByName("Label_new_attack", true)

						GlobalFunc.flyDown({self:getWidgetByName("Label_new_attack"),
							self:getWidgetByName("Label_new_hp"),
							self:getWidgetByName("Label_new_def_p"),
							self:getWidgetByName("Label_new_def_m")}, 0.2, 0.1, 3, function ( ... )
								self:showWidgetByName("Image_arrow_attack", true)
								self:showWidgetByName("Image_arrow_hp", true)
								self:showWidgetByName("Image_arrow_def_p", true)
								self:showWidgetByName("Image_arrow_def_m", true)

								self:showWidgetByName("Image_click_continue", true)
                    			EffectSingleMoving.run(self:getWidgetByName("Image_click_continue"), "smoving_wait", nil , {position = true} )

                    			self._clickToClose = true
                    			self:setClickClose(true)
                    			self:closeAtReturn(1)

                    			if self._finishGuideClick and self.__EFFECT_FINISH_CALLBACK__ then 
                    				if self._callback then 
    									self._callback()
    								end
    								self:close()
                    			end
							end)                    	
                    end)

		GlobalFunc.flyIntoScreenLR({self:getWidgetByName("Panel_name")}, false, 0.3, 2, 50)
	end)	
end

function HeroJingJieResult:initWithBaseId( parentLayer, baseId1, baseId2, level, func )
	baseId1 = baseId1 or 0
	baseId2 = baseId2 or 0
	self._parentLayer = parentLayer
	level = level or 1
	self._callback = func

	local newPassiveSkill = {}

	local knightInfo = nil
	if baseId1 > 0 then 
		knightInfo = knight_info.get(baseId1)
		if knightInfo then 
			self:showTextWithLabel("Label_old_hp", ""..(knightInfo.base_hp + (level - 1)*knightInfo.develop_hp))
			self:showTextWithLabel("Label_old_attack", ""..(G_Me.bagData.knightsData:calcAttackByBaseId(knightInfo.id, level)))
			self:showTextWithLabel("Label_old_def_p", ""..(knightInfo.base_physical_defence + (level - 1)*knightInfo.develop_physical_defence))
			self:showTextWithLabel("Label_old_def_m", ""..(knightInfo.base_magical_defence + (level - 1)*knightInfo.develop_magical_defence))
			
			local label = self:getLabelByName("Label_old_knight")
			if label then 
				label:setColor(Colors.getColor(knightInfo.quality))
				if knightInfo.advanced_level > 0 then 
					label:setText(""..knightInfo.name.." +"..knightInfo.advanced_level)	
				else
					label:setText(knightInfo.name)
				end
			end
			
		else
			self:showTextWithLabel("Label_old_hp", "")
			self:showTextWithLabel("Label_old_attack", "")
			self:showTextWithLabel("Label_old_def_p", "")
			self:showTextWithLabel("Label_old_def_m", "")
			self:showTextWithLabel("Label_old_knight", "")
		end
	end

	if baseId2 > 0 then 
		knightInfo = knight_info.get(baseId2)
		if knightInfo then 
			if type(knightInfo.common_sound) == "string" and #knightInfo.common_sound > 3 then
				G_SoundManager:playSound(knightInfo.common_sound)
			end

			self:showTextWithLabel("Label_new_hp", ""..(knightInfo.base_hp + (level - 1)*knightInfo.develop_hp))
			self:showTextWithLabel("Label_new_attack", ""..(G_Me.bagData.knightsData:calcAttackByBaseId(knightInfo.id, level)))
			self:showTextWithLabel("Label_new_def_p", ""..(knightInfo.base_physical_defence + (level - 1)*knightInfo.develop_physical_defence))
			self:showTextWithLabel("Label_new_def_m", ""..(knightInfo.base_magical_defence + (level - 1)*knightInfo.develop_magical_defence))
			local label = self:getLabelByName("Label_new_knight")
			if label then 
				label:setColor(Colors.getColor(knightInfo.quality))
				if knightInfo.advanced_level > 0 then 
					label:setText(""..knightInfo.name.." +"..knightInfo.advanced_level)	
				else
					label:setText(knightInfo.name)
				end
			end
		else
			self:showTextWithLabel("Label_new_hp", "")
			self:showTextWithLabel("Label_new_attack", "")
			self:showTextWithLabel("Label_new_def_p", "")
			self:showTextWithLabel("Label_new_def_m", "")
			self:showTextWithLabel("Label_new_knight", "")
		end
	end

	require("app.cfg.passive_skill_info")
	local checkUnlockPassive = function ( passiveId )
		if not passiveId or passiveId < 1 or not knightInfo then 
			return nil
		end

		local passiveInfo = passive_skill_info.get(passiveId)
		if not passiveInfo then 
			return nil
		end

		if passiveInfo.open_type == 1 and knightInfo.advanced_level == passiveInfo.open_value then 
			return passiveInfo
		end

		return nil
	end
	
	local passiveInfo = nil 
	if knightInfo then 
		passiveInfo = passiveInfo or checkUnlockPassive(knightInfo.passive_skill_1)
		passiveInfo = passiveInfo or checkUnlockPassive(knightInfo.passive_skill_2)
		passiveInfo = passiveInfo or checkUnlockPassive(knightInfo.passive_skill_3)
		passiveInfo = passiveInfo or checkUnlockPassive(knightInfo.passive_skill_4)
		passiveInfo = passiveInfo or checkUnlockPassive(knightInfo.passive_skill_5)
		passiveInfo = passiveInfo or checkUnlockPassive(knightInfo.passive_skill_6)
	end

	self:showWidgetByName("Label_unlock_text", passiveInfo ~= nil)
	if passiveInfo then 
		self:showTextWithLabel("Label_unlock_text", G_lang:get("LANG_KNIGHT_JINGJIE_UNLOCK_TIANFU", {tianfu=passiveInfo.name}))
		self:showTextWithLabel("Label_unlock_desc", passiveInfo.directions)
	else
		self:showTextWithLabel("Label_unlock_text", "")
		self:showTextWithLabel("Label_unlock_desc", "")
	end

	local trainingArrowAnimation = function ( arrowName, followLabel, showArrow)
		if not arrowName  then
			return 
		end
		local arrow = self:getImageViewByName(arrowName)
		if not arrow then 
			return 
		end

		local arrowX, arrowY = arrow:getPosition()
		local arrowSize = arrow:getSize()
		if followLabel then 
			local followLabelCtrl = self:getWidgetByName(followLabel)
			if followLabelCtrl then 
				local posx, posy = followLabelCtrl:getPosition()
				--local anchorPt = followLabelCtrl:getAnchorPoint()
				--local followLabelSize = followLabelCtrl:getSize()
				--arrowX = posx + (1 - anchorPt.x)*followLabelSize.width + arrowSize.width/2
				arrowY = posy
			end			
		end

		showArrow = showArrow or false
		arrow:stopAllActions()
		arrow:setVisible(showArrow)
		if showArrow then 
			
			arrow:setVisible(true)
			arrow:setOpacity(255)
		--arrow:loadTexture(G_Path.getGrowupIcon(isGrowup))
			local moveDistUp = 10
			local startPosy = (arrowY - moveDistUp/2)

			local arr = CCArray:create()
			arr:addObject(CCResetPosition:create(arrow, ccp(arrowX, startPosy)))
			arr:addObject(CCResetOpacity:create(arrow, 255))
			local moveby = CCMoveBy:create(0.8, ccp(0, moveDistUp))
			arr:addObject(CCEaseIn:create(moveby, 0.3))
			arr:addObject(CCFadeOut:create(0.2))
			
			arrow:runAction(CCRepeatForever:create(CCSequence:create(arr)))
		end
	end

	trainingArrowAnimation("Image_arrow_hp", "Label_new_hp", knightInfo ~= nil)
	trainingArrowAnimation("Image_arrow_attack", "Label_new_attack", knightInfo ~= nil)
	trainingArrowAnimation("Image_arrow_def_m", "Label_new_def_p", knightInfo ~= nil)
	trainingArrowAnimation("Image_arrow_def_p", "Label_new_def_m", knightInfo ~= nil)
end

function HeroJingJieResult.showHeroJingJieResult( parentLayer, baseId1, baseId2, level, func )
	local HeroJingJieResult = require("app.scenes.herofoster.HeroJingJieResult")
	local heroResult = HeroJingJieResult.new("ui_layout/HeroShengJieResult.json")
	heroResult:initWithBaseId(parentLayer, baseId1, baseId2, level, func)
	uf_notifyLayer:getModelNode():addChild(heroResult)

end

function HeroJingJieResult:onBackKeyEvent( ... )
	if not self._finishGuideClick then 
		self:_onDoPauseCurGuide()
	end
	self._finishGuideClick = true
	
	if not self._clickToClose then 
		return true
	end

    if self._callback then 
    	self._callback()
    end
    self:close()
	return true
end


function HeroJingJieResult:onClickClose( ... )
	if not self._finishGuideClick then 
		self:_onDoPauseCurGuide()
	end
    self._finishGuideClick = true

	if not self._clickToClose then 
		return true
	end

    if self._callback then 
    	self._callback()
    end
    self:close()
	return true
end

function HeroJingJieResult:onTouchEnd( xpos, ypos )
	if not self._finishGuideClick then 
		self:_onDoPauseCurGuide()
	end
	self._finishGuideClick = true
	if not self._clickToClose then 
		return 
	end

    ---if self.__EFFECT_FINISH_CALLBACK__ then 
    --    self.__EFFECT_FINISH_CALLBACK__()
    --end

    -- if self._callback then 
    -- 	self._callback()
    -- end
    -- self:close()
end

function HeroJingJieResult:_onDoPauseCurGuide( ... )
	if self.__EFFECT_FINISH_CALLBACK__ then 
        self.__EFFECT_FINISH_CALLBACK__( true )
    end
end


return HeroJingJieResult

