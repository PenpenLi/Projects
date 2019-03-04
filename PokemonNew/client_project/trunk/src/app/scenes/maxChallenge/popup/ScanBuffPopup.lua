--
-- Author:wyx
-- Date: 2018-01-30 11:33:54
--
--ScanBuffPopup.lua
--[====================[

   查看buff加成 弹框
    
]====================]

local ScanBuffPopup =  class("ScanBuffPopup",function()
    return cc.Node:create()
end)

local UpdateNodeHelper = require ("app.common.UpdateNodeHelper")
local UpdateButtonHelper = require ("app.common.UpdateButtonHelper")
local ScanBuffUnit = require("app.scenes.maxChallenge.popup.ScanBuffUnit")
--local FormationsDataManager = require("app.scenes.team.lineup.data.FormationsDataManager")
local EmenyFormationInfo = require("app.scenes.team.lineup.data.EmenyFormationInfo")

function ScanBuffPopup:ctor(isEnemy,dataManager,callback,knightId)
    self:enableNodeEvents()
    self._isEnemy = isEnemy
    self._callback = callback
    self._knightId = knightId or 0
    self._csbNode = nil
    self._dataList = {}
    self._dataManager = dataManager
    if not isEnemy then
        self._formationId = self._dataManager:getFormationIdByFunid(G_FunctionConst.FUNC_MAX_CHALLENGE)
    end
end

function ScanBuffPopup:onEnter()
    --uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_TEAM_GETFORMATION,self._getFormation,self)--
    
	self:_initUI()
	-- if not self._isEnemy then
	-- 	G_HandlersManager.teamHandler:sendGetFormation()
	-- else
	-- 	self:_initListView()
	-- end
    self:_initListView()
end

function ScanBuffPopup:onExit()
    self._dataList = {}
    uf_eventManager:removeListenerWithTarget(self)
    -- if self._csbNode ~= nil then
    --     self._csbNode:removeFromParent()
    --     self._csbNode = nil
    -- end
end

function ScanBuffPopup:_initUI( ... )
    self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("ScanBuffPopup","maxChallenge/popup"))
    self:addChild(self._csbNode)
    self._csbNode:setContentSize(display.width,display.height)
    self:setPosition(display.cx,display.cy)
    ccui.Helper:doLayout(self._csbNode)

    self._panelCon = self._csbNode:getSubNodeByName("Panel_list")

    --标题
    UpdateNodeHelper.updateCommonNormalPop(self._csbNode:getSubNodeByName("common_project"),G_Lang.get("max_challenge_buff_pop"),
    	function ()
    		self:removeFromParent()
    	end,500)
    
end

--获取到其他阵容数据  开始更新数据了
function ScanBuffPopup:_getFormation( data )
	-- self._dataManager = FormationsDataManager.new(data)

 --    self:_initListView()
end

function ScanBuffPopup:_initListView()
	local stageData = G_Me.maxChallengeData:getStageData()
    self._stageId = stageData:getStageId()

    local knight_info_ids,m_order,powers = G_Me.maxChallengeData:getEnemyTeamDataByStageId()
    local knightList = nil
    local orders = nil

	if not self._isEnemy then
        if self._formationId == 0 then--主阵容
            knightList =G_Me.teamData:getMyFormationIDList() or {}
            orders =G_Me.teamData:getMyFormationOrderList() or {}
        elseif self._formationId == -1 then--临时
            knightList =self._dataManager:getTempKnightData().indexs
            orders =self._dataManager:getTempKnightData().order
        else--非主阵容
            knightList =self._dataManager:getKnightIDs(self._formationId)
            orders =self._dataManager:getOrder(self._formationId)
        end

        self._dataList = {}
		local buffList = stageData:getKnightBuffs()
        for i=1,#knightList do
            local unit = nil
            for b=1,#buffList do
                if knightList[i] == buffList[b].id then
                    unit = buffList[b]
                end
            end
            self._dataList[i] = unit
            self._dataList[i].order = orders[i]
        end

        table.sort(self._dataList,function (a,b)
            local a_buffNum = #a.buffs
            local b_buffNum = #b.buffs
            return a_buffNum > b_buffNum
        end)
	else
		self._dataList = stageData:getMonsterBuffs()
        for i=1,#self._dataList do
            self._dataList[i].order = m_order[i]
        end
	end
    
    local size = self._panelCon:getContentSize()
    local scrollView = ccui.ScrollView:create()
    scrollView:setContentSize(size)
    scrollView:setTouchEnabled(true)
    scrollView:setScrollBarEnabled(false)
    scrollView:setBounceEnabled(true)
    self._panelCon:addChild(scrollView)

    -- 筛选有效数据
    local validList = {}
    for i=1,#self._dataList do
        if not self._isEnemy and self._dataList[i].id ~= 0 then
            table.insert(validList, self._dataList[i])
        elseif self._isEnemy and  self._dataList[i].cfg ~= nil then
            table.insert(validList, self._dataList[i])
        end
    end

    local itemNum = #validList
    -- local index = 0 -- 有效个数
    -- for i=1,itemNum do
    --     if not self._isEnemy and self._dataList[i].id ~= 0 then
    --         index = index + 1
    --     elseif self._isEnemy and  self._dataList[i].cfg ~= nil then
    --         index = index + 1
    --     end
    -- end
    local totalH = 155 * itemNum
    totalH = totalH < size.height and size.height or totalH
    scrollView:setInnerContainerSize(cc.size(size.width,totalH))

    --index = 0
    local index = nil
    for i=1,itemNum do
        local buffUnit = ScanBuffUnit.new(self._isEnemy)
        scrollView:addChild(buffUnit)
        buffUnit:setPosition(10,totalH - 155 * i)
        buffUnit:setData(validList[i],handler(self, self.updateBuff))

        if validList[i].id == self._knightId then
            index = i
        end
        -- if not self._isEnemy and validList[i].id ~= 0 then
        --     index = index + 1
        --     local buffUnit = ScanBuffUnit.new(self._isEnemy)
        --     scrollView:addChild(buffUnit)
        --     buffUnit:setPosition(10,totalH - 155 * index)
        --     buffUnit:setData(self._dataList[i],handler(self, self.updateBuff))
        -- elseif self._isEnemy and validList[i].cfg ~= nil then
        --     index = index + 1
        --     local buffUnit = ScanBuffUnit.new(self._isEnemy)
        --     scrollView:addChild(buffUnit)
        --     buffUnit:setPosition(10,totalH - 155 * index)
        --     buffUnit:setData(validList[i],handler(self, self.updateBuff))
        -- end
    end
    
    if index and index > 1 and index < itemNum then
        scrollView:scrollToPercentVertical((index - 1)/itemNum*100,0.1,true)
    elseif index and index == itemNum then
        scrollView:scrollToPercentVertical(100,0.1,true)
    end
end

function ScanBuffPopup:updateBuff(knightId,data)
	if self._isEnemy then
		return
	end
    dump(data)
    G_HandlersManager.maxChallengeHandler:sendChangeBuff(self._stageId,{{id = knightId,buff = {data.k_buffId},op = 2}},2)
    G_Me.maxChallengeData:deleteBuff(knightId,data)

    if self._callback then
        self._callback()
    end
end

return ScanBuffPopup