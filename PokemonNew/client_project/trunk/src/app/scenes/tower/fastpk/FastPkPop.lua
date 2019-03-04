--
-- Author: YouName
-- Date: 2016-01-13 20:30:51
--
local FastPkPop=class("FastPkPop",function()
	return display.newNode()
end)

local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local AudioConst = require "app.const.AudioConst"

function FastPkPop:ctor(onClose)
	-- body
	self:enableNodeEvents()
	self._onClose = onClose
	self._csbNode = nil
	self._listView = nil
	self._nodeCtrl = nil
	self._btnClose = nil
	self._tempBoxAward = nil
	self._currStage = 1
	self._textOnProgress = nil
	self._buffs = nil
	self._minLevel = nil
	self._maxLevel = nil
	self._totalStar = 0
end

--UI界面初始化
function FastPkPop:_initUI( ... )
	-- body
	self:setPosition(display.cx, display.cy)
	self._csbNode = cc.CSLoader:createNode("csb/tower/FastPkPop.csb")
	self:addChild(self._csbNode)

	self._btnClose = self._csbNode:getSubNodeByName("Button_close")
	self._btnClose:addClickEventListener(handler(self, self._onButtonsClick))
	local title = self._csbNode:getSubNodeByName("Text_title")
	title:setString(G_LangScrap.get("lang_tower_3star_sweep"))
	--UpdateNodeHelper.updateCommonNormalPop(commonPop,G_LangScrap.get("lang_tower_3star_sweep"),handler(self,self._onButtonsClick))

	self._tips = self._csbNode:getSubNodeByName("Text_tips")
	self._tips:setVisible(false)
	
	local nodeCtrl = self._csbNode:getSubNodeByName("ProjectNode_ctrl")
	UpdateButtonHelper.updateBigButton(nodeCtrl,{
		desc = "",
		state = UpdateButtonHelper.STATE_NORMAL,
		callback = handler(self,self._onButtonsClick),
	})

	self._nodeCtrl = nodeCtrl

	self._textOnProgress = self._csbNode:getSubNodeByName("Text_on_progress")

	self._listView = self._csbNode:getSubNodeByName("ListView_list")
	self._listView:setScrollBarEnabled(false)

	local nowLayer = G_Me.thirtyThreeData:getNowLayer()
	--local strTitle = G_LangScrap.get("lang_tower_sweep_record")
	--self._csbNode:updateLabel("Text_title_desc", {text = "三星扫荡"})

	--发送快速扫荡请求
	self:_setButtonsVisible(false)
	self:performWithDelay(handler(self,self._fastExecuteTower), 0.25)
end

--点击底部按钮  关闭按钮
function FastPkPop:_onButtonsClick( ... )
	-- body
	if self._onClose ~= nil then
		self._onClose()
	end
	self:removeFromParent(true)
end

--设置按钮显示 隐藏
function FastPkPop:_setButtonsVisible( bool )
	-- body
	self._nodeCtrl:setVisible(bool)
	self._btnClose:setVisible(bool)
	self._textOnProgress:setVisible(not bool)
end

--发送三星扫荡数据请求
function FastPkPop:_fastExecuteTower( ... )
	local index = 3

	if self._pkLayer and self._pkLayer ~= G_Me.thirtyThreeData:getNowLayer() then -- 发现已经扫完本关
	else
		self._pkLayer = G_Me.thirtyThreeData:getNowLayer()
	end

	for i=1,3 do
		dump(self._pkLayer)
		local stageData = G_Me.thirtyThreeData:getStageData(self._pkLayer,i)
		dump(stageData)
		local star = G_Me.thirtyThreeData:getStageStar(stageData.id)
		dump(star)
		if star < 3 then
			index = i
			break
		end
	end
	dump(index)
	--self._pkStage = G_Me.thirtyThreeData:getNowStage()
	self._pkStage = index
	self:performWithDelay(function()
		G_HandlersManager.thirtyThreeHandler:sendFastExecuteTower()
	end, 0.15)
end

