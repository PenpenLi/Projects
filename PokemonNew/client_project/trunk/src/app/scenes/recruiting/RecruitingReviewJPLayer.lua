--
-- Author: Your Name
-- Date: 2017-06-24 16:33:41
------=============
---高级招募预览面板
--====================
local RecruitingReviewBaseLayer = require "app.scenes.recruiting.RecruitingReviewBaseLayer"
local RecruitingReviewJPLayer = class("RecruitingReviewJPLayer", RecruitingReviewBaseLayer)
local RecruitingReviewKnightNode = require "app.scenes.recruiting.RecruitingReviewKnightNode"
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local TypeConverter = require "app.common.TypeConverter"
local RecruitingConfigConst = require "app.const.RecruitingConfigConst"
local ItemInfo = require "app.cfg.item_info"
local ShopScoreInfo = require "app.cfg.shop_score_info"
local UpdateNodeHelper = require ("app.common.UpdateNodeHelper")


local RecruitingShowNormalSingleLayer = require "app.scenes.recruiting.RecruitingShowNormalSingleLayer"
local RecruitingShowNormalMultyLayer = require "app.scenes.recruiting.RecruitingShowNormalMultyLayer"

RecruitingReviewJPLayer.KNIGHT_SHOW_TYPE = 2
local RECRUITING_ONCE = 1
local RECRUITING_TEN = 2

function RecruitingReviewJPLayer:ctor()
    self:setName("RecruitingReviewJPLayer")
	RecruitingReviewJPLayer.super.ctor(self,2)
    self._cname = "RecruitingReviewJPLayer1"
    self._titleName = G_Lang.get("recruiting_high_level_title")
    self._isWaittingServer = false
	self._goldOneTimeCost = G_Me.recruitingData:getJPCost()
	self._goldTenTimeCost = G_Me.recruitingData:getJPTenCost()
end

function RecruitingReviewJPLayer:onEnter()
    RecruitingReviewJPLayer.super.onEnter(self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECRUITING_JP_ONCE, self._showJPGet, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECRUITING_JP_TEN, self._showJPTenGet, self)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,203)
    print("EVENT_GUIDE_STEPEVENT_GUIDE_STEPEVENT_GUIDE_STEP11",203)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1528)

end

function RecruitingReviewJPLayer:onExit()
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1531)
    RecruitingReviewJPLayer.super.onExit(self)
    uf_eventManager:removeListenerWithTarget(self)

    if self._effectBackground then
        self._effectBackground:removeFromParent()
        self._effectBackground = nil
    end

end
    
function RecruitingReviewJPLayer:_initView()
	RecruitingReviewJPLayer.super._initView(self)

    UpdateNodeHelper.updateCommonNormalPop(self._view:getSubNodeByName("project_bg"),
        self._titleName,function()
            self:removeFromParent(true)
        end,630)
	
	local button_once = self._view:getSubNodeByName("Button_once")
    --button_once:setTag(RECRUITING_ONCE)
    local button_ten = self._view:getSubNodeByName("Button_ten")
    --button_ten:setTag(RECRUITING_TEN)
    local button_free = self._view:getSubNodeByName("Button_once_alone")

    UpdateButtonHelper.reviseButton(button_once,{isBig = true})
    UpdateButtonHelper.reviseButton(button_ten,{isBig = true})
    UpdateButtonHelper.reviseButton(button_free,{isBig = true})

    button_once:addClickEventListenerEx((handler(self,self._onOneTimeCall)))
    button_free:addClickEventListenerEx((handler(self,self._onOneTimeCall)))
	button_ten:addClickEventListenerEx((handler(self,self._onTenTimeCall)))
   
    local mid_panel = self:getSubNodeByName("Panel_mid")
    mid_panel:getChildByName("Image_nameBg"):setVisible(false)
    local zhaoXianLing = mid_panel:getChildByName("Text_zhaoxianling")
	
    -- local discCon = self:getSubNodeByName("Node_tips")
    -- local discTxt = ccui.RichText:createWithContent(G_LangScrap.get("recruiting_jp_tips"))
    -- discTxt:formatText()
    -- discTxt:setAnchorPoint(0.5, 0)
    -- discCon:addChild(discTxt)

    self:_updateView()
end

