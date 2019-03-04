--
-- Author: yutou
-- Date: 2018-09-18 20:36:15
--

local MineLayerui=class("MineLayerui",function()
	return cc.Layer:create()
end)
local Parameter_info = require("app.cfg.parameter_info")
local MineBattleReportPopup = require("app.scenes.mine.MineBattleReportPopup")
local LineUpPop = require("app.scenes.team.lineup.LineUpPop")
local ConfirmAlert = require("app.common.ConfirmAlert")
local MinePlayerData = require("app.scenes.mine.data.MinePlayerData")
local ShopCommonFixedLayer =  require("app.scenes.shopCommon.ShopCommonFixedLayer")

function MineLayerui:ctor(mineLayer)
	self._mineLayer = mineLayer
	self._data = G_Me.mineData
	self._myCityData = G_Me.mineData:getMyCityData()
	self._tabIndex = 1
	self:enableNodeEvents()
	self:init()
end

function MineLayerui:init()
	-- 排版
	self._csbNode = cc.CSLoader:createNode("csb/mine/MineLayerui.csb")
	self:addChild(self._csbNode)
	self._csbNode:setContentSize(display.width,display.height)
	ccui.Helper:doLayout(self._csbNode)

    G_CommonUIHelper.FixBackNode(self._csbNode:getSubNodeByName("Node_back"))

    self._csbNode:getSubNodeByName("Button_back"):addClickEventListenerEx(function( ... )
    	G_ModuleDirector:popModule()
    end)
    self._btn_help = self._csbNode:getSubNodeByName("Button_help")

    self._btn_help:addClickEventListenerEx(function( ... )
        G_Popup.newHelpPopup(G_FunctionConst.FUNC_MINE)
    end)
    -----------------------------------------
    local listviewBg = self:getSubNodeByName("Panel_tabs")
    local listViewSize = listviewBg:getContentSize()
    self._btnListView = require("app.ui.WListView").new(listViewSize.width,listViewSize.height, 62, 70, false)
    self._btnListView:setCreateCell(function(view,idx)
        local cell = require("app.scenes.mine.MineTabCell").new(handler(self, self._onClickButton))
        return cell
    end)
    self._btnListView:setTouchCellCallback(handler(self, self._onClickCell))
    self._btnListView:setUpdateCell(function(view,cell,idx)
        cell:updateData(idx)
    end)
    listviewBg:addChild(self._btnListView)
	self._pageNum = tonumber(Parameter_info.get(584).content)
    self._btnListView:setCellNums(self._pageNum, true)

    self._button_left = self:getSubNodeByName("Button_left")
    self._button_right = self:getSubNodeByName("Button_right")
    self._button_left:addClickEventListenerEx(function(  )
    	if self._tabIndex > 1 then
    		self:jumpToPage(self._tabIndex - 1)
    	end
    end)
    self._button_right:addClickEventListenerEx(function(  )
    	if self._tabIndex < self._pageNum then
    		self:jumpToPage(self._tabIndex + 1)
    	end
    end)
    ----------------------------------------------------
    self._button_more = self:getSubNodeByName("Button_more")
    self._node_more = self:getSubNodeByName("Node_more")
    self._Panel_touch = self:getSubNodeByName("Panel_touch")
    self._button_look_mine = self:getSubNodeByName("Button_look_mine")
    self._button_look_worker = self:getSubNodeByName("Button_look_worker")
    self._button_look_lover = self:getSubNodeByName("Button_look_lover")
    self._sprite_9 = self:getSubNodeByName("Sprite_9")
    self._imageShopRed = self:getSubNodeByName("Image_red_dot")

    self._button_look_mine:addClickEventListenerEx(function( ... )
    	G_HandlersManager.mineHandler:sendSearchJob(1)
    end)
    self._button_look_worker:addClickEventListenerEx(function( ... )
    	G_HandlersManager.mineHandler:sendSearchJob(2)
    end)
    self._button_look_lover:addClickEventListenerEx(function( ... )
        if self._data:getMyCityData():getMyPos() == MinePlayerData.JOB_LOVER then
            G_Popup.tip("已在情侣矿场")
        else
            G_HandlersManager.mineHandler:sendSearchJob(3)
        end
    end)

    self._button_more:setScaleY(1)
    self._node_more:setVisible(false)
    self._button_more:addClickEventListenerEx(function( ... )
    	self._button_more:setScaleY(self._button_more:getScaleY()*-1)
    	if self._button_more:getScaleY() == 1 then
    		self._node_more:setVisible(false)
            self._Panel_touch:setVisible(false)
    	else
    		self._node_more:setVisible(true)
            self._Panel_touch:setVisible(true)
    	end
        -- G_HandlersManager.mineHandler:sendRefreshOne(self._myCityData:getID())
    end)
    self._Panel_touch:addTouchEventListener(function( ... )
        self._node_more:setVisible(false)
        self._Panel_touch:setVisible(false)
        self._button_more:setScaleY(1)
    end)
    ----------------------------------------------------
    self._button_my_city = self:getSubNodeByName("Button_my_city")
    self._text_mycity_name = self:getSubNodeByName("Text_mycity_name")
    self._text_source = self:getSubNodeByName("Text_source")
    self._text_add = self:getSubNodeByName("Text_add")
    self._node_add = self:getSubNodeByName("Node_add")


    self._button_time = self:getSubNodeByName("Button_time")
    self._text_has_city = self:getSubNodeByName("Text_has_city")
    self._text_left_time = self:getSubNodeByName("Text_left_time")
    self._text_time = self:getSubNodeByName("Text_time")
    self._text_get_type = self:getSubNodeByName("Text_get_type")
	
    self._button_my_city:addClickEventListenerEx(function( ... )
    	if self._myCityData:hasData() then
    		if self._myCityData:getIndex() == self._data:getNowIndex() then

    		else
    			self:jumpToPage( self._myCityData:getIndex() )
    		end
            -- local pureData = self._data:getCityDataByID(self._myCityData:getID())
            G_Popup.newPopup(function()
                local MineCityInfoPopup = require("app.scenes.mine.MineCityInfoPopup")
                return MineCityInfoPopup.new(self._myCityData:getID())
            end)
    	else
    		G_Popup.tip("未占领矿场")
    	end
    end)

    self._button_time:addClickEventListenerEx(function( ... )
        local confirmAlert = ConfirmAlert.createConfirmText(
            G_Lang.get("common_title_tip"),
            G_Lang.get("mine_get_tips",{num = tonumber(Parameter_info.get(582).content) / 1000 * 100 }),
            function()
                
            end,nil,false
        )
        local confirmTextCon = confirmAlert:getSubNodeByName("ConfirmTextCon")
        confirmTextCon:setMaxLineWidth(450)
        confirmTextCon:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
    end)

    ----------------------------------------------------
    self._button_report = self:getSubNodeByName("Button_report")
    self._button_report_Red = self:getSubNodeByName("Button_report_Red")
    self._button_report_Red:setVisible(false)

    self._button_report:addClickEventListenerEx(function( ... )
		-- G_HandlersManager.mineHandler:sendReportList()
        G_HandlersManager.commonHandler:sendGetCommonReportList(3)
    end)
    -- self._button_report:setVisible(false)
    ----------------------------------------------------


    --布阵按钮
    local btnTeamAttack = self._csbNode:getSubNodeByName("Button_team_attack")
    local btnTeamDefence = self._csbNode:getSubNodeByName("Button_team_defence")
    btnTeamAttack:addClickEventListenerEx(handler(self,self._btnTeamAttackCallBack))
    btnTeamDefence:addClickEventListenerEx(handler(self,self._btnTeamDefenceCallBack))
    ----------------------------------------------------
    self._button_shop = self:getSubNodeByName("Button_shop")
    self._button_shop:addClickEventListenerEx(function(  )
        --商城按钮
        G_ModuleDirector:pushModule(nil, function()
           return require("app.scenes.shopCommon.ShopCommonScene").new(ShopCommonFixedLayer.TAB_MIJING)
        end)
    end)
    ----------------------------------------------------

    ----------------------------------------------------
    self:render()
    self._updateStartTime = G_ServerTime:getTime()
    self:onUpdate(handler(self, self._update))

    self:_onShopRedPointUpdate()
