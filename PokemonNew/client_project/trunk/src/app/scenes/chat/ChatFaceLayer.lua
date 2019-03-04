
--===========
--聊天表情面板
local ChatFaceLayer = class("ChatFaceLayer", function ()
	return ccui.Layout:create()
end)

ChatFaceLayer.FACE_COUNT = 46 --表情总数
ChatFaceLayer.FACE_LINE_COUNT = 6 ---表情的每行个数
ChatFaceLayer.FACE_COLL_COUNT = 3 ---表情多少列为一页


function ChatFaceLayer:ctor()
	self._view = nil
	self._pageView = nil
	self._pageIndexImages = {} --当前页数显示的图片数组
	self:enableNodeEvents()
  self:setContentSize(display.width,display.height)
	self:setTouchEnabled(true)
 --  --self:setSwallowTouches(false)
 --    --self:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
  self:addClickEventListener(function( ... )
    self:getParent():setVisible(false)
  end)
  -- self:registerScriptTouchHandler(function(event,x,y)
  --     if event == "began" then
  --         print("sss")
  --         return false
  --     elseif event == "ended" then
  --         self:removeFromParent()
  --     end
  -- end)
end

function ChatFaceLayer:onEnter()
	self:_initView()
end

function ChatFaceLayer:onExit()
	
end

function ChatFaceLayer:_initView()
	self._view = cc.CSLoader:createNode(G_Url:getCSB("ChatFaceLayer", "chat"))
	self._view:setAnchorPoint(0.5, 0)
	self:addChild(self._view)

	self._view:setPosition(display.cx, 0)

	self._scrollView = self:getSubNodeByName("ScrollView_face")
	self._scrollView:setScrollBarEnabled(false)
	local scrollSize = self._scrollView:getContentSize()

    local panelCon = self:getSubNodeByName("panel_con")
    local row = math.floor(ChatFaceLayer.FACE_COUNT/ChatFaceLayer.FACE_LINE_COUNT)+1
    local conHeight = 10 + row * 48--67
    panelCon:setContentSize(panelCon:getContentSize().width, conHeight)
    self._scrollView:setInnerContainerSize(cc.size(scrollSize.width,conHeight))
    --ccui.Helper:doLayout(panel)

    -- 加入表情
    local placedCount = 0
    for i=1,ChatFaceLayer.FACE_COUNT do
    	local faceCell = self:_createFaceCell(i)
		local faceSize = faceCell:getContentSize()
		local posX = 10
		faceCell:setPositionX((placedCount % ChatFaceLayer.FACE_LINE_COUNT) * (faceSize.width + 15) + 18)
		faceCell:setPositionY(conHeight - 1 * (math.floor(placedCount / ChatFaceLayer.FACE_LINE_COUNT) * (faceSize.height + 7) + 2.5) - (faceSize.height + 5))
		panelCon:addChild(faceCell)
		placedCount = placedCount + 1
    end

  --   local pageViewSize = self._pageView:getContentSize()
  --   local onePageFaceCount = ChatFaceLayer.FACE_LINE_COUNT * ChatFaceLayer.FACE_COLL_COUNT
  --   local pageCount = math.ceil(ChatFaceLayer.FACE_COUNT / onePageFaceCount)
  --   local faceNum = 0
  --   local pageIndexSize = nil

  --   for i = 1, pageCount do
  --   	--最后一页表情判断
  --   	if i == pageCount then
  --   		faceNum = ChatFaceLayer.FACE_COUNT - (i - 1) * onePageFaceCount
  --   	else
  --   		faceNum = onePageFaceCount
  --   	end

  --   	local newPage = self:_getPageByStartIndex((i - 1) * onePageFaceCount + 1, faceNum, pageViewSize)
  --   	self._pageView:addPage(newPage)

  --   	local pageIndexImage = ccui.ImageView:create(G_Url:getUI_common("img_com_btn_tipstab_01"))
  --   	pageIndexImage:setAnchorPoint(0.5, 0)
  --   	self._pageIndexImages[#self._pageIndexImages + 1] = pageIndexImage
  --   	pageIndexSize = pageIndexImage:getContentSize()
  --   end

  --   --排列并添加表示当前页数的图片
  --   local pageIndexCon = self._view:getSubNodeByName("Node_page_index")
  --   local indexBlank = 10
  --   local totalWidth = (pageCount - 1) * indexBlank + pageIndexSize.width * (pageCount - 1)
  --   pageIndexCon:setVisible(pageCount ~= 1)
  --   for i = 1, pageCount do 
  --   	local pageIndexImage = self._pageIndexImages[i]
  --   	pageIndexImage:setPositionX(totalWidth * - 0.5 + (indexBlank + pageIndexSize.width) * (i - 1))
  --   	pageIndexCon:addChild(pageIndexImage)

  --   	pageIndexImage:setTouchEnabled(true)
  --   	pageIndexImage:addClickEventListenerEx(function(sender)
		-- 	self._pageView:scrollToPage(i - 1)
		-- end)
  --   end

  --   self._pageView:scrollToPage(0)
  --   self._pageView:addEventListener(function (sender, eventType)
  --   	if eventType == ccui.PageViewEventType.turning then
	 --        self:_updatePageIndex()
	 --    end
  --   end)
  --   self:_updatePageIndex() --更新页数表示
end

--================
--根据开始下标获取当前页面显示
function ChatFaceLayer:_getPageByStartIndex(startIndex, faceNum, pageSize)
	local pageLayout = ccui.Layout:create()
	pageLayout:setContentSize(pageSize)
	local placedCount = 0
	local endIndex = startIndex + faceNum - 1
	for i = startIndex, endIndex do
		local faceCell = self:_createFaceCell(i)
		local faceSize = faceCell:getContentSize()
		faceCell:setPositionX((placedCount % ChatFaceLayer.FACE_LINE_COUNT) * (faceSize.width + 10) + 10)
		faceCell:setPositionY(10 + pageSize.height - 1 * (math.floor(placedCount / ChatFaceLayer.FACE_LINE_COUNT) * (faceSize.height + 2) + 2.5) - (faceSize.height + 5))
		pageLayout:addChild(faceCell)
		placedCount = placedCount + 1
	end

	return pageLayout
end

function ChatFaceLayer:_createFaceCell(faceId)
	local faceLayout = ccui.Layout:create()
	local facePic = ccui.ImageView:create("face/".. faceId ..".png")
	facePic:setAnchorPoint(0, 0)
  --facePic:setScale(0.8)
	faceLayout:addChild(facePic)
	faceLayout:setContentSize(facePic:getContentSize())
	faceLayout:setTouchEnabled(true)
	faceLayout:addClickEventListenerEx(function(sender)
		uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_CHAT_SELECTE_FACE, nil, false, faceId)
	end)

	return faceLayout
end

function ChatFaceLayer:_updatePageIndex()
	local currentIndex = self._pageView:getCurrentPageIndex() + 1
	for i = 1, #self._pageIndexImages do
		local pageIndexImage = self._pageIndexImages[i]
		pageIndexImage:loadTexture(G_Url:getUI_common(i == currentIndex and "img_com_btn_tipstab_01" or "img_com_btn_tipstab_02"))
	end
end

return ChatFaceLayer