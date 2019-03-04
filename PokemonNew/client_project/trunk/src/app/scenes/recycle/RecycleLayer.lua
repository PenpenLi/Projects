--[====================[

    炼化台主界面

]====================]
local RecycleLayer=class("RecycleLayer",function()
	return display.newLayer()
end)

local FunctionLevelInfo = require "app.cfg.function_level_info"
local EffectNode = require("app.effect.EffectNode")
local RecycleJewelLayer = require("app.scenes.recycle.RecycleJewelLayer")
local RecycleJewelRebornLayer = require("app.scenes.recycle.RecycleJewelRebornLayer")
local KnightReplaceLayer = require("app.scenes.recycle.KnightReplaceLayer")

-- 大页签
RecycleLayer.TAB_RECYCLE_KNIGHT = 1
RecycleLayer.TAB_RECYCLE_EQUIP = 2
RecycleLayer.TAB_RECYCLE_TREASURE = 3

-- 小页签
RecycleLayer.TAB_KINGHT_DECOMPOSE = {1,1}
RecycleLayer.TAB_EQUIP_MATERIAL_DECOMPOSE = {2,1}
RecycleLayer.TAB_WARBOOK_DECOMPOSE = {3,1}
RecycleLayer.TAB_WARHORSE_DECOMPOSE = {4,1}
RecycleLayer.TAB_EQUIP_INHERIT = {2,3}
RecycleLayer.TAB_KINGHT_REBORN = {1,2}
RecycleLayer.TAB_KINGHT_EXCHANGE = {1,3}          --武将置换
--RecycleLayer.TAB_TREASURE_REBORN = 2
RecycleLayer.TAB_EQUIP_REBORN = {2,2}
RecycleLayer.TAB_WARBOOK_REBORN = {3,2}
RecycleLayer.TAB_WARHORSE_REBORN = {4,2}
RecycleLayer.TAB_EXEQUIP_REBORN = {5,2}			-- 专属重生
RecycleLayer.TAB_EXEQUIP_DECOMPOSE = {5,1}		-- 专属分解
RecycleLayer.TAB_JEWEL_DECOMPSE = {6, 1}        --宝石分解
RecycleLayer.TAB_JEWEL_REBORN = {6, 2}			--宝石重生
--RecycleLayer.TAB_INSTRUMENT_DECOMPOSE = 9

--RecycleLayer.MAP_NAME = {{"武将分解"} }

--
function RecycleLayer:ctor(index)
	dump(index)
	--self._goIndex = nil
	self._goIndex = index or {1,1}
	self._index = {0,0}
	self._tabView = nil
	self._tabLayer = nil
	self._tabSize = cc.size(0, 0)
	self._scrollView = nil
	self._tabButtons = nil
	self._subTabButtons = nil
	self._buttonBack = nil
	self._fireEffect = nil
	self._mapTabs = nil -- 页签映射
    self:enableNodeEvents()
end

--
function RecycleLayer:onEnter()
	--dump("RecycleLayer:onEnter()!!!")
	--红点优先进入
	if G_Me.recycleData:hasRedPointRecycleKnights() then
		self._goIndex = RecycleLayer.TAB_KINGHT_DECOMPOSE
	elseif G_Me.recycleData:hasRedPointRecycleEquipMaterial() then
		self._goIndex = RecycleLayer.TAB_EQUIP_MATERIAL_DECOMPOSE
	end

	if self._index[2] ~= 0 then
		self._goIndex = clone(self._index)
	end
	--dump(self._goIndex)
	--dump(self._index)
	self:_initWidget()
	self:_updateRedPoint()

    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECYCLE_UPDATE_RED_POINT_KNIGHT, self._onKnightRedPoint, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECYCLE_UPDATE_RED_POINT_EUIQP_MATERIAL, self._onEquipMaterialRedPoint, self)
end

--
function RecycleLayer:onExit()
    if self._content then
    	self:removeChild(self._content)
    end
    if self._buttonBack then
    	self:removeChild(self._buttonBack)
    end
    uf_eventManager:removeListenerWithTarget(self)
   -- self:_removeFireEffects()

    self._content = nil
    self._tabView = nil
    self._buttonBack = nil
