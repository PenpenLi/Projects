--
--[[
敌方阵容可能是玩家 和 是怪两种可能
例子1玩家
local CommonEnemyFormation = require("app.scenes.team.lineup.CommonEnemyFormation")
local SimpleFormationList = require("app.scenes.team.lineup.SimpleFormationList")
G_Popup.newPopup(function()
	local commonEnemyFormation = CommonEnemyFormation.new(SimpleFormationList.TYPE_PLAYER,G_FunctionConst.FUNC_ARENA,function( useTempTeam )
		print2("battle",useTempTeam)
    end)
	--10010001000039是怪物的id
	commonEnemyFormation:updateEnemyUserID(10010001000039)
    return commonEnemyFormation
end)
例子2怪
local CommonEnemyFormation = require("app.scenes.team.lineup.CommonEnemyFormation")
local SimpleFormationList = require("app.scenes.team.lineup.SimpleFormationList")
G_Popup.newPopup(function()
	local commonEnemyFormation = CommonEnemyFormation.new(SimpleFormationList.TYPE_ENEMY,G_FunctionConst.FUNC_ARENA,function( useTempTeam )
		G_HandlersManager.thirtyThreeHandler:sendExecuteTower(useTempTeam)
    end)
    --此处怪的数据需要自己从本地获取
	local monster_ids,orders,power = G_Me.thirtyThreeData:getEnemyTeamData(nowLayer,nowStage)
	commonEnemyFormation:updateEnemyData(monster_ids,orders,power)
    return commonEnemyFormation
end)
]]
--
-- 通用敌方阵容界面显示
local SimpleFormationList = require("app.scenes.team.lineup.SimpleFormationList")
local UpdateNodeHelper = require ("app.common.UpdateNodeHelper")
local UpdateButtonHelper = require ("app.common.UpdateButtonHelper")

local CommonEnemyFormation = class("CommonEnemyFormation",function()
	return cc.Layer:create()
end)

CommonEnemyFormation.TYPE_NORMAL_FORMATION = 1--非临时阵容
CommonEnemyFormation.TYPE_TEMP_FORMATION = 2--临时阵容
CommonEnemyFormation.TYPE_BOSS_FORMATION = 3--boss战入口
CommonEnemyFormation.TYPE_ARENA_FORMATION = 4--竞技场战入口
--[[
func_id --调用的模块id
enemy_user_id 敌方ID
totalPower 总战力
 当前阵容
callBack 选择完毕的回调
title 标题
bgType 出手背景
]]
function CommonEnemyFormation:ctor(enemyType,func_id,callBack,title,bgType)
	self:enableNodeEvents()
	self._enemyType = enemyType--敌人的类型
	self._func_id = func_id --调用的模块id
	self._callBack = callBack	--挑战后的回调
	self._title = title	--挑战后的回调
	self._bgType = bgType

	self._enemy_user_id =  nil 	--敌方ID

	self._simpleFormationList = nil--显示列表

	self._emenyInfo = nil--敌方信息

	self._csbNode = nil
	self._btnLineup = nil 		--布阵按钮
	self._btnChallenge = nil 	--挑战按钮
	self._btnClose = nil 		--关闭按钮
	self._txtFightCap = 0 		--战力文本

	self:_init()
end

function CommonEnemyFormation:onEnter()
	self:_addEvent()
end

function CommonEnemyFormation:_initCsb()
	-- csb界面处理
	if not self._csbNode then
		self._csbNode = cc.CSLoader:createNode("csb/team/lineup/CommonEnemyFormation.csb")
		self:addChild(self._csbNode)
	end
end

function CommonEnemyFormation:_init()
	self:_initCsb()

	self:setPosition(display.cx, display.cy)

	UpdateNodeHelper.updateCommonNormalPop(self._csbNode:getSubNodeByName("FileNode_com"),"布阵",function ( ... )
		self:close()
	end,602)

	self._btnClose = self._csbNode:getSubNodeByName("Button_close")
	self._btnLineup = self._csbNode:getSubNodeByName("Button_formation")
	self._btnChallenge = self._csbNode:getSubNodeByName("Button_battle")
	UpdateButtonHelper.reviseButton(self._btnChallenge,{isBig = true})

	if self._callBack == nil then
		self._btnChallenge:setVisible(false)
	end

	if self._title then
		self:updateLabel("Text_title", self._title) 
	end

	self._selfPowerNode = self._csbNode:getSubNodeByName("Node_zhanli_my")
	self._enemyPowerNode = self._csbNode:getSubNodeByName("Node_zhanli_enemy")
	self._listCon = self._csbNode:getSubNodeByName("Node_con")
	self._shapeNode = self._csbNode:getSubNodeByName("Node_knight")

    -- self:_addEvent()