function RecruitingReviewJPLayer:_updateView()
	local itemData = ItemInfo.get(RecruitingConfigConst.SS_PROP_ID)
    local ssNum = G_Me.recruitingData:getJPPropNum() --史诗级
    local csNum = G_Me.recruitingData:getCSPropNum() --传说级
    local JpFreeCount = G_Me.recruitingData:getJpFreeCount()
    local coolingTime = G_Me.recruitingData:getJpFreeTime()
    local serverTime = G_ServerTime:getTime()
    local isFree = JpFreeCount > 0 and coolingTime <= serverTime

    self:updateLabel("Text_once_cost",G_Lang.get("common_text_progress_value",{num = ssNum,totalNum = 1}))
    self:updateLabel("Text_ten_cost",G_Lang.get("common_text_progress_value",{num = csNum,totalNum = 1}))

    -- self:updateLabel("Text_zhaoxianling", {
    --     text = G_Lang.get("recruiting_ss_title",{num = tostring(itemNum)}),
    --     })

    local bottomPanel = self._view:getSubNodeByName("Panel_bottom")
    bottomPanel:setVisible(not isFree)

    -- 消耗免费次数时
    local btnOnceFree = self._view:getSubNodeByName("Button_once_alone")
    btnOnceFree:setVisible(isFree)

    self:_updateTimes()
end

function RecruitingReviewJPLayer:_updateTimes()
    --再次购买x次提示
    local recruitedTimes = G_Me.recruitingData:getJpRecruitedTimes()
    local roundTime = RecruitingConfigConst.THE_JP_ROUND_TIME
    local restTimes = roundTime - recruitedTimes
    local color = restTimes > 5 and G_Colors.getColor(104) or G_Colors.getColor(101)
    local outlineColor = restTimes > 5 and G_Colors.getOutlineColor(104) or G_Colors.getOutlineColor(101)
    self:updateLabel("Text_times", {
        text = tostring(restTimes),
        textColor = color,
        outlineColor = outlineColor
        })
end

--@type once or ten
function RecruitingReviewJPLayer:_showTips(tag)
    local content,callback,cost = nil,nil,nil
    if tag == RECRUITING_ONCE then
        cost = G_Me.recruitingData:getJPCost() -- 史诗级招将令
        content = G_Lang.get("recruiting_once_cost")
        callback = function()
            local recruitType = RecruitingConfigConst.TYPE_GOLD
            G_Responder.enoughGold(cost, function()
                ---检查背包武将是否满
                if not G_Responder.isPackFull(TypeConverter.TYPE_KNIGHT) then
                    G_HandlersManager.recruitingHandler:sendRecruitJp(recruitType)
                    self._isWaittingServer = true
                else
                    --G_Popup.tip(G_Lang.get("team_pack_full_tip"))
                end
            end)
        end
    elseif tag == RECRUITING_TEN then
        cost = G_Me.recruitingData:getJPTenCost() -- 传说级招将令
        content = G_Lang.get("recruiting_ten_cost")
        callback = function()
            ---检查背包武将是否满
            G_Responder.enoughGold(cost,function()
                if not G_Responder.isPackFull(TypeConverter.TYPE_KNIGHT) then
                    G_HandlersManager.recruitingHandler:sendRecruitJpTen(RecruitingConfigConst.TYPE_GOLD)
                    self._isWaittingServer = true
                else
                    --G_Popup.tip(G_Lang.get("team_pack_full_tip"))
                end
            end)
        end
    end
    
    if content == nil or callback == nil then
        return
    end

    local jsonStr = G_Lang.get("recruiting_use_gold_tips",{
        con1_color = G_Colors.colorToNumber(G_Colors.getColor(2)),
        img_path = G_Url:getCommonResIcon("100011"),
        img_color = G_Colors.colorToNumber(G_Colors.getColor(11)),
        goldNum = tostring(cost),
        goldColor = G_Colors.colorToNumber(G_Colors.getColor(3)),
        con2 = content,
        con2Color = G_Colors.colorToNumber(G_Colors.getColor(2)),
        })

    --dump(jsonStr)
    require("app.common.ConfirmAlert").createConfirmRichText(nil,jsonStr,callback,nil,nil,90)



    --require("app.common.ConfirmAlert").createConfirmText(nil,content,callback)
    --require("app.scenes.recruiting.RecruitingConfirmPop").create(content,callback)
    --callback()
end