end

-- 初始化界面
function RecycleLayer:_initWidget()
	-- csb
	self._content = cc.CSLoader:createNode(G_Url:getCSB(RecycleLayer.__cname, "recycle"))
	self:addChild(self._content, 0)
	self._rootLayout = self._content:getSubNodeByName("Layout_content")
	self._tabLayout = self._content:getSubNodeByName("Layout_tab")

	-- resize
	self._rootLayout:setContentSize(display.width, display.height)
	self._rootLayout:setSwallowTouches(false)
	ccui.Helper:doLayout(self._rootLayout)
	self._tabSize = self._tabLayout:getContentSize()

	--返回
	self._buttonBack = cc.CSLoader:createNode(G_Url:getCSB("CommonBackNode", "common"))
	self._buttonBack:align(display.RIGHT_TOP , display.width - 68, display.height - 90)
	self:addChild(self._buttonBack, 100)
	self:updateButton("Button_back",function ()
        G_ModuleDirector:popModule()
    end)

	local bottonTabPanel = self:getSubNodeByName("Panel_tab_buttons")
	local bottonTabPanelSize = bottonTabPanel:getContentSize()
	local buttonTabX, buttonTabY = bottonTabPanel:getPosition()
	local tabs = {{},{},{},{},{},{}}
	
	tabs[RecycleLayer.TAB_KINGHT_DECOMPOSE[1]][RecycleLayer.TAB_KINGHT_DECOMPOSE[2]] = {
		text = G_Lang.get("recycle_tab_knight_decompose"),
		noOpen = not G_Responder.funcIsOpened(G_FunctionConst.FUNC_KNIGHT_RECYCLE),
		noOpenTips = FunctionLevelInfo.get(G_FunctionConst.FUNC_KNIGHT_RECYCLE).comment
	}
	tabs[RecycleLayer.TAB_EQUIP_MATERIAL_DECOMPOSE[1]][RecycleLayer.TAB_EQUIP_MATERIAL_DECOMPOSE[2]] = {
		text = G_Lang.get("recycle_tab_equip_material_decompose"),
		noOpen = not G_Responder.funcIsOpened(G_FunctionConst.FUNC_EQUIPMENT_MATERIAL_RECYCLE),
		noOpenTips = FunctionLevelInfo.get(G_FunctionConst.FUNC_EQUIPMENT_MATERIAL_RECYCLE).comment
	}
	-- tabs[RecycleLayer.TAB_INSTRUMENT_DECOMPOSE] = {
	-- 	text = G_LangScrap.get("recycle_tab_instrument_decompose"),
	-- 	noOpen = not G_Responder.funcIsOpened(G_FunctionConst.FUNC_FABAO_RECYCLE),
	-- 	noOpenTips = FunctionLevelInfo.get(G_FunctionConst.FUNC_FABAO_RECYCLE).comment
	-- }
	tabs[RecycleLayer.TAB_KINGHT_REBORN[1]][RecycleLayer.TAB_KINGHT_REBORN[2]] = {
		text = G_Lang.get("recycle_tab_knight_reborn"),
		noOpen = not G_Responder.funcIsOpened(G_FunctionConst.FUNC_KNIGHT_REBORN),
		noOpenTips = FunctionLevelInfo.get(G_FunctionConst.FUNC_KNIGHT_REBORN).comment
	}
	-- tabs[RecycleLayer.TAB_EQUIP_REBORN] = {text = G_LangScrap.get("recycle_tab_equip_reborn")}
	tabs[RecycleLayer.TAB_EQUIP_REBORN[1]][RecycleLayer.TAB_EQUIP_REBORN[2]] = {
		text = G_Lang.get("recycle_tab_equip_reborn"),
		noOpen = not G_Responder.funcIsOpened(G_FunctionConst.FUNC_EQUIPMENT_REBORN),
		noOpenTips = FunctionLevelInfo.get(G_FunctionConst.FUNC_EQUIPMENT_REBORN).comment
	}

	tabs[RecycleLayer.TAB_WARBOOK_REBORN[1]][RecycleLayer.TAB_WARBOOK_REBORN[2]] = {
		text = G_Lang.get("recycle_tab_bookwar_reborn"),
		noOpen = not G_Responder.funcIsOpened(G_FunctionConst.FUNC_BOOKWAR_REBORN),
		noOpenTips = FunctionLevelInfo.get(G_FunctionConst.FUNC_BOOKWAR_REBORN).comment
	}

	tabs[RecycleLayer.TAB_WARHORSE_REBORN[1]][RecycleLayer.TAB_WARHORSE_REBORN[2]] = {
		text = G_Lang.get("recycle_tab_horsewar_reborn"),
		noOpen = not G_Responder.funcIsOpened(G_FunctionConst.FUNC_HORSE_REBORN),
		noOpenTips = FunctionLevelInfo.get(G_FunctionConst.FUNC_HORSE_REBORN).comment
	}

	tabs[RecycleLayer.TAB_EQUIP_INHERIT[1]][RecycleLayer.TAB_EQUIP_INHERIT[2]] = {
		text = G_Lang.get("recycle_tab_equip_inherit"),
		noOpen = not G_Responder.funcIsOpened(G_FunctionConst.FUNC_EQUIP_INHERIT),
		noOpenTips = FunctionLevelInfo.get(G_FunctionConst.FUNC_EQUIP_INHERIT).comment
	}

	tabs[RecycleLayer.TAB_WARBOOK_DECOMPOSE[1]][RecycleLayer.TAB_WARBOOK_DECOMPOSE[2]] = {
		text = G_Lang.get("recycle_tab_bookwar_decompose"),
		noOpen = not G_Responder.funcIsOpened(G_FunctionConst.FUNC_BOOKWAR_RECYCLE),
		noOpenTips = FunctionLevelInfo.get(G_FunctionConst.FUNC_BOOKWAR_RECYCLE).comment
	}

	tabs[RecycleLayer.TAB_WARHORSE_DECOMPOSE[1]][RecycleLayer.TAB_WARHORSE_DECOMPOSE[2]] = {
		text = G_Lang.get("recycle_tab_horsewar_decompose"),
		noOpen = not G_Responder.funcIsOpened(G_FunctionConst.FUNC_HORSE_RECYCLE),
		noOpenTips = FunctionLevelInfo.get(G_FunctionConst.FUNC_HORSE_RECYCLE).comment
	}

	-- dump(G_FunctionConst.FUNC_EXEQUIP_RECYCLE)
	-- dump(FunctionLevelInfo.get(G_FunctionConst.FUNC_EXEQUIP_RECYCLE))
	-- dump(FunctionLevelInfo.get(G_FunctionConst.FUNC_EXEQUIP_RECYCLE).comment)
	tabs[RecycleLayer.TAB_EXEQUIP_DECOMPOSE[1]][RecycleLayer.TAB_EXEQUIP_DECOMPOSE[2]] = {
		text = G_Lang.get("recycle_tab_exequip_decompose"),
		noOpen = not G_Responder.funcIsOpened(G_FunctionConst.FUNC_EXEQUIP_RECYCLE),
		noOpenTips = FunctionLevelInfo.get(G_FunctionConst.FUNC_EXEQUIP_RECYCLE).comment
	}

	tabs[RecycleLayer.TAB_EXEQUIP_REBORN[1]][RecycleLayer.TAB_EXEQUIP_REBORN[2]] = {
		text = G_Lang.get("recycle_tab_exequip_reborn"),
		noOpen = not G_Responder.funcIsOpened(G_FunctionConst.FUNC_EXEQUIP_REBORN),
		noOpenTips = FunctionLevelInfo.get(G_FunctionConst.FUNC_EXEQUIP_REBORN).comment
	}

	tabs[6][1] = {
		text = G_Lang.get("recycle_tab_jewel_decompse"),
		noOpen = not G_Responder.funcIsOpened(G_FunctionConst.FUNC_JEWELFENJIE),
		noOpenTips = FunctionLevelInfo.get(G_FunctionConst.FUNC_JEWELFENJIE).comment
	}	

	tabs[6][2] = {
		text = G_Lang.get("recycle_tab_jewel_reborn"),
		noOpen = not G_Responder.funcIsOpened(G_FunctionConst.FUNC_JEWELCHONGSHENG),
		noOpenTips = FunctionLevelInfo.get(G_FunctionConst.FUNC_JEWELCHONGSHENG).comment
	}
	tabs[RecycleLayer.TAB_KINGHT_EXCHANGE[1]][RecycleLayer.TAB_KINGHT_EXCHANGE[2]] = {
		text = G_Lang.get("recycle_tab_knight_exchange"),
		noOpen = not G_Responder.funcIsOpened(G_FunctionConst.KnightReplace),
		noOpenTips = FunctionLevelInfo.get(G_FunctionConst.KnightReplace).comment
	}
	self._mapTabs = tabs

	-- 创建大页签
	local bigTabs = {{text = "武将"},{text = "装备"},
	{text = "兵书",noOpen = not G_Responder.funcIsOpened(G_FunctionConst.FUNC_BOOKWAR_RECYCLE),noOpenTips = FunctionLevelInfo.get(G_FunctionConst.FUNC_BOOKWAR_RECYCLE).comment},
	{text = "符印",noOpen = not G_Responder.funcIsOpened(G_FunctionConst.FUNC_HORSE_RECYCLE),noOpenTips = FunctionLevelInfo.get(G_FunctionConst.FUNC_HORSE_RECYCLE).comment},
	--{text = "专属"}}
	{text = "专属",noOpen = not G_Responder.funcIsOpened(G_FunctionConst.FUNC_EXEQUIP_RECYCLE),noOpenTips = FunctionLevelInfo.get(G_FunctionConst.FUNC_EXEQUIP_RECYCLE).comment},
	{text = G_Lang.get("equip_tab_title4"), noOpen = not G_Responder.funcIsOpened(G_FunctionConst.FUNC_JEWELFENJIE), noOpenTips = FunctionLevelInfo.get(G_FunctionConst.FUNC_JEWELFENJIE).comment}
	}
	--,{text = "专属"}}
    local params = {
    	tabs = bigTabs,
		isBig = true,
		--scrollRect = cc.rect(buttonTabX, buttonTabY, bottonTabPanelSize.width, 0)
		scrollRect = cc.rect(0, 0, 500, 0),
	}

	
	--dump(self._goIndex)
    local buttonTabNode = self:getSubNodeByName("Node_tab_buttons")
    self._tabButtons = require("app.common.TabButtonsHelper").updateTabButtons(buttonTabNode, params, handler(self, self._createSubTabs))
    self._tabButtons.setSelected(self._goIndex[1])

    self._content:updateButton("Button_left_page", function ()
    	self._tabButtons.setScrollPercent(0)
    end)

    self._content:updateButton("Button_right_page", function ()
    	self._tabButtons.setScrollPercent(100)
    end)
