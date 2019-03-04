local MissionResetPopupLayout = class("MissionResetPopupLayout", function ()
	return ccui.Layout:create()
end)

local Responder = require("app.responder.Responder")
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"

----==============
----重置关卡弹窗
----==============
function MissionResetPopupLayout:ctor(stageId)
	assert(type(stageId) == "number", "invalide stageId " .. tostring(stageId))

	self:enableNodeEvents()
	self._cost = 0
	local content = cc.CSLoader:createNode(G_Url:getCSB("MissionResetStagePopup", "missionnew"))
	self:addChild(content)
	self:setPosition(display.cx, display.cy)

	self:updateLabel("Text_title", G_LangScrap.get("mission_system_tips"))
	self:updateLabel("Label_cost", G_LangScrap.get("mission_will_you_cost"))
	self:updateLabel("Label_reset", G_LangScrap.get("mission_reset_stage"))
	
	UpdateButtonHelper.updateNormalButton(
        self:getSubNodeByName("Button_cancel"),{
        state = UpdateButtonHelper.STATE_NORMAL,
        desc = G_LangScrap.get("common_btn_cancel"),
        callback = function ()
            self:removeFromParent()
        end
    })

	UpdateButtonHelper.updateNormalButton(
        self:getSubNodeByName("Button_confirm"),{
        state = UpdateButtonHelper.STATE_ATTENTION,
        desc = G_LangScrap.get("common_btn_sure"),
        callback = function ()
            Responder.enoughGold(self._cost, function ()
				G_HandlersManager.chapterHandler:sendResetStage(stageId)
			end)
			self:removeFromParent()
        end
    })

    
    self:updateButton("Button_close", function ()
    	self:removeFromParent()
    end)
end

----设置显示数据
function MissionResetPopupLayout:setData(cost, timeLast, totalTime)
	assert(type(cost) == "number", "invalide cost " .. tostring(cost))
	assert(type(timeLast) == "number", "invalide timeLast " .. tostring(timeLast))
	assert(type(totalTime) == "number", "invalide totalTime " .. tostring(totalTime))
	self._cost = cost
	self:updateLabel("Label_cost_value", cost)
	self:updateLabel("Label_reset_times", G_LangScrap.get("mission_you_can_reset_today", {times = timeLast, total = totalTime}))
end


return MissionResetPopupLayout