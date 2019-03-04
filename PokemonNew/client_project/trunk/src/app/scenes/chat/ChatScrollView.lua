
--====================
--聊天列表管理类。

local ChatScrollView = class("ChatScrollView", function ()
	return display.newLayer()
end)

local ChatScrollItem = require "app.scenes.chat.ChatScrollItem"

ChatScrollView.SHOW_MAX_COUNT = 300
ChatScrollView.SHOW_ITEM_BLANK = 10

function ChatScrollView:ctor(dataList, listSize, channelId)
	self._dataList = dataList
	self._listSize = listSize
    self._channelId = channelId
	self._showItems = {}
	self._scrollView = nil

	if #self._dataList > ChatScrollView.SHOW_MAX_COUNT then --只显示最大数量限制内的消息。
		local newList = {}
		for i = #self._dataList - ChatScrollView.SHOW_MAX_COUNT + 1, #self._dataList do
			newList[#newList + 1] = self._dataList[i]
		end
		self._dataList = newList
	end

	self:_initUI()
end

---添加新的信息
function ChatScrollView:addNewMsg(chatUnit)
	if #self._dataList == ChatScrollView.SHOW_MAX_COUNT then
		table.remove(self._dataList, 1)

		local lastItem = table.remove(self._showItems, 1)
		lastItem:removeFromParent()
	end
    --dump(chatUnit)
	self._dataList[#self._dataList + 1] = chatUnit
	self._showItems[#self._showItems + 1] = ChatScrollItem.new(chatUnit:getSenderId() ~= G_Me.userData.id, chatUnit, self._listSize.width)
    self._isSelf = chatUnit:getSenderId() == G_Me.userData.id
    
	self:_freshView()
end

---清除数据
function ChatScrollView:clearView()
    if self._scrollView then
        self._dataList = {}
        self._showItems = {}
        self._scrollView:removeAllChildren()
    end
end

function ChatScrollView:_initUI()
	----滑动条
    self._scrollView = ccui.ScrollView:create()
    self._scrollView:setBounceEnabled(false)
    self._scrollView:setDirection(ccui.ScrollViewDir.vertical)
    self._scrollView:setTouchEnabled(true)
    self._scrollView:enableNodeEvents()
    self._scrollView:setPosition(cc.p(0,0))
    self._scrollView:setInnerContainerSize(cc.size(self._listSize.width, self._listSize.height))
    self:addChild(self._scrollView)
    self._scrollView:setScrollBarEnabled(false)
    self._jumpToBottom = true

    local totalHeight = 0 
    for i = 1, #self._dataList do
    	local data = self._dataList[i]
    	local item = ChatScrollItem.new(data:getSenderId() ~= G_Me.userData.id, data, self._listSize.width)
    	self._showItems[#self._showItems + 1] = item
    	totalHeight = item:getTotalHeight() + totalHeight
    end

    self:_freshView(true)
end

---重新排列聊天信息。
function ChatScrollView:_freshView(isInit)
    if math.abs(self._scrollView:getInnerContainerPosition().y) <= 150 then
        self._jumpToBottom = true
    end

    local innerPosY = 0
    local innerSizeH = 0
    if self._jumpToBottom == false then
        innerPosY = self._scrollView:getInnerContainerPosition().y
        innerSizeH = self._scrollView:getInnerContainerSize().height
    end

	local currentHeigth = 0 --实际内容高度
    for i = #self._showItems, 1, -1 do
    	local item = self._showItems[i]
    	item:setPosition(0, currentHeigth)
    	if item:getParent() == nil then --如果没添加，则添加新消息。
    		self._scrollView:addChild(item)
    	end
        self._scrollView:setInnerContainerSize(cc.size(self._listSize.width, self._listSize.height))
    	currentHeigth = currentHeigth + item:getTotalHeight() + ChatScrollView.SHOW_ITEM_BLANK
    end
    
    --实际内容高度跟UI界面高度，小的为算
    local finalHeight = currentHeigth > self._listSize.height and self._listSize.height or currentHeigth
    self._scrollView:setBounceEnabled(currentHeigth > self._listSize.height)
    self._scrollView:setInnerContainerSize(cc.size(self._listSize.width, currentHeigth))
    self._scrollView:setContentSize(cc.size(self._listSize.width, finalHeight))

    if currentHeigth < self._listSize.height then
    	---消息小于一屏的时候重新排列
    	local placePosY = 0
    	for i = 1, #self._showItems do
    		local item = self._showItems[i]
    		item:setPosition(0, self._listSize.height - item:getTotalHeight() + placePosY)
    		placePosY = - item:getTotalHeight() - ChatScrollView.SHOW_ITEM_BLANK + placePosY
    	end
    	self._scrollView:setContentSize(cc.size(self._listSize.width, self._listSize.height))
    else
        if self._scrollView then
            if self._jumpToBottom then
                self._scrollView:jumpToBottom()
                self._jumpToBottom = false
            else
                self._scrollView:setInnerContainerPosition(
                    {
                    x=0,
                    y=innerPosY - (self._scrollView:getInnerContainerSize().height - innerSizeH)}
                    )
            end
        end
        -- self:performWithDelay(function()
        --     if self._scrollView then
        --         self._scrollView:jumpToBottom()
        --     end 
        -- end, 0.1)
        -- if isInit then
        --     self:performWithDelay(function()
        --         if self._scrollView then
        --             self._scrollView:jumpToBottom()
        --         end 
        --     end, 0.1)
        -- else
        --     if self._isSelf then
        --         self._scrollView:jumpToBottom()
        --     end
        -- end
    end
end

function ChatScrollView:refreshSize(conSize)
    local per = nil
    if self._scrollView:getInnerContainerSize().height > self._listSize.height then
        per = -self._scrollView:getInnerContainerPosition().y/(self._scrollView:getInnerContainerSize().height - self._listSize.height)
    end
    self._listSize = conSize
    self._scrollView:setContentSize(cc.size(self._listSize.width, self._listSize.height))
    if per then
        self._scrollView:jumpToPercentVertical(100 - per*100)
    end
end

function ChatScrollView:getScrollView()
    return self._scrollView
end

return ChatScrollView