end

-- 更新页签显示内容
function RecycleLayer:_updateTabView(index,bigIndex)
	dump(index)
	--print("RecycleLayer updateTabView ".. index)
	-- 
	local function isTableEqual(a,b)
		for i=1,2 do
			if a[i] ~= b[i] then
			 	return false
			end 
		end
		return true
	end
    -- dump(index)
    -- dump(self._index[2])
	if index ~= self._index[2] or self._bigIndex ~= self._index[1] then
		self._index[2] = index
		self._index[1] = self._bigIndex

		-- create tab layer
	    local layer = nil
		dump(self._index)
		if isTableEqual(self._index,RecycleLayer.TAB_KINGHT_DECOMPOSE) then
			--dump(" isTableEqual(self._index,RecycleLayer.)TAB_KINGHT_DECOMPOSE !!!")
			layer = require("app.scenes.recycle.RecycleTabKnightLayer").new(self._tabSize)
		elseif isTableEqual(self._index,RecycleLayer.TAB_EQUIP_MATERIAL_DECOMPOSE) then
			layer = require("app.scenes.recycle.RecycleTabEquipMaterialLayer").new(self._tabSize,1)
		elseif isTableEqual(self._index,RecycleLayer.TAB_KINGHT_REBORN) then
			layer = require("app.scenes.recycle.RecycleTabKnightRebornLayer").new(self._tabSize)
		elseif isTableEqual(self._index,RecycleLayer.TAB_EQUIP_REBORN) then
			layer = require("app.scenes.recycle.RecycleTabEquipRebornLayer").new(self._tabSize,1)
		-- elseif isTableEqual(self._index,RecycleLayer.TAB_TREASURE_REBORN) then
		-- 	layer = require("app.scenes.recycle.RecycleTabTreasureRebornLayer").new(self._tabSize)
		-- elseif isTableEqual(self._index,RecycleLayer.TAB_INSTRUMENT_DECOMPOSE) then
		-- 	layer = require("app.scenes.recycle.RecycleTabInstrumentLayer").new(self._tabSize)
		elseif isTableEqual(self._index,RecycleLayer.TAB_WARBOOK_REBORN) then
			layer = require("app.scenes.recycle.RecycleTabBookWarRebornLayer").new(self._tabSize,1)
		elseif isTableEqual(self._index,RecycleLayer.TAB_WARHORSE_REBORN) then
			layer = require("app.scenes.recycle.RecycleTabBookWarRebornLayer").new(self._tabSize,2)
		elseif isTableEqual(self._index,RecycleLayer.TAB_EQUIP_INHERIT) then
			layer = require("app.scenes.recycle.RecycleEquipInheritLayer").new(self._tabSize)
		elseif isTableEqual(self._index,RecycleLayer.TAB_WARBOOK_DECOMPOSE) then
			layer = require("app.scenes.recycle.RecycleTabBookWarLayer").new(self._tabSize,1)
		elseif isTableEqual(self._index,RecycleLayer.TAB_WARHORSE_DECOMPOSE) then
			layer = require("app.scenes.recycle.RecycleTabBookWarLayer").new(self._tabSize,2)
		elseif isTableEqual(self._index,RecycleLayer.TAB_EXEQUIP_DECOMPOSE) then
			layer = require("app.scenes.recycle.RecycleTabEquipMaterialLayer").new(self._tabSize,2)
		elseif isTableEqual(self._index,RecycleLayer.TAB_EXEQUIP_REBORN) then
			layer = require("app.scenes.recycle.RecycleTabEquipRebornLayer").new(self._tabSize,2)
		elseif isTableEqual(self._index, RecycleLayer.TAB_JEWEL_DECOMPSE)then
			layer = RecycleJewelLayer.new()
		elseif isTableEqual(self._index, RecycleLayer.TAB_JEWEL_REBORN) then
			layer = RecycleJewelRebornLayer.new()
		elseif isTableEqual(self._index, RecycleLayer.TAB_KINGHT_EXCHANGE) then
			layer = KnightReplaceLayer.new()
		end

		if layer then
			if self._tabLayer ~= nil then
				self:removeChild(self._tabLayer)
			end
			self._tabLayer = layer
			self._tabLayer:setPosition(self._tabLayout:getPosition())
			self:addChild(self._tabLayer, 1)
		end

		self:_updateRedPoint()
	end

	-- 背景设置
	--dump(self._index)
	local bgNodeCon = self:getSubNodeByName("Node_bg")
    bgNodeCon:removeAllChildren()
   	local bgNode, bgHolder
    if isTableEqual(self._index,RecycleLayer.TAB_KINGHT_REBORN)  or isTableEqual(self._index,RecycleLayer.TAB_KINGHT_DECOMPOSE) or isTableEqual(self._index,RecycleLayer.TAB_KINGHT_EXCHANGE) then
    	bgNode = cc.CSLoader:createNode(G_Url:getCSB("RecycleTabBgReborn", "recycle"))
    elseif isTableEqual(self._index,RecycleLayer.TAB_EQUIP_REBORN) or isTableEqual(self._index,RecycleLayer.TAB_EQUIP_MATERIAL_DECOMPOSE) or 
    	isTableEqual(self._index,RecycleLayer.TAB_WARBOOK_REBORN) or isTableEqual(self._index,RecycleLayer.TAB_WARHORSE_REBORN) or--isTableEqual(self._index,RecycleLayer.TAB_TREASURE_REBORN) or
    	isTableEqual(self._index,RecycleLayer.TAB_EQUIP_INHERIT) or isTableEqual(self._index, RecycleLayer.TAB_JEWEL_DECOMPSE) or isTableEqual(self._index, RecycleLayer.TAB_JEWEL_REBORN) or RecycleLayer.TAB_WARBOOK_DECOMPOSE or RecycleLayer.TAB_WARHORSE_DECOMPOSE then
    	bgNode = cc.CSLoader:createNode(G_Url:getCSB("RecycleTabBgDecompose", "recycle"))
    	local fireNode = bgNode:getSubNodeByName("Node_effect_fire")
    	-- 火炉特效
    	--if self._fireEffect == nil then
    		self._fireEffect = EffectNode.new("effect_huolu_fire")
    		fireNode:removeAllChildren()
			fireNode:addChild(self._fireEffect)
			--self._fireEffect:setPosition(cc.p(50,50))
			self._fireEffect:play()
    	--end
    end

    bgHolder = bgNode:getSubNodeByName("Panel_holder")
    bgHolder:setContentSize(display.width, display.height)
    ccui.Helper:doLayout(bgHolder)
    
    bgNode:getSubNodeByName("Image_bg"):setContentSize(640, 1140)
    bgNode:setPositionY(-(1140 - display.height) / 2)
    bgNodeCon:addChild(bgNode)
    G_WidgetTools.autoTransformBg(bgNode:getSubNodeByName("Image_bg"),-50)
