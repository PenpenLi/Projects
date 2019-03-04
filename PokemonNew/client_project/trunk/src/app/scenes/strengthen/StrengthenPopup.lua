--
-- Author: YouName
-- Date: 2016-03-31 20:42:25
--
local modulename = ...

local StrengthenPopup = class("StrengthenPopup",function ()
	return display.newNode()
end)

local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local TypeConverter = require("app.common.TypeConverter")
local TextHelper = require("app.common.TextHelper")
local StrengthenCellNode = require("app.scenes.strengthen.StrengthenCellNode")
-- local StrongInfo = require("app.cfg.strong_info")
local EquipInfo = require("app.cfg.equipment_info")
-- local InstrumentInfo = require("app.cfg.instrument_info")
-- local KnightRankInfo = require("app.cfg.knight_rank_info")
local WayFunctionInfo = require("app.cfg.way_function_info")
local FunctionLevelInfo = require("app.cfg.function_level_info")
local ParameterInfo = require("app.cfg.parameter_info")
local NumberChanger = require("app.ui.number.NumberChanger")
local TeamUtils = require("app.scenes.team.TeamUtils")

-- 定义表中字段前缀
local WAYFUNCTIONID = "way_functiond_"
local WAYFUNCTIONVALUE = "recommend_way_"

-- 指向的FUCNTIONID 表如果修改要一起修改
local FUNCTION_EQUIP_LV = 80
local FUNCTION_EQUIP_RANK = 81
local FUNCTION_EQUIP_AWAKEN = 82
local FUNCTION_TREASURE_LV = 83
local FUNCTION_TREASURE_REFINE = 84
local FUNCTION_KNIGHT_LV = 85
local FUNCTION_KNIGHT_RANK = 86
local FUNCTION_KNIGHT_DESTINY = 87
local FUNCTION_INSTRUMENT_LV = 88
local FUNCTION_INSTRUMENT_AWAKEN = 89

-- 各个模块目前强化上限，如果增加要一起修改
local EQUIPMAXRANK = 15
local KNIGHTMAXRANK = 15
local INSTRUMENTMAXAWAKEN = 5

-- 各个模块的排序，公式见文档
local function SortWays( lway, rway )
	-- local lPercent = math.min(lway.value / lway.MaxValue,1)
	-- local rPercent = math.min(rway.value / rway.MaxValue,1)

	-- local lCurPer = lway.value / lway.Totalvalue
	-- local rCurPer = rway.value / rway.Totalvalue

	-- if lPercent == rPercent then
	-- 	return lCurPer < rCurPer
	-- end

	-- return lPercent < rPercent

	local lCur = lway.value
	local lMax = lway.Totalvalue
	local lRec = lway.MaxValue

	local lPercent = ((lRec / lMax) - (lCur / lMax)) / (lRec / lMax) * lMax

	local rCur = rway.value
	local rMax = rway.Totalvalue
	local rRec = rway.MaxValue

	local rPercent = ((rRec / rMax) - (rCur / rMax)) / (rRec / rMax) * rMax

	return lPercent > rPercent
end

-- 排序神将，战力高的排前面
local function sortKnightbyPower( lknight, rknight )
	print(lknight,rknight)
	local lCfg = G_Me.teamData:getKnightDataByPos(lknight)
	local rCfg = G_Me.teamData:getKnightDataByPos(rknight)

	local lPower =  0
	local rPower =  0

	if lCfg ~= nil then
		lPower = G_Me.teamData:getKnigthPowerByID(lCfg.serverData.id)
	end

	if rCfg ~= nil then
		rPower = G_Me.teamData:getKnigthPowerByID(rCfg.serverData.id)
	end

	return lPower > rPower
end

