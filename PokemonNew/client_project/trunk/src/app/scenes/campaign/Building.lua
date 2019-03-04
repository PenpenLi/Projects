--
-- Author: YouName
-- Date: 2016-03-25 15:28:45
--
local Building = class("Building",function()
	return display.newNode()
end)

function Building:ctor( touchSize,functionId,onClick,showFrameFunc )
	-- body
	self:enableNodeEvents()	

	self._functionId = functionId or 0
	self._onClick = onClick
	self._showFrameFunc = showFrameFunc
	self._imageBuilding = nil
	self._imageFileName = nil
	self._conSize = nil
	self._imageTitle = nil
	self._textOpenLevel = nil
	self._imageRedPoint = nil
	self._posTitle = nil
	self._posLevel = nil
	self._posRedPoint = nil
	self._pathTitle = nil
	self._isOpen = false
	self._isShow = false
	self._isShowRed = false
	self._isClicked = false
	
	local rootPath = "newui/adventure/bg_adventure/"
	local imageFileName = nil
	if functionId == G_FunctionConst.FUNC_WORLD_BOSS then
		imageFileName = rootPath.."bg_adventure_platform01a.png"
		self._conSize = cc.size(600,425)
		self._posTitle = cc.p(12,150)
		self._posRedPoint = cc.p(75,180)
		self._posLevel = cc.p(12,120)
		self._pathTitle = "newui/text/system/txt_sys_title_arena01.png"
	elseif functionId == G_FunctionConst.FUNC_MONSTER_TOWER then
		imageFileName = rootPath.."bg_adventure_platform02a.png"
		self._conSize = cc.size(367,360)
		self._posTitle = cc.p(10,110)
		self._posRedPoint = cc.p(80,140)
		self._posLevel = cc.p(12,80)
		self._pathTitle = "newui/text/system/txt_sys_title_thirtythree01.png"
	elseif functionId == G_FunctionConst.FUNC_ROB_TREASURE then
		imageFileName = rootPath.."bg_adventure_platform03.png"
		self._conSize = cc.size(253,259)
		self._posTitle = cc.p(0,110)
		self._posRedPoint = cc.p(55,140)
		self._posLevel = cc.p(0,80)
		self._pathTitle = "newui/text/system/txt_sys_title_indiana01.png"
	elseif functionId == G_FunctionConst.FUNC_SPOOKY then
		imageFileName = rootPath.."bg_adventure_platform04a.png"
		self._conSize = cc.size(288,273)
		self._posTitle = cc.p(-30,110)
		self._posRedPoint = cc.p(70,140)
		self._posLevel = cc.p(-30,80)
		self._pathTitle = "newui/text/system/txt_sys_title_spook01.png"
	elseif functionId == G_FunctionConst.FUNC_RICH then
		imageFileName = rootPath.."bg_adventure_platform06.png"
		self._conSize = cc.size(324,254)
		self._posTitle = cc.p(0,40)
		self._posRedPoint = cc.p(100,70)
		self._posLevel = cc.p(0,10)
		self._pathTitle = "newui/text/system/txt_sys_title_heaven01.png"
	elseif functionId == G_FunctionConst.FUNC_MOUNTAIN then
		imageFileName = rootPath.."bg_adventure_platform05a.png"
		self._conSize = cc.size(290,290)
		self._posTitle = cc.p(0,90)
		self._posRedPoint = cc.p(60,120)
		self._posLevel = cc.p(0,70)
		self._pathTitle = "newui/text/system/txt_sys_title_forward01.png"
	end
	self._imageFileName = imageFileName

	self._rootNode = display.newNode()
	self._rootNode:setCascadeOpacityEnabled(true)
	self:addChild(self._rootNode)

	local touchLayout = ccui.Layout:create()
	touchLayout:setTouchEnabled(true)
	touchLayout:setContentSize(touchSize.width,touchSize.height)
	touchLayout:setAnchorPoint(0.5,0.5)
	self._rootNode:addChild(touchLayout,1)
	touchLayout:addTouchEventListener(handler(self,self._onBuildingClick))

	self._step = 0
	self._offsetY = 0
	self._angle = math.random()
	self:onUpdate(handler(self,self._onEnterFrame))
end

function Building:addEffectNode( effectName,pos )
	-- body
	local effect = require("app.effect.EffectNode").new(effectName)
	effect:play()
	effect:setPosition(pos.x,pos.y)
	self._rootNode:addChild(effect,4)
