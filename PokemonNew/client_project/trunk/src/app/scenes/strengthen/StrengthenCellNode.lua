--
-- Author: YouName
-- Date: 2016-04-01 10:49:38
--
local StrengthenCellNode = class("StrengthenCellNode", function ( ... )
	return cc.TableViewCell:new()
end)

local WayFunctionInfo = require("app.cfg.way_function_info")
local ModuleEntranceHelper = require "app.common.ModuleEntranceHelper"

function StrengthenCellNode:ctor( isBattle )
	self._csbNode = nil
	self._wayValue = nil
	self._knightId = nil
	self._moveStart = nil
	self._moveEnd = nil

	self._isBattle = isBattle or false

	self:_initUI()
end

function StrengthenCellNode:_initUI( ... )
	self._csbNode = cc.CSLoader:createNode("csb/strengthen/StrengthenCellNode.csb")
	self:addChild(self._csbNode)

	self._progress = self._csbNode:getSubNodeByName("progressbar")
	self._imageBg = self._csbNode:getSubNodeByName("Image_bg")

	self._imageBg:setTouchEnabled(true)
	self._imageBg:setSwallowTouches(false)
	self._imageBg:addTouchEventListener(handler(self,self._onTouchBackGround))

	-- self._csbNode:updateButton("Button_goto", handler(self,self._onGotoClick))
end

function StrengthenCellNode:setInfo( way, knightId, index )
	local wayCfg = WayFunctionInfo.get(way.id)
	self._wayValue = wayCfg.value
	self._knightId = knightId

	local curValue = way.value
	local totValue = way.Totalvalue
	local maxValue = way.MaxValue

	self._csbNode:updateImageView("Image_icon", G_Url:getIcon_module(wayCfg.icon))
	self._csbNode:updateLabel("label_type", {text = wayCfg.name})
	self._csbNode:updateLabel("label_progress", {text = curValue .. "/" .. G_LangScrap.get("common_title_x_level" ,{level = totValue})})--, outlineColor = G_ColorsScrap.DEFAULT_OUTLINE_COLOR})

	print(way.id,index,"curValue",curValue,"maxValue",maxValue,"totValue",totValue)
	if index < 2 and curValue < maxValue and curValue < totValue then
		self._csbNode:updateImageView("Image_recommend", {visible = true})
	else
		self._csbNode:updateImageView("Image_recommend", {visible = false})
	end

	self._progress:setPercent(curValue / totValue * 100)
end

function StrengthenCellNode:_getDistance()
	if self._moveStart == nil or self._moveEnd == nil then
		return 0
	end

	local dx = self._moveStart.x - self._moveEnd.x
	local dy = self._moveStart.y - self._moveEnd.y
	local distance = math.pow(dx * dx + dy * dy, 0.5)
	return distance
end

function StrengthenCellNode:_onTouchBackGround( sender,event )
	if event == cc.EventCode.BEGAN then
		sender:setScale(1.05)
		return true
	elseif event == cc.EventCode.MOVED then
		local curPt = sender:getTouchMovePosition()
		if self._moveStart == nil then
			self._moveStart = curPt
		end
		self._moveEnd = curPt
		local distance = self:_getDistance()
		if distance > 20 then
			sender:setScale(1)
		end
	elseif event == cc.EventCode.ENDED then
		local distance = self:_getDistance()
		if distance < 20 then
			self:_onGotoClick()
		end

		self._moveStart = nil
		sender:setScale(1)
	elseif event == cc.EventCode.CANCELLED then
		self._moveStart = nil
		sender:setScale(1)
	end
end

function StrengthenCellNode:_onGotoClick()
	local param = nil
	if self._wayValue == G_FunctionConst.FUNC_KNIGHT_UPGRADE then
		local knightData = G_Me.teamData:getKnightDataByPos(1)
		if knightData.serverData.id == self._knightId then
			G_Popup.tip(G_LangScrap.get("team_txt_me_no_up_level"))
			return
		end
		param = {self._knightId,1}

	elseif self._wayValue == G_FunctionConst.FUNC_KNIGHT_TUPO then
		param = {self._knightId,2}

	elseif self._wayValue == G_FunctionConst.FUNC_KNIGHT_TIANMING then
		param = {self._knightId,3}

	elseif self._wayValue == G_FunctionConst.FUNC_FABAO_SHENGJI then
		param = {self._knightId,1}

	elseif self._wayValue == G_FunctionConst.FUNC_FABAO_TUPO then
		param = {self._knightId,2}

	elseif self._wayValue == G_FunctionConst.FUNC_EQUIPMENT_ENHANCE then
		local pos = G_Me.teamData:getKnightPosByID(self._knightId)
		local list = G_Me.equipData:getEquipInfoList(true)
		for i,equip in ipairs(list) do
			if equip.pos == pos and equip.cfgData.type == 1 then
				param = {equip.serverData.id,1}
				break
			end
		end

	elseif self._wayValue == G_FunctionConst.FUNC_EQUIPMENT_UPRANK then
		local pos = G_Me.teamData:getKnightPosByID(self._knightId)
		local list = G_Me.equipData:getEquipInfoList(true)
		for i,equip in ipairs(list) do
			if equip.pos == pos and equip.cfgData.type == 1 then
				param = {equip.serverData.id,2}
				break
			end
		end

	elseif self._wayValue == G_FunctionConst.FUNC_EQUIPMENT_AWAKEN then
		local pos = G_Me.teamData:getKnightPosByID(self._knightId)
		local list = G_Me.equipData:getEquipInfoList(true)
		for i,equip in ipairs(list) do
			if equip.pos == pos and equip.cfgData.type == 1 then
				param = {equip.serverData.id,3}
				break
			end
		end

	elseif self._wayValue == G_FunctionConst.FUNC_TREASURE_ENHANCE or
		self._wayValue == G_FunctionConst.FUNC_TREASURE_REFINE then
		local pos = G_Me.teamData:getKnightPosByID(self._knightId)
		param = {pos,0,false}
	end

	local entrance, isLayer = ModuleEntranceHelper.getEntranceByFuncId(self._wayValue, param)
	if entrance then
		if self._isBattle then
			G_ModuleDirector:replaceModule(nil, function()
				return entrance()
			end, isLayer)
		else
			G_ModuleDirector:pushModule(nil, function()
				return entrance()
			end, isLayer)
		end
	end
end

return StrengthenCellNode