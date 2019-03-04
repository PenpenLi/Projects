
---==================
---阵容招募奖励总览

local RecruitingShowZYAwardSummay = class("RecruitingShowZYAwardSummay", function ()
	return display.newLayer()
end)

local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local EffectMovingNode = require "app.effect.EffectMovingNode"
local EffectNode = require "app.effect.EffectNode"
local UpdateNodeHelper = require "app.common.UpdateNodeHelper" 
local RoundEffectHelper = require "app.common.RoundEffectHelper"
local TypeConverter = require "app.common.TypeConverter"

function RecruitingShowZYAwardSummay:ctor(awards, totalPoint, oneMoreCall)
	self:enableNodeEvents()
	self._view = nil
	self._awards = awards
	self._totalPoint = totalPoint
	self._oneMoreCall = oneMoreCall
    self._brightItems = nil
end

function RecruitingShowZYAwardSummay:onEnter()
	self:_initUI()
end

function RecruitingShowZYAwardSummay:onExit()
	
end

---设置需要被添加流光特效的道具信息
function RecruitingShowZYAwardSummay:setBrightAwards(items)
    self._brightItems = items
end

function RecruitingShowZYAwardSummay:_initUI()
	self._view = cc.CSLoader:createNode(G_Url:getCSB("RecruitingZYAwardSummary", "recruiting"))
	self:addChild(self._view)
	self:setPosition(display.cx, display.cy)

    ---根据奖励数量来调整面板高度。
    local awardCount = #self._awards
    if awardCount > 10 then
        local content = self._view:getSubNodeByName("Panel_content")
        local size = content:getContentSize()
        content:setContentSize(size.width, size.height + 150)
        ccui.Helper:doLayout(content)
    end

	local middleNode = display.newNode()
    middleNode:addChild(display.newSprite(G_Url:getText_system("txt_com_settl_reward02")))

    local effectNode = EffectMovingNode.new("moving_choujiang_hude", function(effect)
        if effect == "txt" then
            return middleNode
        elseif effect == "txt_bg" then
            return self:_createEffectNode("effect_huode_a")
        elseif effect == "txt_shine" then
            return self:_createEffectNode("effect_win_22")
        elseif effect == "frame_line" then
            return self:_createEffectNode("effect_win_1")
        elseif effect == "houzi" then
            return display.newSprite(G_Url:getUI_common("icon_com_role02"))
        end
    end)


    local effectCon = self._view:getSubNodeByName("Node_effect")
    effectNode:play()
    effectNode:setPositionY(140)
    effectCon:addChild(effectNode)

    local awardsCon = self._view:getSubNodeByName("Node_awards")
    local totalWidth = 0
    local collNum = 5 --一行显示5个
    local blankWidth = 10
    local blankHeight = 50
    local awardNodes = {}
    for i = 1, #self._awards do
        local award = self._awards[i]
    	local awardNode, itemSize = self:_getAwardNode(award)
        local totalWidth = (itemSize.width + blankWidth) * (collNum - 1)

        if award.type == TypeConverter.TYPE_KNIGHT then
            local signImg = display.newSprite(G_Url:getText_signet("w_img1_signet26"))
            awardNode:addChild(signImg)
            signImg:setPosition(-25,35)
        end

        awardNode:setPosition(totalWidth * -0.5 + (itemSize.width + blankWidth) * ((i - 1) % collNum), 
            math.floor((i - 1)/collNum) * (itemSize.height + blankHeight) * - 1)
        awardsCon:addChild(awardNode)
    end

	UpdateButtonHelper.updateBigButton(
        self:getSubNodeByName("Button_one_more"),{
        state = UpdateButtonHelper.STATE_ATTENTION,
        desc = G_LangScrap.get("recruiting_zy_one_more"),
        callback = function ()
            self._oneMoreCall()
            self._oneMoreCall = nil
            self:removeFromParent()
        end
    })

    UpdateButtonHelper.updateBigButton(
        self:getSubNodeByName("Button_confirm"),{
        state = UpdateButtonHelper.STATE_NORMAL,
        desc = G_LangScrap.get("common_btn_sure"),
        callback = function ()
            self:removeFromParent()
        end
    })

    self:updateLabel("Text_tips", {
    	text = G_LangScrap.get("recruiting_zy_buy_point_total", {num = self._totalPoint}),
    	outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE
    	})

    local currentPropNum = G_Me.recruitingData:getZYPropNum()
    local needPropOne = G_Me.recruitingData:getZYTenCostProp()
    local buttonOneMore = self._view:getSubNodeByName("Button_one_more")
    local propNode = self._view:getSubNodeByName("Node_item")
    local isEnoughItem = currentPropNum >= needPropOne

    buttonOneMore:updateLabel("Text_item_cost", isEnoughItem and needPropOne or G_Me.recruitingData:getZYTenCost())
    buttonOneMore:updateImageView("Image_item_icon", G_Url:getCommonResIcon(isEnoughItem and "100093" or "100011"))

    propNode:updateLabel("Text_item_value", isEnoughItem and currentPropNum or G_Me.userData.gold)
    propNode:updateImageView("Image_item_icon", G_Url:getCommonResIcon(isEnoughItem and "100093" or "100011"))

    self:_addOutLines("Text_tips", "Text_item_cost", "Text_item_title", "Text_item_value")

    ---给底部按钮添加一个向上的缓动，防止玩家点击过快。
    local bottomNode = self._view:getSubNodeByName("Node_bottom")
    local prePosX, prePosY = bottomNode:getPosition()
    bottomNode:setPosition(prePosX, prePosY - 400)
    bottomNode:runAction(cc.MoveTo:create(0.5, cc.p(prePosX, prePosY)))
end

function RecruitingShowZYAwardSummay:_getAwardNode(award)
    local item, itemSize
    item = cc.CSLoader:createNode(G_Url:getCSB("CommonIconItemNode", "common"))
    itemSize = item:getSubNodeByName("Image_icon_bg"):getContentSize()
    award.disableTouch = true
    award.nameVisible = true
    UpdateNodeHelper.updateCommonIconItemNode(item, award)
    --判断是否要加流光
    for i = 1, #self._brightItems do
        local brightItem = self._brightItems[i]
        if award.type == brightItem.type and award.value == brightItem.value then
            RoundEffectHelper.addCommonIconRoundEffect(item)
            break
        end
    end
    return item, itemSize
end

function RecruitingShowZYAwardSummay:_addOutLines(...)
    local texts = {...}
    for i = 1, #texts do
        local text = texts[i]
        self:updateLabel(text, {
            outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE
        })
    end
end

function RecruitingShowZYAwardSummay:_createEffectNode(effectName, eventHandler, autoRelease)

    local effectNode = EffectNode.new(effectName, eventHandler)
    effectNode:setAutoRelease(autoRelease)
    effectNode:play()

    return effectNode
    
end

return RecruitingShowZYAwardSummay