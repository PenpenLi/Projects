local MatchFinalPkPop=class("MatchFinalPkPop",function()
	return display.newNode()
end)

local MatchFinalPkData = require("app.data.MatchFinalPkData")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local ShaderUtils = require("app.common.ShaderUtils")
local MyGuessPop = import(".MyGuessPop")
local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local MatchGuessList = import(".MatchGuessList")
local MatchFinalPkPage = import(".MatchFinalPkPage")

local LINE_MAP = {
	[2] = {{1},{2}},
	[4] = {{1},{2},{3},{4},{1,2},{3,4}},
	[8] = {
		{1},{2},{3},{4},{5},{6},{7},{8},
		{1,2},{3,4},{5,6},{7,8},
		{1,2,3,4},{5,6,7,8},
		},
}

local BIGGROUP_NAME_MAP = {
	[1] = "A",
	[2] = "B",
	[3] = "C",
	[4] = "D",
}

MatchFinalPkPop.LAYER_TREE = 1
MatchFinalPkPop.LAYER_LIST = 2

function MatchFinalPkPop:ctor(data,progress,bigGroup,smallGroup)
	self:enableNodeEvents()
	self._data = data
	self._bigGroup = bigGroup
	self._smallGroup = smallGroup
	self._progress = progress
	self._curPages = {}
	self._pageData = self._data:getPageList(self._progress)
	self:_init()
end

function MatchFinalPkPop:_init()
	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("PKPop","match/pk"))
	self._csbNode:setContentSize(display.width,display.height)
	self._csbNode:setPosition(display.cx,display.cy)
	ccui.Helper:doLayout(self._csbNode)
	self._csbNode:addTo(self)

    UpdateNodeHelper.updateCommonNormalPop(self._csbNode,titleName,function ( ... )
        self:removeFromParent(true)
    end,730)

	UpdateButtonHelper.updateBigButton(
		self._csbNode:getSubNodeByName("FileNode_myGuess"),
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

    self._pageView = self._csbNode:getSubNodeByName("PageView_page")
    self._text_title = self._csbNode:getSubNodeByName("Text_title")

    self._pageView:addEventListener(handler(self,self._pageViewTruingEvent))
    self._pageView:removeAllPages()

    self._btnPkTree = self._csbNode:getSubNodeByName("Button_treeline")
    self._btnPkTree:addClickEventListenerEx(function( ... )
		self._curLayer = MatchFinalPkPop.LAYER_TREE
		self:render()
    end)

    self._btnPkList = self._csbNode:getSubNodeByName("Button_pklist")
    self._btnPkList:addClickEventListenerEx(function( ... )
		self._curLayer = MatchFinalPkPop.LAYER_LIST
		self:render()
    end)

    self._btnLeft = self._csbNode:getSubNodeByName("Button_left")
    self._btnLeft:addClickEventListenerEx(function( ... )
        local curPageIndex = self._pageView:getCurrentPageIndex()
		self._pageView:scrollToPage(curPageIndex - 1)
    end)

    self._btnRight = self._csbNode:getSubNodeByName("Button_right")
    self._btnRight:addClickEventListenerEx(function( ... )
        local curPageIndex = self._pageView:getCurrentPageIndex()
		self._pageView:scrollToPage(curPageIndex + 1)
    end)

    self._page_name = self._csbNode:getSubNodeByName("Text_page_name")

    for i=1,#self._pageData do
    	local onePage = MatchFinalPkPage.new(self._data,self._progress)
        self._pageView:addPage(onePage)
    end

	self._curLayer = MatchFinalPkPage.LAYER_TREE

	self:setPageByGroup(self._bigGroup,self._smallGroup)
end

--pageview翻页handler
function MatchFinalPkPop:_pageViewTruingEvent(sender, eventCode)
    if eventCode == ccui.PageViewEventType.turning then
        local curPageIndex = sender:getCurrentPageIndex()
        if self._curPageIdx ~= curPageIndex then
            -- self._btnListView:setLocation(curPageIndex)
            self:updatePage(curPageIndex)
        end
    end
end

function MatchFinalPkPop:setPageByGroup( bigGroup,smallGroup )
	for i=1,#self._pageData do
		print(self._pageData[i].bigGroup , bigGroup , self._pageData[i].smallGroup , smallGroup)
		if self._pageData[i].bigGroup == bigGroup and self._pageData[i].smallGroup == smallGroup then
			self._pageView:setCurrentPageIndex(i - 1)
			self:updatePage( i - 1 )
			break
		end
	end
end

function MatchFinalPkPop:updatePage( pageIndex )
	for i=1,#self._curPages do
		self._curPages[i] = nil
	end
    for i=1,#self._pageData do
        local index = i - 1
		if math.abs(pageIndex - index) <= 1 then
            local page = self._pageView:getItem(index)

		    local data = self._pageData[index+1] 
		    if pageIndex == index then
				self._curPage = page
		        self._bigGroup = data.bigGroup
		        self._smallGroup = data.smallGroup
			    if page then
			        page:updatePage(data.bigGroup,data.smallGroup,self._curLayer)
			    end
		    else
			    if page then
			        page:updatePage(data.bigGroup,data.smallGroup,self._curLayer)
			        -- page:updatePageDelay(data.bigGroup,data.smallGroup,self._curLayer)
			    end
		    end
		    table.insert(self._curPages,page)
        else
            local page = self._pageView:getItem(index)
            if page then
                page:clearPage()
            end
        end
    end
    self:render()
end

function MatchFinalPkPop:render()
	local name = ""
	if self._smallGroup == nil then
		name = BIGGROUP_NAME_MAP[self._bigGroup]
	else
		name = BIGGROUP_NAME_MAP[self._bigGroup] .. self._smallGroup
	end
	local titleName = ""
	local winName = ""
	local pageName = ""
	if self._progress ~= 3 then
		titleName = G_Lang.get("match_pk_title",{group = name})
		pageName = G_Lang.get("match_pk_title2",{group = name})
	else
		titleName = G_Lang.get("match_pk_final")
	end
    self._text_title:setString(titleName)
	self._page_name:setString(pageName)

	for i=1,#self._curPages do
	    if self._curPages[i] then
			self._curPages[i]:updateLayer(self._curLayer)
	    end
	end

	if self._curLayer == MatchFinalPkPage.LAYER_TREE then
	    self._btnPkList:setVisible(true)
	    self._btnPkTree:setVisible(false)
	elseif self._curLayer == MatchFinalPkPage.LAYER_LIST then
	    self._btnPkList:setVisible(false)
	    self._btnPkTree:setVisible(true)
	end

    local curPageIndex = self._pageView:getCurrentPageIndex()
    self._btnLeft:setVisible(curPageIndex ~= 0)
    self._btnRight:setVisible(curPageIndex ~= #self._pageData - 1)
end

function MatchFinalPkPop:onEnter()

end

function MatchFinalPkPop:onExit()
	uf_eventManager:removeListenerWithTarget(self)
end

function MatchFinalPkPop:onCleanup( ... )
	
end

return MatchFinalPkPop