--ActivityWealLayer.lua

--[====================[

    福利活动layer
    
]====================]


local ActivityWealLayer = class("ActivityWealLayer", function()
    return ccui.Layout:create()
end)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local ActivityConst = require("app.const.ActivityConst")
local ActivityUIHelper = require("app.scenes.activity.ActivityUIHelper")


function ActivityWealLayer:ctor(act_id)

    self._activity = G_Me.activityData.custom:getActivityByActId(act_id)       --活动数据
    self._act_id = act_id or 0

    self._csbNode = nil       

    self:enableNodeEvents()

end


function ActivityWealLayer:onEnter()

    self:_initUI()

end


function ActivityWealLayer:updatePage( activity )

    if type(activity) ~= "table" then return end

    self._activity = activity.data
   
    ActivityUIHelper.updateBaseInfo(self._csbNode, self._activity, true)

    self._csbNode:updateLabel("Text_start", {
    	color = G_ColorsScrap.COLOR_POPUP_DESC_NORMAL,
        --outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
        outlineSize = 2})
    self._csbNode:updateLabel("Text_end", {
    	color = G_ColorsScrap.COLOR_POPUP_DESC_NORMAL,
        --outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
        outlineSize = 2})

    self._csbNode:updateLabel("Text_startTime", {
    	color = G_ColorsScrap.COLOR_POPUP_DESC_NOTE,  
        --outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
        outlineSize = 2})
    self._csbNode:updateLabel("Text_endTime", {
    	color = G_ColorsScrap.COLOR_POPUP_DESC_NOTE,  
        --outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
        outlineSize = 2})

    self._csbNode:updateLabel("Text_desc", {
    	color = G_ColorsScrap.COLOR_POPUP_DESC_NORMAL,
        --outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
        outlineSize = 2})

    self._csbNode:updateLabel("Text_title", { 
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
        fontSize = 28,
        outlineSize = 2})

end


function ActivityWealLayer:onExit()

    uf_eventManager:removeListenerWithTarget(self)

    if self._csbNode ~= nil then
        self._csbNode:removeFromParent(true)
        self._csbNode = nil
    end

end

function ActivityWealLayer:_initUI()

    self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("ActivityWealLayer","activity"))
    self:addChild(self._csbNode)
    self._csbNode:setContentSize(display.width, display.height)
    ccui.Helper:doLayout(self._csbNode)

    UpdateButtonHelper.updateNormalButton(self._csbNode:getSubNodeByName("Button_goto"), {
        state = UpdateButtonHelper.STATE_ATTENTION,
        desc = G_LangScrap.get("common_btn_go_to"),
        callback = function()
            self:_onGoToButton()
        end
    })


    local npcPanel = self._csbNode:getSubNodeByName("Panel_npc")
    local panelSize = npcPanel:getContentSize()

    --local npcRankInfo = require("app.cfg.knight_rank_info").get(3523,2)

    local knightImage = require("app.common.KnightImg").new(21301,0,0)---npcRankInfo.res_id)
    knightImage:setScale(1.2)
    knightImage:setAnchorPoint(cc.p(0.5, 0))
    knightImage:setPosition(cc.p(panelSize.width*0.45,50))
    npcPanel:addChild(knightImage,-1)

    self:performWithDelay(function ( ... )
        knightImage:setAniTimeScale(0)
    end, 0.05)

end


--前往按钮
function ActivityWealLayer:_onGoToButton()
    
    local questList = G_Me.activityData.custom:getQuestByActId(self._act_id, true) or {}

    local quest = (#questList > 0) and questList[1] or nil

    ActivityUIHelper.gotoModule(quest)

end


return ActivityWealLayer