end

--商店相关红点 更新
function MineLayerui:_onShopRedPointUpdate()
        self._imageShopRed:setVisible(false)
    --local isShowRedPoint = G_Me.redPointData:isMineShopShowRed()
    --if(self._imageShopRed ~= nil)then
    --    self._imageShopRed:setVisible(isShowRedPoint)
    --end
end

function MineLayerui:_btnTeamAttackCallBack( sender )
    G_Popup.newPopup(function()
        return LineUpPop.new(LineUpPop.TYPE_TEAM_ATTACK,nil,G_FunctionConst.FUNC_MINE)
    end)
end

function MineLayerui:_btnTeamDefenceCallBack( sender )
    G_Popup.newPopup(function()
        return LineUpPop.new(LineUpPop.TYPE_TEAM_DEFENCE,nil,G_FunctionConst.FUNC_MINE)
    end)
end

function MineLayerui:render()
    if self._isAttacking then
        return
    end
    -- print("renderrenderrenderrender",self._myCityData:getID())
    if self._myCityData:hasData() and self._myCityData:isInCity() then
    	self._text_has_city:setString("已占领")
    	self._text_mycity_name:setString(self._myCityData:getCityName())
        self._text_left_time:setVisible(true)
    else
    	self._text_has_city:setString("未占领")
    	self._text_mycity_name:setString("无")
        self._text_left_time:setVisible(false)
    end

    if self._myCityData:getMyPlayerData() then
        self._text_source:setString(self._myCityData:getMyPlayerData():getGeted())
    else
        self._text_source:setString("0")
    end
    self._sprite_9:setPositionX(self._text_source:getPositionX() - self._text_source:getContentSize().width - 22)

    self._node_add:setVisible(self._data:getPowerAdd() ~= 0)
    self._text_add:setString("+" .. self._data:getPowerAdd() .. "%")
