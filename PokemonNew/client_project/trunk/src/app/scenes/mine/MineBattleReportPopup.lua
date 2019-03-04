--
-- Author: yutou
-- Date: 2018-09-20 14:23:40
--

local MineBattleReportPopup=class("MineBattleReportPopup",function()
	return display.newNode()
end)

local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local storage = require "app.storage.storage"

function MineBattleReportPopup:ctor(data)
	self:enableNodeEvents()
    self._mineData = G_Me.mineData
    self._data = G_Me.mineData:getBattleList()

	self:_init()
end

function MineBattleReportPopup:_init()
	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("MineBattleReportPopup","mine"))
	-- self._csbNode:setContentSize(display.width,display.height)
	self._csbNode:setPosition(display.cx,display.cy)
	-- ccui.Helper:doLayout(self._csbNode)
	self._csbNode:addTo(self)
	
    UpdateNodeHelper.updateCommonNormalPop(self._csbNode,"战报信息",function ( ... )
        self:removeFromParent(true)
    end,760)

    local listviewBg = self:getSubNodeByName("Panel_con")
    local listViewSize = listviewBg:getContentSize()
    self._btnListView = require("app.ui.WListView").new(listViewSize.width,listViewSize.height, 528, 204)
    self._btnListView:setCreateCell(function(view,idx)
        local cell = require("app.scenes.mine.MineBattleReportCell").new(self)
        return cell
    end)
    self._btnListView:setUpdateCell(function(view,cell,idx)
        cell:updateData(self._data[#self._data - idx],idx)
    end)
    listviewBg:addChild(self._btnListView)
    --------------------------------------------------
    
    --------------------------------------------------

    self:render()
end

function MineBattleReportPopup:render()
    self._btnListView:setCellNums(#self._data, true)
end

--获取战报协议
function MineBattleReportPopup:_onReportBattel( bufferData )
    G_ModuleDirector:pushModule(nil, function()
        return require("app.scenes.mine.MineBattleScene").new(bufferData.battle_report,true,true)
    end)
end

function MineBattleReportPopup:onEnter()
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_GET_BATTLE_REAPORT, self._onReportBattel, self)
end

function MineBattleReportPopup:onExit()
    if self._data and #self._data > 0 and self._data[#self._data] then
        
        storage.save(storage.rolePath("MineBattleReportLastTime"), {
            time = self._data[#self._data]:getTime()
        })
    end
	uf_eventManager:removeListenerWithTarget(self)
end

function MineBattleReportPopup:onCleanup()
	
end

return MineBattleReportPopup