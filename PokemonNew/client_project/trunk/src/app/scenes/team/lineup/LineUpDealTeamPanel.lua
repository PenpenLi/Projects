--
-- Author: Yutou
-- Date: 2017-02-14 11:12:51
--
-- 三个按钮选择面板
local LineUpDealTeamPanel = class("LineUpDealTeamPanel",function()
	return display.newNode()
end)

LineUpDealTeamPanel.DEL = "del"--放弃
LineUpDealTeamPanel.RE = "re"--重置
LineUpDealTeamPanel.CHANGE = "change"--更改图标
LineUpDealTeamPanel.FASHION = "fashion"--时装
local shader =  require("app.common.ShaderUtils")


function LineUpDealTeamPanel:ctor(callBack,switchBack)
	self._callBack = callBack--回调函数
	self._switchBack = switchBack--回调函数

	self._csb = cc.CSLoader:createNode("csb/team/lineup/LineUpDeal.csb")
	self._csb:addTo(self)

	local panel_deal = self._csb:getSubNodeByName("Panel_deal")
	self:setContentSize(panel_deal:getContentSize())


	self._btnDel = self._csb:getSubNodeByName("Button_del")
	self._btnRe = self._csb:getSubNodeByName("Button_reset")
	self._btnChange = self._csb:getSubNodeByName("Button_change_info")
	self._btnFashion = self._csb:getSubNodeByName("Button_fashion")

	self:addEvent()
end

function LineUpDealTeamPanel:updateDeal(teamId)
	self._btnDel:setEnabled(teamId ~= 0)
	self._btnRe:setEnabled(teamId ~= 0)
	self._btnChange:setEnabled(teamId ~= 0)
	if teamId == 0 then
    	shader.applyGrayFilter(self._btnDel)
    	shader.applyGrayFilter(self._btnRe)
    	shader.applyGrayFilter(self._btnChange)
    else
    	shader.removeFilter(self._btnDel)
    	shader.removeFilter(self._btnRe)
    	shader.removeFilter(self._btnChange)
	end
end

function LineUpDealTeamPanel:addEvent( ... )
	self._btnDel:addClickEventListenerEx(function(sender)
		self._callBack(LineUpDealTeamPanel.DEL)
		self._switchBack()
		--self:removeFromParent()
	end)
	self._btnRe:addClickEventListenerEx(function(sender)
		self._callBack(LineUpDealTeamPanel.RE)
		self._switchBack()
		--self:removeFromParent()
	end)
	self._btnChange:addClickEventListenerEx(function(sender)
		self._callBack(LineUpDealTeamPanel.CHANGE)
		self._switchBack()
		--self:removeFromParent()
	end)
	self._btnFashion:addClickEventListenerEx(function(sender)
		self._callBack(LineUpDealTeamPanel.FASHION)
		self._switchBack()
		--self:removeFromParent()
	end)
end

return LineUpDealTeamPanel