function StrengthenPopup:ctor( isBattle )
	self:enableNodeEvents()
	self._csbNode = nil
	self._curPos = nil
	self._lastPos = nil
	self._lastPower = nil
	self._change = nil

	self._isBattle = isBattle or false

	self._knightList = {1,2,3,4,5,6}

	-- 去除排序
	-- table.sort(self._knightList,sortKnightbyPower)

	-- icon列表
	self._iconList = 
	{
		--cc.CSLoader:createNode(G_Url:getCSB("CommonIconKnightNode", "common"))
	}

	self._arrawList = 
	{
		-- display.newSprite(G_Url:getUI_common("img_com_btn_arrow04"))
	}

	self._itemList =
	{
		--app.scenes.strengthen.StrengthenCellNode
	}

	-- 每个模块当前最高培养等级
	self._functionMaxLevels = 
	{
	--[[
		[FUNCTION_EQUIP_LV] = 1,
		[FUNCTION_EQUIP_RANK] = 2,
		[FUNCTION_EQUIP_AWAKEN] = 3,
		[FUNCTION_TREASURE_LV] = 4,
		[FUNCTION_TREASURE_REFINE] = 5,
		[FUNCTION_KNIGHT_LV] = 6,
		[FUNCTION_KNIGHT_RANK] = 7,
		[FUNCTION_KNIGHT_DESTINY] = 8,
		[FUNCTION_INSTRUMENT_LV] = 9,
		[FUNCTION_INSTRUMENT_AWAKEN] = 10,
	]]
	}
end

function StrengthenPopup:onEnter( ... )
	self:_initUI()
	self:_getFunctionMaxLevel()

	local lastInfo = G_Me.teamData:getLastStrengthenInfo()
	self._lastPos = lastInfo.pos or self._knightList[1]
	self._lastPower = lastInfo.power

	self:_updateByPos(self._lastPos, true)

	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHANGE_TEAM_KNIGHT,self._onFightKnightChange,self)
end

function StrengthenPopup:onExit( ... )
	uf_eventManager:removeListenerWithTarget(self)

	if self._change ~= nil then
		self._change:stop()
		self._change = nil
	end

	if self._csbNode then
		self._csbNode:removeFromParent()
		self._csbNode = nil
	end

	local knightData = G_Me.teamData:getKnightDataByPos(self._curPos)
	local power = 0
	if knightData ~= nil then
		power = G_Me.teamData:getKnigthPowerByID(knightData.serverData.id)
	end

	G_Me.teamData:setLastStrengthenInfo({pos = self._curPos, power = power})

	self._iconList = {}
	self._arrawList = {}
	self._itemList = {}
	self._functionMaxLevels = {}
	self._curPos = nil
	------------------------------------
	-- package.loaded[modulename] = nil
	-- package.loaded["app.scenes.strengthen.StrengthenCellNode"] = nil
	------------------------------------
end

function StrengthenPopup:_initUI( ... )
	self._csbNode = cc.CSLoader:createNode("csb/strengthen/StrengthenPopup.csb")
	self:addChild(self._csbNode)

	self:setPosition(display.cx,display.cy)

	UpdateNodeHelper.updateCommonFullPop(self,G_LangScrap.get("lang_strengthen_title"))

	self._itemListView = self._csbNode:getSubNodeByName("scroll_item")
	self._panel = self._csbNode:getSubNodeByName("Panel_container")
	self._image_bg = self._csbNode:getSubNodeByName("Image_right_bg")
	self._progress = self._csbNode:getSubNodeByName("progress_info")
	self._line = self._csbNode:getSubNodeByName("Image_line")
	self._selectImg = self._csbNode:getSubNodeByName("Image_select")

	self._csbNode:updateLabel("label_power",{outlineColor = G_ColorsScrap.DEFAULT_OUTLINE_COLOR})
	self._csbNode:updateImageView("Image_1", {visible = false})
	self._line:setLocalZOrder(1)

	self:_updateAllIcon()
end

