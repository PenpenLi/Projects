--
-- Author: yutou
-- Date: 2019-01-16 16:55:19
--
local SoulPossessionSelectLayer=class("SoulPossessionSelectLayer",function()
	return cc.Layer:create()
end)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local StageListItem = require("app.scenes.maxChallenge.common.StageListItem")
local ConfirmAlert = require("app.common.ConfirmAlert")

function SoulPossessionSelectLayer:ctor(layer,callBack)
	-- body
	self:enableNodeEvents()
	self._csbNode = nil
	self._curLayer = layer
	self._callBack = callBack

	self._inited = false
end

function SoulPossessionSelectLayer:init()
	if self._inited then
		return
	end
	self._max_layer = G_Me.soulPossessionData:getMaxStage()
	self._inited = true
	self:_initUI()
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MAX_CHALLENGE_ENTER_STAGE,self._enterStage,self)
	-- uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_TOMB_START,self._startStage,self)--
	-- G_HandlersManager.tombHandler:sendChapterList()
end

--UI界面初始化
function SoulPossessionSelectLayer:_initUI()
	-- 排版
	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("SoulPossessionSelectLayer","soulPossession"))
	self:addChild(self._csbNode)
	self._csbNode:setContentSize(display.width,display.height)
	ccui.Helper:doLayout(self._csbNode)

	--------------------list  start
	--self._listNum = G_Me.maxChallengeData:getStageListNum()
	--self._listNum = self._listNum/4
	self._listNum = self._max_layer%4 == 0 and self._max_layer/4 or self._max_layer/4 + 1
	local curLine = self._curLayer%4 == 0 and self._curLayer/4 or self._curLayer/4 + 1
	local listCon = self._csbNode:getSubNodeByName("Panel_list")
	
	self._btn_back = self._csbNode:getSubNodeByName("Button_back")
	G_CommonUIHelper.FixBackNode(self._csbNode:getSubNodeByName("FileNode_back"))
	local bg= self._csbNode:getSubNodeByName("Sprite_bg")
    G_WidgetTools.autoTransformBg(bg)

	local listSize = listCon:getContentSize()
	self._viewList = require("app.ui.WListView").new(listSize.width, listSize.height, listSize.width, 60, true)
    self._viewList:setFirstCellPaddigTop(5)
    self._viewList:setCreateCell(function(view, idx)
        local cell = StageListItem.new(listSize.width,handler(self, self._onEnterCallback))
        return cell
    end)

    self._viewList:setUpdateCell(function(view, cell, idx)
        cell:updateCell(idx,self._curLayer,self._max_layer) --cell下标从0开始
    end)
    listCon:addChild(self._viewList)

	self._viewList:setCellNums(self._listNum, true)
	self._viewList:setLocation(curLine + 2,false)
	--------------------list  end

    self._btn_back:addClickEventListenerEx(function( ... )
    	-- G_ModuleDirector:popModule()
    	self:removeFromParent()
    end)
end

--
function SoulPossessionSelectLayer:_onEnterCallback(stageId)
	-- if stageId == self._curLayer then
	self._callBack(stageId)
	-- else
		-- if G_Me.maxChallengeData:getBuffFreshState() == false then
  --   		G_HandlersManager.maxChallengeHandler:sendEnterStage(stageId)
  --   		return
  --   	end
		-- ConfirmAlert.createConfirmText(nil, G_Lang.get("max_challenge_enter_confirm"),
  --       	function ()
  --           	G_HandlersManager.maxChallengeHandler:sendEnterStage(stageId)
  --          	end)
	-- end
end

function SoulPossessionSelectLayer:_enterStage()
    self:removeFromParent()
end

function SoulPossessionSelectLayer:onEnter()
	self:init()
end

function SoulPossessionSelectLayer:onExit()
	uf_eventManager:removeListenerWithTarget(self)
end

return SoulPossessionSelectLayer