end

function Building:addToRootNode( child )
	-- body
	self._rootNode:addChild(child,4)
end

function Building:startFloating( step,offsetY )
	-- body
	self._step = step or 0
	self._offsetY = offsetY or 0
end

function Building:_onEnterFrame( dt )
	-- body
	self._angle = self._angle + self._step
	self._angle = self._angle%(math.pi*2)
	local ypos = math.cos(self._angle)*self._offsetY
	self._rootNode:setPositionY(ypos)
end

function Building:checkFunctionOpen( )
	-- body
	local isOpen = require("app.common.FunctionLevelHelper").isFunctionOpen(self._functionId)
	local isShow = require("app.common.FunctionLevelHelper").isFunctionShow(self._functionId)
	self._isOpen = isOpen
	self._isShow = isShow

	if self._imageTitle == nil then return end
	if self._textOpenLevel == nil then return end
	if isOpen then
		self._imageTitle:setVisible(true)
		self._textOpenLevel:setVisible(false)
	elseif isShow then
		self._imageTitle:setVisible(true)
		self._textOpenLevel:setVisible(true)
	else
		self._textOpenLevel:setVisible(false)
		self._imageTitle:setVisible(false)	
	end
end

function Building:checkRedPoint( ... )
	-- body
	local isShowRed = require("app.common.RedPointHelper").isValueReach(self._functionId)
	self._isShowRed = isShowRed
	if self._imageRedPoint == nil then return end
	self._imageRedPoint:setVisible(isShowRed)

end

function Building:_doTouchAction( isDown )
	if self._showFrameFunc ~= nil then
		self._showFrameFunc(self._functionId, isDown)
	end
end

function Building:_onBuildingClick( sender,state )
	-- body
	if self._isClicked then
		return
	end

	if state == ccui.TouchEventType.began then
		self:_doTouchAction(true)
		self._clock = os.clock()
		return true
	elseif state == ccui.TouchEventType.ended then
		self:_doTouchAction(false)

		local passClock = os.clock() - self._clock
		local waitTime = 0.2 - passClock
		if waitTime < 0 then
			waitTime  = 0
		end
		if self._onClick ~= nil then
			self:performWithDelay(function ()
				self._onClick(self._functionId)
				self._isClicked = false
			end, waitTime)
			self._isClicked = true
		end
	elseif state == ccui.TouchEventType.canceled then
		self:_doTouchAction(false)
	end

end

function Building:startUp( callback )
	if self._pathTitle ~= nil then
		self._imageTitle = display.newSprite(self._pathTitle)
		self._imageTitle:setScale(0.85)
		self._imageTitle:setPosition(self._posTitle.x,self._posTitle.y)
		self._rootNode:addChild(self._imageTitle,10)

		local strDesc = require("app.common.FunctionLevelHelper").getFunctionDesc(self._functionId)
		self._textOpenLevel = cc.Label:createWithTTF(strDesc,G_Path:getNormalFont(),24)
		self._textOpenLevel:setAnchorPoint(0.5,1)
		self._textOpenLevel:setPosition(self._posLevel.x,self._posLevel.y)
		self._textOpenLevel:enableOutline(G_ColorsScrap.COLOR_SCENE_OUTLINE, 2)
		self._rootNode:addChild(self._textOpenLevel,11)

		self._imageRedPoint = display.newSprite(G_Url:getUI_common("img_com_btn_tipred01"))
		self._rootNode:addChild(self._imageRedPoint,12)
		self._imageRedPoint:setPosition(self._posRedPoint.x,self._posRedPoint.y)
    end

	if self._isOpen then
		self._imageTitle:setVisible(true)
		self._textOpenLevel:setVisible(false)
	elseif self._isShow then
		self._imageTitle:setVisible(true)
		self._textOpenLevel:setVisible(true)
	else
		self._textOpenLevel:setVisible(false)
		self._imageTitle:setVisible(false)	
	end

	self._imageRedPoint:setVisible(self._isShowRed)

	if callback ~= nil then
		callback()
	end
end

function Building:_unbindAsync( ... )
	-- body
	if self._imageFileName ~= nil then
		cc.Director:getInstance():getTextureCache():unbindImageAsync(self._imageFileName)
	end
end

function Building:onEnter( ... )
	-- body
	self:checkFunctionOpen()
	self:checkRedPoint()
end

function Building:onExit( ... )
	-- body
end

return Building 