-- 获取当前神将各个模块的培养度
function StrengthenPopup:_getWaysByLevel( pos, level )
	-- local Cfg = StrongInfo.get(G_Me.userData.level)
	-- local index = 1
	local ways = {}
	-- local knightData = G_Me.teamData:getKnightDataByPos(pos)
	-- local isMainRole = knightData.cfgData.type == 1
	-- local isLowQuality = (G_TypeConverter.quality2Color(knightData.cfgData.quality) < 4 and not isMainRole)
	-- while StrongInfo.hasKey(WAYFUNCTIONID .. index) do
	-- 	local way = {id = Cfg[WAYFUNCTIONID .. index], Totalvalue = self._functionMaxLevels[Cfg[WAYFUNCTIONID .. index]], value = self:_getValueByFunctionId(pos,Cfg[WAYFUNCTIONID .. index]), MaxValue = Cfg[WAYFUNCTIONVALUE .. index]}
	-- 	local wayCfg = WayFunctionInfo.get(way.id)
	-- 	local funCfg = FunctionLevelInfo.get(wayCfg.value)

	-- 	if isMainRole and way.id == FUNCTION_KNIGHT_LV then
	-- 		index = index + 1
	-- 	else
	-- 		-- 获取当前神将法宝觉醒上限
	-- 		if way.id == FUNCTION_INSTRUMENT_AWAKEN then
	-- 			way.Totalvalue = self:_getMaxAwakenByPos(pos)
	-- 		end
	-- 		way.value = math.min(way.value,way.Totalvalue)

	-- 		if funCfg and funCfg.level <= G_Me.userData.level then
	-- 			-- 低品质神将，取消某些功能显示
	-- 			if isLowQuality then
	-- 				if way.id ~= FUNCTION_KNIGHT_RANK and
	-- 				way.id ~= FUNCTION_KNIGHT_DESTINY and
	-- 				way.id ~= FUNCTION_INSTRUMENT_LV and
	-- 				way.id ~= FUNCTION_INSTRUMENT_AWAKEN then
	-- 					table.insert(ways,way)
	-- 				end
	-- 			else
	-- 				table.insert(ways,way)
	-- 			end
	-- 		end
	-- 		index = index + 1
	-- 	end
	-- end

	-- table.sort(ways,SortWays)

	return ways
end

-- 由于上限配表，不是统一规则，在这里计算
function StrengthenPopup:_getMaxAwakenByPos( pos )
	-- local knightData = G_Me.teamData:getKnightDataByPos(pos)
	-- local currInsLv = self._functionMaxLevels[FUNCTION_INSTRUMENT_LV]
	-- local currInsRank = knightData.serverData.instrumentRank
	-- local insId = knightData.cfgData.instrument
	-- local maxInsRank = self._functionMaxLevels[FUNCTION_INSTRUMENT_AWAKEN]
	-- local insInfo = InstrumentInfo.get(insId, currInsRank)
	-- while insInfo ~= nil do
	-- 	if currInsLv < insInfo.level_limit then
	-- 		maxInsRank = insInfo.rank
	-- 		break
	-- 	end
	-- 	currInsRank = currInsRank + 1
	-- 	insInfo = InstrumentInfo.get(insId, currInsRank)
	-- end
	-- return maxInsRank
end

