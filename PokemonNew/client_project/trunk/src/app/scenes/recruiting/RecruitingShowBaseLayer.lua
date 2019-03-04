--
-- Author: Your Name
-- Date: 2017-12-26 11:41:43
--====================
----招募展示界面基类

local RecruitingShowBaseLayer = class("RecruitingShowBaseLayer", function()
	--return cc.Node:create()
	--return cc.LayerColor:create(cc.c4b(110, 107, 108, 255)) --6e6b6c 不透明
	return cc.LayerColor:create(cc.c4b(0, 0, 0, 155)) --6e6b6c 不透明
end)

local EffectNode = require "app.effect.EffectNode"
local EffectMovingNode = require "app.effect.EffectMovingNode"
local ParameterInfo = require "app.cfg.parameter_info"
local KnightInfo = require "app.cfg.knight_info"
local KnightImg = require "app.common.KnightImg"
local TeamUtils = require "app.scenes.team.TeamUtils"
local CommonKnightShowLayer = require "app.common.CommonKnightShowLayer"
local PopupBase = require "app.popup.common.PopupBase"
local exclusive_info = require "app.cfg.exclusive_info"
-- local KnightFirstDialogue = require "app.cfg.knight_first_dialogue"

RecruitingShowBaseLayer.RecruitypeOne = 1
RecruitingShowBaseLayer.RecruitypeTen = 2

local EFFECT_ONE_NAME = "effect_choujiang_theone"
local EFFECT_TEN_NAME = "effect_choujiang_ten"
local EFFECT_ONE_EQUIP = "effect_chouzhuanshu_theone" -- 单抽装备
local EFFECT_TEN_EQUIP = "effect_chouzhuanshu_ten" 
---type 1 武将 2 专属
function RecruitingShowBaseLayer:ctor(recruitType,type)
	dump("RecruitingShowBaseLayer:ctor(recruitType,type)!!: ".. recruitType.." : " .. tostring(type))
	self:enableNodeEvents()
	assert(recruitType,"recruitType should not be nil")
	self._recruitType = recruitType
	self._type = type
	-- 触摸吞噬
	--if self._recruitType ~= RecruitingShowBaseLayer.RecruitypeTen then
		local layout = ccui.Layout:create()--display.newLayer(cc.c4b(0,0,0,155))
		self._swallowLayout = layout
	   	layout:setContentSize(display.width,display.height)
	  	layout:setTouchEnabled(true)
	  	layout:setTouchSwallowEnabled(true)
	    --layout:setSwallowsTouches(true)
		self:addChild(layout)
	--end

	--展示用根节点
	self._rootNode = display.newNode()
	self._rootNode:setPosition(display.cx,display.cy)
	self:addChild(self._rootNode)

	--展示完毕所用信息节点
	self._endEffectNode = display.newNode()
	self:addChild(self._endEffectNode)

	self._rootEffect = nil 	-- 所有的特效都从这个开始
	self._awards = nil     	--收到服务器的武将数据
	self._onClose = nil   	--关闭回调
	self._pause = false 	--当前是否暂停，因为展示武将的时候，要停一下
	self._showIndex = 0 
	self._loadIndex = 0 


	self._bgNode = nil
	self._showKnightNode = nil
	self._awardNodes = {} --所有显示出来的奖励显示
	self._descTxt = nil --招募顶部的描述
	
	self._currentSound = nil
end

function RecruitingShowBaseLayer:onEnter()
	dump("RecruitingShowBaseLayer:onEnter()!!!!!!!!!!")
	--场景什么的都在特效中，基本不用再单独创建什么东西
	if self._rootEffect == nil then
		self:_showAwards()
	end
end

function RecruitingShowBaseLayer:onExit()
	G_AudioManager:stopSound(self._currentSound)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_RECEQUIP_UPDATE, nil, false)
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

