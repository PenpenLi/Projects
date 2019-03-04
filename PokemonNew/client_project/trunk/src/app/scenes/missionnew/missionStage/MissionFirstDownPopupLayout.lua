local MissionFirstDownPopupLayout = class("MissionFirstDownPopupLayout", function ()
    return ccui.Layout:create()
end)

local WidgetTools=require("app.common.WidgetTools")
local Url = require "app.setting.Url"
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"

---=======
---首杀弹窗,
---@data 首杀数据
---=======
function MissionFirstDownPopupLayout:ctor(data)
    assert(type(data) == "table", "invalide data " .. tostring(data))
    self:enableNodeEvents()
    self:setPosition(display.cx, display.cy)
    self._report = data
    self._content = nil
end

function MissionFirstDownPopupLayout:onEnter()
    self._content = cc.CSLoader:createNode(Url:getCSB("MissionFirstDownPopup", "missionnew"))
    self:addChild(self._content)

    local Helper = require("app.common.UpdateNodeHelper")
    local Converter = require("app.common.TypeConverter")
    Helper.updateCommonIconKnightNode(self:getSubNodeByName("Node_hero_avatar"), {
        value = self._report.knight_id,
        type = Converter.TYPE_KNIGHT,    --武将
        levelVisible = false,
        rank = self._report.rank_lv},
        function()
            G_HandlersManager.commonHandler:sendGetCommonBattleUser(self._report.uid , 1)
        end
    )

    ---过滤掉玩家
    local showFormations = {}
    for i = 1, #self._report.formations do
        local formationData = self._report.formations[i]
        if formationData.knight_id ~= self._report.knight_id then
            showFormations[#showFormations + 1] = formationData
        end
    end

     ----显示侠客阵容
    local knightList = self:getSubNodeByName("ListView_knight_list")
    for i = 1, #showFormations do
        local formationData = showFormations[i]
        local knightNode = cc.CSLoader:createNode(Url:getCSB("MissionKnightsItem", "missionnew"))
        local showData = {
            value = formationData.knight_id,
            type = Converter.TYPE_KNIGHT,    --武将
            levelVisible = false,
            nameVisible = false,
            rank = formationData.rank_lv,
            scale = 1}
        Helper.updateCommonIconKnightNode(knightNode:getSubNodeByName("content"), showData)
        local outframe = knightNode:getSubNodeByName("holder")
        knightNode:removeChild(outframe)
        knightList:insertCustomItem(outframe, i - 1)
    end

    self:updateLabel("Label_time_title", G_LangScrap.get("mission_first_down_time_title"))
    self:updateLabel("Text_title", G_LangScrap.get("mission_first_down"))
    self:updateButton("Button_view_report", function ()
        G_HandlersManager.commonHandler:sendGetBattleReport(self._report.report_id)
    end)

    UpdateButtonHelper.updateNormalButton(
        self:getSubNodeByName("Button_confirm"),{
        state = UpdateButtonHelper.STATE_NORMAL,
        desc = G_LangScrap.get("common_btn_close"),
        callback = function ()
            self:removeFromParent(true)
        end
    })

    self:updateButton("Button_close", function ()
        self:removeFromParent(true)
    end)

    self:updateLabel("Label_name", self._report.name)
    self:updateLabel("Label_power_title", G_LangScrap.get("mission_power_word"))
    self:updateLabel("Label_power_value", self._report.power)
    self:updateLabel("Label_date_day", os.date("%Y", self._report.timestamp) .. "/" .. os.date("%m", self._report.timestamp) .. "/" .. os.date("%d", self._report.timestamp))
    self:updateLabel("Label_date_hour", os.date("%X", self._report.timestamp))

    ---添加战报返回
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_GET_BATTLE_REAPORT, self._playReportBattle, self)
end

----播放首杀战斗
function MissionFirstDownPopupLayout:_playReportBattle(reportData)
    local stageId = self._report.id

     uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_CHAPTER_PLAY_BATTLE, nil, false, {
            decodeBuffer = {battle = reportData.battle_report},
            stageId = stageId,
            isFistDownReplay = true
        })
end

function MissionFirstDownPopupLayout:onExit()
    uf_eventManager:removeListenerWithTarget(self)
    self:removeChild(self._content)
end

return MissionFirstDownPopupLayout