-- 分析获取每个模块当前最大培养度
function StrengthenPopup:_getFunctionMaxLevel( )
	self._functionMaxLevels[FUNCTION_EQUIP_LV] = G_Me.equipData:getMaxEnhanceLevel({})

	local equipMaxRank = EQUIPMAXRANK
	for i=1,EQUIPMAXRANK do
		local ECfg = EquipInfo.indexOf(i)
		if ECfg.level_limit > G_Me.userData.level then
			equipMaxRank = ECfg.rank - 1
			break
		end
	end
	self._functionMaxLevels[FUNCTION_EQUIP_RANK] = equipMaxRank

	local isOpen, cur, total  = G_Me.teamData:getCultivateProgressByType(G_Me.teamData.TYPE_KNIGHT_EQUIP_AWAKEN,1)
	self._functionMaxLevels[FUNCTION_EQUIP_AWAKEN] = total

	local isOpen, cur, total  = G_Me.teamData:getCultivateProgressByType(G_Me.teamData.TYPE_KNIGHT_TREASURE_LEVEL,1)
	self._functionMaxLevels[FUNCTION_TREASURE_LV] = total

	local isOpen, cur, total  = G_Me.teamData:getCultivateProgressByType(G_Me.teamData.TYPE_KNIGHT_TREASURE_REFINE,1)
	self._functionMaxLevels[FUNCTION_TREASURE_REFINE] = total

	self._functionMaxLevels[FUNCTION_KNIGHT_LV] = G_Me.userData.level

	local knightMaxRank = KNIGHTMAXRANK
	-- for i=0,KNIGHTMAXRANK do
	-- 	local KCfg = KnightRankInfo.get(1,i)
	-- 	if G_Me.userData.level < KCfg.level_limit then
	-- 		knightMaxRank = KCfg.knight_rank
	-- 		break
	-- 	end
	-- end
	self._functionMaxLevels[FUNCTION_KNIGHT_RANK] = knightMaxRank

	local isOpen, cur, total  = G_Me.teamData:getCultivateProgressByType(G_Me.teamData.TYPE_KNIGHT_DESTINY,1)
	self._functionMaxLevels[FUNCTION_KNIGHT_DESTINY] = total

	local instrument_lvup_rate = ParameterInfo.get(136)
	self._functionMaxLevels[FUNCTION_INSTRUMENT_LV] = G_Me.userData.level * tonumber(instrument_lvup_rate.content)

	local instrumentMaxAwaken = INSTRUMENTMAXAWAKEN
	for i=1,INSTRUMENTMAXAWAKEN + 1 do
		local ICfg = InstrumentInfo.indexOf(i)
		instrumentMaxAwaken = ICfg.rank
	end
	self._functionMaxLevels[FUNCTION_INSTRUMENT_AWAKEN] = instrumentMaxAwaken
end

-- 获取当前神将当前培养度
function StrengthenPopup:_getValueByFunctionId( pos, id )
	-- 装备强化
	if id == FUNCTION_EQUIP_LV then
		local equiplv = G_Me.teamData:getEquipsLevelSumByPos(pos)
		return math.floor(equiplv / 4)

	-- 装备升品
	elseif id == FUNCTION_EQUIP_RANK then
		local equiprank = G_Me.teamData:getEquipsRankSumByPos(pos)
		return math.floor(equiprank / 4)

	-- 装备觉醒
	elseif id == FUNCTION_EQUIP_AWAKEN then
		local equipawaken = G_Me.teamData:getEquipAwakeSumByPos(pos)
		return math.floor(equipawaken / 4)

	-- 宝物强化
	elseif id == FUNCTION_TREASURE_LV then
		local treasurelv = G_Me.teamData:getTreasuresLevelSumByPos(pos)
		return math.floor(treasurelv / 2)

	-- 宝物精炼
	elseif id == FUNCTION_TREASURE_REFINE then
		local treasurerefine = G_Me.teamData:getTreasuresRefineSumByPos(pos)
		return math.floor(treasurerefine / 2)

	-- 神将升级
	elseif id == FUNCTION_KNIGHT_LV then
		local knightData = G_Me.teamData:getKnightDataByPos(pos)
		return knightData.serverData.level

	-- 神将突破
	elseif id == FUNCTION_KNIGHT_RANK then
		local knightData = G_Me.teamData:getKnightDataByPos(pos)
		return knightData.serverData.knightRank

	-- 神将天命
	elseif id == FUNCTION_KNIGHT_DESTINY then
		local knightData = G_Me.teamData:getKnightDataByPos(pos)
		return knightData.serverData.destinyLevel

	-- 法宝升级
	elseif id == FUNCTION_INSTRUMENT_LV then
		local knightData = G_Me.teamData:getKnightDataByPos(pos)
		return knightData.serverData.instrumentLevel

	-- 法宝觉醒
	elseif id == FUNCTION_INSTRUMENT_AWAKEN then
		local knightData = G_Me.teamData:getKnightDataByPos(pos)
		return knightData.serverData.instrumentRank
	end

	assert(false, "Unknown FunctionId:" .. id)
end

