--
-- Author: suNSun
-- Date: 2017-06-12 18:38:48
--
-- 升星结果界面
local HeroTokenUpQualityLayer=class("HeroTokenUpQualityLayer",function()
	return cc.Layer:create()
end)

local TeamUIHelper = require("app.scenes.team.TeamUIHelper")

function HeroTokenUpQualityLayer:ctor()
	self:enableNodeEvents()
	self._csbNode = nil
	--self._knightId = knightId
end

-- 初始化UI
function HeroTokenUpQualityLayer:_initUI( ... )
	-- 解析csb
	self._csbNode = cc.CSLoader:createNode("csb/userBible/HeroTokenUpQualityLayer.csb")
	self:addChild(self._csbNode)
	self._csbNode:setContentSize(display.width,display.height)
	ccui.Helper:doLayout(self._csbNode)
	G_WidgetTools.autoTransformBg(self._csbNode:getSubNodeByName("Image_109"))
	
	self._Panel_touch_swallow = self._csbNode:getSubNodeByName("Panel_touch_swallow")

	self:_updateView()
end

-- 刷新界面数据
function HeroTokenUpQualityLayer:_updateView()
	-- 武将形象刷新
	local knightData = G_Me.teamData:getKnightDataByPos(1)
	--local currRankData = knightData.cfgRankData
	local spineLayout = self._csbNode:getSubNodeByName("Layout_spine")
	local spine = require("app.common.KnightImg").new(knightData.serverData.knightId,knightData.serverData.starLevel,0)
	spine:setScale(1.5)
	spine:showShaddow(false)
	spine:setLocalZOrder(100)
	spineLayout:addChild(spine)

	-- 品质记录
	local param = {[8] =5,[10] =8,[13] =10,[15] =13,[18] =15}
	local nextParam = {[5] =8,[8] =10,[10] =13,[13] =15,[15] =18}

	-- 武将名字刷新
	local starLevel = knightData.serverData.starLevel
	local knightLevel = knightData.serverData.level
    TeamUIHelper.updateNodeStar(self._csbNode:getSubNodeByName("projectNode_star"),starLevel)
	local nodeKnightName = self._csbNode:getSubNodeByName("ProjectNode_knight_name")
	TeamUIHelper.updateNodeKnightName(nodeKnightName,knightData,nil,false)

	self._csbNode:updateLabel("Text_knight_name_last", {
		text=G_Me.userData.name,
		textColor = G_Colors.qualityColor2Color(G_TypeConverter.quality2Color(param[knightData.cfgData.quality]),true),
		outlineColor = G_Colors.qualityColor2OutlineColor(G_TypeConverter.quality2Color(param[knightData.cfgData.quality])),
		outlineSize = 2,
		})
	
	-- 属性刷新
	dump(knightData.cfgData.quality)
	local oldQualityInfo = require("app.cfg.knight_star_info").get(knightData.cfgData.job,param[knightData.cfgData.quality],starLevel)
	local newQualityInfo = require("app.cfg.knight_star_info").get(knightData.cfgData.job,knightData.cfgData.quality,starLevel)
	------------------- 基础属性
	local numBaseHp = newQualityInfo.base_hp
	local numBaseAtk = newQualityInfo.base_attack
	local numBaseDef = newQualityInfo.base_defense
	local numDevelopHp = newQualityInfo.develop_hp * (knightLevel - 1)
	local numDevelopAtk = newQualityInfo.develop_attack * (knightLevel - 1)
	local numDevelopDef = newQualityInfo.develop_defense * (knightLevel - 1)

	local curr = {}
	curr[1] = numBaseHp + numDevelopHp
	curr[2] = numBaseAtk + numDevelopAtk
	curr[3] = numBaseDef + numDevelopDef

	local numBaseHp = oldQualityInfo.base_hp
	local numBaseAtk = oldQualityInfo.base_attack
	local numBaseDef = oldQualityInfo.base_defense
	local numDevelopHp = oldQualityInfo.develop_hp * (knightLevel - 1)
	local numDevelopAtk = oldQualityInfo.develop_attack * (knightLevel - 1)
	local numDevelopDef = oldQualityInfo.develop_defense * (knightLevel - 1)

	local currOld = {}
	currOld[1] = numBaseHp + numDevelopHp
	currOld[2] = numBaseAtk + numDevelopAtk
	currOld[3] = numBaseDef + numDevelopDef

	-- 控件渲染
	for i = 1,3 do
		--self._csbNode:updateLabel("Text_old_attr"..i, {text = G_Lang.get("common_text_attr"..i,{num = currOld[i]})})
		self._csbNode:updateLabel("Text_old_attr"..i, {text =  currOld[i]})
		--self._csbNode:updateLabel("Text_new_attr"..i, {text = G_Lang.get("common_text_attr"..i,{num = curr[i]})})
		self._csbNode:updateLabel("Text_new_attr"..i, {text = curr[i]})
		self._csbNode:updateLabel("Text_attr_dif"..i, {text = "+" .. tostring(curr[i] - currOld[i])})
	end

	-- 播放特效
	--TeamUtils.playEffect("effect_ui_shengxing",{x=0,y=0},self._csbNode:getSubNodeByName("Layout_spine"),"finish",function()end)
  	local action = cc.CSLoader:createTimeline(G_Url:getCSB("renwushengxing","card/ani"))
    local boomNode = cc.CSLoader:createNode(G_Url:getCSB("renwushengxing","card/ani"))
  	boomNode:runAction(action)
  	boomNode:setLocalZOrder(0)
    action:gotoFrameAndPlay(0,false)
    spineLayout:addChild(boomNode)

	self:playEffect()