function RecruitingReviewJPLayer:_onOneTimeCall(isMustUseItem)

    if self._isWaittingServer then return end
    local JpFreeCount = G_Me.recruitingData:getJpFreeCount()
    local coolingTime = G_Me.recruitingData:getJpFreeTime()
    local serverTime = G_ServerTime:getTime()
    local isFree = JpFreeCount > 0 and coolingTime <= serverTime

    local needGold = G_Me.recruitingData:getJPCost()

    local recruitType
    if isFree then
        recruitType = RecruitingConfigConst.TYPE_FREE
    else
        local jpPropNum = G_Me.recruitingData:getJPPropNum()
        if jpPropNum > 0 then
            recruitType = RecruitingConfigConst.TYPE_PROP
        else
            self:_showTips(RECRUITING_ONCE)
            return
        end
    end
     ---检查背包武将是否满
    if not G_Responder.isPackFull(TypeConverter.TYPE_KNIGHT) then
        G_HandlersManager.recruitingHandler:sendRecruitJp(recruitType)
        self._isWaittingServer = true
    end
    
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,203)
    print("EVENT_GUIDE_STEPEVENT_GUIDE_STEPEVENT_GUIDE_STEP00",203)
    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false,1528)
end

function RecruitingReviewJPLayer:_onTenTimeCall(useProp)
    print("hhhhhhh",self._isWaittingServer)
    if self._isWaittingServer then return end

    --传说级抽奖令
	local csPropNum = G_Me.recruitingData:getCSPropNum()

     if csPropNum > 0 then
        if not G_Responder.isPackFull(TypeConverter.TYPE_KNIGHT) then
                G_HandlersManager.recruitingHandler:sendRecruitJpTen(RecruitingConfigConst.TYPE_PROP)
                self._isWaittingServer = true
        end
     else
        self:_showTips(RECRUITING_TEN)
        -- G_Responder.enoughGold(needGold,function()
        --     ---检查背包武将是否满
        --     if not G_Responder.isPackFull(TypeConverter.TYPE_KNIGHT) then
        --         G_HandlersManager.recruitingHandler:sendRecruitJpTen(RecruitingConfigConst.TYPE_GOLD)
        --         self._isWaittingServer = true
        --     end
        -- end)
     end
end

function RecruitingReviewJPLayer:_showJPGet(param)
    local jpPropNum = G_Me.recruitingData:getJPPropNum()
    local isMustUseItem = jpPropNum > 0 ---是否这次连抽必须使用道具(改为必须使用道具)
    --local priceType = isMustUseItem and TypeConverter.TYPE_ITEM or TypeConverter.TYPE_GOLD
    local priceType = TypeConverter.TYPE_ITEM
    local callSize = priceType == TypeConverter.TYPE_ITEM and 1 or self._goldOneTimeCost
    local price = {
        type = priceType,
        value = RecruitingConfigConst.SS_PROP_ID,
        size = callSize}

    --uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false)
    local money = G_Me.recruitingData:getJPoneMoney()
    if self._showLayer then
        self._showLayer:removeFromParent()
        self._showLayer = nil
    end
    if self._showLayer == nil then
        self._showLayer = RecruitingShowNormalSingleLayer.new()
        self._showLayer:setAwards(param.awards)
        self._showLayer:setProp(price, callSize)
        self._showLayer:setBoughtCopper(param.money)
        self._showLayer:setOneMoreCallback(function ()
            self:_onOneTimeCall(isMustUseItem)
        end)
        self:_showAwardsLayer()
    else
        --self._showLayer:freshView(param.awards)
    end

    self:_updateView()
    self._isWaittingServer = false
end


function RecruitingReviewJPLayer:_showJPTenGet(param)
    local price = {
        type = TypeConverter.TYPE_GOLD,
        value = RecruitingConfigConst.SS_PROP_ID,
        size = G_Me.recruitingData:getJPTenCost()}

    self._showLayer = RecruitingShowNormalMultyLayer.new()
    self._showLayer:setAwards(param.awards)
    self._showLayer:setBoughtCopper(param.money)
    self:_showAwardsLayer()

    self:_updateView()
    self._isWaittingServer = false
end

---获取武将展示的类型
function RecruitingReviewJPLayer:_getKnightShowType()
	return RecruitingReviewJPLayer.KNIGHT_SHOW_TYPE
end

return RecruitingReviewJPLayer