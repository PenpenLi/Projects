--
-- Author: YouName
-- Date: 2015-08-30 02:01:30
--
local WListView=class("WListView",function()
	return cc.Node:create()
end)

function WListView:ctor( viewW,viewH,cellW,cellH,isVertical)
	-- body
	self:enableNodeEvents()
	self._cellList = nil
	self._firstCellPaddingTop = 0
	self._paddingBot = 0
	self._viewW = viewW
	self._viewH = viewH
	self._cellNum = 0
	self._cellTouchCallback = nil
	local defaultDir=(isVertical==false) and cc.SCROLLVIEW_DIRECTION_HORIZONTAL or cc.SCROLLVIEW_DIRECTION_VERTICAL
	self._defaultDir=defaultDir
	self._cellW=cellW
	self._cellH=cellH
	
	self._tableview = cc.TableView:create(cc.size(viewW,viewH))
	self._tableview:setDirection(defaultDir)
	self._tableview:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	self._tableview:setDelegate()--监听事件
	self:addChild(self._tableview)

	
	self._tableview:registerScriptHandler(handler(self,self._tableCellTouched), cc.TABLECELL_TOUCHED)
	self._tableview:registerScriptHandler(handler(self,self._cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
	self._tableview:registerScriptHandler(handler(self,self._tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
	self._tableview:registerScriptHandler(handler(self,self._numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

	self._needTouchEnabled = true--本身是否允许触摸
	self:_setListTouchEnabled(false)
end

--设置第一个到顶部的空隙距离
function WListView:setFirstCellPaddigTop( value )
	-- body
	self._firstCellPaddingTop = value
end

--获取cell
function WListView:getCellAtIndex( idx )
	-- body
	return self._tableview:cellAtIndex(idx)
end

--插入  没有用到
function WListView:insertCellAtIndex( idx )
	-- body
	self._tableview:insertCellAtIndex(idx)
end

--移除
function WListView:removeCellAtIndex( idx )
	-- body
	self._tableview:removeCellAtIndex(idx)
end

--重新设置 viewsize
function WListView:updateViewSize( size )
	-- body
	self._tableview:setViewSize(size)
end

--设置点击cell回调
function WListView:setTouchCellCallback(callback)
	-- body
	self._cellTouchCallback = callback
end

--获取所有以创建的Cell
function WListView:getCreatedCells()
	-- body
	return self._cellList
end

---停止自动滚动
function WListView:stopAutoMoving( ... )
	-- body
	if self._tableview == nil then return end
	-- self._tableview:stopAnimatedContentOffset()
end

function WListView:_resetCellsList( ... )
    -- body
    if self._cellList ~= nil then
        for i=1,#self._cellList do
            self._cellList[i]:stopAllActions()
            self._cellList[i]:setVisible(true)
            if self._cellList[i].originalPositionX then
            	self._cellList[i]:setPositionX(self._cellList[i].originalPositionX)
            end
            if self._cellList[i].originalPositionY then
            	self._cellList[i]:setPositionY(self._cellList[i].originalPositionY)
            end
        end
    end
    self:_setListTouchEnabled(self._needTouchEnabled)
end

--刷新列表数据
function WListView:setCellNums(num ,isAnimation, paddingBottom, callback)
	assert(tolua.isnull(self) == false,"self._tableview has released!!")
	-- body
	if(self._createCellCallBack==nil or self._updateCellCallBack==nil)then
		print("please setCreateCell(callback) and setUpdateCell(callback) first")
		return 
	end
	self:stopAutoMoving()

	--可能出现列表无法滑动的兼容   如果不是第一次刷新则不锁定点击
	local needLock = self._cellNum ~= nil and self._cellNum > 0

	local botom_pad= paddingBottom or 0
	self._paddingBot = botom_pad
	local delay_sec=0.05
	self._cellNum=math.max(num,0)
	-- if(botom_pad>0)then
	-- 	local layeout =  ccui.Layout:create()
 --        layeout:setContentSize(self._cellW,botom_pad)
	-- 	self._tableview:setTableViewFooter(layeout)
	-- else
		self._tableview:reloadData()
	-- end
	if(isAnimation == false)then
		self:_resetCellsList()
		self:_setListTouchEnabled(self._needTouchEnabled)
		if callback then
			callback(self)
		end
		return
	end

	--横向的没有缓动
	if(self._defaultDir==cc.SCROLLVIEW_DIRECTION_HORIZONTAL)then
		self:_setListTouchEnabled(self._needTouchEnabled)
		return 
	end

	--纵向缓动 缓动前先禁止触摸
	if needLock then
		self:_setListTouchEnabled(false)
		print("self:_setListTouchEnabled(false)")
	end
	
	if(self._cellList == nil)then
		self._cellList = {}
	end
	table.sort(self._cellList,function(a,b)
		return a:getPositionY()>b:getPositionY()
	end)

	local duration = 0
	for i=1,#self._cellList do
		local cell=self._cellList[i]
		if(cell ~= nil and cell:getParent() ~= nil)then
			local posx=cell:getPositionX()
			local posy=cell:getPositionY()
			cell.originalPositionX = posx
			cell.originalPositionY = posy
			cell:setPosition(posx-100,posy)
			cell:setVisible(false)

			local action=cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(posx,posy)))
			local delayTime = cc.DelayTime:create(i*delay_sec)
			local subCall = cc.CallFunc:create(function(node,p)
				node:setVisible(true)
			end)
			local subCall2 = cc.CallFunc:create(function(node,p)
				cell.originalPositionX = nil
				cell.originalPositionY = nil
			end)
			local seq=cc.Sequence:create(delayTime,subCall,action,subCall2)
			cell:runAction(seq)

			duration = seq:getDuration()
		end
	end

	self:runAction(cc.Sequence:create(cc.DelayTime:create(duration), cc.CallFunc:create(function()
		if callback then
			callback(self)
		end
	end)))

    --
    local count = #self._cellList
    local seq = cc.Sequence:create(cc.DelayTime:create(count * delay_sec), cc.CallFunc:create(function(node, p)
        self:_setListTouchEnabled(self._needTouchEnabled)
		print("self:_setListTouchEnabled(true)")
    end))

    self:runAction(seq)

end

--获取偏移位置
function WListView:getContentOffset(  )
	-- body
	if self._tableview == nil then return nil end
	return self._tableview:getContentOffset()
end

--设置偏移位置
function WListView:setContentOffset( offset )
	-- body
	if self._tableview == nil or offset == nil then return end
	self:_resetCellsList()
	self._tableview:setContentOffset(offset)
end

--刷新数据并定位到上次滑动的位置
function WListView:updateCellNums( cellNum )
	assert(tolua.isnull(self) == false,"self._tableview has released!!")
	-- body
	self:stopAutoMoving()
	self:_resetCellsList()
	self:_setListTouchEnabled(self._needTouchEnabled)
	self._cellNum = math.max(cellNum,0)
	local minY = self._viewH - self._cellNum*self._cellH
	local minX = (self._viewW - self._cellNum*self._cellW)
	local offset = self._tableview:getContentOffset()
	if self._defaultDir ~= cc.SCROLLVIEW_DIRECTION_HORIZONTAL then
		if(minY > offset.y)then
			offset.y = minY
		end
	else
		if(minX > offset.x)then
			offset.x = minX
		end
	end

	self._tableview:reloadData()
	--print(offset)
	self._tableview:setContentOffset(offset)
end

--设置定位到那个cell
function WListView:setLocation( cellIdx,isAni )
	-- body
	local size = self._tableview:getContentSize()
	if(self._defaultDir == cc.SCROLLVIEW_DIRECTION_VERTICAL)then
		local offsetY = self._viewH - (self._cellNum*self._cellH - cellIdx*self._cellH)
		local minY = self._viewH - size.height
		if(offsetY >= 0)then
			offsetY = math.min(offsetY,0)
		else
			offsetY = math.max(offsetY,minY)
		end
		if minY > 0 then
			offsetY = minY
		end
		self:_resetCellsList()
		self._tableview:setContentOffset(cc.p(0,offsetY),isAni~=false)
	else
		local prevX = self._tableview:getContentOffset().x
		--dump(prevX)
		local offsetX = -cellIdx*self._cellW
		--dump(offsetX)
		if(offsetX > prevX)then -- 左边回弹
			offsetX = -cellIdx*self._cellW
		elseif(prevX - offsetX > self._viewW - self._cellW)then -- 右边回弹
			offsetX = -cellIdx*self._cellW + self._viewW - self._cellW
		else -- 无需回弹
			return
		end

		--dump(self._viewW)
		--dump(size.width)
		--	-980  =	520 - 1500
		local minX = self._viewW - size.width
		--dump(minX)
		--dump(offsetX)

		if(offsetX <= 0 and offsetX >= minX)then
			self:_resetCellsList()
			self._tableview:setContentOffset(cc.p(offsetX,0),isAni~=false)
		end
	end
end

function WListView:getLocation()
	return self._tableview:getContentOffset()
end

-- function WListView:setContentOffset(pos)
-- 	dump(pos)
-- 	self._tableview:setContentOffset(cc.p(pos.x,0),false)
-- end

function WListView:setLocation2( cellIdx,isAni )
	-- body
	local size = self._tableview:getContentSize()
	if(self._defaultDir == cc.SCROLLVIEW_DIRECTION_VERTICAL)then
		local offsetY = self._viewH - (self._cellNum*self._cellH - cellIdx*self._cellH)
		local minY = self._viewH - size.height
		if(offsetY >= 0)then
			offsetY = math.min(offsetY,0)
		else
			offsetY = math.max(offsetY,minY)
		end
		if minY > 0 then
			offsetY = minY
		end
		self:_resetCellsList()
		self._tableview:setContentOffset(cc.p(0,offsetY),isAni~=false)
	else
		local prevX = self._tableview:getContentOffset().x
		dump(prevX)
		local offsetX = -cellIdx*self._cellW
		dump(offsetX)
		if(offsetX > prevX)then -- 左边回弹
			offsetX = -cellIdx*self._cellW
		elseif(offsetX < prevX)then -- 右边回弹
			offsetX = -cellIdx*self._cellW + self._viewW - self._cellW
		end

		--dump(self._viewW)
		--dump(size.width)
		--	-980  =	520 - 1500
		local minX = self._viewW - size.width
		--dump(minX)
		dump(offsetX)

		if(offsetX <= 0 and offsetX >= minX)then
			self:_resetCellsList()
			self._tableview:setContentOffset(cc.p(offsetX,0),isAni~=false)
		end
	end
end

--点击了哪个cell
function WListView:_tableCellTouched( view,cell )
	-- body
	print(cell:getIdx())
	if self._cellTouchCallback then
		self._cellTouchCallback(cell)
	end
end

--cell的框
function WListView:_cellSizeForTable( view,idx )
	-- body
	local h,w = self._cellH,self._cellW
	if idx == 0 then
		h = h + self._firstCellPaddingTop
	elseif idx == self._cellNum - 1 then
		h = h + self._paddingBot
	end
	return w,h
end

--cell复用
function WListView:_tableCellAtIndex( view,idx )
	-- body
	local cell=self._tableview:dequeueCell()
	if(self._cellList == nil)then
		self._cellList = {}
	end
	if(cell==nil)then
		cell=self._createCellCallBack(view,idx)
		self._cellList[#self._cellList+1]=cell
	end
	if(cell)then
		self._updateCellCallBack(view,cell,idx)
		
		if self._paddingBot ~= 0 then
			local bottomPad = 0
			if idx == self._cellNum - 1 then
				bottomPad = self._paddingBot
			end
			local children=cell:getChildren()
		    for i=1,#children do
		    	if children[i].__oldPosY == nil then--记录原始坐标
		    		children[i].__oldPosY = children[i]:getPositionY()
		    	end
				children[i]:setPositionY(children[i].__oldPosY + bottomPad)
		    end
		end
	end
	return cell
end

--列表真实的cell个数
function WListView:_numberOfCellsInTableView( view )
	-- body
	return self._cellNum
end

--指定更新cell的方法
function WListView:setUpdateCell( callback )
	-- body
	if(callback==nil or type(callback)~="function")then
		print("callback must not be nil callback is function")
		return
	end
	self._updateCellCallBack=callback
end

--指定cell的创建方法
function WListView:setCreateCell( callback )
	-- body
	if(callback==nil or type(callback)~="function")then
		print("callback must not be nil callback is function")
		return
	end
	self._createCellCallBack=callback
end

--对外接口
function WListView:setListTouchEnabled(bool)
	self._needTouchEnabled = bool
	self:_setListTouchEnabled(bool)
end

function WListView:_setListTouchEnabled(bool)
	-- body
	if(self._tableview ~= nil)then
		if bool ~= self._tableview:isTouchEnabled() then
			self._tableview:setTouchEnabled(bool)
		end
	end
end

function WListView:onCleanup( ... )
	-- body
	self._updateCellCallBack = nil
	self._createCellCallBack = nil
	self._tableview = nil
	self._cellList = nil
end

function WListView:setCellPadding(padding)
	if self._tableview then
		self._tableview:setCellPadding(padding)
	end
end

function WListView:setScrollEnabled(enable)
	if self._tableview and self._tableview.setScrollEnabled then
		self._tableview:setScrollEnabled(enable)
	end
end

--获得内部滑动层
function WListView:getInnerContainer()
	return self._tableview:getContainer()
end

--设置滑动回弹
function WListView:setBounceable(bool)
	self._tableview:setBounceable(bool)
end

--add by cqh
function WListView:getViewSize()
	return self._viewW, self._viewH
end

--直接jump到当前index
function WListView:jumpToIndex( index )
	if(index < 1 or index > self._cellNum)then
		return
	end

	local innerContainer = self:getInnerContainer()
	if(self._defaultDir == cc.SCROLLVIEW_DIRECTION_VERTICAL)then
		local vorder = self._tableview:getVerticalFillOrder()
		if(vorder == cc.TABLEVIEW_FILL_TOPDOWN)then
			local totalH = innerContainer:getContentSize().height
			local maxOffset = totalH >= self._viewH and 0 or self._viewH - totalH
			local minOffset = self._viewH - totalH

			--计算index上面cells的总高度
			local h = self._cellH + self._firstCellPaddingTop + (index - 2)*self._cellH

			local offset = minOffset + h
			if(offset > maxOffset)then
				offset = maxOffset
			elseif(offset < minOffset)then
				offset = minOffset
			end
			self:setContentOffset(cc.p(0, offset))		
		end
	end

end
--add end

return WListView