--收到快速挑战数据
function FastPkPop:_onFastExecuteTower( dataValue )
    G_AudioManager:playSoundById(AudioConst.SOUND_BATTLE_DROP)
	-- required uint32 ret = 1;
	-- optional uint32 now_layer = 2;//下一次可打的层数
	-- optional uint32 now_stage = 3;//下一次可打的关卡
	-- optional uint32 money = 4;  //奖励的白银
	-- optional uint32 star = 5; //此次战斗获得的星数
	-- optional uint32 now_star = 6; //当前最大星数
	-- optional uint32 tower_resource = 7;//奖励的玉石
	-- //repeated Award  pass_awards = 8;	 //关卡宝箱奖励
	-- //repeated uint32 buffs = 9; //三个可选buff
	-- //repeated Award	total_award = 10; //累积奖励
	-- optional Tower tower = 11; //通关显示
	-- repeated AddAward add_awards = 12; //暴击奖励
    
    local now_stage = rawget(dataValue, "now_stage")
    local now_layer = rawget(dataValue, "now_layer")
    local totalAward = rawget(dataValue, "total_award")
    local buffs = rawget(dataValue, "buffs")
    local boxAwards = rawget(dataValue, "box_awards")
    local towerData = rawget(dataValue, "tower")
    local money = rawget(dataValue, "money")
    local towerResource = rawget(dataValue, "tower_resource")
    -- local addAwards = rawget(dataValue,"pass_awards")
    local star = rawget(dataValue,"star")
    local awards = rawget(dataValue,"awards")
    self._currStage = stage
    self._tempBoxAward = nil

    local pkType = 0
    local cell = nil
    local widget = ccui.Widget:create()

	--G_AudioManager:playSoundById(9044)
	--怪物
	pkType = 1
    cell = require("app.scenes.tower.fastpk.FastPkCell1").new(self._pkLayer,self._pkStage,money,towerResource,awards)
    widget:addChild(cell)
    widget:setContentSize(527,170)

    --取出最小跟最大关
    local stageData = G_Me.thirtyThreeData:getStageData(now_layer, now_stage)
    self._minLevel = self._minLevel ~= nil and
     math.min(stageData.level,self._minLevel) or
     stageData.level

    self._maxLevel = self._maxLevel ~= nil and
     math.max(stageData.level,self._maxLevel) or
     stageData.level

    self._totalStar = self._totalStar + star

    self._listView:pushBackCustomItem(widget)
    self._listView:refreshView()
    self._listView:scrollToBottom(0.1,true)

	local isOver = G_Me.thirtyThreeData:isOver()
	dump(self._pkStage)
	dump(isOver)

	-- 判断是否全3星了
	local index = 4
	for i=1,3 do
		--dump(self._pkLayer)
		local stageData = G_Me.thirtyThreeData:getStageData(self._pkLayer,i)
		--dump(stageData)
		local star = G_Me.thirtyThreeData:getStageStar(stageData.id)
		--dump(star)
		if star < 3 then
			index = i
			break
		end
	end
	dump(index)

    if((self._pkStage < 3 and index ~= 4) and not isOver)then
	    self:_fastExecuteTower()
    else
    	UpdateButtonHelper.updateBigButton(self._nodeCtrl,{
			desc = G_LangScrap.get("lang_tower_sweep_finish"),
		})                                                                                                                                                                                                                                                                                                  
		self:_setButtonsVisible(true)

		local tips = G_Lang.get("tower_fast_pk_tips",
			{startLevel=self._minLevel-1,endLevel=self._maxLevel-1,star = self._totalStar}
		),
		self._tips:setVisible(true)
		self._tips:setString(tips)
    end
end

function FastPkPop:onEnter( ... )
	-- body
	self:_initUI()
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MT_FAST_EXECUTE_TOWER,self._onFastExecuteTower,self)
end

function FastPkPop:onExit( ... )
	-- body
	if(self._csbNode ~= nil)then
		self._csbNode:removeFromParent(true)
		self._csbNode = nil
	end
	uf_eventManager:removeListenerWithTarget(self)
end

return FastPkPop