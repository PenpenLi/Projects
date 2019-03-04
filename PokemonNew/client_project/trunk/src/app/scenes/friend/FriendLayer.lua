
--================
--好友面板
local FriendLayer = class("FriendLayer", function ( )
	return display.newLayer()
end)

local RoleInfo = require("app.cfg.role_info")
local FriendTabApplyListLayout = require "app.scenes.friend.FriendTabApplyListLayout"
local FriendTabBlackListLayout = require "app.scenes.friend.FriendTabBlackListLayout"
local FriendTabLoversLayout = require "app.scenes.friend.FriendTabLoversLayout"
local FriendTabListLayout = require "app.scenes.friend.FriendTabListLayout"
local FriendTabPresentLayout = require "app.scenes.friend.FriendTabPresentLayout"
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local FriendAddLayer = require "app.scenes.friend.FriendAddLayer"
local FriendRecommandLayer = require "app.scenes.friend.FriendRecommandLayer"
local FriendLoversPopup = require("app.scenes.friend.FriendLoversPopup")
local FriendLoversRespondPop = require("app.scenes.friend.FriendLoversRespondPop")

---好友列表的四个页签。
FriendLayer.TAB_FRIEND = 1
--FriendLayer.TAB_PRESENT = 2
FriendLayer.TAB_APPLY = 2
FriendLayer.TAB_LOVERS = 3 -- 情侣
FriendLayer.TAB_BLACK = 4

--======
--@initIndex 初始化的页签值
function FriendLayer:ctor(initIndex)
	--self._initIndex = initIndex or FriendLayer.TAB_FRIEND
	self._view = nil
	self._longListCon = nil
	self._shortListCon = nil
	self._listFriend = nil --好友列表
	self._listPresent = nil --领取礼物
	self._listApply = nil --好友请求
	self._listBlack = nil --黑名单
	self._listLovers = nil --情侣
	self._currentIndex = FriendLayer.TAB_FRIEND --当前页签下标
	self._isInited = false
	self._presentBottomNode = nil
	self._friendBottomNode = nil
	self._buttonAddFriend = nil --添加好友按钮
	self._buttonRecommandFriend = nil --推荐好友
	self._buttonGetAllPresent = nil --一键领取

	self._FileNode_auto = nil -- 自动匹配按钮
	self._FileNode_manual = nil -- 手动寻找按钮
	self._loversNode = nil -- 情侣相关控件
	self._isLoversOpen = false -- 情侣功能是否开启

	self._oneKeyNeedSendNum = 0
	self._oneKeySentNum = 0

	self._viewArr = {} --用于保存所有已经创建的列表对象
	self._queueTimer = nil
	self:enableNodeEvents()
end

function FriendLayer:onEnter()
	self._isLoversOpen = G_Responder.funcIsOpened(G_FunctionConst.FUNC_LOVERS)
	
	self:_initUI()
	
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_FRIEND_GET_LIST, self._onFreshList, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_FRIEND_GET_REQUEST_LIST, self._onInitFriendRequstList, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_FRIEND_UPDATE_FRIEND, self._onFreshList, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_FRIEND_PRESENT_GET_STATE, self._onUpdateFriendGetPresentState, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_FRIEND_PRESENT_SENDED_STATE, self._updateFriendSendPresentState, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_FRIEND_UPDATE_REQUEST_LIST, self._onUpdateFriendRequstList, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_FRIEND_BLACK_LIST_UPDATE, self._onBlackListChanged, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RED_POINT_UPDATE, self._onRedPointUpdate, self)
   
    -- 情侣
   	--uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_LOVERS_RESPOND_GET_LIST, self._onGotoRespond, self)
   	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_LOVERS_GET_DATA, self._onGetLoversData, self)
   	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_LOVERS_APPLY_MATCH, self._onGetLoversData, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_LOVERS_REFRESH_QUEUE, self._refreshQueue, self)
   	--uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_LOVERS_MATCH_RESULT, self._onMatchResult, self)

    --uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_FRIEND_GET_LIST, self._onFreshList, self)

    ---向服务器请求数据
    if self._isLoversOpen then G_HandlersManager.friendHandler:sendGetLoversData() end -- 获取情侣信息
    G_HandlersManager.friendHandler:sendGetFriendList()
    G_HandlersManager.friendHandler:sendGetFriendReqList()
