local EventMsgID = require("app.network.EventMsgID")
local TabButtonsHelper = require("app.common.TabButtonsHelper")

local MatchPureBg=class("MatchPureBg",function()
	return display.newNode()
end)

MatchPureBg.TAB_MAX = 4

function MatchPureBg:ctor()
	self:enableNodeEvents()

    self._data = G_Me.matchData
	self:_init()
end

function MatchPureBg:_init()
	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("MatchPureBg","match/common"))
	self._csbNode:setContentSize(display.width,display.height)
	self._csbNode:setPosition(0,0)
	ccui.Helper:doLayout(self._csbNode)
	self._csbNode:addTo(self)

	-- self:initTabBtns()
end

--初始化页签
function MatchPureBg:updateTabBtns()
    local nodeTabButtons = self:getSubNodeByName("Node_tabs_con")

    --tab页签按钮数组
    local tabs = {}
    for i = 1,MatchPureBg.TAB_MAX do
        local noOpen = nil
        local noOpenTips = nil
        if i == 3 then
            local data = self._data:getDataByType(3)
            if data == nil then
                noOpen= true
                noOpenTips=G_Lang.get("match_tab_noopen_tip_"..i)
            else
                if data:getAllPlayer() <= 4 then
                    noOpen= true
                    noOpenTips=G_Lang.get("match_tab_noopen_tip_5")
                else
                    noOpen = false
                end
            end
        elseif i == 4 then
            local data = self._data:getDataByType(3)
            if data == nil then
                noOpen= true
                noOpenTips=G_Lang.get("match_tab_noopen_tip_"..i)
            else
                if data:findBetterRandNum(nil,4) >= 4 then
                    noOpen= false
                else
                    noOpen= true
                    noOpenTips=G_Lang.get("match_tab_noopen_tip_"..i)
                end
            end
        else
            noOpen= self._data:getDataByType(i) == nil
            noOpenTips=G_Lang.get("match_tab_noopen_tip_"..i)
        end
        tabs[i] =  {
                text = G_Lang.get("match_tab_"..i),
                noOpen= noOpen,
                noOpenTips=noOpenTips
            }
    end

    local params = {
        tabs = tabs,
        bgWidth = 640,
        tabsOffsetX = 69,
        gap = 4
    }

    self._tabButtons = TabButtonsHelper.updateTabButtons(
        nodeTabButtons,params,handler(self,self._onTabChange))
    
    if self._curTabIndex == nil then
        self._tabButtons.setSelected(1)
    end

    self._csbNode:getSubNodeByName("Button_back"):addClickEventListenerEx(function( ... )
        G_ModuleDirector:popModule()
    end)
    
    self:updateButton("Button_help", {
    callback = function ( ... )
        G_Popup.newHelpPopup(G_FunctionConst.NAME_MATCH)
    end})
end

function MatchPureBg:setSelected( tabIndex )
    self._tabButtons.setSelected(tabIndex)
end

function MatchPureBg:_onTabChange(tabIndex)
    self._curTabIndex = tabIndex or 1
	uf_eventManager:dispatchEvent(EventMsgID.EVENT_MATCH_TABCHANGE,nil,false,tabIndex)
end

function MatchPureBg:onEnter()
end

function MatchPureBg:onExit()
	uf_eventManager:removeListenerWithTarget(self)
end

function MatchPureBg:onCleanup( ... )
	
end

return MatchPureBg