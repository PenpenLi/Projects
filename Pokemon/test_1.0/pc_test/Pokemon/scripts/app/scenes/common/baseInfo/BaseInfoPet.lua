--BaseInfoPet.lua

local PetInfoPage = require("app.scenes.common.baseInfo.pet.PetInfoPage")
local PetFragementPage = require("app.scenes.common.baseInfo.pet.PetFragmentPage")
local EffectSingleMoving = require "app.common.effects.EffectSingleMoving"
local BaseInfoPet = class("BaseInfoPet", UFCCSModelLayer)

BaseInfoPet.CONST_COLOR = {
	HIGHLIGHT_COLOR = ccc3(0xf2, 0x79, 0x0d),
	NORMAL_COLOR = ccc3(0xe1, 0xb2, 0x7c),
	GRAY_COLOR = ccc3(0xae, 0xae, 0xae),
}

BaseInfoPet.PAGE_TYPE = {
	PAGE_FRAGMENT = 1,
	PAGE_BASEINFO = 2,
}

function BaseInfoPet.showWidthBaseId( baseId, scenePack )
	local baseInfo = BaseInfoPet.new("ui_layout/BaseInfo_PetMain.json",
	 Colors.modelColor, baseId, 0, BaseInfoPet.PAGE_TYPE.PAGE_BASEINFO, scenePack)	
	uf_sceneManager:getCurScene():addChild(baseInfo)
end

function BaseInfoPet.showWidthFragmentId( fragmentId, scenePack )
	local baseInfo = BaseInfoPet.new("ui_layout/BaseInfo_PetMain.json", 
		Colors.modelColor, 0, fragmentId, BaseInfoPet.PAGE_TYPE.PAGE_FRAGMENT, scenePack)		
	uf_sceneManager:getCurScene():addChild(baseInfo)
end

function BaseInfoPet:ctor( ... )
	self._mainBaseId = 0
	self._fragmentId = 0
	self._defaultPageId = 0
	self._knightPageView = nil
	self._delayLoadPages = {}

	self.super.ctor(self, ...)
end

function BaseInfoPet:onLayerLoad( _, _, baseId, fragmentId, pageId, scenePack )
	self._mainBaseId = baseId
	self._fragmentId = fragmentId
	self._defaultPageId = pageId or BaseInfoPet.PAGE_TYPE
	self._curPageIndex = -1
	self._maxPageCount = 0
	self._scenePack = scenePack
	self._typeToPagePair = {}
	self._pageToTypePair = {}

	self:showAtCenter(true)

	self:_initEquipAndFragment()
	self:_calcPageCount()
	self:_initInvalidPageFlag()

	self:registerBtnClickEvent("Button_close", function ( ... )
		self:animationToClose()
	end)
	self:registerBtnClickEvent("Button_left", function ( ... )
		if self._knightPageView then 
			self._knightPageView:scrollToPage(self._curPageIndex - 2)
		end
	end)
	self:registerBtnClickEvent("Button_right", function ( ... )
		if self._knightPageView then 
			self._knightPageView:scrollToPage(self._curPageIndex)
		end
	end)

	self:registerWidgetClickEvent("Label_page_2", function ( ... )
		self:_onSwitchViewPage(BaseInfoPet.PAGE_TYPE.PAGE_BASEINFO)
	end)
	self:registerWidgetClickEvent("Image_icon_2", function ( ... )
		self:_onSwitchViewPage(BaseInfoPet.PAGE_TYPE.PAGE_BASEINFO)
	end)

	self:registerWidgetClickEvent("Label_page_1", function ( ... )
		self:_onSwitchViewPage(BaseInfoPet.PAGE_TYPE.PAGE_FRAGMENT)
	end)
	self:registerWidgetClickEvent("Image_icon_1", function ( ... )
		self:_onSwitchViewPage(BaseInfoPet.PAGE_TYPE.PAGE_FRAGMENT)
	end)

	self:_initClickClose()
end

function BaseInfoPet:_onSwitchViewPage( index )
	if self._knightPageView and type(index) == "number" then 
		self._knightPageView:scrollToPage(self._typeToPagePair[index])
	end
end

function BaseInfoPet:_initClickClose( ... )
	if G_GuideMgr and G_GuideMgr:isCurrentGuiding() then 
		self:showWidgetByName("Image_click_continue", false)
		return 
	end

	self:setClickClose(true)
	EffectSingleMoving.run(self:getWidgetByName("Image_click_continue"), "smoving_wait", nil , {position = true} )
end

function BaseInfoPet:_initEquipAndFragment( ... )
	if self._mainBaseId <= 0 and self._fragmentId <= 0 then 
		return 
	end
	if self._mainBaseId <= 0 then 
		
		local fragmentInfo = fragment_info.get(self._fragmentId)
		if not fragmentInfo then 
			assert("wrong fragment id:"..self._fragmentId)
			return 
		end

		self._mainBaseId = fragmentInfo.fragment_value
	else
		
		local knightInfo = pet_info.get(self._mainBaseId)
		if not knightInfo then 
			assert("wrong knight id:"..self._mainBaseId)
			return 
		end

		self._fragmentId = knightInfo.relife_id or 0
	end
