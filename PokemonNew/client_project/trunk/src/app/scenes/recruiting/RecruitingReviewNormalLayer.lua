--
-- Author: Your Name
-- Date: 2017-06-23 19:59:26
--
------=============
---普通招募预览面板
--====================
local RecruitingReviewBaseLayer = require "app.scenes.recruiting.RecruitingReviewBaseLayer"
local RecruitingReviewNormalLayer = class("RecruitingReviewNormalLayer", RecruitingReviewBaseLayer)
local RecruitingReviewKnightNode = require "app.scenes.recruiting.RecruitingReviewKnightNode"
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local TypeConverter = require "app.common.TypeConverter"
local RecruitingConfigConst = require "app.const.RecruitingConfigConst"
local ItemInfo = require "app.cfg.item_info"
local ParameterInfo = require "app.cfg.parameter_info"
local RecruitingShowNormalSingleLayer = require "app.scenes.recruiting.RecruitingShowNormalSingleLayer"
local RecruitingShowNormalMultyLayer = require "app.scenes.recruiting.RecruitingShowNormalMultyLayer"
local UpdateNodeHelper = require ("app.common.UpdateNodeHelper")


RecruitingReviewNormalLayer.KNIGHT_SHOW_TYPE = 1


function RecruitingReviewNormalLayer:ctor()
	RecruitingReviewNormalLayer.super.ctor(self,1)
    self._cname = "RecruitingReviewNormalLayer1"
    self._titleName = G_Lang.get("recruiting_normal_title")
    self._getmoney = ParameterInfo.get(158).content
end

function RecruitingReviewNormalLayer:onEnter()
    RecruitingReviewNormalLayer.super.onEnter(self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECRUITING_NORMAL_ONCE, self._showNormalGet, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECRUITING_NORMAL_TEN, self._showNormalTenGet, self)

end

function RecruitingReviewNormalLayer:onExit()
    RecruitingReviewNormalLayer.super.onExit(self)
    uf_eventManager:removeListenerWithTarget(self)
end

function RecruitingReviewNormalLayer:_initView()
	RecruitingReviewNormalLayer.super._initView(self)

    UpdateNodeHelper.updateCommonNormalPop(self._view:getSubNodeByName("project_bg"),
        self._titleName,function()
            self:removeFromParent(true)
        end,605)

    local button_once = self._view:getSubNodeByName("Button_once")
    local button_ten = self._view:getSubNodeByName("Button_ten")
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
    -- local discTxt = ccui.RichText:createWithContent(G_LangScrap.get("recruiting_normal_tips"))
    -- discTxt:formatText()
    -- discTxt:setAnchorPoint(0.5, 0)
    -- discCon:addChild(discTxt)

    self:_updateView()
end

function RecruitingReviewNormalLayer:_updateView()
	local itemData = ItemInfo.get(RecruitingConfigConst.NORMAL_PROP_ID)
    local itemNum = G_Me.recruitingData:getNormalPropNum()
    local normalFreeCount = G_Me.recruitingData:getNormalFreeCount()
    local coolingTime = G_Me.recruitingData:getNormalFreeTime()
    local serverTime = G_ServerTime:getTime()
    local isFree = normalFreeCount > 0 and coolingTime <= serverTime

    self:updateLabel("Text_once_cost",G_Lang.get("common_text_progress_value",{num = itemNum,totalNum = 1}))
    self:updateLabel("Text_ten_cost",G_Lang.get("common_text_progress_value",{num = itemNum,totalNum = 10}))
    -- self:updateLabel("Text_zhaoxianling", {
    --     text = G_Lang.get("recruiting_zhaoXian_title",{num = tostring(itemNum)}),
    --     })

    local bottomPanel = self._view:getSubNodeByName("Panel_bottom")
    bottomPanel:setVisible(not isFree)

    -- 消耗免费次数时
    local btnOnceFree = self._view:getSubNodeByName("Button_once_alone")
    btnOnceFree:setVisible(isFree)
end

function RecruitingReviewNormalLayer:_onOneTimeCall()
    
	local normalFreeCount = G_Me.recruitingData:getNormalFreeCount()
    local coolingTime = G_Me.recruitingData:getNormalFreeTime()
    local serverTime = G_ServerTime:getTime()
    local propNum = G_Me.recruitingData:getNormalPropNum()

    local recruitType
    if normalFreeCount > 0 and coolingTime <= serverTime then
        recruitType = RecruitingConfigConst.TYPE_FREE
    elseif propNum > 0 then
        recruitType = RecruitingConfigConst.TYPE_PROP
    else
        G_Popup.tip(G_Lang.get("recruiting_not_enough_prop"))
        return
    end

    print("recruitType",recruitType,propNum,G_Responder.isPackFull(TypeConverter.TYPE_KNIGHT))

    ---检查背包武将是否满
    if not G_Responder.isPackFull(TypeConverter.TYPE_KNIGHT) then
        G_HandlersManager.recruitingHandler:sendRecruitLp(recruitType)
    else
        --G_Popup.tip(G_Lang.get("team_pack_full_tip"))
    end
end

function RecruitingReviewNormalLayer:_onTenTimeCall()
	local propNum = G_Me.recruitingData:getNormalPropNum()
    print("sdfasdfsd",propNum)
    if propNum >= 10 then
        ---检查背包武将是否满
        if not G_Responder.isPackFull(TypeConverter.TYPE_KNIGHT) then
            G_HandlersManager.recruitingHandler:sendRecruitLpTen(RecruitingConfigConst.TYPE_PROP)
        else
            --G_Popup.tip(G_Lang.get("team_pack_full_tip"))
        end
    else
        G_Popup.tip(G_Lang.get("recruiting_not_enough_prop"))
    end
end


function RecruitingReviewNormalLayer:_showNormalGet(param)
    print("1111111111111111111111111")
    dump(param)
    local normalPropNum = G_Me.recruitingData:getNormalPropNum()
    local price = {
        type = TypeConverter.TYPE_ITEM,
        value = RecruitingConfigConst.NORMAL_PROP_ID,
        size = 1}

    if self._showLayer then
        self._showLayer:removeFromParent()
        self._showLayer = nil
    end

    if self._showLayer == nil then
        self._showLayer = RecruitingShowNormalSingleLayer.new()
        self._showLayer:setAwards(param.awards)
        self._showLayer:setProp(price, 1)
        self._showLayer:setBoughtCopper(param.money)
        --self._showLayer:setBoughtCopper(tonumber(self._getmoney))
        self._showLayer:setOneMoreCallback(function ()
            self:_onOneTimeCall()
        end)
        self:_showAwardsLayer()
    else
        self._showLayer:freshView(param.awards)
    end
    
    self:_updateView()
end

function RecruitingReviewNormalLayer:_showNormalTenGet(param)
    print("十十十十十十十十")
    dump(param)
    local normalPropNum = G_Me.recruitingData:getNormalPropNum()
    local priceType = normalPropNum >= 10 and TypeConverter.TYPE_ITEM or TypeConverter.TYPE_GOLD
    local price = {
        type = priceType,
        value = RecruitingConfigConst.NORMAL_PROP_ID,
        size = 10}

    self._showLayer = RecruitingShowNormalMultyLayer.new()
    self._showLayer:setAwards(param.awards)
    self._showLayer:setBoughtCopper(param.money)
    self:_showAwardsLayer()
    self:_updateView()
end

---获取武将展示的类型
function RecruitingReviewNormalLayer:_getKnightShowType()
	return RecruitingReviewNormalLayer.KNIGHT_SHOW_TYPE
end


return RecruitingReviewNormalLayer