end

-- 播放特效
function HeroTokenUpQualityLayer:playEffect( ... )
		-- 初始化状态
	self._Image_title_upstar = self._csbNode:getSubNodeByName("Image_title_upquality")
	self._Node_bottom = self._csbNode:getSubNodeByName("Node_bottom")
	self._Node_top = self._csbNode:getSubNodeByName("Node_top")
	self._Node_bottom:setVisible(false)
	self._Node_top:setVisible(false) 

	-- 显示元素
    local showOther = function ()
		self._Node_bottom:setVisible(true)
		self._Node_top:setVisible(true)

		-- 标题缩放
		self._Image_title_upstar:setScale(1.25)
    	self._Image_title_upstar:runAction(cc.Sequence:create(cc.ScaleTo:create(0.2, 0.5),
        cc.ScaleTo:create(0.3, 0.75)))

        -- 属性飘过特效
    	local Node_left_attr1 = self._csbNode:getSubNodeByName("Node_left_attr1")
    	local Node_left_attr2 = self._csbNode:getSubNodeByName("Node_left_attr2")
    	local Node_left_attr3 = self._csbNode:getSubNodeByName("Node_left_attr3")
    	local Node_right_attr1 = self._csbNode:getSubNodeByName("Node_right_attr1")
    	local Node_right_attr2 = self._csbNode:getSubNodeByName("Node_right_attr2")
    	local Node_right_attr3 = self._csbNode:getSubNodeByName("Node_right_attr3")

	 	Node_left_attr1:setPositionX(-410)
	    self:_runMoveAction(Node_left_attr1, 10, {-20,0},{3,3},{1.5,1})
	    Node_left_attr2:setPositionX(-410)
	    self:_runMoveAction(Node_left_attr2, 15, {-20,0},{3,3},{1.5,1})
	    Node_left_attr3:setPositionX(-410)
	    self:_runMoveAction(Node_left_attr3, 20, {-20,0},{3,3},{1.5,1})

	    Node_right_attr1:setPositionX(-410)
	    self:_runMoveAction(Node_right_attr1, 30, {-20,0},{3,3},{1.5,1})
	    Node_right_attr2:setPositionX(-410)
	    self:_runMoveAction(Node_right_attr2, 35, {-20,0},{3,3},{1.5,1})
	    Node_right_attr3:setPositionX(-410)
	    self:_runMoveAction(Node_right_attr3, 40, {-20,0},{3,3},{1.5,1})

	      -- 屏幕触摸
		self:performWithDelay(function ( ... )
			self._Panel_touch_swallow:setTouchEnabled(false)
		end, 1)
	end
    self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(showOther)))
end

function HeroTokenUpQualityLayer:_runMoveAction( node, delay, moveXList, durationList, scaleList )
    local actionList = {}
    local totalDuration = 0
    local FrameDuration = 0.03
    if delay and delay > 0 then
        table.insert(actionList,cc.DelayTime:create(delay * FrameDuration))
    end
    for i=1,#moveXList do
        local duration = durationList[i] * FrameDuration or 0.1 
        local moveX = moveXList[i]
        local moveY = node:getPositionY()
        local scale = scaleList[i] or 1
        local move = cc.MoveTo:create(duration, cc.p(moveX, moveY))
        local scaleAction = cc.ScaleTo:create(duration, scale, 1)
        table.insert(actionList,cc.Spawn:create(move,scaleAction))
        totalDuration = totalDuration + duration
    end

    node:setOpacity(0)
    node:runAction(cc.Spawn:create(cc.Sequence:create(actionList), cc.Sequence:create(cc.DelayTime:create(delay * FrameDuration),cc.FadeIn:create(totalDuration))))
end

function HeroTokenUpQualityLayer:onEnter( ... )
	self:_initUI()
end

function HeroTokenUpQualityLayer:onExit( ... )
end

return HeroTokenUpQualityLayer
