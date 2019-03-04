--
-- Author: YouName
-- Date: 2016-02-03 14:07:48
--
local PkLogCell = require("app.scenes.common.PkLog.PkLogCell")
local MatchPkLogCell=class("MatchPkLogCell",PkLogCell)

function MatchPkLogCell:ctor(listView)
	self._listView = listView
	local csbNode = cc.CSLoader:createNode("csb/match/common/MatchPkLogCell.csb")
	self:addChild(csbNode)
	self.csbNode = csbNode

	-- self._exNode = cc.CSLoader:createNode("csb/match/common/PkLogCellEx.csb")
	-- self:addChild(self._exNode)
	self:_init()
end

function MatchPkLogCell:_init()
	MatchPkLogCell.super._init(self)
	self._btnExt = self.csbNode:getSubNodeByName("Button_extend")
	self._btnExt:setVisible(false)
	-- self._imgReset = self.csbNode:getSubNodeByName("Image_reset")
	-- self._imgEx = self.csbNode:getSubNodeByName("Image_extend") 
	-- self._btnExt:addClickEventListenerEx(function( ... )
	-- 	self._listView:switchExtend(self._cellIdx)
	-- end)
end

function MatchPkLogCell:_render( cellData,cellIdx)
	self._cellIdx = cellIdx
	self._panel_touch:setVisible(true)
	-- self:_renderExtend()
end

-- -- 重置
-- function MatchPkLogCell:adaptForAction()
-- 	self.csbNode:setPositionY(0)
-- 	self._exNode:setPositionY(0)
-- 	self._imgReset:setVisible(false)
-- 	self._imgEx:setVisible(true)
-- 	self._exNode:setVisible(false)
-- end

-- -- 展开
-- function MatchPkLogCell:runCellOpenAction()
-- 	self._imgReset:setVisible(true)
-- 	self._imgEx:setVisible(false)
-- 	self._exNode:setVisible(true)
-- 	self.csbNode:setPositionY(self._listView:getChangeHeight())
-- 	self._exNode:setPositionY(self._listView:getChangeHeight())
-- end

-- -- 关闭
-- function MatchPkLogCell:runCellCloseAction()
-- 	self._imgReset:setVisible(false)
-- 	self._imgEx:setVisible(true)
-- 	self._exNode:setVisible(false)
-- 	self.csbNode:setPositionY(0)
-- 	self._exNode:setPositionY(0)
-- end

-- function MatchPkLogCell:_renderExtend()
	
-- end

return MatchPkLogCell