--
-- Author: YouName
-- Date: 2015-10-19 20:01:39
--
local RankCell=class("RankCell",function()
	return cc.TableViewCell:new()
end)

local TypeConverter = require("app.common.TypeConverter")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local UpdateButtonHelper = require("app.common.UpdateButtonHelper")

function RankCell:ctor( onViewHandler,onIconClick )
	-- body
	self._onViewHandler = onViewHandler
	self._onIconClick = onIconClick
	self._cellValue = nil
	self._csbNode = nil
	self._commonCell = nil
	self:_initUI()
end

function RankCell:_initUI( ... )
	-- body
end

function RankCell:updateCell( value,cellIdx )
	print2("======================>")
	-- body
	self._cellValue = value
	local rank = cellIdx + 1
	local cellValue = value ~= nil and value[1] or nil

	if rank > 0 and rank <= 3 then
		self._csbNode = cc.CSLoader:createNode("csb/tower/RankCell1.csb")
	else
		self._csbNode = cc.CSLoader:createNode("csb/tower/RankCell2.csb")
	end
	self:addChild(self._csbNode)
	self._commonCell = self._csbNode:getSubNodeByName("FileNode_1")

	-- 	required uint32 rank = 1;
	-- required uint64 user_id = 2;
	-- optional string name = 3;
	-- required uint32 layer = 4;
	-- required uint32 stage = 5;
	-- optional uint32 knight_id = 6;

	local rankData = nil
	local params = nil
	if(cellValue ~= nil)then
		local uid = cellValue.user_id
		local myUid = G_Me.userData.id
		local knightId = cellValue.knight_id
		local star = cellValue.star
		local strName = uid ~= myUid and cellValue.name or G_Me.userData.name
		local layerData = G_Me.thirtyThreeData:getLayerData(layer)
		-- local strStage = stageData ~= nil and string.format(layerData.layerName.."第%d关",stage) or ""
		self._csbNode:updateLabel("Text_star", {text = star ,visible = true})
		rankData = {rankNum = rank,rankName = strName,isSelf = myUid == uid}
	    params = {type = TypeConverter.TYPE_KNIGHT,value = knightId}
	else
		rankData = {rankNum = rank}
		self._csbNode:updateLabel("Text_star", {visible = false})
	end


    UpdateNodeHelper.updateCommonRankCellNode(self._commonCell,rankData, params,
        function()
        	print(myUid,id)
			if(self._onIconClick ~= nil and rankData.isSelf == false)then
				self._onIconClick(self._cellValue)
			end
        end, 
        function()
			if(self._onViewHandler ~= nil and rankData.isSelf == false)then
				self._onViewHandler(self._cellValue)
			end
    end)
    
	self._csbNode:getSubNodeByName("Button_show_formation"):setVisible(false)
end

return RankCell