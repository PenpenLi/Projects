--
-- Author: yutou
-- Date: 2018-04-25 15:19:14
--
local HotGuessPop=class("HotGuessPop",function()
	return display.newNode()
end)

-- local MatchFinalPkData = require("app.data.MatchFinalPkData")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local MatchGuessList = import(".MatchGuessList")
local MyGuessPop = import(".MyGuessPop")
-- local ShaderUtils = require("app.common.ShaderUtils")

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")

function HotGuessPop:ctor(data)
	self:enableNodeEvents()
	self._data = data
	-- self._showData = data:getShowData(progress,bigGroup,smallGroup)
	-- self._showDataList = data:getDataList(self._showData)
	-- self._progress = progress
	-- self._bigGroup = bigGroup
	-- self._smallGroup = smallGroup
	-- self._iconList = {}
	self:_init()
end

function HotGuessPop:_init()
	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("HotGuessPop","match/pk"))
	self._csbNode:setContentSize(display.width,display.height)
	self._csbNode:setPosition(display.cx,display.cy)
	ccui.Helper:doLayout(self._csbNode)
	self._csbNode:addTo(self)

	local titleName = G_Lang.get("match_hot_guess")
    UpdateNodeHelper.updateCommonNormalPop(self._csbNode,titleName,function ( ... )
        self:removeFromParent(true)
    end,730)

    self._panel_con = self._csbNode:getSubNodeByName("Panel_con")

    self._matchGuessList = MatchGuessList.new(self._data:getHotGuess(),self._panel_con)

	UpdateButtonHelper.updateBigButton(
		self._csbNode:getSubNodeByName("FileNode_myguess"),
		{
			-- state = UpdateButtonHelper.STATE_ATTENTION,
			desc = G_Lang.get("match_my_guess"),
			callback = function()
				G_Popup.newPopup(function( ... )
					return MyGuessPop.new(self._data)
				end)
			end
		}
	)

    -- self._node_con = self._csbNode:getSubNodeByName("Node_con")

    -- self._showNum = #self._showDataList

    -- self._csbLine = nil
    -- self._csbLine = cc.CSLoader:createNode(G_Url:getCSB("PK" .. self._showNum,"match/pk"))
    -- self._csbLine:addTo(self._node_con)

    -- self._text_win_title = self._csbNode:getSubNodeByName("Text_title_winer")
    -- self._text_title = self._csbNode:getSubNodeByName("Text_title")

    self:render()
end

function HotGuessPop:render()
	self._matchGuessList:render()
 --    for i=1,#LINE_MAP[self._showNum] do
 --    	local isFaile = false
 --    	local checkList = LINE_MAP[self._showNum][i]
 --    	isFaile = self._data:checkFaile(self._showData,checkList)

 --    	local lineName = "Sprite_line"
 --    	for i=1,#checkList do
 --    		lineName = lineName .. "_" .. checkList[i]
 --    	end

 --    	if isFaile then
 --    		ShaderUtils.applyGrayFilter(self._csbNode:getSubNodeByName(lineName))
 --    	else
 --    		ShaderUtils.removeFilter(self._csbNode:getSubNodeByName(lineName))
 --    	end
 --    end

 --    for i=1,#self._showDataList do
 --    	local data = self._showDataList[i]
 --    	local iconCon = self._csbNode:getSubNodeByName("Node_"..i)
 --    	if self._iconList[i] == nil then
	--     	local item = cc.CSLoader:createNode(G_Url:getCSB("CommonIconItemNode", "common"))
 --    		self._iconList[i] = item
	-- 		item:addTo(iconCon)
 --    	end
	-- 	local param = {}
	-- 	param.nameVisible = true
	-- 	param.type = G_TypeConverter.TYPE_KNIGHT
	-- 	param.value = data.knight
	-- 	param.sizeVisible = false
	-- 	param.scale = UpdateNodeHelper.NODE_SCALE_70
	-- 	param.name = data.name
	-- 	UpdateNodeHelper.updateCommonIconItemNode(self._iconList[i], param)
 --    end


	-- local name = ""
	-- if self._smallGroup == nil then
	-- 	name = BIGGROUP_NAME_MAP[self._bigGroup]
	-- else
	-- 	name = BIGGROUP_NAME_MAP[self._bigGroup] .. self._smallGroup
	-- end
	
	-- local titleName = ""
	-- local winName = ""
	-- if self._progress ~= 3 then
	-- 	titleName = G_Lang.get("match_pk_title",{group = name})
	-- else
	-- 	titleName = G_Lang.get("match_pk_final")
	-- end
	-- if self._progress ~= 3 then
	-- 	winName = G_Lang.get("match_pk_win",{group = name})
	-- else
	-- 	winName = G_Lang.get("match_pk_final_win")
	-- end
 --    self._text_title:setString(titleName)
 --    self._text_win_title:setString(winName)
end

function HotGuessPop:onEnter()

end

function HotGuessPop:onExit()
	uf_eventManager:removeListenerWithTarget(self)
end

function HotGuessPop:onCleanup( ... )
	
end

return HotGuessPop