end

function RecycleLayer:_onKnightRedPoint()
	-- dump(G_Me.recycleData:hasRedPointRecycleKnights())
	-- dump(self._index[1])
	-- dump(RecycleLayer.TAB_KINGHT_DECOMPOSE[1])
	-- dump( G_Me.recycleData:hasRedPointRecycleKnights() and (self._index[1] == RecycleLayer.TAB_KINGHT_DECOMPOSE[1]))
	self._tabButtons.updateRedPoint(RecycleLayer.TAB_KINGHT_DECOMPOSE[1], G_Me.recycleData:hasRedPointRecycleKnights())
	if self._index[1] == RecycleLayer.TAB_KINGHT_DECOMPOSE[1] then self._subTabButtons.updateRedPoint(RecycleLayer.TAB_KINGHT_DECOMPOSE[2], G_Me.recycleData:hasRedPointRecycleKnights()) end --and (self._index[1] == RecycleLayer.TAB_KINGHT_DECOMPOSE[1]))
end

function RecycleLayer:_onEquipMaterialRedPoint()
	self._tabButtons.updateRedPoint(RecycleLayer.TAB_EQUIP_MATERIAL_DECOMPOSE[1], G_Me.recycleData:hasRedPointRecycleEquipMaterial())
	if self._index[1] == RecycleLayer.TAB_EQUIP_MATERIAL_DECOMPOSE[1] then self._subTabButtons.updateRedPoint(RecycleLayer.TAB_EQUIP_MATERIAL_DECOMPOSE[2], G_Me.recycleData:hasRedPointRecycleEquipMaterial()) end--and (self._index[1] == RecycleLayer.TAB_EQUIP_MATERIAL_DECOMPOSE[1]))
end

function RecycleLayer:_updateRedPoint()
	self:_onKnightRedPoint()
	self:_onEquipMaterialRedPoint()
end

-- 移除炉火效果
function RecycleLayer:_removeFireEffects( ... )
	if self._fireEffect then
		self._fireEffect:removeFromParent(true)
		self._fireEffect = nil
	end
end

-- 创建子页签
function RecycleLayer:_createSubTabs( index )
	dump(index)
	--创建标签页
	local tabs = self._mapTabs[index]
	self._bigIndex = index
	--self._index[1] = index
	--self._index[2] = 0

	local nodeTabButtons = self:getSubNodeByName("lower_tab_buttons")
	local params = {
		tabs = tabs,
		isBig = false,
		--tabsOffsetX = 124*1,
	}
	
	self._subTabButtons = require("app.common.TabButtonsHelper").updateTabButtons(nodeTabButtons,params,handler(self,self._updateTabView))
	dump(self._goIndex[2])
	self._subTabButtons.setSelected(self._goIndex[2])
	self._goIndex[2] = 1
end

return RecycleLayer