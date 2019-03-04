local WListExtendView = class("WListExtendView", function()
	return cc.Node:create()
end)

--
function WListExtendView:ctor(width, height, cellWidth, cellHeight, extendCellHeight, isVertical, initIndex)
	self._width = width
    self._height = height
    self._normalCellHeight = cellHeight
    self._normalCellWidth = cellWidth
    self._extendCellWidth = cellWidth
    self._changeHeight = extendCellHeight
    self._extendCellHeight = self._changeHeight + self._normalCellHeight
    self._currentIndex = initIndex

    self._needTouchEnabled = true
    self._firstCellPaddingTop = 0
    self._normalOffset = 0
    self._extendOffset = 0
    self._cellList = {}

    local defaultDir = isVertical == false and cc.SCROLLVIEW_DIRECTION_HORIZONTAL or cc.SCROLLVIEW_DIRECTION_VERTICAL
	self._defaultDir = defaultDir

    self._tableview = cc.TableView:create(cc.size(self._width, self._height))
    self:addChild(self._tableview)
    self._tableview:setDirection(defaultDir)
    self._tableview:setDelegate()
    self._tableview:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    --self._tableview:setExtendCellHeight(extendCellHeight)

    self._tableview:registerScriptHandler(handler(self,self._numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW) 
    self._tableview:registerScriptHandler(handler(self,self._scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL)
    self._tableview:registerScriptHandler(handler(self,self._scrollViewDidZoom), cc.SCROLLVIEW_SCRIPT_ZOOM)
    --self._tableview:registerScriptHandler(handler(self,self._tableCellTouched), cc.TABLECELL_TOUCHED)
    self._tableview:registerScriptHandler(handler(self,self._cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    self._tableview:registerScriptHandler(handler(self,self._tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    self:setTouchEnabled(self._needTouchEnabled)
	self:enableNodeEvents()
end

---停止自动滚动
function WListExtendView:stopAutoMoving( ... )
    -- body
    if self._tableview == nil then return end
    -- self._tableview:stopAnimatedContentOffset()
end

function WListExtendView:setFirstCellPaddigTop( value )
    -- body
    self._firstCellPaddingTop = value
end

--对外接口
function WListExtendView:setListTouchEnabled(bool)
    self._needTouchEnabled = bool
    self._tableview:setTouchEnabled(self._needTouchEnabled)
end

function WListExtendView:updateCellNums( cellNum,idx )
    -- body
    self:stopAutoMoving()
    self:_resetCellsList()
    self._currentIndex = nil
    self:setTouchEnabled(self._needTouchEnabled)
    self._cellNum = math.max(cellNum,0)
    local minY = self._height - self._cellNum*self._normalCellHeight
    local minX = self._width - self._cellNum*self._normalCellWidth
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
    if idx ~= nil and type(idx) == "number" then
        local size = self._tableview:getContentSize()
        offset.y = self._height - (self._cellNum*self._normalCellHeight - idx*self._normalCellHeight)
        local minY = self._height - size.height
        if(offset.y >= 0)then
            offset.y = math.min(offset.y,0)
        else
            offset.y = math.max(offset.y,minY)
        end
        if minY > 0 then
            offset.y = minY
        end
        self._tableview:setContentOffset(offset)
        local cell = self._tableview:cellAtIndex(idx)
        if cell ~= nil then
            self:_tableCellTouched(self._tableview,cell)
        end
    else
        self._tableview:setContentOffset(offset)
    end
end

function WListExtendView:_resetCellsList( ... )
    -- body
    if self._cellList ~= nil then
        for i=1,#self._cellList do
            self._cellList[i]:stopAllActions()
            self._cellList[i]:setVisible(true)
            self._cellList[i]:setPositionX(0)
        end
    end
end

--
function WListExtendView:setCellNums(num, isAnimation, paddingBottom, delay, callback)
    self._currentIndex = nil
	if self._createCellCallBack == nil or self._updateCellCallBack == nil then
		print("please setCreateCell(callback) and setUpdateCell(callback) first")
		return 
	end
    self:stopAutoMoving()
	self._cellList = {}
	self._cellNum = math.max(num, 0)
	self._normalOffset = self._height - self._normalCellHeight * self._cellNum
    self._extendOffset = self._normalOffset - self._changeHeight

	local botom_pad = paddingBottom or 0
	if botom_pad > 0 then
		local layeout = ccui.Layout:create()
        layeout:setContentSize(self._normalCellWidth, self._normalCellHeight)
		self._tableview:setTableViewFooter(layeout)
	else
		self._tableview:reloadData()
	end

	if isAnimation == false then
        self:_resetCellsList()
        self:setTouchEnabled(self._needTouchEnabled)
        if callback then
            callback(self)
        end
        return
    end

	if self._defaultDir == cc.SCROLLVIEW_DIRECTION_HORIZONTAL then return end

	local delay_sec = delay or 0.05
	for i=1, #self._cellList do
		local cell = self._cellList[i]
		local posx = cell:getPositionX()
		local posy = cell:getPositionY()
		cell:setPosition(posx-100, posy)
		cell:setVisible(false)

		local action = cc.EaseBackOut:create(cc.MoveTo:create(0.3, cc.p(posx, posy)))
		local seq = cc.Sequence:create(cc.DelayTime:create(i * delay_sec), cc.CallFunc:create(function(node, p)
			node:setVisible(true)
		end), action)

        -- 动画结束回调
        if i == #self._cellList and callback then
            seq = cc.Sequence:create(seq, cc.CallFunc:create(function()
                callback()
            end))
        end

		cell:runAction(seq)
	end

    --
    local count = #self._cellList
    local seq = cc.Sequence:create(cc.DelayTime:create(count * delay_sec), cc.CallFunc:create(function(node, p)
        self:setTouchEnabled(self._needTouchEnabled)
    end))

    self:runAction(seq)
end

--
function WListExtendView:setUpdateCell(callback)
	if callback == nil or type(callback) ~= "function" then
		print("callback must not be nil callback is function")
		return
	end

	self._updateCellCallBack = callback
end

--
function WListExtendView:setCreateCell(callback)
	if callback == nil or type(callback) ~= "function" then
		print("callback must not be nil callback is function")
		return
	end

	self._createCellCallBack = callback
end

--获取所有以创建的Cell
function WListExtendView:getCreatedCells()
    -- body
    return self._cellList
end

--
function WListExtendView:onCleanup(...)
	self._updateCellCallBack = nil
	self._createCellCallBack = nil
	self._tableview = nil
end

--
function WListExtendView:_numberOfCellsInTableView(view)
	return self._cellNum
end

--
function WListExtendView:_cellSizeForTable(view, idx) 
    local h,w = self._normalCellHeight, self._normalCellWidth
    if self._currentIndex and self._currentIndex == idx then
        h,w = self._extendCellHeight, self._extendCellWidth
    end

    if idx == 0 then
        h = h + self._firstCellPaddingTop
    end

    return w,h
end

function WListExtendView:getExtendCellHeight( ... )
    return self._extendCellHeight
end

function WListExtendView:getChangeHeight( ... )
    return self._changeHeight
end

--
function WListExtendView:_tableCellAtIndex(view, idx)
    local cell = self._tableview:dequeueCell()
    if cell == nil then
    	cell = self._createCellCallBack(view, idx)
    	self._cellList[#self._cellList+1] = cell
    end

    --是否需要展开
    local isNeedExtend = false
    if self._currentIndex and self._currentIndex == idx then
        isNeedExtend = true
    else
        isNeedExtend = false
    end

    --是否需要关闭
    local isCloseExtend = false
    if self._changeIndex and self._changeIndex == idx then 
		isCloseExtend = true    
    end

    --
    if cell then
        self._updateCellCallBack(view, cell, idx)
        --关闭或者打开滑动的时候需要 重新设置每个cell的位置 因为复用
        cell:adaptForAction()  
        --
        if isNeedExtend then
        	--执行展开动作
            cell:runCellOpenAction()
        end
        if isCloseExtend then  
        	--执行滑动动作
            cell:runCellCloseAction() 
        end
    end
     
    return cell
end

--
function WListExtendView:_scrollViewDidScroll(view)
    self._newrecorder = self._tableview:getContentOffset()
    -- print("self._newrecorder.x = " .. self._newrecorder.x)
    -- print("self._newrecorder.y = " .. self._newrecorder.y)
end

--
function WListExtendView:_scrollViewDidZoom(view)
end

--[[
@idx cell下标，
之前是touchcell，相当于内部操作，现在适应需求改为外部操作，逻辑不变
]]
function WListExtendView:switchExtend(idx)
    local index = idx
    self._isChangeToOther = false
    self._otherorder = nil

    if self._currentIndex == nil then
        -- 第一次点击的时候
        self._oldrecorder = self._newrecorder --or self._tableview:getContentOffset()
        self._itemStatus = true
        self._currentIndex = index
        --self._tableview:openCellAtIndex(self._currentIndex)
        self._tableview:reloadData()
        self._newrecorder = self._tableview:getContentOffset()
        self:_moveToCell(index)
        --self._tableview:setIsExpand(false)
    else 
        if self._currentIndex == index then
            -- 关闭点击的控件
            self._itemStatus = false
            self._currentIndex = nil
            self._oldrecorder = self._newrecorder
            --self._tableview:closeCellAtIndex(index)
            self._changeIndex = index 
            self._tableview:reloadData()  
            self._newrecorder = self._tableview:getContentOffset()    
            self:_moveToCell(index)
            --self._tableview:closeCellAtIndex(-1)
            self._changeIndex = nil
        else
            -- 已经展开了一个元素后点击另外的元素
            self._isChangeToOther = true
            self._otherorder = self._oldrecorder  
            self._oldrecorder = self._newrecorder
            self._itemStatus = true
            self._currentIndex = index
            --self._tableview:openCellAtIndex(self._currentIndex)
            self._newrecorder = self._tableview:getContentOffset()
            self._tableview:reloadData()
            self:_moveToCell(index)
            --self._tableview:setIsExpand(false)
        end
    end
end

---TODO实现方式 第一个是插入 删除 第二是更新数据表
function WListExtendView:_tableCellTouched(view,cell)
    local index = cell:getIdx()
    self._isChangeToOther = false
    self._otherorder = nil

    if self._currentIndex == nil then
    	-- 第一次点击的时候
        self._oldrecorder = self._newrecorder
        self._itemStatus = true
        self._currentIndex = index
        --self._tableview:openCellAtIndex(self._currentIndex)
        self._tableview:reloadData()
        self._newrecorder = self._tableview:getContentOffset()
        self:_moveToCell(index)
        --self._tableview:setIsExpand(false)
    else 
    	if self._currentIndex == index then
	    	-- 关闭点击的控件
	        self._itemStatus = false
	        self._currentIndex = nil
	        self._oldrecorder = self._newrecorder
	        --self._tableview:closeCellAtIndex(index)
	        self._changeIndex = index 
	        self._tableview:reloadData()  
	        self._newrecorder = self._tableview:getContentOffset()    
	        self:_moveToCell(index)
	        --self._tableview:closeCellAtIndex(-1)
	        self._changeIndex = nil
		else
	        -- 已经展开了一个元素后点击另外的元素
	        self._isChangeToOther = true
	        self._otherorder = self._oldrecorder  
	        self._oldrecorder = self._newrecorder
	        self._itemStatus = true
	        self._currentIndex = index
	        --self._tableview:openCellAtIndex(self._currentIndex)
	        self._newrecorder = self._tableview:getContentOffset()
	        self._tableview:reloadData()
	        self:_moveToCell(index)
	        --self._tableview:setIsExpand(false)
	    end
	end
end

--
function WListExtendView:_moveToCell(index)
    if self._oldrecorder == nil then
        return
    end
    if self._itemStatus == true then
        if self._oldrecorder.y == self._normalOffset then
            return
        else
            if self._oldrecorder.y == 0 then
                self._tableview:setContentOffset(self._oldrecorder)
                return
            else
                if self._currentIndex == nil then
					return
                else
                	-- 点击最上面的元素 然后换到别的条目
                    if self._oldrecorder.y == self._newrecorder.y then
                        return 
                    else
                        if self._isChangeToOther == true then
                            if self._oldrecorder.y == 0 then
                            elseif self._oldrecorder.y == self._normalOffset then
                            else
                                if self._otherorder.y == self._normalOffset then
                                    self._tableview:setContentOffset(cc.p(0, self._oldrecorder.y - self._changeHeight))
                                    return
                                else
                                    self._tableview:setContentOffset(cc.p(0, self._oldrecorder.y))
                                    return
                                end
                            end
                            return
                        end
                    end
                end
                local y = self._oldrecorder.y - self._changeHeight
                local x = self._oldrecorder.x
                self._tableview:setContentOffset(cc.p(x, y)) 
            end
        end
    else
        if self._oldrecorder.y == 0 then
            if self._newrecorder.y > 0 then
                --self._tableview:setContentOffset(cc.p(0, 0))
            else
                self._tableview:setContentOffset(cc.p(0, 0))
            end
        else
            if self._oldrecorder.y ~= self._extendOffset then 
                self._tableview:setContentOffset(cc.p(0, self._oldrecorder.y + self._changeHeight))
            end
        end
    end
end

function WListExtendView:setScrollEnabled(enable)
    if self._tableview and self._tableview.setScrollEnabled then
        self._tableview:setScrollEnabled(enable)
    end
end

--设置滑动回弹
function WListExtendView:setBounceable(bool)
    self._tableview:setBounceable(bool)
end

return WListExtendView