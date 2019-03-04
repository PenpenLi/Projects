--[====================[
	演练场弹出框
]====================]
local PracticePopup = {}

local PopupBase = require "app.popup.common.PopupBase"

local storage = require("app.storage.storage")
local UpdateNodeHelper = require "app.common.UpdateNodeHelper"
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local ModuleEntranceHelper = require("app.common.ModuleEntranceHelper")
local TextHelper = require ("app.common.TextHelper")
local FriendLoversInvitePop = require("app.scenes.friend.FriendLoversInvitePop")
local yanwuchang_bangpai_rankaward_info = require("app.cfg.yanwuchang_bangpai_rankaward_info")
local yanwuchang_geren_rankaward_info = require("app.cfg.yanwuchang_geren_rankaward_info")

---展示奖励弹出框 @isSelf :是否是个人奖励
function PracticePopup.newShowRewardPopup(isSelf)
    PopupBase.newPopupWithTouchEnd(function ()
        local view = cc.CSLoader:createNode(G_Url:getCSB("WorldBossRewardPanel","worldBoss"))
        view:setContentSize(display.width,display.height)
        view:setPosition(display.cx,display.cy)
        ccui.Helper:doLayout(view)

        UpdateNodeHelper.updateCommonNormalPop(view,isSelf and "个人奖励" or "帮派奖励",nil,744)

        -- 数据创建
        local rankListData = {}
        local count = (isSelf and yanwuchang_geren_rankaward_info or yanwuchang_bangpai_rankaward_info).getLength()
        for i = 1,count do
            local info = (isSelf and yanwuchang_geren_rankaward_info or yanwuchang_bangpai_rankaward_info).indexOf(i)
            rankListData[i] = info
        end

        -- 列表创建
        local listViewPanel = view:getSubNodeByName("Panel_list")
        local size = listViewPanel:getContentSize()

        local rankListView = require("app.ui.WListView").new(size.width,size.height,size.width,150)
        rankListView:setCreateCell(function(list,index)
            local cell = require("app.scenes.worldBoss.WorldBossRewardItem").new()
            return cell
        end)

        rankListView:setUpdateCell(function(list,cell,index)
            cell:updateData(rankListData[index+1], 1, index+1)
        end)

        rankListView:setCellNums(#rankListData, true)
        listViewPanel:addChild(rankListView)

        ---添加到当前场景
        view:setPosition(display.cx, display.cy)
        return view
    end, false, false,view,70)
end

---购买挑战次数弹出框 
function PracticePopup.newBuyChallegesPopup()
    PopupBase.newPopupWithTouchEnd(function ()
        local view = cc.CSLoader:createNode(G_Url:getCSB("CommonBuyChallengesPopup","common"))
        view:setContentSize(display.width,display.height)
        view:setPosition(display.cx,display.cy)
        ccui.Helper:doLayout(view)

        -- 获取数据
        local num = G_Me.practiceData:getChallengeNums()
        local total = G_Me.vipData:getVipTimesByFuncId(10941)
        local left = total - G_Me.practiceData:getBuyChallengeNum()
        local buyNum = 1
        local cost = G_Me.vipData:getVipBuyTimeCost(10941,G_Me.practiceData:getBuyChallengeNum())

        -- 界面渲染
        view:updateLabel("Text_current_num",num)
        view:updateLabel("Text_left_num",left)
        view:updateLabel("Text_cost_num",cost)

        -- 花费刷新
        function view:_updateView() 
            for i=1,buyNum - 1 do
                cost = cost + G_Me.vipData:getVipBuyTimeCost(10941,G_Me.practiceData:getBuyChallengeNum() + i)
            end

            view:updateLabel("Text_amount",buyNum)
            view:updateLabel("Text_cost_num",cost)
        end

        -- 按钮添加监听
        view:updateButton("Button_sub10", {
        callback = function ( ... )
            buyNum = buyNum - 10 < 1 and 1 or (buyNum - 10)
            view:_updateView()
        end})
        view:updateButton("Button_sub1", {
        callback = function ( ... )
            buyNum = buyNum - 1 < 1 and 1 or (buyNum - 1)
            view:_updateView()
        end})
        view:updateButton("Button_add10", {
        callback = function ( ... )
            buyNum = buyNum + 10 > left and left or (buyNum + 10)
            view:_updateView()
        end})
        view:updateButton("Button_add1", {
        callback = function ( ... )
            buyNum = buyNum + 1 > left and left or (buyNum + 1)
            view:_updateView()
        end})
        view:updateButton("Button_cancel", {
        callback = function ( ... )
            view:removeFromParent()
        end})
        view:updateButton("Button_sure", {
        callback = function ( ... )
            G_HandlersManager.practiceHandler:sendBuyChallenge(buyNum)
            view:removeFromParent()
        end})

        ---添加到当前场景
        view:setPosition(display.cx, display.cy)
        return view
    end, false, false,view)
end


return PracticePopup