end

function MineLayerui:_update()
    self._myCityData = G_Me.mineData:getMyCityData()

    if self._myCityData == nil then
        return
    end
    -- local updateTime = G_ServerTime:getTime() - self._updateStartTime
    -- if updateTime%30 == 0 and self._updatedTime ~= updateTime then
    --     print("MineLayerui:_updateMineLayerui:_updateMineLayerui:_update")
    --     self._myCityData:refreshGeted()
    --     self._data:refreshGeted()
    --     self._updatedTime = updateTime
    -- end

    if self._myCityData:hasData() then
		self._text_left_time:setString(G_ServerTime:getLeftSecondsString(self._myCityData:getOverTime()))
        self._text_source:setString(self._myCityData:getMyPlayerData():getGeted())
        self._sprite_9:setPositionX(self._text_source:getPositionX() - self._text_source:getContentSize().width - 22)

        if G_ServerTime:getLeftSeconds(self._myCityData:getOverTime()) < 0 and G_HandlersManager.mineHandler.lockRefreshOne ~= true then
            -- G_HandlersManager.mineHandler:sendRefreshOne(self._myCityData:getID())
        end
    end

    self._text_time:setString(G_ServerTime:getTimeString2())

    if self._data:isLittleTime() then
    	self._text_get_type:setString("低效收益")
        self._text_get_type:setTextColor(G_Colors.getColor(4))
        self._text_get_type:enableOutline(G_Colors.getOutlineColor(9))
    else
    	self._text_get_type:setString("正常收益")
        self._text_get_type:setTextColor(G_Colors.getColor(13))
        self._text_get_type:enableOutline(G_Colors.getOutlineColor(13))
    end
end

function MineLayerui:_onClickCell(cell)
	local index = cell:getIdx() + 1
	if index == self._clickBtnIndex then
		self:jumpToPage( index )
	end
	self._clickBtnIndex = nil
end

function MineLayerui:jumpToPage( index )
	self._data:setNowIndex(index)
	if self._tabIndex ~= index then
		self._tabIndex = index
		-- self._data:setNowIndex(index)
		self._mineLayer:render()
		self._mineLayer:getPageView():setCurPageIndex(index - 1)
		self:renderBtnList()
	end
end

function MineLayerui:renderBtnList()
    self._tabIndex = self._data:getNowIndex()
	self._btnListView:updateCellNums(self._pageNum)
	self._btnListView:setLocation(self._tabIndex - 1)

    self._button_left:setVisible(self._tabIndex ~= 1)
    self._button_right:setVisible(self._tabIndex ~= self._pageNum)
    self._data:removeDataOut()
end

function MineLayerui:_onClickButton(index)
	self._clickBtnIndex = index
end

function MineLayerui:onEnter()
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_GET_COMMON_REPORT_LIST,self._showBattleReport,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_ATTACK,self.attacking,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_ATTACK_OVER,self.attackover,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_REFRESH_ONE,self.render,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_APPLY_JOB,self.render,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_QUIT,self.render,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_SHOP_RED_POINT_UPDATE,self._onShopRedPointUpdate,self)
end

function MineLayerui:attacking()
    self._isAttacking = true
end

function MineLayerui:attackover()
    self._isAttacking = false
    self:render()
end

function MineLayerui:_showBattleReport(data)
    if data.mine_reports then
        G_Me.mineData:setBattleList(data.mine_reports)
        G_Popup.newPopup(function()
            return MineBattleReportPopup.new(data.mine_reports)
        end)
    end
end

function MineLayerui:onExit()
	uf_eventManager:removeListenerWithTarget(self)
end

function MineLayerui:onCleanup()
	self:removeAllChildren()
end

return MineLayerui