end

function CommonEnemyFormation:_addEvent( ... )
	--self._btnClose:addClickEventListenerEx(handler(self, self.close))
	-- 布阵回调
	self._btnLineup:addClickEventListenerEx(handler(self, self._showLineUpPop))
	-- 挑战回调
	self._btnChallenge:addClickEventListenerEx(handler(self, self._clickChallenge))
	-- 网络回调
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_TEAM_GET_USER_FORMATION,self._getUserFormation,self)
end

--服务器返回敌方数据
function CommonEnemyFormation:_getUserFormation( emenyInfo )
	self._emenyInfo = emenyInfo
	self:_updateView()
end

-- 更新界面
function CommonEnemyFormation:_updateView(  )
	local gapW,gapH = 130,100
  	self._simpleFormationList = SimpleFormationList.new(self._enemyType,nil,nil,self._bgType)
  	self._simpleFormationList:setGapW(gapW,gapH)
  	self._simpleFormationList:iconSetScale(0.75)
  	self._simpleFormationList:setOrderOff(40)
    self._simpleFormationList:update(self._emenyInfo.knight_info_ids,self._emenyInfo.orders)
    self._simpleFormationList:setPosition(
    		- gapW,
    		SimpleFormationList.GAP_H/2
    	)
    self._simpleFormationList:addTo(self._listCon)

    self._selfPowerNode:updateLabel("Text_zhanli", tostring(G_Me.userData.power))
    self._enemyPowerNode:updateLabel("Text_zhanli", tostring(self._emenyInfo.power))
end

function CommonEnemyFormation:_creatEnemyInfo( knight_info_ids,orders, power)
	local EmenyFormationInfo = require("app.scenes.team.lineup.data.EmenyFormationInfo")
	local emenyInfo = EmenyFormationInfo.new(knight_info_ids,orders, power)
	return emenyInfo
end

function CommonEnemyFormation:updateEnemyTeamID( teamID )
	local MonsterTeamDataManager = require("app.scenes.team.lineup.data.MonsterTeamDataManager")
	local monster_ids,orders,power = MonsterTeamDataManager.getFormationData(teamID)
	self:updateEnemyData(monster_ids,orders,power)
end

function CommonEnemyFormation:updateEnemyUserID( user_id ,sid)
    self._enemy_user_id = user_id
    G_HandlersManager.teamHandler:sendGetUserDefFormation(user_id,sid)
end

function CommonEnemyFormation:updateEnemyData( knight_info_ids,orders, power )
	self._emenyInfo = self:_creatEnemyInfo(knight_info_ids,orders, power)
	self:_updateView()
end

--[[
param={
	knight_id = ,
	star = ,
	exclusive =,
	name = ,
	quality = ,
}
]]
function CommonEnemyFormation:updateEnemyInfo(param)
	assert(type(param) == "table","CommonEnemyFormation invalid param")

	local star = param.star or 0
	local exclusive = param.exclusive or 0

	local knight = require("app.common.KnightImg").new(param.knight_id,star,exclusive):addTo(self._shapeNode)
	knight:setScale(1)
	knight:setPosition(0,15)

	local color = G_TypeConverter.quality2Color(param.quality)
	if color == nil then
		return
	end
	self._csbNode:updateLabel("Text_enemy_title", {
		text = param.name,
		textColor = G_Colors.qualityColor2Color(color),
		--outlineColor = G_Colors.qualityColor2OutlineColor(color),
		})
end

function CommonEnemyFormation:onExit( ... )
	uf_eventManager:removeListenerWithTarget(self)
	-- if(self._csbNode ~= nil)then
	-- 	self._csbNode:removeFromParent(true)
	-- 	self._csbNode = nil
	-- end
end

function CommonEnemyFormation:_showLineUpPop( ... )
	G_Popup.newPopup(function()
		if not self._callBack then
			return require("app.scenes.team.lineup.CommonVsFormation").new(self._enemyType,self._func_id,self._emenyInfo,0)
		else
			return require("app.scenes.team.lineup.CommonVsFormation").new(self._enemyType,self._func_id,self._emenyInfo,0,function( ... )
	    		self._callBack(...)
				self:removeFromParent(true)
	    	end)
		end
    end)
end

--关闭
function CommonEnemyFormation:close( ... )
	self:removeFromParent(true)
end

-- 点击挑战
function CommonEnemyFormation:_clickChallenge( ... )
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,2203)
	self._callBack(nil,self)

	--self:removeFromParent(true)
end

return CommonEnemyFormation