--展示招募奖励
function RecruitingShowBaseLayer:_showAwards()
	dump("RecruitingShowBaseLayer:_showAwards()!!!!!!!!!!!")
	if self._recruitType == RecruitingShowBaseLayer.RecruitypeOne then
		self:_oneShow()
	elseif self._recruitType == RecruitingShowBaseLayer.RecruitypeTen then
		self:_tenShow()
	else
		print("among the recruitType, self._recruitType not be there, type error")
	end
end

--单抽展示
function RecruitingShowBaseLayer:_oneShow()
	dump("RecruitingShowBaseLayer:_oneShow()!!!!!!!")
	dump(self:isVisible())
	self._rootEffect = self:_createEffectNode(self._type == 2 and EFFECT_ONE_EQUIP or EFFECT_ONE_NAME,function (event)
		if event == "load" then
			dump("event == load")
			local knightNode = self:_getAwardNode(self._awards[1])
			local info_node = knightNode:getSubNodeByName("info_node")
			if info_node then
				info_node:setVisible(false)
			end

			local effectNode = self._rootEffect:getEffectNodeBykey(self._type == 2 and "ball" or "man")
			local rongqi = effectNode:getEffectNodeBykey("rongqi")
			rongqi:addChild(knightNode)
			self._awardNodes[#self._awardNodes + 1] = knightNode

		    local AudioConst = require("app.const.AudioConst")
		    G_AudioManager:playSoundById(AudioConst.SOUND_SPEED)
		elseif event == "finish" then
			dump("event == finish")
			local info_node = self._awardNodes[1]:getSubNodeByName("info_node")
			if info_node then
				info_node:setVisible(true)
			end
			self:_openCheck()
			--self._awardNodes[1]:getSubNodeByName("knight_node"):playVoice()
			-- self._showIndex = self._showIndex + 1
			-- self:_checkSpecialShow(self._awards[1])
			-- self:_checkShowOver()
		end
	end,false)

	self._rootNode:addChild(self._rootEffect) 
	dump(self._rootNode:isVisible())
	--添加武将节点到特效容器
	self:_addKnightToEffect()

	--开始播放
	self._rootEffect:play()
	
    local AudioConst = require("app.const.AudioConst")
    G_AudioManager:playSoundById(AudioConst.SOUND_LEVEL_UP_BIG)
end

--十连抽展示
function RecruitingShowBaseLayer:_tenShow()
	dump("RecruitingShowBaseLayer:_tenShow()!!!!!!!")
	local playSpeedVoice = false
	self._rootEffect = self:_createEffectNode(self._type == 2 and EFFECT_TEN_EQUIP or EFFECT_TEN_NAME,function (event)
		if event == "load" then
			self._loadIndex = self._loadIndex + 1
			dump(self._loadIndex)
			local str = (self._type == 2 and "ball" or "man")..self._loadIndex
			dump(str)
			local effectNode = self._rootEffect:getEffectNodeBykey(str)
			local rongqi = effectNode:getEffectNodeBykey("rongqi")
			if self._loadIndex > #self._awards then
				effectNode:setVisible(false)
			else
				--test code
				-- local img = ccui.ImageView:create(G_Url:getUI_text("text_stay_chapter"))
				-- effectNode:addChild(img)
				local knightNode = self:_getAwardNode(self._awards[self._loadIndex])
				knightNode:getSubNodeByName("name_label"):setVisible(false)
				rongqi:addChild(knightNode)
				self._awardNodes[#self._awardNodes + 1] = knightNode
			end
			
			if playSpeedVoice == false then
			    local AudioConst = require("app.const.AudioConst")
			    G_AudioManager:playSoundById(AudioConst.SOUND_SPEED)
			    playSpeedVoice = true
			end
		elseif event == "finish" then
			--self:_pauseEffect()
			for i=1,#self._awards do
				dump(i)
				dump(self._awardNodes)
				local knightNode = self._awardNodes[i]
				knightNode:getSubNodeByName("name_label"):setVisible(true)
			end
			self:_openCheck()
			-- local maxNum = math.min(10,#self._awards)
			-- for i=1,maxNum do
			-- 	self._showIndex = self._showIndex + 1
			-- 	local isShow = self:_checkSpecialShow(self._awards[self._showIndex])
			-- 	if isShow then
			-- 		return
			-- 	end
			-- end
			--self:_checkShowOver()
			self._swallowLayout:setTouchEnabled(false)
		end
	end,false)

	self._rootNode:addChild(self._rootEffect) 
	--self._rootEffect:setPositionY(display.height * 0.1)

	--添加武将节点到特效容器
	self:_addKnightToEffect()

	--开始播放
	self._rootEffect:play()

    local AudioConst = require("app.const.AudioConst")
    G_AudioManager:playSoundById(AudioConst.SOUND_LEVEL_UP_BIG)
end

--开测
function RecruitingShowBaseLayer:_openCheck()
	--继续上次的idx继续检测是否有需要展示的武将
	local idx = self._showIndex
	if idx >= #self._awards then
		self:_checkShowOver()
		return
	end

	idx = idx == 0 and 1 or idx
	local show = false
	for i=idx,#self._awards do
		self._showIndex = self._showIndex + 1
		if self._showIndex > #self._awards then
			break
		end

		dump(self._showIndex)
		if self:_isNeedShow(self._awards[self._showIndex]) then
			show = true
			break
		end
	end
	
	self._showIndex = self._showIndex > #self._awards and #self._awards or self._showIndex
	if show then
		self:_showSpecial(self._awards[self._showIndex])
	else
		self:_checkShowOver()
	end
end

-- 特殊展示
function RecruitingShowBaseLayer:_showSpecial(data)
	G_Popup.newPopupWithTouchEnd(function ()
		local specialLayer = CommonKnightShowLayer.new(self._type == 2 and 3 or CommonKnightShowLayer.STYLE_RECRUITING,data.value,true,function (event)
			if event == "finish" then
				--specialLayer:setTouchEnabled(false)
			elseif event == "on_close" then
				--self:_resumeEffect()
				--dump(self._showIndex)
				self:_openCheck() --继续检测
				-- self:_checkShowOver()
			end
		end)
		specialLayer:setTouchEnabled(true)
		return specialLayer
	end, false, true)
end

-- 是否展示完毕
function RecruitingShowBaseLayer:_checkShowOver()

	if self._showIndex >= #self._awards then
		--展示奖励结束之后
		self:_onAwardsPlayOver()
	end
end

---是否需要展示
function RecruitingShowBaseLayer:_isNeedShow(param)
	--return true --test
	if param.type == G_TypeConverter.TYPE_KNIGHT then
		local knightInfo = KnightInfo.get(param.value)
		assert(knightInfo, "can't find knight_info of id " .. tostring(param.value))
		if knightInfo.quality >= self:_getNeedShowColor() and knightInfo.type == 2 then
			return true
		end
	end
	if param.type == G_TypeConverter.TYPE_EXCLUSIVE_EQUIP then
		local knightInfo = exclusive_info.get(param.value)
		-- assert(knightInfo, "can't find knight_info of id " .. tostring(param.value))
		if knightInfo.quality >= self:_getNeedShowColor() then
			return true
		end
	end
	return false
end

--添加武将节点
function RecruitingShowBaseLayer:_addKnightToEffect()
	if self._recruitType == RecruitingShowBaseLayer.RecruitypeOne then
		-- local knightNode = self:_getAwardNode(self._awards[1])
		-- local effectNode = self._rootEffect:getEffectNodeBykey("man")
		-- effectNode:addChild(knightNode)
	elseif self._recruitType == RecruitingShowBaseLayer.RecruitypeTen then
		-- local maxNum = math.min(10,#self._awards)
		-- for i=1,maxNum do
		-- 	-- local knightNode = self:_getAwardNode(self._awards[i])
		-- 	-- local effectNode = self._rootEffect:getEffectNodeBykey("man"..i)
		-- 	-- effectNode:addChild(knightNode)
		-- end
	end
end

---获取奖励节点
function RecruitingShowBaseLayer:_getAwardNode(award)
	
end

---获取购买成功的显示的小标题文字对象和文字需要放置的位置
function RecruitingShowBaseLayer:_getDescTxtAndPos()
	
end

---所有奖励都展示完后调用。
---这里只是设置了文字的标题，子类要根据情况添加新东西。
function RecruitingShowBaseLayer:_onAwardsPlayOver()
	local tipsTxt, pos = self:_getDescTxtAndPos()
	self._descTxt = display.newTTFLabel({
	    text = tipsTxt,
	    font = G_Path.getNormalFont(),
	    size = 25,
	    color = G_Colors.getColor(8)
	})

	self._descTxt:enableOutline(G_Colors.getOutlineColor(9), 2)
	self._endEffectNode:addChild(self._descTxt)
	self._descTxt:setPosition(pos.x, pos.y)
	self._descTxt:setVisible(false)

	self._descTxt:performWithDelay(function()
		self._descTxt:setVisible(true)
	end, 0.1)

end

-- 创建一个特效节点
function RecruitingShowBaseLayer:_createEffectNode(effectName, eventHandler, autoRelease)
	dump(effectName)
	local effectNode = EffectNode.new(effectName, eventHandler)
	effectNode:setAutoRelease(autoRelease)

	return effectNode
end

-- 创建一个武将节点
--[[
param = {
	knightData = ,
	scale = ,
	fontSize = ,
	isVoice = ,
}
]]
function RecruitingShowBaseLayer:_createKnightImg(param)
	local rootNode = display.newNode()
	rootNode:setCascadeOpacityEnabled(true)
	local node = KnightImg.new(param.knightData.cfg.knight_id,0,0)
	node:setPositionY(-90)
	node:setScale(1)
	node:setName("knight_node")
	rootNode:addChild(node)
	--rootNode:setScale(0.8)

	local label = display.newTTFLabel({
	    text = param.knightData.cfg.name or "",
	    font = G_Path.getNormalFont(),
	    size = param.fontSize,
	})

	local color = G_TypeConverter.quality2Color(param.knightData.cfg.quality)
	label:setColor(G_Colors.qualityColor2Color(color,true))
	label:enableOutline(G_Colors.qualityColor2OutlineColor(color), 2)
	label:setName("name_label")
	rootNode:addChild(label)
	label:setPositionY(-80)

	if param.isVoice and color < 5 then
		node:performWithDelay(function()
			node:playVoice()
		end, 0.5)
	end

	return rootNode
end

function RecruitingShowBaseLayer:_createEquipImg(param)
	dump(param)
	local rootNode = display.newNode()
	rootNode:setCascadeOpacityEnabled(true)
    local img = ccui.ImageView:create(param.knightData.icon)
	rootNode:addChild(img)
	if param.knightData.type == G_TypeConverter.TYPE_EXCLUSIVE_EQUIP then -- 专属缩放
		img:setScale(0.5)
	end
	--rootNode:setScale(0.8)

	local strName = param.knightData.cfg.name
	if self._type == 2 then
		strName = strName .. "*" .. param.knightData.size
	end
	local label = display.newTTFLabel({
	    text = strName or "",
	    font = G_Path.getNormalFont(),
	    size = param.fontSize,
	})

	dump(param.knightData.cfg.name)
	local color = G_TypeConverter.quality2Color(param.knightData.cfg.quality)
	label:setColor(G_Colors.qualityColor2Color(color,true))
	label:enableOutline(G_Colors.qualityColor2OutlineColor(color), 2)
	label:setName("name_label")
	rootNode:addChild(label)
	label:setPositionY(-80)

	return rootNode
end

---获取购买成功的显示的小标题文字对象和文字需要放置的位置
-- function RecruitingShowBaseLayer:_getDescTxtAndPos()
	
-- end

-- 创建武将信息面板
function RecruitingShowBaseLayer:_createKnightInfo(param)

	local node = cc.CSLoader:createNode(G_Url:getCSB("RecruitingKnightInfoNode", "recruiting"))
	node:setCascadeOpacityEnabled(true)
	node:setOpacity(0)
	node:runAction(cc.FadeIn:create(0.2))

	local colorQuality = G_TypeConverter.quality2Color(param.cfg.quality)


	-- 种族
	if self._type ~= 2 then
		node:updateImageView("Image_group", {texture=TeamUtils.getGroupImgUrl(param.cfg.group)})
		-- 资质:xx
		node:updateLabel("Text_quality_amount_desc", {
			text = G_Lang.get("lang_battle_summary_quality_desc",{quality = param.cfgInfo.quality}),
			color=G_Colors.qualityColor2Color(colorQuality,true),
			outlineColor=G_Colors.qualityColor2OutlineColor(colorQuality),
		})
		-- 白/蓝将
		node:updateImageView("Image_quality_desc", {
			texture = G_Url:getText_system("txt_sys_quality_0"..colorQuality)
		})
	else
		local strOther = ""
		dump(param.type)
		if param.type == G_TypeConverter.TYPE_EXCLUSIVE_EQUIP then
			
			strOther = "\n【" .. KnightInfo.get(param.cfg.knight_id).name .. "】"
		end
		
		param.name = param.cfg.name .. " * " .. param.size .. strOther
		node:getSubNodeByName("Image_group"):setVisible(false)
		node:getSubNodeByName("Text_quality_amount_desc"):setVisible(false)
		node:getSubNodeByName("Image_quality_desc"):setVisible(false)
	end

	-- 名字
	dump(param)
	node:updateLabel("Text_name", {
		text=param.name,
		color=G_Colors.qualityColor2Color(colorQuality,true),
		outlineColor=G_Colors.qualityColor2OutlineColor(colorQuality),
	})

	return node
end

-- --检查是否要弹出武将引导对话。
-- function RecruitingShowBaseLayer:_checkKnightDialog(knightId, onOver)
-- 	local dialogCache = G_Me.recruitingData:getDialogCache()
-- 	if dialogCache ~= nil then ---判断当前武将是否需要弹出
-- 		local knightDialogInfo = KnightFirstDialogue.get(knightId)
-- 		assert(knightDialogInfo, "can't find knightId in KnightFirstDialogue" .. tostring(knightId))
-- 		G_Responder.hasGuideStory(knightDialogInfo.dialogue, nil, onOver)
-- 		G_Me.recruitingData:clearDialogCache()
-- 	else
-- 		onOver()
-- 	end
-- end

function RecruitingShowBaseLayer:_getNeedShowColor()
	-- 确认是否是武将需要展示
	local id = 231
	local info = ParameterInfo.get(id)
	assert(info, "Could not find the parameter_info with id: "..tostring(id))

	local limitColor = tonumber(info.content)
	assert(limitColor, "Invalid info.content: "..tostring(info.content))

	return limitColor
end

-- 暂停
function RecruitingShowBaseLayer:_pauseEffect()
	self._pause = true
	self._rootEffect:pause()
end

-- 继续播放
function RecruitingShowBaseLayer:_resumeEffect()
	self._pause = false
	self._rootEffect:resume()
end

function RecruitingShowBaseLayer:_addOutlines(node, ...)
	-- local texts = {...}
	-- for i = 1, #texts do
	-- 	local text = texts[i]
	-- 	node:updateLabel(text, {
	-- 		outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE
	-- 	})
	-- end
end

function RecruitingShowBaseLayer:_getKnightScaleAfterShow()
	return 1
end

return RecruitingShowBaseLayer