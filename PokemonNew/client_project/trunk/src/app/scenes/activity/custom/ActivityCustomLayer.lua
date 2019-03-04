--[====================[

    可配置活动layer
    
]====================]

local ActivityCustomLayer = class("ActivityCustomLayer", function()
    return ccui.Layout:create()
end)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local TypeConverter = require ("app.common.TypeConverter")
local ActivityConst = require("app.const.ActivityConst")
local ActivityUIHelper = require("app.scenes.activity.ActivityUIHelper")
local KnightImg = require("app.common.KnightImg")
local ShopUtils = require("app.scenes.shopCommon.ShopUtils")

local ActivityExchangeCell = require("app.scenes.activity.custom.ActivityExchangeCell")
local ActivityRewardCell = require("app.scenes.activity.custom.ActivityRewardCell")

function ActivityCustomLayer:ctor(act_id)
    self._activity = G_Me.activityData.custom:getActivityByActId(act_id)       --活动数据
    self._act_id = act_id or 0

    self._csbNode = nil       
    
    self._listData = {}         --任务数据

    self._listView = nil        --任务列表

    self._npcPanel = nil

    self._onFocus = false

    self:enableNodeEvents()
end

function ActivityCustomLayer:onEnter()
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CUSTOM_ACTIVITY_GET_AWARD, self._getAward, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CUSTOM_ACTIVITY_UPDATE_QUEST, self._refreshActQuest, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CUSTOM_ACTIVITY_UPDATE, self._refreshAct, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECHARGE_SUCCESS, self._rechargeSuccess, self) 

    self:_initUI()

    self:_initListView()
end

function ActivityCustomLayer:updatePage( activity )
    if type(activity) ~= "table" then return end

    self._activity = activity.data
    self._act_id = activity.data.act_id

    ActivityUIHelper.updateBaseInfo(self._csbNode, self._activity)
end

--翻到当前页
function ActivityCustomLayer:focusOnPage()
    G_TipsClickCount:addTodayClickTimes("custom_" .. self._act_id)
    self._onFocus = true
end

function ActivityCustomLayer:focusOutPage()
    self._onFocus = false
end

function ActivityCustomLayer:onExit()
    uf_eventManager:removeListenerWithTarget(self)

    if self._csbNode ~= nil then
        self._csbNode:removeFromParent(true)
        self._csbNode = nil
    end
end