function StrengthenPopup:_updateIcon(pos,arrowShow)
	local knightData = G_Me.teamData:getKnightDataByPos(pos)

	local icon = self._iconList[pos]
	if icon == nil then
		icon = require("app.scenes.team.icons.KnightIcon").new(pos,handler(self,self._onIconClick))
		icon:setPosition((pos - 1) * 90 + 50,605)
		self._panel:addChild(icon)
		self._iconList[pos] = icon
	end

	local arrowImg = self._arrawList[pos]
	if arrowImg == nil then
		arrowImg = display.newSprite(G_Url:getUI_common("img_com_btn_arrow04"))
		icon:addChild(arrowImg)
		arrowImg:setPosition(35,-30)
		arrowImg:setOpacity(255*0.5)
		self._arrawList[pos] = arrowImg
	end
	arrowImg:stopAllActions()
	arrowImg:setVisible(arrowShow)

	if arrowShow then
		local action1 = cc.MoveBy:create(0.75, cc.p(0, 8))
		local fade1 = cc.FadeTo:create(0.75,255)
		local spawn1 = cc.Spawn:create(action1,fade1)

		local action2 = cc.MoveBy:create(0.75, cc.p(0, -8))
		local fade2 = cc.FadeTo:create(0.75,255*0.5)
		local spawn2 = cc.Spawn:create(action2,fade2)

		local seq = cc.Sequence:create(spawn1,spawn2)
		local rep = cc.RepeatForever:create(seq)

		arrowImg:runAction(rep)
	end

	if knightData == nil then
		icon:updateIcon(pos, true)
	else
		icon:updateIcon(pos)
	end
	icon:setScale(0.8)
end

