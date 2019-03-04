

local RecruitingShowBaseMultyLayer = require "app.scenes.recruiting.RecruitingShowBaseMultyLayer"
local RecruitingShowNormalMultyLayer = class("RecruitingShowNormalMultyLayer", RecruitingShowBaseMultyLayer)

local UpdateNodeHelper = require "app.common.UpdateNodeHelper"
local TypeConverter = require "app.common.TypeConverter"

-- type 1 武将 2 专属
function RecruitingShowNormalMultyLayer:ctor(type)
	RecruitingShowNormalMultyLayer.super.ctor(self,type)
	self._coppor = 0
	self._type = type
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1528)
end

function RecruitingShowNormalMultyLayer:setBoughtCopper(value)
	self._coppor = value
end

--返回一个武将显示
function RecruitingShowNormalMultyLayer:_getAwardNode(award)
	local param = TypeConverter.convert(award)
	dump(param)
	local cfg = {
		knightData = param,
		scale = 0.65,
		fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL,
		isVoice = false
	}
	dump(self._type)
	local node = self._type == 2 and self:_createEquipImg(cfg) or self:_createKnightImg(cfg)
	return node
end

function RecruitingShowNormalMultyLayer:_onAwardsPlayOver()
	RecruitingShowNormalMultyLayer.super._onAwardsPlayOver(self)
	self._endEffectNode:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(0.3),
			cc.CallFunc:create(function()
				self:_showClick2Continue()
			end))
	)

	-- self._rootNode:runAction(cc.Spawn:create(
	-- 	cc.MoveBy:create(0.3, cc.p(0, - display.height * 0.12)),
	-- 	cc.Sequence:create(
	-- 		cc.DelayTime:create(0.3 - 0.07),
	-- 		cc.CallFunc:create(function()
	-- 			--self:_createShineEffect()
	-- 		end)
	-- 	),
	-- 	cc.Sequence:create(
	-- 		cc.DelayTime:create(0.3),
	-- 		cc.CallFunc:create(function()
	-- 			self:_showClick2Continue()
	-- 		end)
	-- 	)
	-- ))
	uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_TOUCH_AUTH_BEGIN, nil, false)
end

function RecruitingShowNormalMultyLayer:_getAwardPos(index)
	local factor = 853/display.height == 1 and 1 or 0.95  --如果是高分辨率，位置需要稍微往下一点
	local beginPos = {x = display.width * 0.2, y = display.height * 0.8 * factor}

	local xPos = beginPos.x + ((index - 1) % 4) * display.width * 0.2
	local yPos = beginPos.y - math.floor((index - 1) / 4) * 170
	return {x = xPos, y = yPos}
end

function RecruitingShowNormalMultyLayer:_showClick2Continue()
	local node = cc.CSLoader:createNode(G_Url:getCSB("CommonContinueNode", "common"))
    self._endEffectNode:addChild(node, 20)
    node:setPosition(display.cx,40)

    UpdateNodeHelper.updateCommonContinueNode(node, true)

    --点击屏幕关闭自己
    self:setTouchEnabled(true)
    self:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self:registerScriptTouchHandler(function (event)
    	if event == "began" then
    		return true 
    	elseif event == "ended" then
	    	self._onClose()
	    	self._onClose = nil
	    	--self:removeFromParent(true)
	    	return true
	    end
    end)
end

---获得描述文本以及位置
function RecruitingShowNormalMultyLayer:_getDescTxtAndPos()
	local txt = G_Lang.get("recruiting_money_desc", {num = self._coppor})
	local factor = display.height <= 853 and 1 or display.height/853 * 1.5
	local pos = cc.p(
		display.cx,
		display.height - display.height * 0.06 * factor
	)
	return txt, pos
end

function RecruitingShowNormalMultyLayer:onExit()
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_TOUCH_AUTH_END, nil, false)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1529)
	RecruitingShowNormalMultyLayer.super.onExit(self)
end

return RecruitingShowNormalMultyLayer