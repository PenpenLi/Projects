
--====================
----招募展示界面基类

local RecruitingShowBaseLayer = class("RecruitingShowBaseLayer", function()
	return cc.LayerColor:create(cc.c4b(0, 0, 0, 0))
end)

local EffectNode = require "app.effect.EffectNode"
local EffectMovingNode = require "app.effect.EffectMovingNode"
local ParameterInfo = require "app.cfg.parameter_info"
local TypeConverter = require "app.common.TypeConverter"
local KnightInfo = require "app.cfg.knight_info"
local KnightImg = require "app.common.KnightImg"
local TeamUtils = require "app.scenes.team.TeamUtils"
local CommonKnightShowLayer = require "app.common.CommonKnightShowLayer"
local PopupBase = require "app.popup.common.PopupBase"
-- local KnightFirstDialogue = require "app.cfg.knight_first_dialogue"

RecruitingShowBaseLayer.RecruitypeOne = 1
RecruitingShowBaseLayer.RecruitypeTen = 2


function RecruitingShowBaseLayer:ctor(recruitType)
	self:enableNodeEvents()
	assert(recruitType,"recruitType should not be nil")
	self._recruitType = recruitType

	self._onClose = nil
	self._bgNode = nil
	self._rootNode = nil --所有武将的展示节点
	self._endEffectNode = nil ---结束后的UI放置节点
	self._rootPosition = nil --所有
	self._showKnightNode = nil
	self._awardNodes = {} --所有显示出来的奖励显示
	self._awards = nil
	self._descTxt = nil --招募顶部的描述
	self._pause = false --当前是否暂停，因为展示武将的时候，要停一下
	self._currentSound = nil
end

function RecruitingShowBaseLayer:onEnter()
	self:_initUI()
end

function RecruitingShowBaseLayer:onExit()
	G_AudioManager:stopSound(self._currentSound)
end

---设置获取的奖励。
function RecruitingShowBaseLayer:setAwards(awards)
	assert(awards or type(awards) == "table", "invalide awards " .. tostring(awards))
	--此处传来的是服务端的proto，要转换为可以随便更新的数据
	dump(awards)
	self._awards = awards
end

---设置关闭后的回调。
function RecruitingShowBaseLayer:setOnClose(onClose)
	assert(onClose or type(onClose) == "function", "invalide onClose " .. tostring(onClose))
	self._onClose = onClose
end