function StrengthenPopup:_updateScrollView(pos)
	local knightData = G_Me.teamData:getKnightDataByPos(pos)
	local level = knightData.serverData.level

	local Ways = self:_getWaysByLevel(pos,level)
	local totalNum = math.max(8,#Ways)
	totalNum = totalNum + totalNum % 2

	for k,item in pairs(self._itemList) do
		item:setVisible(false)
	end

	for i,way in ipairs(Ways) do
		local item = self._itemList[i]
		if item == nil then
			item = StrengthenCellNode.new(self._isBattle)
			self._itemListView:addChild(item)
			self._itemList[i] = item
		end
		item:setInfo(way,knightData.serverData.id,i - 1)
		item:setPosition((i - 1) % 2 * 270 + 145,math.floor((totalNum - i) / 2) * 110 + 55 )
		item:setVisible(true)
	end

	local scorllWidth = self._itemListView:getContentSize().width

	self._itemListView:setInnerContainerSize(cc.size(scorllWidth,math.ceil(totalNum / 2) * 110))

	-- 计算当前神将总培养度
	local maxSum = 0
	for k,way in pairs(Ways) do
		if maxSum < way.Totalvalue then
			maxSum = way.Totalvalue
		end
	end

	local valueSum = 0
	for k,way in pairs(Ways) do
		valueSum = valueSum + way.value * maxSum / way.Totalvalue
	end

	self._progress:setPercent(valueSum / (maxSum * #Ways) * 100)
end

function StrengthenPopup:_updateAllIcon()
	local knightPosList = {1,2,3,4,5,6}
	for i=1,#knightPosList do
		for j=1,#knightPosList - i do
			local pre = G_Me.teamData:getKnightDataByPos(knightPosList[j])
			local nxt = G_Me.teamData:getKnightDataByPos(knightPosList[j + 1])
			if pre == nil then
				local tmp = knightPosList[j]
				knightPosList[j] = knightPosList[j + 1]
				knightPosList[j + 1] = tmp
			elseif nxt == nil then
			else
				local pPower = G_Me.teamData:getKnigthPowerByID(pre.serverData.id)
				local nPower = G_Me.teamData:getKnigthPowerByID(nxt.serverData.id)
				if pPower > nPower then
					local tmp = knightPosList[j]
					knightPosList[j] = knightPosList[j + 1]
					knightPosList[j + 1] = tmp
				end
			end
		end
	end

	for i=1,6 do
		local arrowShow = i == knightPosList[1] or i == knightPosList[2]
		self:_updateIcon(i,arrowShow)
	end
end

function StrengthenPopup:_onFightKnightChange( ... )
	self:_updateAllIcon()
end

function StrengthenPopup:_onIconClick(pos,status,isFirstClick,isOld)
	if(status == 1)then
		local bool,strTips = TeamUtils.hasOtherKnights(pos,1)
		if(bool == false)then
			G_Popup.tip(strTips)
		else
			local layer = require("app.scenes.team.ChoseKnightLayer").new(pos,isChange,team)
			display.getRunningScene():addToPopupLayer(layer)
		end
	elseif(status == 99)then
		if(isFirstClick ~= true)then
			if(self._pos == pos and self._pageViewMainIndex == 0)then
				return
			end
		end
		self:_updateByPos(pos)
	elseif(status == 0)then
		G_Popup.tip(G_LangScrap.get("team_main_pos_lock"))	
	elseif(status == 2)then
		self:_updateByPos(pos)
	end
end

function StrengthenPopup:_updateByPos( pos, noMoveEffect )
	if self._curPos == pos then
		return
	end

	local knightData = G_Me.teamData:getKnightDataByPos(pos)
	if knightData == nil then
		return
	end
	self._curPos = pos
	-- assert(knightData,"Not Found KnightPos " .. pos)

	local StrongCfg = StrongInfo.get(G_Me.userData.level)
	local name = pos == 1 and G_Me.userData.name or knightData.cfgData.name
	local power = G_Me.teamData:getKnigthPowerByID(knightData.serverData.id)

	if knightData.serverData.knightRank > 0 then
		name = name .. "+" .. tostring(knightData.serverData.knightRank)
	end

	-- self._csbNode:updateLabel("label_name", {text = name, color = G_ColorsScrap.getDarkColor(G_TypeConverter.quality2Color(knightData.cfgData.quality))})
	UpdateNodeHelper.updateQualityLabel(self._csbNode:getSubNodeByName("label_name"),G_TypeConverter.quality2Color(knightData.cfgData.quality),name)
	self._csbNode:updateLabel("label_level", knightData.serverData.level .. G_LangScrap.get("team_txt_level_simple"))
	self._csbNode:updateLabel("label_power_re", G_LangScrap.get("lang_strengthen_recommend") .. TextHelper.getAmountText3(StrongCfg.recommend_power))

	self:_updateScrollView(pos)
	self:_updatePower(pos)
	self:_updateSelect(pos, noMoveEffect)
end

function StrengthenPopup:_updatePower(pos)
	local knightData = G_Me.teamData:getKnightDataByPos(pos)
	local power = G_Me.teamData:getKnigthPowerByID(knightData.serverData.id)

	local lastpower = self._lastPower or power
	if pos == self._lastPos and lastpower < power then
		self._change = NumberChanger.new(lastpower,power,function(value)
            self._csbNode:updateLabel("label_power", TextHelper.getAmountText3(value))
        end,
        function ( ... )
        	self._change = nil
        end)
        self._csbNode:updateLabel("label_power", TextHelper.getAmountText3(lastpower))
		self:performWithDelay(function ( )
			self._change:play()
		end, 0.3) 

		local action1 = cc.ScaleTo:create(0.35,1.3)
        local action2 = cc.ScaleTo:create(0.35,1)
        local seq = cc.Sequence:create(action1,cc.DelayTime:create(0.15),action2)
        self._csbNode:getSubNodeByName("label_power"):runAction(seq)

        self._lastPos = nil
	else
		self._csbNode:updateLabel("label_power", TextHelper.getAmountText3(power))
	end
end

function StrengthenPopup:_updateSelect(pos, noMoveEffect)
	noMoveEffect = noMoveEffect or false
	local icon = self:_getIconByKnightPos(pos)
	-- self._selectImg:setPosition()
	self._selectImg:stopAllActions()
	if noMoveEffect then
		self._selectImg:setPosition(cc.p(icon:getPositionX(),icon:getPositionY() - 4))
	else
		self._selectImg:runAction(cc.MoveTo:create(0.1,cc.p(icon:getPositionX(),icon:getPositionY() - 4)))
	end
end

function StrengthenPopup:_getIconByKnightPos(pos)
	for i,knightpos in ipairs(self._knightList) do
		if knightpos == pos then
			return self._iconList[i]
		end
	end
end

return StrengthenPopup