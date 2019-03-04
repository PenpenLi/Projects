
---好友刷新类型的列表。
---有标记是否要刷新，会在显示的时候进行刷新
local FriendTabBaseListLayout = class("FriendTabBaseListLayout", function ()
	return ccui.Layout:create()
end)

function FriendTabBaseListLayout:ctor(size, cellHeight,index)
	self._needFresh = false
	self._listView = nil --显示列表的组件
	self._dataList = nil --列表数据
	self._emptyBoard = nil -- 空面板
	self._size = size
	self._cellHeight = cellHeight
	self._tabType = index

	self:setSwallowTouches(true)
	--self:setTouchEnabled(false)
	self:setContentSize(size)
end

--需要显示的时候调用
function FriendTabBaseListLayout:onShow()
	if self._listView == nil then --创建列表
		self._listView = require("app.ui.WListView").new(self._size.width, self._size.height, self._size.width, self._cellHeight)
	    self:addChild(self._listView)
	    self._listView:setFirstCellPaddigTop(0)
	    self._dataList = self:_getListData()

	    --dump(self._dataList)

	    self._listView:setCreateCell(function(view, idx)
            return self:_getCellClass().new()
        end)
        self._listView:setUpdateCell(function(view, cell, idx)
        	local data = self._dataList[idx + 1]
            cell:updateCell(data, idx) ---显示更新
        end)
        self._listView:setCellNums(#self._dataList, true, 0)
	elseif self._needFresh then
		local newList = self:_getListData() --重新获取数据后刷新
		if (#newList == 1 and #self._dataList == 0) or (#newList == 0 and #self._dataList == 1) or
			#newList > #self._dataList then
			self._dataList = newList
			self._listView:setCellNums(#self._dataList, false)
		else
			self._dataList = newList
			self._listView:updateCellNums(#self._dataList)
		end
		self._needFresh = false
	end
	self:_checkItemNum()
end

---检查数量。
function FriendTabBaseListLayout:_checkItemNum()
	dump(self._tabType)
	dump(#self._dataList)
	if self._tabType and self._tabType == 4 then -- 黑名单跳过
		return
	end
	if #self._dataList == 0 then
		self:_addNoItemTips()
		--self._listView:setListTouchEnabled(false)
	else
		self:_delNoItemTips()
	end
end

----添加没有数量的提示
function FriendTabBaseListLayout:_addNoItemTips()
	if self._emptyBoard == nil then
        self._emptyBoard = require("app.scenes.common.CommonEmptyPanel").new(self._size,self._tabType == 3)
        self:addChild(self._emptyBoard)

        local tips = self:_getNoItemTips()
        self._emptyBoard:updateTips(tips)
    else
        local tips = self:_getNoItemTips()
        self._emptyBoard:updateTips(tips)
    end
end

----移除没有数量的提示
function FriendTabBaseListLayout:_delNoItemTips()
	if self._emptyBoard ~= nil then
        self:removeChild(self._emptyBoard)
        self._emptyBoard = nil
    end
end

function FriendTabBaseListLayout:setNeedFresh()
	self._needFresh = true
end

--更新单个组件
function FriendTabBaseListLayout:updateSingleCell(id, data)
	local cells = self._listView:getCreatedCells()
	for i = 1 ,#cells do
		local cell = cells[i]
		if cell:getId() == id then
			cell:updateCell(data)
			break
		end
	end
end

---返回列表显示的数据
function FriendTabBaseListLayout:_getListData()
	
end

---获得显示列表Item的组件
function FriendTabBaseListLayout:_getCellClass()
	
end

return FriendTabBaseListLayout