
-- SliderButton

--[=================[
	
	滑动按钮
	
	模仿梦幻西游中的滑动按钮做的

]=================]

local max = math.max

local AudioWrapper = require "app.audio.AudioWrapper"
local SoundButtonWrapper = AudioWrapper.SoundButtonWrapper

local SliderButton = class("SliderButton", function()
	return display.newNode()
end)

function SliderButton.create(...)
	return SliderButton.new(...)
end

function SliderButton:ctor(on)
	self._on = on
	self:enableNodeEvents()
end

function SliderButton:onEnter()

	-- 未来这些按钮要放到通用里
	local sliderOff = G_Url:getUI_subtitle("btn_guan")
    local sliderOn = G_Url:getUI_subtitle("btn_kai")
    local sliderButton = G_Url:getUI_subtitle("btn_kaiguan")

	-- 分别创建其对象
	local _sliderOff = display.newSprite(sliderOff)
	self:addChild(_sliderOff)

	local _sliderOn = display.newSprite(sliderOn)
	self:addChild(_sliderOn)

	-- 取最大的尺寸（背景图和激活图）
	local offSize = _sliderOff:getContentSize()
	local onSize = _sliderOn:getContentSize()

	local size = cc.size(max(offSize.width, onSize.width), max(offSize.height, onSize.height))
	self:setContentSize(size)
	self:setAnchorPoint(cc.p(0.5, 0.5))

	_sliderOff:setPosition(size.width/2, size.height/2)
	_sliderOn:setPosition(size.width/2, size.height/2)

	-- 按钮的固定偏移值
	local offset = 25
	local _start = offset
	local _end = size.width - offset
	self._distance = _end - _start

	-- 用作按钮位置的参考
	local ref = display.newNode()
	self:addChild(ref)
	ref:setPosition(_start, size.height/2)

	-- 创建按钮
	local _sliderButton = ccui.Button:create(sliderButton)
	ref:addChild(_sliderButton)

	self._sliderButton = _sliderButton
	self._sliderOff = _sliderOff
	self._sliderOn = _sliderOn

	self:turn(self._on, false)

	self._sliderButton:addClickEventListener(function()
		if not self._lock then
			self._on = not self._on
			self:turn(self._on, true)
			
			if self._callback then
				self._callback(self, self._on)
			end
		end
	end)

end

function SliderButton:onExit()
	self:removeAllChildren()
end

--[=================[
	
	开启/关闭

	@on 是否开启标示
	@withAnimation 是否伴随动画

]=================]

function SliderButton:turn(on, withAnimation)

	if on then
		if not withAnimation then
			self._sliderButton:setPositionX(self._distance)
			self._sliderOn:setOpacity(255)
		else
			self._sliderButton:runAction(cc.Sequence:create(
				cc.MoveTo:create(0.25, cc.p(self._distance, 0)),
				cc.CallFunc:create(function() self._lock = false end)
			))
			self._sliderOn:runAction(cc.FadeIn:create(0.03))
		end
	else
		if not withAnimation then
			self._sliderButton:setPositionX(0)
			self._sliderOn:setOpacity(0)
		else
			self._sliderButton:runAction(cc.Sequence:create(
				cc.MoveTo:create(0.25, cc.p(0, 0)),
				cc.CallFunc:create(function() self._lock = false end)
			))
			self._sliderOn:runAction(cc.FadeOut:create(0.03))
		end
	end

	if withAnimation then
		self._lock = true
	end

	self._on = on

end

--[=================[
	
	对按钮增加监听

	@callback 监听回调

]=================]

function SliderButton:addClickEventListener(callback)
	self._callback = callback
end

return SliderButton