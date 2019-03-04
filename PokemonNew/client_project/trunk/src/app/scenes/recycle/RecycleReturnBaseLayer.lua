--[====================[

    分解重生返还材料预览道具Cell

]====================]
local RecycleReturnItemCell = class ("RecycleReturnItemCell", function ()
      return cc.TableViewCell:new()
end)

local UpdateNodeHelper = require "app.common.UpdateNodeHelper" 
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"

function RecycleReturnItemCell:ctor()
    local node = cc.CSLoader:createNode(G_Url:getCSB("RecycleReturnItemCell","recycle"))
    self:addChild(node)
end

function RecycleReturnItemCell:updateCell(data, index) ---更新一行的显示
	local count = #data
	for i=1, 5 do
		local iconNode = self:getSubNodeByName("ProjectNode_icon" .. i)
		--iconNode:setPositionX(iconNode:getPositionX() - 5 * (i - 1) ) -- 调整间距
		if i <= count then
			local item  = data[i]
			UpdateNodeHelper.updateCommonIconItemNode(iconNode,
				{
					type = item.type,
					value = item.value,
					size = item.size,
					disableTouch = true,
					nameVisible = true,
					scale = 0.8,
				})
			iconNode:setVisible(true)
		else
			iconNode:setVisible(false)
		end
	end
end


--[====================[

    分解重生返还材料预览面板基类

]====================]
local RecycleReturnBaseLayer = class("RecycleReturnBaseLayer",function()
	return display.newLayer()
end)

--
function RecycleReturnBaseLayer:ctor(returnResource, call)
    self:enableNodeEvents()
    --
	self._content = nil
	self._listLayer = nil
	self._listView = nil
    self._callback = call
	--
	local result = {}
	local cellSize = 0

	if returnResource then
	    for i=1, #returnResource do
	        local index = (i-1) % 5
	        if index == 0 then
	            cellSize = cellSize + 1
	            result[cellSize] = {}
	        end
	        result[cellSize][(index+1)] = returnResource[i]
	    end
    end
	self._returnResource = result
	
end

--
function RecycleReturnBaseLayer:onEnter()
	self:_initWidget()
	self:_updateWidget()
end

--
function RecycleReturnBaseLayer:onExit()
end

-- 初始化界面
function RecycleReturnBaseLayer:_initWidget()
	self:setPosition(cc.p(display.cx, display.cy))

	-- csb
	self._content = cc.CSLoader:createNode(G_Url:getCSB("RecycleReturnLayer", "recycle"))
	self:addChild(self._content)

	UpdateNodeHelper.updateCommonNormalPop(self, nil, nil, 553)

	self._content:updateButton("Button_close", function()
        self:removeFromParent(true)
    end)

	UpdateButtonHelper.updateNormalButton(
        self:getSubNodeByName("Button_confirm"),{
        state = UpdateButtonHelper.STATE_ATTENTION,
        callback = function ()
            if self._callback then
	        	self._callback()
	        end
	        
	        self:removeFromParent(true)
	        uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false)
        end
    })

	UpdateButtonHelper.updateNormalButton(
        self:getSubNodeByName("Button_cancle"),{
        state = UpdateButtonHelper.STATE_NORMAL,
        callback = function ()
	        self:removeFromParent(true)
        end
    })

    -- create list view
	self._listLayer = self._content:getSubNodeByName("Layout_tableView")
	local size = self._listLayer:getContentSize()
    self._listView = require("app.ui.WListView").new(size.width, size.height, 550, 150) --以每行作为一个单元
    self._listView:setTouchEnabled(#self._returnResource >= 2)
    self._listView:setCreateCell(function(view, idx)
        return RecycleReturnItemCell.new()
    end)
    self._listView:setUpdateCell(function(view, cell, idx)
        local data = self._returnResource[idx + 1]
        cell:updateCell(data, idx)
    end)

    self._listLayer:addChild(self._listView)
end

-- 更新界面
function RecycleReturnBaseLayer:_updateWidget()
    self._listView:setCellNums(#self._returnResource, false, 0)
end


return RecycleReturnBaseLayer