function ActivityCustomLayer:_initUI()
    self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("ActivityCustomLayer","activity"))
    self:addChild(self._csbNode)
    self._csbNode:setContentSize(display.width, display.height)
    self._csbNode:getSubNodeByName("ProjectNode_con"):setContentSize(display.width, display.height)

    ccui.Helper:doLayout(self._csbNode)
    G_WidgetTools.autoTransformBg(self._csbNode:getSubNodeByName("Image_bg"))

    self._npcPanel = self._csbNode:getSubNodeByName("Panel_npc")
    local panelSize = self._npcPanel:getContentSize()

    local npcId = 21301  --默认貂蝉

    --苹果审核版本
    -- if G_Setting.get("appstore_version") == "1" then
    --     npcId = 1191

    --换NPC形象
    --if rawget(self._activity, "icon_type") and self._activity.icon_type == TypeConverter.TYPE_KNIGHT and
    if rawget(self._activity, "icon_type") and self._activity.icon_type > 0 then
        local param = {type=G_TypeConverter.TYPE_KNIGHT, value=self._activity.icon_type}

        param = TypeConverter.convert(param)
       --dump(param)
        npcId = self._activity.icon_type--param.cfgRank.res_id
    end

    local knightImage = KnightImg.new(npcId,0,0)
    knightImage:setAnchorPoint(cc.p(0.5, 0))
    knightImage:setPosition(cc.p(panelSize.width*0.17,10))
    self._npcPanel:removeAllChildren()
    self._npcPanel:addChild(knightImage)

    --列表底部遮罩
    --self:updateImageView("Image_listBottom", {visible = #self._listData>3})

end

--不进行排序的list
ActivityCustomLayer.sortListOnlyByID = {
    [201] = true,
    [202] = true,
    [401] = true,
    [402] = true,
    [403] = true,
    [411] = true,
    [412] = true,
    [413] = true
}

function ActivityCustomLayer:_initListView()
    local listData,showIndex = G_Me.activityData.custom:getQuestByActId(self._act_id,nil,nil,nil,ActivityCustomLayer.sortListOnlyByID[self._act_id] == true)
    self._listData = listData or {}
    dump(self._act_id)
    dump(self._listData)

    if self._listView then

        self._listView:removeFromParent(true)
        self._listView = nil
    end 

    if self._listView == nil  then

        if not self._activity then
            return
        end

        local listviewBg = self:getSubNodeByName("Panel_listView")
        local listViewSize = listviewBg:getContentSize()
        self._listView = require("app.ui.WListView").new(listViewSize.width,listViewSize.height, listViewSize.width, G_CommonUIHelper.getListCellH5())
        self._listView:setCreateCell(function(view,idx)
            local cell = nil
                --兑换类型
                if self._activity.act_type == ActivityConst.CUSTOM_TYPE_SELL then
                    cell = ActivityExchangeCell.new(handler(self, self._onExchangeButton))
                --领奖类型
                else
                    cell = ActivityRewardCell.new(handler(self, self._onGetButton))
                end
            return cell
        end)
        self._listView:setUpdateCell(function(view,cell,idx)
            if cell and idx < #self._listData then
                dump(self._listData[idx + 1])
                cell:updateData(self._listData[idx + 1])
            end
        end)

        self._listView:setFirstCellPaddigTop(0)

        self._listView:setCellNums(#self._listData, false)
        print("showIndexshowIndexshowIndex",showIndex)
        if showIndex then
            self._listView:setLocation(showIndex,false)
        end
        --self._listView:updateCellNums(#self._listData)

        listviewBg:addChild(self._listView)
    end
end

--兑换类任务按钮响应方法
function ActivityCustomLayer:_onExchangeButton(quest, curQuest)
    local quest = quest or nil

    --dump(quest)

    local curQuest = curQuest or nil

    if not quest or not curQuest then
        return
    end

    --判断活动是否处于预览期
    if G_Me.activityData.custom:checkPreviewByActId(quest.act_id) then
        G_Popup.tip(G_LangScrap.get("activity_text_in_priview",{
            time=G_Me.activityData.custom:getStartDateByActId(quest.act_id)}))
        return
    end

    --判断是否过期
    if not G_Me.activityData.custom:checkIsActiveById(quest.act_id) then
        G_Popup.tip(G_LangScrap.get("activity_text_is_expired"))
        return
    end

    --判断兑换次数
    local value02 = 0   --限制次数
    local value01 = 0   --当前进度

    --判断是全服剩余还是普通的
    if quest.server_limit > 0 then   --全服限制
        value02 = quest.server_limit or 0   --限制次数
        value01 = quest.server_times or 0   --当前进度
    else
        value02 = quest.award_limit or 0   --限制次数
        value01 = curQuest.award_times or 0   --当前进度
    end

    --都是0的话表示不受限
    if value01 >= value02 and value02 > 0 then
        --刷新条件未写好,正常是置灰的
        if quest.server_limit > 0 then --全服剩余次数不足需要加个提示
            G_Popup.tip("activity_text_came_later")
        end
        return
    end

    local reachCondition, itemName = G_Me.activityData.custom:checkExchangeCondition(quest)
    --条件未达成
    if not reachCondition then
        G_Popup.tip(itemName~=nil and G_LangScrap.get("activity_text_exchange_item_not_enough",{name=itemName 
            .. (quest.consume_type1 == G_TypeConverter.TYPE_KNIGHT_FRAGMENT and "碎片" or "")})
        	or G_LangScrap.get("activity_text_exchange_not_enough"))
        return 
    end

    --判断领奖时间是否到了
    local act = G_Me.activityData.custom:getActivityByActId(quest.act_id)
    if not act then
        return
    end

    if G_ServerTime:getTime() > act.award_time then
        G_Popup.tip(G_LangScrap.get("activity_text_award_expired"))
        return
    end

    --判断是否是多选
    if quest.award_select > 0 then
        local awardList = {}

        for i=1,4 do
            local _type = quest["award_type" .. i]
            if _type > 0 then
                local value = quest["award_value" .. i]
                local size = quest["award_size" .. i]
                local good = TypeConverter.convert({type=_type,value=value,size=size})
                if good then
                    table.insert(awardList,good)
                end
            end
        end

        --多选一
        G_Popup.newSelectRewardPopup(function(index)
            G_HandlersManager.activityCustomHandler:sendGetCustomActivityAward(
                quest.act_id,quest.quest_id,(index-1)) 
            end, awardList, nil, false)

        return
    end

    --必定是有兑换次数的，否则按钮是灰的 
    if quest.server_limit > 0 then
        --全服剩余时，不发送次数
        G_HandlersManager.activityCustomHandler:sendGetCustomActivityAward(
            quest.act_id,quest.quest_id) 
    else
        local consumeNum, awardNum = G_Me.activityData.custom:getExchangeConsumeAndAwardTypeNum(quest)

        --num为1时才显示可以批量兑换，否则直接兑换
        --也可以再做个兑换弹框
        local leftBuyNum = quest.award_limit - curQuest.award_times   --剩余次数

        --剩余1次
        --if consumeNum == 1 and awardNum == 1 and leftBuyNum > 1 then
            local consumeAmount = G_Responder.getNumByTypeAndValue(quest.consume_type1,quest.consume_value1)
            local awardAmount = G_Responder.getNumByTypeAndValue(quest.award_type1,quest.award_value1)

            local maxBuyNum = math.floor(consumeAmount/quest.consume_size1)   --最多能兑换的次数
            if maxBuyNum==0 then -- 资源不足
                G_HandlersManager.activityCustomHandler:sendGetCustomActivityAward(
                quest.act_id,quest.quest_id) 
                return
            end
            maxBuyNum = (maxBuyNum==0) and leftBuyNum or maxBuyNum

            maxBuyNum = math.min(maxBuyNum, leftBuyNum)
            --dump(maxBuyNum)
            G_Popup.buyConfirm({
                type = quest.award_type1,
                value = quest.award_value1,
                maxBuyNum = maxBuyNum,
                price = quest.consume_size1,
                nums = awardAmount,
                buySize = quest.award_size1,
                notDay = true,
            }, function (num, totalPrice, id)
                if num == 0 then return end

                ShopUtils.checkCostEnough(quest.consume_type1,quest.consume_value1,totalPrice, 
                    function ()
                        G_HandlersManager.activityCustomHandler:sendGetCustomActivityAward(
                            quest.act_id,quest.quest_id,nil,num) 
                    end)
                
            end, {type = quest.consume_type1,value = quest.consume_value1})

        -- else
        --     G_HandlersManager.activityCustomHandler:sendGetCustomActivityAward(
        --         quest.act_id,quest.quest_id) 
        -- end
    end
end

--非兑换类任务按钮响应方法
function ActivityCustomLayer:_onGetButton(quest, curQuest)
    local quest = quest or nil

    local curQuest = curQuest or nil

    if not quest or not curQuest then
        return
    end

    --活动处于预览期
    if G_Me.activityData.custom:checkPreviewByActId(quest.act_id) then
        G_Popup.tip(G_LangScrap.get("activity_text_in_priview",{
            time=G_Me.activityData.custom:getStartDateByActId(quest.act_id)}))
        return
    end

    --判断是否过了领取时间
    if not G_Me.activityData.custom:checkCanGetAward(quest.act_id) then
        G_Popup.tip(G_LangScrap.get("activity_text_award_expired"))
        return
    end

    local act = G_Me.activityData.custom:getActivityByActId(quest.act_id)
    if not act then
        return
    end


    --先判断是否完成
    local value02 = tonumber(quest.param1) or 0   --完成所需次数

    local progress = curQuest.progress or 0   --当前进度

    local canGetAward = progress >= value02

    local awardTimes = curQuest.award_times
    local awardLimit = quest.award_limit

    --收集类
    if quest.quest_type == ActivityConst.QUEST_TYPE_PUSH_ITEM then
        --此时第三个参数为所需次数
        value02 = tonumber(quest.param3) or 0   --完成所需次数
        canGetAward = progress >= value02

    --单笔充值达到#num1 --连续#num1#日充值#num2#元
    elseif quest.quest_type == ActivityConst.QUEST_TYPE_PAY_ONCE_TODAY_REACH
        or quest.quest_type == ActivityConst.QUEST_TYPE_PAY_ONCE_EVERYDAY_REACH then
        value02 = awardTimes --已领取次数
        --dump(progress)
        --dump(value02)
        canGetAward = progress > value02
        awardLimit = tonumber(quest.award_limit) or 0
       -- dump(quest)
    --单笔充值达到#num1#~#num2#元
    -- elseif quest.quest_type == ActivityConst.QUEST_TYPE_PAY_ONCE_TODAY_BETWEEN then    
    --     value02 = curQuest.award_times
    --     canGetAward = progress > value02
    
    end

    -- dump(curQuest)
    -- dump(quest)

    --是否已经领取
    -- if awardLimit ~= 0 and awardTimes >= awardLimit then
    --     G_Popup.tip(G_LangScrap.get("activity_text_award_got"))
    --     return
    -- end

    local awardFunc = function()

        --判断包裹是否满了
        if G_Me.activityData.custom:checkBagFullByQuest(quest) then
            return
        end

        -- 判断是否多选1
        if quest.award_select > 0 then
            local awardList = {}

            for i=1,4 do
                local _type = quest["award_type" .. i]
                if _type > 0 then
                    local value = quest["award_value" .. i]
                    local size = quest["award_size" .. i]
                    local good = TypeConverter.convert({type=_type,value=value,size=size})
                    if good then
                        table.insert(awardList,good)
                    end
                end
            end

            G_Popup.newSelectRewardPopup(function(index)
                G_HandlersManager.activityCustomHandler:sendGetCustomActivityAward(
                    quest.act_id,quest.quest_id,(index-1)) 
            end, awardList, nil, false)
        
        else
            G_HandlersManager.activityCustomHandler:sendGetCustomActivityAward(quest.act_id,quest.quest_id) 
        end
    end

    --canGetAward = true --tempcode
    if canGetAward then
        awardFunc()
        return
    end

    --判断是否过期，过期了就不前往了
    if not G_Me.activityData.custom:checkIsActiveById(quest.act_id) then
        G_Popup.tip(G_LangScrap.get("activity_text_is_expired"))
        return
    end

    --未完成--前往
    ActivityUIHelper.gotoModule(quest)
end

function ActivityCustomLayer:_getAward(data)
    if data.ret == 1 and data.act_id == self._activity.act_id then
        uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_ACTIVITY_UPDATED, nil, false)

        local award_id = nil
        if rawget(data,"award_id") then
            award_id = data.award_id
        end 
        local num = nil
        if rawget(data,"award_num") then
            num = data.award_num
        end
        local award = G_Me.activityData.custom:getAwardById(data.act_id,data.quest_id,award_id,num)
        if award == {} then
            G_Popup.tip(G_LangScrap.get("common_item_get_success"))
        else
            G_Popup.awardTips(award)
        end

        -- 非兑换类刷新list
        -- if G_Me.activityData.custom:getActivityByActId(data.act_id).act_type 
        --     ~= ActivityConst.CUSTOM_TYPE_SELL then
        --     self._listData = G_Me.activityData.custom:getQuestByActId(self._act_id) or {}
        --     dump(self._listData)
        --     --self._listView:updateCellNums(#self._listData, false)
        --     self._listView:setCellNums(#self._listData, false)
        -- end
    end
end

--刷新活动
function ActivityCustomLayer:_refreshAct(data)
    dump(" ActivityCustomLayer:_refreshAct(data)!!!!!!!!!!!")
    if self._listView then
        -- local len = #self._listData
        --重新取一下数据
        self._listData = G_Me.activityData.custom:getQuestByActId(self._act_id) or {}

        --print("--------------------------------------------ffff")

        --活动有可能刷新了
        self._activity = G_Me.activityData.custom:getActivityByActId(self._act_id)

        self._listView:updateCellNums(#self._listData, false)
        --self._listView:setCellNums(#self._listData, false)
    end
end

--刷新任务
function ActivityCustomLayer:_refreshActQuest(data)
    dump(" ActivityCustomLayer:_refreshActQuest(data)!!!!!!!!!!!")
    dump(data)
    if self._listView then
        local user_quest = rawget(data,"user_quest") and data.user_quest or {}
        dump(#user_quest)
        if #user_quest > 0 then
            local act_id = user_quest[1].act_id
            self._listData = G_Me.activityData.custom:getQuestByActId(self._act_id) or {}
            dump(act_id)
            --dump(self._activity.act_id)
            if self._activity == nil then
                return
            end
            if act_id == self._activity.act_id then
                --print("--------------------------------------------eeee")

                uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_ACTIVITY_UPDATED, nil, false)
                self._listView:updateCellNums(#self._listData) --, false)
                --self._listView:setCellNums(#self._listData, false)

            else
                --可能也需要更新
                --print("--------------------------------------------ddddd")
                --self:performWithDelay(function()
                    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_ACTIVITY_UPDATED, nil, false)
                    self._listView:updateCellNums(#self._listData) --, false)
                    --self._listView:setCellNums(#self._listData, false)
                --end, 0.25)
            end
        end
    end
    --dump(self._listData)
end

--充值成功刷新红点
function ActivityCustomLayer:_rechargeSuccess()
    --不能在这更新红点 因为更新活动消息还没有下发下来
    --uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_ACTIVITY_UPDATED, nil, false)
    --uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_CUSTOM_ACTIVITY_UPDATE, nil, false)
end


return ActivityCustomLayer