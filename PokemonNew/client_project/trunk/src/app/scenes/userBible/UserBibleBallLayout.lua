local UserBibleBallLayout = class("UserBibleBallLayout", function ()
	return ccui.Layout:create()
end)

----==========
----传入的数据为单个珠宝的数据，对象为UserBibleUnit
----==========
local TipsNode = require "app.scenes.userBible.UserBibleTipsNode" 
local UserBibleConfigConst = require "app.const.UserBibleConfigConst" 
local EffectNode = require "app.effect.EffectNode" 
local ShaderUtils =  require "app.common.ShaderUtils" 

UserBibleBallLayout.SCALE_TIME = 0.05
UserBibleBallLayout.SHOW_TIME = 1.2
UserBibleBallLayout.FADE_TIME = 0.4

local LIGHT_COLOR = cc.c3b(0xff,0xff,0xff)
local DARK_COLOR = cc.c3b(0x66,0x66,0x66)

function UserBibleBallLayout:ctor(bibleData, index)
	assert(bibleData or type(bibleData) == "table", "invalide bibleData " .. tostring(bibleData))
	self:enableNodeEvents()

	self._actionTag = 666
	self._scaleActTag = 777
	self._isPlayingScale = false
	self._bibleData = bibleData
	self._activeAnim = nil
    self._currentSound = nil
	self._active = false
	self._index = index
	self._view = cc.CSLoader:createNode(G_Url:getCSB("UserBibleBallCell", "userBible"))
	self._view:updateImageView("Image_type", {visible = false})--G_Url:getUI_userBible("bg_userbible_iconlit0" .. bibleData:getPicUrl()))
	self._view:updateImageView("Image_bg", G_Url:getUI_userBible("bg_userbible_iconbg0" .. bibleData:getPicUrl()))
	local cellContent = self._view:getSubNodeByName("Panel_content")
	local contentSize = cellContent:getContentSize()
	
	cellContent:setSwallowTouches(false)
	self:setContentSize(contentSize)
	self._view:setPosition(contentSize.width/2, contentSize.height/2)
	self:setAnchorPoint(0.5, 0.5)
	self:setSwallowTouches(false)
	self._view:setScale(self._bibleData:isImportant() and 1.25 or 1)
	self:addChild(self._view)

	local touchMask = ccui.Layout:create()
	touchMask:setAnchorPoint(0.5, 0)
	touchMask:setContentSize(116, 160)
	touchMask:setTouchEnabled(true)
	touchMask:setSwallowTouches(false)
	touchMask:setPositionX(contentSize.width/2)
	self:addChild(touchMask)
	touchMask:addClickEventListenerEx(handler(self, self._onClicked))
end

function UserBibleBallLayout:onEnter()
	if self._bibleData:isImportant() then --or self._bibleData:isEndOfChapter() then
		self:addTipsNode()
	end
	self:_updateState()
end

--刷新本地数据，断线重连情况下要刷新
function UserBibleBallLayout:freshData()
	self._bibleData = G_Me.userBibleData:getBibleDataById(self._bibleData:getId())
end

-----更新本地显示状态
function UserBibleBallLayout:updateState()
	self:_updateState()
end

----设置是为正要点亮的状态
function UserBibleBallLayout:setActiveState(active)
	self._active = active
	--dump(active)
	self:_updateState()
end

function UserBibleBallLayout:_updateState()
	local contentSize = self:getContentSize()
	local imgType = self._view:getSubNodeByName("Image_type")
	--dump(self._active)
	if self._active then
		if self._activeAnim == nil then
			self._activeAnim = EffectNode.new("effect_yuegh_zhuan")
			self:addChild(self._activeAnim)
			self._activeAnim:setPosition(contentSize.width/2, contentSize.height/2)
			self._activeAnim:setAutoRelease(true)
			self._activeAnim:play()
		end

		self._view:setColor(LIGHT_COLOR)
		imgType:setVisible(false)

		-- if self._tipsNode == nil then
		-- 	self:addTipsNode()
		-- end
	else
		if self._activeAnim ~= nil then
			self:removeChild(self._activeAnim)
			self._activeAnim = nil
		end

		if self._tipsNode ~= nil and not self._bibleData:isEndOfChapter() then
			self._tipsNode:removeFromParent()
			self._tipsNode = nil
		end

		if self._bibleData:getLighting() then
			imgType:setVisible(false)
			self._view:setColor(LIGHT_COLOR)
		else
			imgType:setVisible(false)
			self._view:setColor(DARK_COLOR)
			if self._lightingAnim ~= nil then
		 		self:removeChild(self._lightingAnim)
				self._lightingAnim = nil
			end
		end
	end
end