end

function FriendLayer:onExit()
	self:_removeTimer()
	uf_eventManager:removeListenerWithTarget(self)
end

function FriendLayer:_initUI()
	self._view = cc.CSLoader:createNode(G_Url:getCSB("FriendLayer", "friend"))
    self:addChild(self._view)
    
    local panelHolder = self._view:getSubNodeByName("Panel_holder")
    panelHolder:setContentSize(display.width, display.height)
    ccui.Helper:doLayout(panelHolder)

    local nodeBack = self._view:getSubNodeByName("back_node")
    G_CommonUIHelper.FixBackNode(nodeBack)
    local btnBack = nodeBack:getSubNodeByName("Button_back")
    btnBack:addClickEventListenerEx(function(sender)
        G_ModuleDirector:popModule()
    end)

    --列表有两种高度的尺寸，这里先记录下来。
    self._longListCon = self._view:getSubNodeByName("Panel_list_long")
    self._shortListCon = self._view:getSubNodeByName("Panel_list_short")

    self._friendBottomNode = self._view:getSubNodeByName("Node_friend_list_bottom")
    self._presentBottomNode = self._view:getSubNodeByName("Node_present_bottom")
    self._loversNode = self._view:getSubNodeByName("Node_lovers")
    self._Node_to_match = self._view:getSubNodeByName("Node_to_match")
    self._Node_cancel_match = self._view:getSubNodeByName("Node_cancel_match")
    self._Text_wait_num = self._view:getSubNodeByName("Text_wait_num")
    self._loversNode:setVisible(false)
    self._bottomNode = self._view:getSubNodeByName("Node_bottom")
    self._bottomNode:setVisible(false)
    -- self._view:updateLabel("Text_other_desc", {
    -- 	text = G_LangScrap.get("friend_num_limit_tip"),
    -- 	outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE
    -- })

	local tabs = {}
	tabs[FriendLayer.TAB_FRIEND] = {
		text = G_Lang.get("friend_tab_title1")
	}
	-- tabs[FriendLayer.TAB_PRESENT] = {
	-- 	text = G_LangScrap.get("friend_tab_present")
	-- }
	tabs[FriendLayer.TAB_APPLY] = {
		text = G_Lang.get("friend_tab_title2")
	}
	tabs[FriendLayer.TAB_LOVERS] = {
		text = G_Lang.get("friend_tab_title3")
	}
	tabs[FriendLayer.TAB_BLACK] = {
		text = G_Lang.get("friend_tab_title4")
	}
	-- if self._initIndex == nil then
	-- 	--根据红点选择跳转的
	-- 	local presentHasRedPoint = G_Me.redPointData:isFriendGiftShowRed()
	--     local applyHasRedPoint = G_Me.redPointData:isFriendReqShowRed()

	--     if presentHasRedPoint then
	--     	self._initIndex = FriendLayer.TAB_PRESENT
	--     elseif applyHasRedPoint then
	--     	self._initIndex = FriendLayer.TAB_APPLY
	--     end

	--     self._initIndex = self._initIndex ~= nil and self._initIndex or FriendLayer.TAB_FRIEND
	-- end
		-- 功能开启状态判断
	if(self._isLoversOpen == false)then
		tabs[FriendLayer.TAB_LOVERS].noOpen = true
		tabs[FriendLayer.TAB_LOVERS].noOpenTips = require("app.common.FunctionLevelHelper").getFunctionDesc(G_FunctionConst.FUNC_LOVERS,true)
	end

	local params = {
        tabs = tabs,
        isBig = true,
		scrollRect = cc.rect(0, 0, 500, 0),
    }

    local buttonTabNode = self:getSubNodeByName("ProjectNode_tab_buttons")
    self._tabButtons = require("app.common.TabButtonsHelper").updateTabButtons(buttonTabNode, params, handler(self,self._onTabChange))
    --self._tabButtons.setSelected(self._initIndex)

    self:_updateRedPoint()

    --更新底部按钮显示
    self._buttonAddFriend = self:getSubNodeByName("Button_add_friend")
    self._buttonRecommandFriend = self:getSubNodeByName("Button_recommended_friend")
    self._buttonGetAllPresent = self:getSubNodeByName("Button_oneKey_get")
    self._buttonSendAllPresent = self:getSubNodeByName("Button_oneKey_send")

    UpdateButtonHelper.reviseButton(self._buttonAddFriend,{isBig = true})
    UpdateButtonHelper.reviseButton(self._buttonRecommandFriend,{isBig = true})
    UpdateButtonHelper.reviseButton(self._buttonGetAllPresent,{isBig = true})
    UpdateButtonHelper.reviseButton(self._buttonSendAllPresent,{isBig = true})

    self._buttonAddFriend:addClickEventListenerEx(function ()
			G_Popup.newPopupWithTouchEnd(function ()
           --G_Popup.newPopup(function ()
           		local popLayer = FriendAddLayer.new()
           		return popLayer
           end,false,false)
        end)
    self._buttonRecommandFriend:addClickEventListenerEx(function ()
           G_Popup.newPopup(function ()
           		local popLayer = FriendRecommandLayer.new()
           		return popLayer
           end)
        end)

    self._buttonSendAllPresent:addClickEventListenerEx(function ()
            self:_sendAllPresent()
        end)

    self._buttonGetAllPresent:addClickEventListenerEx(function ()
            local tips = G_Me.friendData:getPresentTips()
        	if tips then
        		G_Popup.tip(tips)
        	else
        		G_HandlersManager.friendHandler:sendGetFriendPresent(0)
        	end
        end)

    self:_initLoversUI()



    -- UpdateButtonHelper.updateNormalButton(
    --     self._buttonAddFriend,{
    --     state = UpdateButtonHelper.STATE_NORMAL,
    --     desc = G_LangScrap.get("friend_button_add_friend"),
    --     callback = function ()
    --        G_Popup.newPopup(function ()
    --        		local popLayer = FriendAddLayer.new()
    --        		return popLayer
    --        end)
    --     end
    -- })

    -- UpdateButtonHelper.updateNormalButton(
    --     self._buttonRecommandFriend,{
    --     state = UpdateButtonHelper.STATE_NORMAL,
    --     desc = G_LangScrap.get("friend_button_recommand_friend"),
    --     callback = function ()
    --        G_Popup.newPopup(function ()
    --        		local popLayer = FriendRecommandLayer.new()
    --        		return popLayer
    --        end)
    --     end
    -- })

    -- UpdateButtonHelper.updateNormalButton(
    --     self._buttonGetAllPresent,{
    --     state = UpdateButtonHelper.STATE_NORMAL,
    --     desc = G_LangScrap.get("friend_button_get_all_presents"),
    --     callback = function ()
    --     	local tips = G_Me.friendData:getPresentTips()
    --     	if tips then
    --     		G_Popup.tip(tips)
    --     	else
    --     		G_HandlersManager.friendHandler:sendGetFriendPresent(0)
    --     	end
    --     end
    -- })

    --self:_updateRedPoint()
    --self:_addOutline2Label("Text_friend_num_title", "Text_friend_num_value", "Text_award_times_value", "Text_award_times_title")
end

function FriendLayer:_sendAllPresent()
	local list = G_Me.friendData:getFriendList()
	local num = 0
	for i=1,#list do
		local unit = list[i]
		if unit:canSendPresent() then
			self._isAllSend = true
			num = num + 1
			G_HandlersManager.friendHandler:sendFriendPresent(unit:getId())
		end
	end
	if num == 0 then
		G_Popup.tip("没有可赠送的好友")
	end
	self._oneKeyNeedSendNum = num
end

-- 伴侣相关ui
function FriendLayer:_initLoversUI()
	self:getSubNodeByName("Button_respond"):addClickEventListenerEx(function ()
    	--G_HandlersManager.friendHandler:sendGetLoversRespond()
    	G_Popup.newPopup(function ()
            local popLayer = FriendLoversRespondPop.new()
            return popLayer
        end)
    end)

	self._FileNode_auto = self:getSubNodeByName("FileNode_auto")
	UpdateButtonHelper.updateBigButton(self._FileNode_auto,{state = UpdateButtonHelper.STATE_NORMAL,
		desc = G_Lang.get("lovers_btn_auto_match"),
        callback = function ()
        	FriendLoversPopup.newAutoMatchPopup()
    	end})

	self._FileNode_manual = self:getSubNodeByName("FileNode_manual")
	UpdateButtonHelper.updateBigButton(self._FileNode_manual,{state = UpdateButtonHelper.STATE_ATTENTION,
		desc = G_Lang.get("lovers_btn_self_find"),
        callback = function ()
        	if G_Me.userData.power < 300000  then 
        		G_Popup.tip("战力到达30W开启")
        	else 
        		FriendLoversPopup.newFindLoversPopup()
        	end
    	end})

	self._FileNode_cancel_match = self:getSubNodeByName("FileNode_cancel_match")
	UpdateButtonHelper.updateBigButton(self._FileNode_cancel_match,{state = UpdateButtonHelper.STATE_NORMAL,
		desc = "取消匹配",
        callback = function ()
        	G_HandlersManager.friendHandler:sendCancelMatch()
            self:_removeTimer()
    	end})
end

function FriendLayer:_onTabChange(index)
print("FriendLayer:_onTabChange",index)
	self._currentIndex = index
	if not self._isInited then return end
	local showList --当前显示的列表
	if index == FriendLayer.TAB_FRIEND then
		if self._listFriend == nil then
			self._listFriend = FriendTabListLayout.new(self._shortListCon:getContentSize(),G_CommonUIHelper.getListCellH1(),index)
			self._viewArr[FriendLayer.TAB_FRIEND] = self._listFriend
			self._shortListCon:addChild(self._listFriend)
		end
		showList = self._listFriend
		self._friendBottomNode:setVisible(true)
		self._presentBottomNode:setVisible(false)
		self._loversNode:setVisible(false)
		--self._view:getSubNodeByName("Text_other_desc"):setVisible(true)
	-- elseif index == FriendLayer.TAB_PRESENT then
	-- 	if self._listPresent == nil then
	-- 		self._listPresent = FriendTabPresentLayout.new(self._shortListCon:getContentSize(), 155)
	-- 		self._viewArr[FriendLayer.TAB_PRESENT] = self._listPresent
	-- 		self._shortListCon:addChild(self._listPresent)
	-- 	end
	-- 	showList = self._listPresent
	-- 	self._friendBottomNode:setVisible(false)
	-- 	self._presentBottomNode:setVisible(true)
	-- 	self._view:getSubNodeByName("Text_other_desc"):setVisible(true)
	elseif index == FriendLayer.TAB_APPLY then
		print("FriendLayer.TAB_APPLY",FriendLayer.TAB_APPLY)
		self._friendBottomNode:setVisible(false)
		self._presentBottomNode:setVisible(false)
		self._loversNode:setVisible(false)
		--self._view:getSubNodeByName("Text_other_desc"):setVisible(false)
		if self._listApply == nil then
			self._listApply = FriendTabApplyListLayout.new(self._longListCon:getContentSize(),G_CommonUIHelper.getListCellH1(),index)
			self._viewArr[FriendLayer.TAB_APPLY] = self._listApply
			self._longListCon:addChild(self._listApply)
		end
		showList = self._listApply
	elseif index == FriendLayer.TAB_BLACK then
		if self._listBlack == nil then
			self._listBlack = FriendTabBlackListLayout.new(self._longListCon:getContentSize(),G_CommonUIHelper.getListCellH1(),index)
			self._viewArr[FriendLayer.TAB_BLACK] = self._listBlack
			self._longListCon:addChild(self._listBlack)
		end
		showList = self._listBlack
		self._friendBottomNode:setVisible(false)
		self._presentBottomNode:setVisible(false)
		self._loversNode:setVisible(false)
		--self._view:getSubNodeByName("Text_other_desc"):setVisible(false)
	elseif index == FriendLayer.TAB_LOVERS then -- 情侣
		if self._listLovers == nil then
			self._listLovers = FriendTabLoversLayout.new(self._longListCon:getContentSize(), 160,index)
			self._viewArr[FriendLayer.TAB_LOVERS] = self._listLovers
			self._longListCon:addChild(self._listLovers)
		end
		showList = self._listLovers
		self._friendBottomNode:setVisible(false)
		self._presentBottomNode:setVisible(false)
		self._loversNode:setVisible(G_Me.loversData:getLoversInfo() == nil and true or false)
		--self._view:getSubNodeByName("Text_other_desc"):setVisible(false)
	end

	--刷新列表显示
	showList:onShow()

	---更新相应列表的显示
	for i = 1, 4 do
		local list = self._viewArr[i]
		if list ~= nil then
			list:setVisible(index == i)
		end
	end

	--更新底部显示
	self:_updateFriendCount()
	self:_updateFriendPresentCount()
end

---刷新当前的好友列表，领取精力列表，黑名单
---这些列表的刷新规则是，如果数据改变，在要显示的时候刷新，否则不刷新。
function FriendLayer:_onFreshList()
	self._bottomNode:setVisible(true)
	if self._listFriend ~= nil then self._listFriend:setNeedFresh() end
	--if self._listPresent ~= nil then self._listPresent:setNeedFresh() end
	if self._listBlack ~= nil then self._listBlack:setNeedFresh() end
	if not self._isInited then
		self:_initTab()
	end
	
	dump(self._currentIndex)
	--if self._currentIndex ~= FriendLayer.TAB_APPLY then
		self:_onTabChange(self._currentIndex)
	--end
	self:_updateRedPoint()
end

--初始化页签（定位红点页签）
function FriendLayer:_initTab()
	if self._isInited == true then
		return
	end
	local presentHasRedPoint = G_Me.redPointData:isFriendGiftShowRed()
    local applyHasRedPoint = G_Me.redPointData:isFriendReqShowRed()
    local loversHasRedPoint = G_Me.redPointData:isLoversShowRed()
    local list = {presentHasRedPoint,applyHasRedPoint,loversHasRedPoint}
    local initIndex = FriendLayer.TAB_FRIEND
    for i=1,#list do
    	if list[i] == true then
    		initIndex = i
    		break
    	end
    end
    self._isInited = true
    self._tabButtons.setSelected(initIndex)
end

---初始化好友请求列表
function FriendLayer:_onInitFriendRequstList()
	if self._listApply == nil then
		self._listApply = FriendTabApplyListLayout.new(self._longListCon:getContentSize(), G_CommonUIHelper.getListCellH1())
		self._viewArr[FriendLayer.TAB_APPLY] = self._listApply
		self._longListCon:addChild(self._listApply)
	end

	if self._currentIndex == FriendLayer.TAB_APPLY then
		self._listApply:setNeedFresh()
		self._listApply:onShow()
	end
end

---更新好友礼品赠送状态
function FriendLayer:_updateFriendSendPresentState()
	if self._listFriend ~= nil then
		self._listFriend:setNeedFresh()
		if self._isAllSend then
			self._oneKeySentNum = self._oneKeySentNum + 1
		end
		if self._currentIndex == FriendLayer.TAB_FRIEND then
			if self._isAllSend and (self._oneKeySentNum%6 == 0 or self._oneKeySentNum == self._oneKeyNeedSendNum) then
				self:_onTabChange(self._currentIndex)
			else
				self:_onTabChange(self._currentIndex)
			end
		end
		
		if not self._isAllSend or self._oneKeySentNum == self._oneKeyNeedSendNum then
			G_Popup.tip(G_Lang.get("friend_present_send_tips"))
			self._isAllSend = false
			self._oneKeySentNum = 0
			self._oneKeyNeedSendNum = 0
		end
	end
end

---更新好友礼品领取状态
function FriendLayer:_onUpdateFriendGetPresentState(num)
	if self._listFriend ~= nil then
		self._listFriend:setNeedFresh()
		if self._currentIndex == FriendLayer.TAB_FRIEND then
			self:_onTabChange(self._currentIndex)
		end
		G_Popup.tip(G_Lang.get("friend_get_present_tips", {num = num}))
	end
end

---更新好友请求状态
function FriendLayer:_onUpdateFriendRequstList()
	if self._listApply ~= nil then
		self._listApply:setNeedFresh()
		if self._currentIndex == FriendLayer.TAB_APPLY then
			self:_onTabChange(self._currentIndex)
		end
	end
end

--黑名单有变化
function FriendLayer:_onBlackListChanged()
	self:_updateRedPoint()
	self:_onFreshList()
	if self._listApply then
		self._listApply:setNeedFresh()
		if self._currentIndex == FriendLayer.TAB_APPLY then
			self._listApply:onShow()
		end
	end
end

--刷新好友数量
function FriendLayer:_updateFriendCount()
	self._view:updateLabel("Text_friend_num_title", {
		textColor = G_Colors.getColor(11),
		outlineColor = G_Colors.getOutlineColor(26),
		})
    self._view:updateLabel("Text_friend_num_value", {
    	text = G_Me.friendData:getFriendsCount() .. "/" .. G_Me.friendData:getMaxFriendNum(),
    	textColor = G_Colors.getColor(25),
		outlineColor = G_Colors.getOutlineColor(26),
    	})
  --   self._view:updateLabel("Text_online_num", {
  --   	text = "("..tostring(G_Me.friendData:getFriendListOnlineNum())..")",
  --   	textColor = G_Colors.qualityColor2Color(6,true),
		-- outlineColor = G_Colors.qualityColor2OutlineColor(6),
  --   	}) -- 在线数量
	self._view:updateLabel("Text_online_num_0", {
		textColor = G_Colors.getColor(11),
		outlineColor = G_Colors.getOutlineColor(26),
		})
  	self._view:updateLabel("Text_online_num", {
    	text = tostring(G_Me.friendData:getFriendListOnlineNum()),
    	textColor = G_Colors.getColor(25),
		outlineColor = G_Colors.getOutlineColor(26),
    	}) -- 
end

--刷新体力数量
function FriendLayer:_updateFriendPresentCount()
    self._view:updateLabel("Text_vit_title", {
		textColor = G_Colors.getColor(11),
		outlineColor = G_Colors.getOutlineColor(26),
		})
    self._view:updateLabel("Text_vit_tips", {
    	text = "（情侣赠送体力+10不受此限制）",
		textColor = G_Colors.getColor(11),
		outlineColor = G_Colors.getOutlineColor(26),
		})
    self._view:updateLabel("Text_vit_num", {
    	text = tostring(G_Me.friendData:getRecivedPresentNum()).."/"..tostring(G_Me.friendData:getMaxVitNum()),
		textColor = G_Colors.getColor(25),
		outlineColor = G_Colors.getOutlineColor(26),
		})
    --self._view:updateLabel("Text_award_times_value", roleInfo.max_earn_from_friend - G_Me.friendData:getRecivedPresentNum() ..  "/" .. roleInfo.max_earn_from_friend)
end

---收到服务端的红点刷新消息
function FriendLayer:_onRedPointUpdate()
    -- G_HandlersManager.friendHandler:sendGetFriendList()
    -- G_HandlersManager.friendHandler:sendGetFriendReqList()

    self:_updateRedPoint()
end

function FriendLayer:_updateRedPoint()
	local presentHasRedPoint = G_Me.redPointData:isFriendGiftShowRed()
    local applyHasRedPoint = G_Me.redPointData:isFriendReqShowRed()
    local loversHasRedPoint = G_Me.redPointData:isLoversShowRed()
	self._tabButtons.updateRedPoint(FriendLayer.TAB_FRIEND, presentHasRedPoint)
    self._tabButtons.updateRedPoint(FriendLayer.TAB_APPLY, applyHasRedPoint)
    self._tabButtons.updateRedPoint(FriendLayer.TAB_LOVERS, loversHasRedPoint)

    self:getSubNodeByName("Image_dot_respond"):setVisible(loversHasRedPoint)
end

---添加统一的文字描边
function FriendLayer:_addOutline2Label(...)
    local labelNames = {...}
    for i = 1, #labelNames do
        local labelName = labelNames[i]
         self._view:updateLabel(labelName, {
            outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
            outlineSize = 2
        })
    end
end

-- 跳转寻吕回应界面
function FriendLayer:_onGotoRespond(...)
  --  FriendLoversPopup.newClearCDPopup(self._isAutoFight)
  	G_Popup.newPopup(function ()
   		local popLayer = FriendLoversRespondPop.new()
   		return popLayer
   	end)
end

-- 情侣数据接收完毕，界面渲染
function FriendLayer:_onGetLoversData(...)
	local matchType = G_Me.loversData:getMatchType()

	 -- 定时器申请排队人数
	self:_removeTimer()
    if self._queueTimer == nil and matchType == 1 then 
        self._queueTimer = GlobalFunc.addTimer(3, function ( ... )
            G_HandlersManager.friendHandler:sendGetQueueNum()
        end)
        G_HandlersManager.friendHandler:sendGetQueueNum()
    end

	-- 按钮状态变更
	UpdateButtonHelper.updateBigButton(self._FileNode_auto,{
		state = UpdateButtonHelper.STATE_NORMAL,
		desc = matchType == 1 and G_Lang.get("lovers_btn_matching") or G_Lang.get("lovers_btn_auto_match"),
	    callback = function ()
		    if matchType == 1 then
	    		FriendLoversPopup.newMatchingPopup()
		    else
	    		FriendLoversPopup.newAutoMatchPopup()
		    end
		end})

	UpdateButtonHelper.updateBigButton(self._FileNode_manual,{
		state = matchType == 1 and UpdateButtonHelper.STATE_GRAY or UpdateButtonHelper.STATE_NORMAL,
		})

	-- 情侣寻找层显示隐藏
	if self._listLovers then 
		self._listLovers:setNeedFresh()
		self._listLovers:onShow() 
	end
	self._loversNode:setVisible((self._currentIndex == FriendLayer.TAB_LOVERS and G_Me.loversData:getLoversInfo() == nil) and true or false)
	self._Node_to_match:setVisible(matchType ~= 1)
	self._Node_cancel_match:setVisible(matchType == 1)
end

-- 匹配结果
function FriendLayer:_onMatchResult(...)
	--FriendLoversPopup.newBeLoversPopup()
end

-- 刷新队列
function FriendLayer:_refreshQueue(num)
    self._view:updateLabel("Text_wait_num",num)
end

  -- 移除定时器
function FriendLayer:_removeTimer()
    if self._queueTimer then
        GlobalFunc.removeTimer(self._queueTimer)
        self._queueTimer = nil
    end
end

return FriendLayer