function RecruitingShowBaseLayer:_initUI()
	--添加背景显示
	local bgPahtId = self._recruitType == RecruitingShowBaseLayer.RecruitypeOne and "bg_recruiting_show_one" or "bg_recruiting_show_ten"
	local background = display.newSprite(G_Url:getUI_backgroundjpg(bgPahtId))
	self:addChild(background)
	background:setScale(display.width / background:getContentSize().width)
	background:align(display.BOTTOM_CENTER, display.cx, display.cy)

	-- 背景特效节点
	self._bgNode = display.newNode()
	self._bgNode:setContentSize(cc.size(display.width, display.height))
	self._bgNode:setIgnoreAnchorPointForPosition(true)
	self._bgNode:setAnchorPoint(cc.p(0.5, 0.5))
	self:addChild(self._bgNode)

	-- 展示用根节点
	self._rootNode = display.newNode()
	self:addChild(self._rootNode)

	self._endEffectNode = display.newNode()
	self:addChild(self._endEffectNode)

	self._showKnightNode = display.newNode()
	self:addChild(self._showKnightNode)

	-- 下面是背景动画
	-- local movingNode = EffectMovingNode.new("moving_choujiang_bg",
	-- 	function(effect)
	-- 		if effect == "star_bg1" or effect == "star_bg2" then
	-- 			return display.newNode()
	-- 		elseif effect == "scene_bg" then
	-- 			return display.newNode()
	-- 		end
	-- 	end
	-- )

	-- self._bgNode:addChild(movingNode)
	-- movingNode:setPositionX(display.cx)
	-- movingNode:play()

	local skillNames = {}

	for i=1, 28 do
		skillNames[#skillNames+1] = G_Url:getText_skillName(i)
	end

	local function createNameEffect(effect)
		local node = EffectMovingNode.new(effect, function()
			return display.newSprite(skillNames[math.random(#skillNames)])
		end)
		node:play()
		return node
	end

	-- 将名字的动画
	-- local movingNode = EffectMovingNode.new("moving_choujiang_name", function(effect)
	-- 	return createNameEffect(effect)
	-- end)

	-- self._bgNode:addChild(movingNode)
	-- movingNode:play()
	-- movingNode:setPosition(221.80, display.height - 189.65)

	-- 城楼的特效需要根据屏幕位置做一定适配，初步定为根据屏幕的高度自动下降一定距离
	local rootPosition = cc.p(display.cx, display.cy - display.height * 0.3)
	-- 这里的位置适配的是动画中发射器的位置，所以要保存一下
	self._rootPosition = rootPosition

	local movingNode = EffectMovingNode.new("moving_choujiang",
		-- 节点创建
		function(effect)
			if effect == "star" then
				--播放音效
				--self._currentSound = G_AudioManager:playSoundById(9064)
				return self:_createEffectNode("effect_choujiang_star_1")
			elseif effect == "cloud" then
				--return self:_createEffectNode("effect_choujiang_yun")
				return display.newNode()
			elseif effect == "constellation1" then
				-- return self:_createEffectNode("effect_choujiang_star_3")
				return display.newNode()
			elseif effect == "constellation2" then
				-- return self:_createEffectNode("effect_choujiang_star_4")
				return display.newNode()
			elseif effect == "constellation3" then
				-- return self:_createEffectNode("effect_choujiang_star_5")
				return display.newNode()
			elseif effect == "door1" then
				return self:_createEffectNode(self:_getEffectDoor())
			elseif effect == "door2" then
				return self:_createEffectNode("effect_choujiang_building2")
			elseif effect == "door3" then
				return self:_createEffectNode("effect_choujiang_building3")
			elseif effect == "door_cloud1" or effect == "door_cloud2" then
				--return self:_createEffectNode("effect_choujiang_yun3")
				return display.newNode()
			elseif effect == "blue_fire" then
				return self:_createEffectNode("effect_choujiang_guang_1")
			elseif effect == "black_bg" then
				-- local blackBackground = cc.LayerColor:create(cc.c4b(0, 0, 0, 0), 768, 1368)
				-- blackBackground:setAnchorPoint(cc.p(0.5, 0.5))
				-- blackBackground:setIgnoreAnchorPointForPosition(false)
				-- return blackBackground
				return display.newNode()
			end
		end,
		-- 事件处理
		function(event)
			if event == "hit" then
				self:_showAwards()
			end
		end
	)
	
	self._bgNode:addChild(movingNode)
	movingNode:gotoAndPlay(self:_getStarFrameIndex())
	movingNode:setPosition(rootPosition)

	-- 触屏事件
	self:setTouchEnabled(true)
    self:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self:registerScriptTouchHandler(function(event,x,y)
    	return true
    end)
end

--展示招募奖励
function RecruitingShowBaseLayer:_showAwards()
	local iteratorIndex = 0

	local function iterate()
		iteratorIndex = iteratorIndex + 1
		local award = self._awards[iteratorIndex]
		if iteratorIndex <= #self._awards then ---奖励没有展示完
			local needShow = self:_isNeedShow(award)
			self._pause = needShow
			self:_showAward(award, self:_getAwardPos(iteratorIndex), needShow, iterate)
		else ---展示奖励结束之后
			self:_onAwardsPlayOver()
		end
	end

	iterate()
end

---展示一个奖励，
function RecruitingShowBaseLayer:_showAward(award, placePos, isNeedShow, onPlaceOver)
	local distance = cc.pSub(placePos, self._rootPosition)
    local angle = math.deg(cc.pToAngleSelf(distance)) * -1 + 90

    -- 光束高246，我们打点折扣，按照实际高度的90%进行拉伸比计算
    local scale = (cc.pGetLength(distance)) * 0.9 / 246
    -- 但是宽度不能太粗，所以宽度也打个折扣，但不能低于1
    local scaleX, scaleY = math.max(1, scale * 0.8), scale

    -- 武将展示
	local effectNode = self:_createEffectNode("effect_choujiang_hit", function(event)
		-- 开始播放武将展示
		if event == "hurt" then
			local effectHurt = self:_createEffectNode("effect_choujiang_hurt", function(event)
				if event == "single_card_out" then
					-- 创建奖励显示
					print("3333333333333333",isNeedShow)
					if isNeedShow then
						local param = TypeConverter.convert(award)
						self:_playKnightShow(param, placePos, function ()
							self:_checkKnightDialog(award.value, function ()
								self._pause = false
								onPlaceOver()
							end)
						end)
					else
						local awardNode = self:_getAwardNode(award)
						awardNode:setPosition(placePos.x, placePos.y)
						self._awardNodes[#self._awardNodes + 1] = awardNode
						self._rootNode:addChild(awardNode)
					end
				end

			end, true)

			self._rootNode:addChild(effectHurt)
			effectHurt:setPosition(placePos)

		elseif event == "finish" then
			if not self._pause then
				onPlaceOver()
			end
		end

	end, true)

	effectNode:setDouble(2)
	effectNode:setRotation(angle)
	effectNode:setScale(scaleX, scaleY)

	self._rootNode:addChild(effectNode)
	effectNode:setPosition(self._rootPosition)

	--播放音效
	--self._currentSound = G_AudioManager:playSoundById(9065)
end

---获取奖励节点
function RecruitingShowBaseLayer:_getAwardNode(award)
	
end

--获取奖励的位置
function RecruitingShowBaseLayer:_getAwardPos(index)
	
end

---所有奖励都展示完后调用。
---这里只是设置了文字的标题，子类要根据情况添加新东西。
function RecruitingShowBaseLayer:_onAwardsPlayOver()
	local tipsTxt, pos = self:_getDescTxtAndPos()
	self._descTxt = display.newTTFLabel({
	    text = tipsTxt,
	    font = G_Path.getNormalFont(),
	    size = 28,
	    color = G_ColorsScrap.COLOR_SCENE_DESC_NORMAL
	})

	self._descTxt:enableOutline(G_ColorsScrap.COLOR_SCENE_OUTLINE, 2)
	self._endEffectNode:addChild(self._descTxt, 3)
	self._descTxt:setPosition(pos.x, pos.y)
	self._descTxt:setVisible(false)

	self._descTxt:performWithDelay(function()
		self._descTxt:setVisible(true)
	end, 0.2)

	G_Me.recruitingData:clearDialogCache()

	------------------------------------------
	if self._awards == nil then return end

	local mainKnightData = G_Me.teamData:getKnightDataByPos(1)
	local userName = G_Me.userData.name
	local userColor = G_ColorsScrap.colorToNumber(G_ColorsScrap.getColor(G_TypeConverter.quality2Color(mainKnightData.cfgData.quality)))
	for i=1,#self._awards do
		local awardType = self._awards[i].type
		if awardType == TypeConverter.TYPE_KNIGHT then
			local knightId = self._awards[i].value
			local info = require("app.cfg.knight_info").get(knightId)
			assert(info,"knight_info can't find id = "..tostring(knightId))
			local strKnightName = info.name
			if info.gm_note == 1 then
				local knightColor = G_ColorsScrap.colorToNumber(G_ColorsScrap.getColor(info.color))
				-- local list = {userName,userColor,info.potential,info.name,knightColor}
				local list = {userName,userColor,strKnightName,knightColor}
				local conId = 52
				if self._recruitType == 1 then
					conId = 52
				elseif self._recruitType == 2 then
					conId = 53
				end
				--require("app.scenes.team.TeamUtils").sendMainCitySubtitle(conId,list)
			end
		end
	end
	
end

function RecruitingShowBaseLayer:_getStarFrameIndex()
	return 52
end

-- 创建一个特效节点
function RecruitingShowBaseLayer:_createEffectNode(effectName, eventHandler, autoRelease)

	local effectNode = EffectNode.new(effectName, eventHandler)
	effectNode:setAutoRelease(autoRelease)
	effectNode:play()

	return effectNode
	
end

---是否需要展示
function RecruitingShowBaseLayer:_isNeedShow(param)
	if param.type == TypeConverter.TYPE_KNIGHT then
		local knightInfo = KnightInfo.get(param.value)
		assert(knightInfo, "can't find knight_info of id " .. tostring(param.value))
		if knightInfo.quality >= self:_getNeedShowColor() and knightInfo.type == 2 then --3为蟠桃类型
			return true
		end
	end

	return false
	--return true
end

-- 创建一个神将节点
function RecruitingShowBaseLayer:_createKnightImg(param, withName, withVoice, scale, fontSize)

	local rootNode = display.newNode()
	rootNode:setCascadeOpacityEnabled(true)
	local node = KnightImg.new(param.cfg.knight_id,0,0)
	node:setPositionY(-80)
	node:setScale(scale == nil and 1 or scale)
	node:setName("knight_node")
	rootNode:addChild(node)

	local label = display.newTTFLabel({
	    text = withName and param.cfg.name or "",
	    font = G_Path.getNormalFont(),
	    size = fontSize,
	})

	local color = G_TypeConverter.quality2Color(param.cfg.quality)
	label:setColor(G_Colors.qualityColor2Color(color))
	label:enableOutline(G_Colors.qualityColor2OutlineColor(color), 2)
	label:setName("name_label")
	rootNode:addChild(label)
	label:setPositionY(-80)

	if withVoice then
		node:performWithDelay(function()
			node:playVoice()
		end, 0.5)
	end

	return rootNode

end

--创建顶部恭喜标题特效。
function RecruitingShowBaseLayer:_createShineEffect()
	local effectNode = EffectMovingNode.new("moving_choujiang_hude", function(effect)
        if effect == "txt" then
            return display.newSprite(G_Url:getText_system("txt_com_settl_get01"))
        elseif effect == "txt_bg" then
            return self:_createEffectNode("effect_huode_a")
        elseif effect == "txt_shine" then
		    return self:_createEffectNode("effect_win_22")
		elseif effect == "frame_line" then
			return self:_createEffectNode("effect_win_1")
		elseif effect == "houzi" then
            return display.newNode()
        end
	end)

	effectNode:play()
    self._endEffectNode:addChild(effectNode)

    effectNode:setPosition(display.cx, display.height - display.height * 0.06)

    --G_AudioManager:playSoundById(9047)
end

---获取购买成功的显示的小标题文字对象和文字需要放置的位置
function RecruitingShowBaseLayer:_getDescTxtAndPos()
	
end

-- 创建武将信息面板
function RecruitingShowBaseLayer:_createKnightInfo(param)

	local node = cc.CSLoader:createNode(G_Url:getCSB("RecruitingKnightInfoNode", "recruiting"))
	node:setCascadeOpacityEnabled(true)
	node:setOpacity(0)
	node:runAction(cc.FadeIn:create(0.2))

	local colorQuality = G_TypeConverter.quality2Color(param.cfg.quality)

	-- 名字
	node:updateLabel("Text_name", {
		text=param.name,
		color=G_Colors.qualityColor2Color(colorQuality),
		outlineColor=G_Colors.qualityColor2OutlineColor(colorQuality),
	})
	-- 种族
	node:updateImageView("Image_group", {texture=TeamUtils.getGroupImgUrl(param.cfg.group)})

	-- 白/蓝将
	node:updateImageView("Image_quality_desc", {
		texture = G_Url:getText_system("txt_sys_quality_0"..colorQuality)
	})

	-- 资质:xx
	node:updateLabel("Text_quality_amount_desc", {
		text = G_Lang.get("lang_battle_summary_quality_desc",{quality = param.cfgInfo.quality}),
		color=G_Colors.qualityColor2Color(colorQuality),
		outlineColor=G_Colors.qualityColor2OutlineColor(colorQuality),
	})

	return node
end

--检查是否要弹出武将引导对话。
function RecruitingShowBaseLayer:_checkKnightDialog(knightId, onOver)
	local dialogCache = G_Me.recruitingData:getDialogCache()
	if dialogCache ~= nil then ---判断当前武将是否需要弹出
		-- local knightDialogInfo = KnightFirstDialogue.get(knightId)
		-- assert(knightDialogInfo, "can't find knightId in KnightFirstDialogue" .. tostring(knightId))
		-- G_Responder.hasGuideStory(knightDialogInfo.dialogue, nil, onOver)
		-- G_Me.recruitingData:clearDialogCache()
	else
		onOver()
	end
end

function RecruitingShowBaseLayer:_getNeedShowColor()
	-- 确认是否是武将需要展示
	local id = 231
	local info = ParameterInfo.get(id)
	assert(info, "Could not find the parameter_info with id: "..tostring(id))

	local limitColor = tonumber(info.content)
	assert(limitColor, "Invalid info.content: "..tostring(info.content))

	return limitColor
end

-- 播放武将信息展示
function RecruitingShowBaseLayer:_playKnightShow(param, endPos, onShowOver)
	-- 开始展示卡牌
	print("start to play knight.......")
	local duration = 0.3
	-- 目标位置
	local dstPosition = cc.p(display.cx, display.cy + 90)

	-- 背景做缩放
	self._bgNode:runAction(cc.ScaleTo:create(0.2, 1.2))

	-- 三个门要隐藏
	local hideAction = cc.FadeOut:create(0.2)
	for i=1, 3 do
		self._bgNode:getSubNodeByName("door"..i):runAction(hideAction:clone())
	end

	self._rootNode:setVisible(false)
    G_Popup.newPopupWithTouchEnd(function ()
		local showLayer
		showLayer = CommonKnightShowLayer.new(CommonKnightShowLayer.STYLE_RECRUITING, param.value, 0, true, function(event)
	    	if event == "show_finish" then
	    		showLayer:setTouchEnabled(false)
	    	elseif event == "on_close" then ---面板关闭后，显示武将从中心到招募位置的动画。而且之前的缩放还原
	    		local awardNode = self:_createKnightImg(param, true, false, 1, 20)
	    		local knightNode = awardNode:getSubNodeByName("knight_node")
	    		local nameLabel = awardNode:getSubNodeByName("name_label")
	    		local onMoveOver = cc.CallFunc:create(function ()
	    			self:_onShowKnigthOver(awardNode, param) --武将展示完后添加效果
	    		end)
	    		nameLabel:setVisible(false)
	    		awardNode:setPosition(display.cx, display.cy)
				self._rootNode:addChild(awardNode)
				self._awardNodes[#self._awardNodes + 1] = awardNode
				self:performWithDelay(function ()
						onShowOver()
						nameLabel:setVisible(true)
					end, duration)

				local moveAct = cc.EaseBackOut:create(cc.MoveTo:create(duration, endPos))
				local moveSeq = cc.Sequence:create(moveAct, onMoveOver)
				knightNode:runAction(cc.EaseBackOut:create(cc.ScaleTo:create(duration, self:_getKnightScaleAfterShow())))
				awardNode:runAction(moveSeq)

				self._bgNode:runAction(cc.ScaleTo:create(0.2, 1))

				-- 三个门要恢复
				local showAction = cc.FadeIn:create(0.2)
				for i=1, 3 do
					self._bgNode:getSubNodeByName("door"..i):runAction(showAction:clone())
				end

				self._rootNode:setVisible(true)
	    	end
	    end)

		showLayer:setTouchEnabled(true)
		return showLayer
    end, false, true)
end

---返回特效中间的那个房子的特效名称
function RecruitingShowBaseLayer:_getEffectDoor()
	return "effect_choujiang_building1"
end

function RecruitingShowBaseLayer:_addOutlines(node, ...)
	local texts = {...}
	for i = 1, #texts do
		local text = texts[i]
		node:updateLabel(text, {
			outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE
		})
	end
end

function RecruitingShowBaseLayer:_getKnightScaleAfterShow()
	return 1
end

--武将展示完后的效果添加。
function RecruitingShowBaseLayer:_onShowKnigthOver(awardNode, param)
	
end

return RecruitingShowBaseLayer