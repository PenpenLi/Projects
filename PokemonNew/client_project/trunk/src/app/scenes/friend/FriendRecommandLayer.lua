
---好友推荐弹窗
local FriendRecommandLayer = class("FriendRecommandLayer", function ()
	return display.newLayer()
end)

local SchedulerHelper = require "app.common.SchedulerHelper" 
local UpdateNodeHelper = require ("app.common.UpdateNodeHelper")
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local ParameterInfo = require "app.cfg.parameter_info"
local FriendTabRecommandListLayout = require "app.scenes.friend.FriendTabRecommandListLayout"

function FriendRecommandLayer:ctor()
	self._view = nil
	self._listView = nil
	self._scheduler = nil
	self:enableNodeEvents()
end

function FriendRecommandLayer:onEnter()
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_FRIEND_GET_RECOMMAND_LIST, self._onInitFriendRecommandList, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_FRIEND_ADD_SEND_SUCEESS, self._onUpdateRecommandList, self)
    self:_initUI()
end

function FriendRecommandLayer:onExit()
	uf_eventManager:removeListenerWithTarget(self)

	if self._scheduler ~= nil then
		SchedulerHelper.cancelCountdown(self._scheduler)
		self._scheduler = nil
	end
end

function FriendRecommandLayer:_initUI()
	self._view = cc.CSLoader:createNode(G_Url:getCSB("FriendRecommandLayer", "friend"))
	self:addChild(self._view)
	self:setPosition(display.cx, display.cy)
    ccui.Helper:doLayout(self._view)

	UpdateNodeHelper.updateCommonNormalPop(self:getSubNodeByName("ProjectNode_common"),G_Lang.get("friend_recommond_title"),function ( ... )
    	self:removeFromParent(true)
    end,670)

	local content = self._view:getSubNodeByName("Panel_content")
	self._listView = FriendTabRecommandListLayout.new(content:getContentSize(), G_CommonUIHelper.getListCellH1())
	content:addChild(self._listView)
	---判断是否有请求CD
	local coolTime = G_Me.friendData:getRecommandFriendCoolTime()
	if coolTime == 0 then ---重新请求列表
    	G_HandlersManager.friendHandler:sendGetFriendRecommandList()
    else
    	self._listView:setNeedFresh()
    	self._listView:onShow()
	end

	self:_updateView()
end

function FriendRecommandLayer:_updateView()
	local coolTime = G_Me.friendData:getRecommandFriendCoolTime()
	self:getSubNodeByName("Text_count"):setVisible(coolTime ~= 0)

	local btnFresh = self._view:getSubNodeByName("Button_call")
	btnFresh:addClickEventListenerEx(function ()
            G_HandlersManager.friendHandler:sendGetFriendRecommandList()
        end)
	btnFresh:setEnabledEx(coolTime == 0)
    -- UpdateButtonHelper.updateNormalButton(
    --     self._view:getSubNodeByName("Button_call"),{
    --     state = coolTime == 0 and UpdateButtonHelper.STATE_NORMAL or UpdateButtonHelper.STATE_GRAY,
    --     desc = G_LangScrap.get("common_btn_to_refresh"),
    --     callback = function ()
    --         G_HandlersManager.friendHandler:sendGetFriendRecommandList()
    --     end
    -- })

    if self._scheduler ~= nil then
		SchedulerHelper.cancelCountdown(self._scheduler)
		self._scheduler = nil
	end

    if coolTime ~= 0 then
    	self._view:updateLabel("Text_count", G_Lang.get("friend_count_down_sec", {num = coolTime}))
    	self._scheduler = SchedulerHelper.newCountdown(
	        coolTime, 1,
	        function()
	            coolTime = coolTime - 1
	            self._view:updateLabel("Text_count", G_Lang.get("friend_count_down_sec", {num = coolTime}))
	        end, 
	        function() 
	        	btnFresh:setEnabledEx(true)
	            -- UpdateButtonHelper.updateNormalButton(self._view:getSubNodeByName("Button_call"),{
	            -- 	state = UpdateButtonHelper.STATE_NORMAL
	            -- })
	            self._view:getSubNodeByName("Text_count"):setVisible(false)
	        end
        )
    end
end


---初始好友推荐列表
function FriendRecommandLayer:_onInitFriendRecommandList()
	self._listView:setNeedFresh()
	self._listView:onShow()
	self:_updateView()
end

function FriendRecommandLayer:_onUpdateRecommandList()
	G_Popup.tip(G_Lang.get("friend_add_friend_request_sended"))
	self._listView:setNeedFresh()
	self._listView:onShow()
end

return FriendRecommandLayer