end



function BaseInfoPet:_calcPageCount( ... )
	local pageToTypeIndex = 0
	local typeToPageIndex = 0
	if type(self._fragmentId) == "number" and self._fragmentId > 0 then 
		pageToTypeIndex = pageToTypeIndex + 1
		self._typeToPagePair[BaseInfoPet.PAGE_TYPE.PAGE_FRAGMENT] = typeToPageIndex
		self._pageToTypePair[pageToTypeIndex] = BaseInfoPet.PAGE_TYPE.PAGE_FRAGMENT
		typeToPageIndex = typeToPageIndex + 1
	end

	if type(self._mainBaseId) == "number" and self._mainBaseId > 0 then 
		pageToTypeIndex = pageToTypeIndex + 1
		self._typeToPagePair[BaseInfoPet.PAGE_TYPE.PAGE_BASEINFO] = typeToPageIndex
		self._pageToTypePair[pageToTypeIndex] = BaseInfoPet.PAGE_TYPE.PAGE_BASEINFO
		typeToPageIndex = typeToPageIndex + 1
	end

	__Log("pageToTypeIndex = " .. tostring(pageToTypeIndex))
	self._maxPageCount = pageToTypeIndex or 2
end

function BaseInfoPet:_initInvalidPageFlag( ... )
	for loopi = 1, 2, 1 do 
		if not self._typeToPagePair[loopi] then 
			local img = self:getImageViewByName("Image_icon_"..loopi)
			if img then 
				img:loadTexture("ui/baseInfo/xinxitanchuang_dot_unable.png")
			end

			local label = self:getLabelByName("Label_page_"..loopi)
			if label then 
				label:setColor(BaseInfoPet.CONST_COLOR.GRAY_COLOR)
			end
		end
	end
end

function BaseInfoPet:onLayerEnter( ... )
	self:_loadPage()

	for i = 1, 2 do
		local labelPage = self:getLabelByName("Label_page_" .. i)
		if labelPage then
			labelPage:createStroke(Colors.strokeBrown, 1)
		end
	end

	require("app.common.effects.EffectSingleMoving").run(self, "smoving_bounce", function ( event )
		if not event then 
			return 
		end
		if event == "finish" then 
			self:closeAtReturn(true)
			for key, value in pairs(self._delayLoadPages) do 
				if value and value.doDelayLoad then 
					value:doDelayLoad()
				end
			end
		end
	end)
end

function BaseInfoPet:_loadPage( ... )
	local pagePanel = self:getPanelByName("Panel_content")
	if pagePanel == nil then
		return 
	end	

	self._knightPageView = CCSPageViewEx:createWithLayout(pagePanel)
	self._knightPageView:setCloneWidget(false)
	self._knightPageView:setPageCreateHandler(function ( page, index )
		return self:_doCreatePageItem(index)
	end)
	self._knightPageView:setPageTurnHandler(function ( page, index, cell )
		self:_onPageChanged(index)
	end)
	self._knightPageView:showPageWithCount(self._maxPageCount, self._typeToPagePair[self._defaultPageId] or 0 )
end

function BaseInfoPet:_doCreatePageItem( index )
	index = index or 0
	local pageItem = nil
	local pageModel = nil

	local pageTypeIndex = self._pageToTypePair[index + 1]

	if pageTypeIndex == BaseInfoPet.PAGE_TYPE.PAGE_FRAGMENT then 
		pageModel = PetFragementPage
	else
		pageModel = PetInfoPage
	end

	if pageTypeIndex == self._defaultPageId then 
		pageItem = pageModel.create(self._mainBaseId, self._fragmentId, self._scenePack)
	else
		pageItem = pageModel.delayCreate(self._mainBaseId, self._fragmentId, self._scenePack)
		if pageItem then
			table.insert(self._delayLoadPages, #self._delayLoadPages + 1, pageItem)
		end
	end

	return pageItem
end

function BaseInfoPet:_onPageChanged( index )
	inde = index or self._defaultPageId
	local lastIndex = self._curPageIndex
	self._curPageIndex = index + 1

	if lastIndex == self._curPageIndex then 
		return
	end

	lastIndex = self._pageToTypePair[lastIndex] or 0
	local curCtrlIndex = self._pageToTypePair[self._curPageIndex]

	local img = self:getImageViewByName("Image_icon_"..lastIndex)
	if img then 
		img:loadTexture("ui/baseInfo/xinxitanchuang_dot_norml.png")
	end
	img = self:getImageViewByName("Image_icon_"..curCtrlIndex)
	if img then 
		img:loadTexture("ui/baseInfo/xinxitanchuang_dot_red.png")
	end

	local label = self:getLabelByName("Label_page_"..lastIndex)
	if label then 
		label:setColor(BaseInfoPet.CONST_COLOR.NORMAL_COLOR)
	end

	label = self:getLabelByName("Label_page_"..curCtrlIndex)
	if label then 
		label:setColor(BaseInfoPet.CONST_COLOR.HIGHLIGHT_COLOR)
	end
end

return BaseInfoPet