function UserBibleBallLayout:_onClicked()
	if self._bibleData:isImportant() then
		-- local chapterId = self._bibleData:getChapterId()
  --   	local pageData = G_Me.userBibleData:getPageBibleDataById(chapterId)
  --   	local pageRewardType = pageData:getRewardType()

	 --    if pageRewardType == UserBibleConfigConst.REWARD_MULTY then
		-- 	G_Popup.newSelectRewardPopup(nil, nil, pageData:getRewardValue(), false, true)
		-- 	return
		-- end
	end

	if self._tipsNode ~= nil then
		self._tipsNode:onTouch()
	end

	if self._tipsNode == nil then
		self:addTipsNode()
	end

	if not self._bibleData:isImportant() then
		if self._active then
			self:_fadeTipsNode()
			--self:_reshowTipsNode()
		else
			self:_fadeTipsNode()
		end
	end
end

function UserBibleBallLayout:_fadeTipsNode()
	---先停止之前的action
	self._tipsNode:stopActionByTag(self._actionTag)
	self._tipsNode:setScale(0)
	---点击后延迟消失
	local seq = cc.Sequence:create(
		cc.ScaleTo:create(UserBibleBallLayout.SCALE_TIME, 1),
		cc.DelayTime:create(UserBibleBallLayout.SHOW_TIME),
        cc.FadeOut:create(UserBibleBallLayout.FADE_TIME))
	seq:setTag(self._actionTag)
	self._tipsNode:setOpacity(255)
    self._tipsNode:runAction(seq)
end

function UserBibleBallLayout:_reshowTipsNode()
	---先停止之前的action
	self._tipsNode:stopActionByTag(self._actionTag)
	self._tipsNode:setScale(0)
	---点击后延迟消失
	local seq = cc.Sequence:create(
		cc.ScaleTo:create(UserBibleBallLayout.SCALE_TIME, 1))
	seq:setTag(self._actionTag)
	self._tipsNode:setOpacity(255)
    self._tipsNode:runAction(seq)
end

------播放点亮动画
function UserBibleBallLayout:lightUp()
	dump("UserBibleBallLayout:lightUp!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	local contentSize = self:getContentSize()
	-- ---播放移动动画
	local playPassAnim = function ()
		local selfPosX, selfPosY = self:getPosition() 
		local worldPos = self:getParent():convertToWorldSpaceAR(cc.p(selfPosX, selfPosY))

		uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_USER_BIBLE_PLAY_STAR_LINE, nil, false, {x = worldPos.x, y = worldPos.y})
	end

	local function effectFinished(event,frameIndex,node)
		if event == "finish" then -----出现动画播放完毕之后，播放采集到月光宝盒的动画
			dump("effectFinished!!!!!!!!!!")
			playPassAnim()
			self:playScaleAct()
			if self._activeAnim ~= nil then
			    self:removeChild(self._activeAnim)
				self._activeAnim = nil
			end
		end
	end

	local effectNodeLight = EffectNode.new("effect_yuegh_gx", effectFinished)
	self:addChild(effectNodeLight)
	effectNodeLight:setPosition(contentSize.width/2, contentSize.height/2)
	effectNodeLight:setAutoRelease(true)
	effectNodeLight:play()
	
    ---播放点亮音效。
    --self._currentSound = G_AudioManager:playSoundById(9061)
    --G_AudioManager:playSound(self._currentSound)
end

function UserBibleBallLayout:addTipsNode()
	local chapterColor = self._bibleData:getChapterTipColor()
	self._tipsNode = TipsNode.new(chapterColor)
	self._tipsNode:setTips(self._bibleData:getTips())
	self._tipsNode:setPageTips(self._bibleData:isEndOfChapter() and self._bibleData:getChapterTips() or nil)
	self._tipsNode:setCascadeOpacityEnabled(true)

	local selfPosX, selfPosY = self:getPosition()
	local tipPos = cc.p(selfPosX, selfPosY + 45)

	self:getParent():addChild(self._tipsNode, 100)
	self._tipsNode:setPosition(tipPos)
end

function UserBibleBallLayout:playScaleAct()
	if self._isPlayingScale or not self._bibleData:getLighting() then return end

	local scalePlus = self._bibleData:isImportant() and 1.25 or 1
	local scale1 = cc.ScaleTo:create(0.5, 1.01 * scalePlus)
    local scale2 = cc.ScaleTo:create(0.5, 0.99 * scalePlus)
    local seq = cc.Sequence:create(scale1,scale2)
    local repeatAction = cc.RepeatForever:create(seq)
    repeatAction:setTag(self._scaleActTag)
    self._view:runAction(repeatAction)
    self._isPlayingScale = true
end

function UserBibleBallLayout:stopScaleAct()
	self._view:stopActionByTag(self._scaleActTag)
	self._isPlayingScale = false
end

function UserBibleBallLayout:onExit()
	if self._tipsNode ~= nil then
		self._tipsNode:stopActionByTag(self._actionTag)
	end
	G_AudioManager:stopSound(self._currentSound)
end


return UserBibleBallLayout