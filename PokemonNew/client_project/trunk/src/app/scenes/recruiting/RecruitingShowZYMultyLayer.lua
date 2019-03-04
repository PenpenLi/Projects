
---==============
---阵容招募，10连展示界面

local RecruitingShowBaseMultyLayer = require "app.scenes.recruiting.RecruitingShowBaseMultyLayer"
local RecruitingShowZYMultyLayer = class("RecruitingShowZYMultyLayer", RecruitingShowBaseMultyLayer)

local TypeConverter = require "app.common.TypeConverter"
local UpdateNodeHelper = require "app.common.UpdateNodeHelper" 
local RoundEffectHelper = require "app.common.RoundEffectHelper"

function RecruitingShowZYMultyLayer:ctor()
	RecruitingShowZYMultyLayer.super.ctor(self,2)
	self._boughtScore = 0
	self._awardIndex = 0
	self._awardIndexView = nil --显示是第几次招募的对象
	self._isLocked = true
	self._continueNode = nil
	self._addAwards = nil
	self._moveDownDist = display.height * 0.17
	self._addValue = 0
	self._brightItems = {}
end

function RecruitingShowZYMultyLayer:onEnter()
	RecruitingShowZYMultyLayer.super.onEnter(self)
	--点击屏幕时间侦听
    self:setTouchEnabled(true)
    self:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self:registerScriptTouchHandler(function (event)
    	if event == "began" then
    		return true 
    	elseif event == "ended" then
	    	self:_onTouch()
	    	return true
	    end
    end)
end

function RecruitingShowZYMultyLayer:onExit()
	RecruitingShowZYMultyLayer.super.onExit(self)
	if self._onClose ~= nil then
		self._onClose()
		self._onClose = nil
	end
end

--设置单个动画播放完毕的回调。
function RecruitingShowZYMultyLayer:setOnPlayOver(onPlayOver)
	self._onPlayOver = onPlayOver
end

--设置已购买的积分
function RecruitingShowZYMultyLayer:setBoughtScore(value, addAwards)
	self._boughtScore = value
	self._addAwards = addAwards
end

---设置一开始的招募次数
function RecruitingShowZYMultyLayer:setBeginIndex(value)
	self._awardIndex = value
end

---设置需要被添加流光特效的道具信息
function RecruitingShowZYMultyLayer:setBrightAwards(items)
	self._brightItems = items
end

---设置刷新获取。
function RecruitingShowZYMultyLayer:freshView(awards, awardIndex)
	self._rootPosition = cc.p(display.cx, display.cy - display.height * 0.2 + self._moveDownDist)
	self._awards = awards
	self:_replaceAwards() --仅删除之前的奖励显示
	self._awardIndex = awardIndex
	self._awardIndexView:setVisible(false)
	self._continueNode:setVisible(false)
	self._descTxt:setVisible(false)
	self._isLocked = true
	
	if self._addLable ~= nil then
		self._addLable:setVisible(false)
	end
end

---更新当前界面上的奖励展示。
function RecruitingShowZYMultyLayer:_replaceAwards()
	for i = 1, #self._awardNodes do
		local awardNode = self._awardNodes[i]
		awardNode:removeFromParent()
	end

	self._awardNodes = {}

	local iteratorIndex = 0

	local function iterate()
		iteratorIndex = iteratorIndex + 1
		local award = self._awards[iteratorIndex]
		if iteratorIndex <= #self._awards then ---奖励没有展示完
			local needShow = self:_isNeedShow(award)
			self._pause = needShow
			self:_showAward(award, self:_getAwardPos(iteratorIndex), needShow, iterate)
		else ---展示奖励结束之后
			self:_onReplaceOver()
		end
	end

	iterate()
end

function RecruitingShowZYMultyLayer:_onReplaceOver()
	self._awardIndexView:setVisible(self._awardIndex ~= 0)
	self._continueNode:setVisible(true)
	self._descTxt:setVisible(true)
	self:_updateAddAwardLabel()

	if self._addLable ~= nil then
		self._addLable:setVisible(true)
	end

	local desc = self:_getDescTxtAndPos()
	self._descTxt:setString(desc)

	self._awardIndexView:updateLabel("Text_index_value", self._awardIndex)

	if self._awardIndex ~= 0 then ---展示最后一个
    	self._continueNode:updateLabel("Text_continue_desc", G_LangScrap.get("recruiting_click_2_open_more"))
    else
    	self._continueNode:updateLabel("Text_continue_desc", G_LangScrap.get("common_text_click_continue"))
	end

	self:performWithDelay(function () ---因为最后一个动画展示还需要时间，这边延时让玩家继续点击。
		self._isLocked = false
	end, 0.25)

	G_Me.recruitingData:clearDialogCache()
