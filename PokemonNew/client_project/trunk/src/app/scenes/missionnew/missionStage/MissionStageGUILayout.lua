
local MissionStageGUILayout = class("MissionStageGUILayout", function ()
	return ccui.Layout:create()
end)
local MissionTimeLimite = require("app.scenes.missionnew.common.MissionTimeLimite")

local ChapterConfigConst = require("app.const.ChapterConfigConst")
---===================
---关卡界面的GUI
---@missionId 章节ID
---===================
function MissionStageGUILayout:ctor(missionId)
    assert(type(missionId) == "number", "invalide missionId " .. tostring(missionId))
	self._missionId = missionId
    G_Me.allChapterData:setStageLastEnterdById(self._missionId)
	self:enableNodeEvents()
    self._inited = false
end

function MissionStageGUILayout:addListeners()
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAPTER_SHOW_UI, self._showUI, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAPTER_HIDE_BOX_AND_RANK, self._hideBoxAndRank, self)
end

function MissionStageGUILayout:removeListenrs()
    uf_eventManager:removeListenerWithTarget(self)
end

function MissionStageGUILayout:_showUI(param)
    if self._inited then return end
    ---宝箱
    self._tray = require("app.scenes.missionnew.star.MissionBoxTrayLayout").new(self._missionId)
    self:addChild(self._tray)
    self._tray:setAnchorPoint(0,0)
    local posx = display.width - self._tray:getSize().width - 10
    self._tray:setPosition(posx, -600)
    local actionBot = cc.MoveTo:create(0.4, cc.p(posx, 10))
    actionBot = cc.Sequence:create(cc.DelayTime:create(0.3),cc.EaseBackOut:create(actionBot))
    self._tray:runAction(actionBot)

    ---星数总览
    self._totalStarNode = cc.CSLoader:createNode(G_Url:getCSB("MissionStageStarAmountNode", "missionnew"))
    self._tray:addChild(self._totalStarNode)
    self._totalStarNode:setPosition(382, 23)
    -- local actionBot = cc.MoveTo:create(0.4, cc.p(400,33))
    -- actionBot = cc.Sequence:create(cc.DelayTime:create(0.3),cc.EaseBackOut:create(actionBot))
    -- self._totalStarNode:runAction(actionBot)
    self:_freshStarNums()

    --标题
    local chapterData = G_Me.allChapterData:getChapterDataById(self._missionId)
    self._labelBg = ccui.ImageView:create(G_Url:getUI_common("shade/img_shade_mission01")) --display.newScale9Sprite(G_Url:getUI_common("shade/img_shade_mission01"),0,0,cc.size(260, 47),cc.rect(10,10,10,10))
    self:addChild(self._labelBg)
    self._labelBg:setAnchorPoint(0,0)
    self._labelBg:setPosition(-4, display.top - 116)
    self._label = display.newTTFLabel({size=24, font = G_Path.getNormalFont(), text =
        G_Lang.get("mission_chapter_title", {num = G_Me.allChapterData:getChapterOrderById(self._missionId), title = chapterData:getCfgInfo().name})}):addTo(self)
    self._label:setColor(G_ColorsScrap.COLOR_SCENE_DESC_NORMAL)
    self._label:setAnchorPoint(0,0)
    self._label:setPosition(14, display.top - 103)

    --返回
    self._buttonBack = cc.CSLoader:createNode(G_Url:getCSB("CommonBackNode", "common"))
    self._buttonBack:align(display.RIGHT_TOP , display.width - 68, display.height - 89)
    self:addChild(self._buttonBack, 100)
    self:updateButton("Button_back",function ()
        G_ModuleDirector:popModule()
    end)

    ---排行榜按钮
    self._btnRank= cc.CSLoader:createNode(G_Url:getCSB("MissionStarRankNode", "missionnew"))
    self._btnRank:setAnchorPoint(0,0)
    self._btnRank:setPosition(25, 15)
    self:addChild(self._btnRank)
    self._btnRank:updateButton("Button_rank", function()
        G_ModuleDirector:pushModule(G_FunctionConst.FUNC_RANK, function()
            local RankConst = require("app.scenes.rank.RankConst")
            local cp_index_map = {
                [ChapterConfigConst.NORMAL_CHAPTER] = RankConst.RANK_MAIN,--普通副本
                [ChapterConfigConst.ELITE_CHAPTER] = RankConst.RANK_ELITE,--精英副本
                [ChapterConfigConst.NIGHTMARE_CHAPTER] = RankConst.RANK_NIGHTMARE,--噩梦
            }
            local index = cp_index_map[chapterData:getCfgInfo().type]
            return require("app.scenes.rank.RankSence").new(index)
        end)
        -- 到时候会跳到总榜
        -- local RankPop = require("app.popup.Popup")
        -- RankPop.newPopup(function ()
        --     local popWindow = require("app.scenes.missionnew.star.MissionStarRankLayout"):new()
        --     popWindow:setMissionType(ChapterConfigConst.NORMAL_CHAPTER)
        --     return popWindow, function(event, node)
        --         if event == "onPopupFinish" then
        --             popWindow:onPopupFinish()
        --         end
        --     end
        -- end)
    end)
    -- self._btnRank:updateLabel("Text_title", {
    --     outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
    --     text = G_LangScrap.get("common_icon_star_rank")
    -- })

    if chapterData:getCfgInfo().type == ChapterConfigConst.NIGHTMARE_CHAPTER then
        self._missionTimeLimite = MissionTimeLimite.new()
        self:addChild(self._missionTimeLimite,1000)
        self._missionTimeLimite:setPosition(
            display.width - self._missionTimeLimite:getContentSize().width,
            display.height - 265
        )
    end

    self._inited = true
end

function MissionStageGUILayout:_freshStarNums()
    local chapterData = G_Me.allChapterData:getChapterDataById(self._missionId)
    self._totalStarNode:updateLabel("Label_star_num", 
        {text = tostring(chapterData:getCurrentStar()) .. "/" .. tostring(G_Me.allChapterData:getChpaterAllStar(chapterData:getId())),
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
        outlineSize = 2
    })
end

function MissionStageGUILayout:onEnter()
    print("MissionStageGUILayout:onEnter")
end

function MissionStageGUILayout:_hideBoxAndRank()
    --dump(self._inited)
    if not self._inited then
        return
    end
    self._btnRank:setVisible(false)
    self._tray:setVisible(false)
    self._label:setVisible(false)
    self._labelBg:setVisible(false)
    self._buttonBack:setVisible(false)
    self._totalStarNode:setVisible(false)
end

return MissionStageGUILayout