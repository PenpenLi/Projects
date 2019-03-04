
---好友求侣列表弹窗
local FriendLoversInvitePop = class("FriendLoversInvitePop", function ()
	return display.newLayer()
end)

local SchedulerHelper = require "app.common.SchedulerHelper" 
local UpdateNodeHelper = require ("app.common.UpdateNodeHelper")
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local ParameterInfo = require "app.cfg.parameter_info"
local FriendTabRecommandListLayout = require "app.scenes.friend.FriendTabRecommandListLayout"

function FriendLoversInvitePop:ctor()
	self._view = nil
	self._listView = nil
	self._scheduler = nil
	self._isMan = nil -- 性别：nil全 true 男 flase 女
	self:enableNodeEvents()
end

function FriendLoversInvitePop:onEnter()
    G_HandlersManager.friendHandler:sendGetLoversRespond()
	
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_LOVERS_INVITE_FRIEND, self._updateView, self)
    --uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_FRIEND_GET_LIST, self._updateView, self)
   -- uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_LOVERS_MATCH_RESULT, self._onAccept, self)
    self:_initUI()
end

function FriendLoversInvitePop:onExit()
	uf_eventManager:removeListenerWithTarget(self)

	if self._scheduler ~= nil then
		SchedulerHelper.cancelCountdown(self._scheduler)
		self._scheduler = nil
	end
end

function FriendLoversInvitePop:_initUI()
	self._view = cc.CSLoader:createNode(G_Url:getCSB("FriendLoversInvitePop", "friend"))
	self:addChild(self._view)
	self:setPosition(display.cx, display.cy)
    ccui.Helper:doLayout(self._view)

	UpdateNodeHelper.updateCommonNormalPop(self:getSubNodeByName("ProjectNode_common"),"好友列表",function ( ... )
    	self:removeFromParent(true)
    end,685)

	-- 列表创建
	local view = self._view
	local content = self._view:getSubNodeByName("Panel_content")
	local size = content:getContentSize()
	local listview = require("app.ui.WListView").new(size.width,size.height,size.width,158)
	self._listView = listview
	listview:setCreateCell(function(view,idx)
		local cell = require("app.scenes.friend.FriendLoversInviteCell").new(self._knightData,handler(self,self._onAccept))
		return cell
	end)
	listview:setPositionX(4)

	content:addChild(self._listView)

	 --checkbox男女选择
    local CheckBox_man = view:getSubNodeByName("CheckBox_man")
    local CheckBox_woman = view:getSubNodeByName("CheckBox_woman")
    CheckBox_man:addEventListener(function (sender,type)
        --dump(type)
        if type == CHECKBOX_STATE_EVENT_SELECTED then
            CheckBox_woman:setSelected(false)
            self._isMan = true
        elseif type == CHECKBOX_STATE_EVENT_UNSELECTED then
            self._isMan = nil
            --CheckBox_woman:setSelected(true)
        end
        self:_updateView()
    end)
    CheckBox_woman:addEventListener(function (sender,type)
        --dump(type)
        if type == CHECKBOX_STATE_EVENT_SELECTED then
            CheckBox_man:setSelected(false)
            self._isMan = false
        elseif type == CHECKBOX_STATE_EVENT_UNSELECTED then
            self._isMan = nil
            --CheckBox_man:setSelected(true)
        end
        self:_updateView()
    end)

	self:_updateView()
end

function FriendLoversInvitePop:_updateView()
	local respondList = G_Me.friendData:getFriendList()
	local dataList = {} -- 实际筛选数据

	-- 数据整理
	if self._isMan == nil then -- 全选
		for i=1,#respondList do
			if not respondList[i]:isHaveLovers() then
				dataList[#dataList+1] = respondList[i]
			end
		end
	else -- 区别性别
		for i=1,#respondList do
			if self._isMan and respondList[i]:getSex() == 1 and not respondList[i]:isHaveLovers() then
				dataList[#dataList+1] = respondList[i]
			elseif self._isMan == false and respondList[i]:getSex() == 2 and not respondList[i]:isHaveLovers() then
				dataList[#dataList+1] = respondList[i]
			end
		end
	end
	table.sort(dataList,function ( a,b ) -- 按是否已发送排序
		if a:isSendInvite() then
			return false
		elseif b:isSendInvite() then
		 	return true
		end
		return false
	end)

	-- 列表渲染
	self._listView:setUpdateCell(function(view,cell,idx)
		cell:updateCell(dataList[idx+1],idx)
	end)
	self._listView:setCellNums(#dataList, true, 0)

	-- 发送次数
	self:updateLabel("Text_tell_num","（".. G_Me.loversData:getSendNumFriend() .."/3）")
end

-- 接受回应
function FriendLoversInvitePop:_onAccept()
	self:removeFromParent()
end

return FriendLoversInvitePop