end

function RecruitingShowZYMultyLayer:_onTouch()
	if not self._isLocked then
		self._onPlayOver()
	end
end

--返回一个奖励显示
function RecruitingShowZYMultyLayer:_getAwardNode(award)
	local item
	item = cc.CSLoader:createNode(G_Url:getCSB("CommonIconItemNode", "common"))
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

function RecruitingShowZYMultyLayer:_getAwardPos(index)
	local posIndex = #self._awards - index ---重置下标信息，让位置从上到下分布
	local xIndex = 1 - (posIndex % 2)
	local yIndex = math.floor(posIndex / 2)

	local xPos = display.width * 0.35 + xIndex * (display.width * 0.3)
	local yPos = display.height *0.64 + yIndex * 170
	return {x = xPos, y = yPos}
end

---获得描述文本以及位置
function RecruitingShowZYMultyLayer:_getDescTxtAndPos()
	local txt = G_LangScrap.get("recruiting_zy_buy_point", {num = self._boughtScore})
	local pos = cc.p(
		display.cx,
		display.height - display.height * 0.06 - 180
	)
	return txt, pos
end

function RecruitingShowZYMultyLayer:_getEffectDoor()
	return "effect_choujiang_building1_r"
end

function RecruitingShowZYMultyLayer:_onAwardsPlayOver()
	RecruitingShowZYMultyLayer.super._onAwardsPlayOver(self)

	self._continueNode = cc.CSLoader:createNode(G_Url:getCSB("CommonContinueNode", "common"))
	UpdateNodeHelper.updateCommonContinueNode(self._continueNode, true)
    self._rootNode:addChild(self._continueNode, 100)
    self._continueNode:setPosition(display.cx, display.height * 0.3)
    self._continueNode:updateLabel("Text_continue_desc", G_LangScrap.get("recruiting_click_2_open_more"))
	
	local tagY = (display.width / display.height >= 0.75) and -50 or 0
	self._rootNode:runAction(cc.Spawn:create(
		cc.MoveBy:create(0.3, cc.p(0, - self._moveDownDist + tagY)),
		cc.Sequence:create(
			cc.DelayTime:create(0.3 - 0.07),
			cc.CallFunc:create(function()
				self:_createShineEffect()
			end)
		),
		cc.Sequence:create(
			cc.DelayTime:create(0.3),
			cc.CallFunc:create(function()
				if self._awardIndexView == nil then ---添加第几次招募的显示
					self._awardIndexView = cc.CSLoader:createNode(G_Url:getCSB("RecruitingZYAwardIndexNode", "recruiting"))
					self:addChild(self._awardIndexView)
					self._awardIndexView:setPosition(display.width * 0.6, display.height * 0.26)
				end
				self._awardIndexView:setVisible(true)
				self._awardIndexView:updateLabel("Text_index_value", self._awardIndex)
				self:_updateAddAwardLabel()
				self._isLocked = false
			end)
		)
	))
end

function RecruitingShowZYMultyLayer:_updateAddAwardLabel()
	if self._addAwards ~= nil then
		local descStr = "+" .. tostring(self._addAwards.award.size) .. G_LangScrap.get("lang_value_extra" .. self._addAwards.index)
		if self._addLable == nil then
			self._addLable = display.newTTFLabel({
			    font = G_Path.getNormalFont(),
			    size = 28
			})

			local descPosX, descPosY = self._descTxt:getPosition()
			local descSize = self._descTxt:getContentSize()
			self._addLable:setPosition(descPosX + descSize.width * 0.5, descPosY)
			self._endEffectNode:addChild(self._addLable, 3)
		end

		self._addLable:setAnchorPoint(0, 0.5)
		self._addLable:setString(descStr)
		self._addLable:setColor(G_ColorsScrap.getCritColor(self._addAwards.index, true))
		self._addLable:enableOutline(G_ColorsScrap.getCritColorOutline(self._addAwards.index), 2)
	else
		if self._addLable ~= nil then
			self._addLable:setString("")
		end
	end
end

return RecruitingShowZYMultyLayer