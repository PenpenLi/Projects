--
-- Author: yutou
-- Date: 2018-09-18 21:59:07
--

local MineTabCell=class("MineTabCell",function ()
    return cc.TableViewCell:new()
end)

function MineTabCell:ctor(callBack)
	self._callBack = callBack
	self._index = nil
	self._data = G_Me.mineData
	self:enableNodeEvents()
	self:init()
end

function MineTabCell:init()

end

function MineTabCell:onEnter()

end

function MineTabCell:onExit()
	uf_eventManager:removeListenerWithTarget(self)
end

--获取活动索引
function MineTabCell:getIndex()
    return self._index
end

function MineTabCell:updateData(index)
	self._index = index + 1
	self._csbNode = cc.CSLoader:createNode("csb/mine/MineTabCell.csb")
	self:addChild(self._csbNode)

	self._btn = self._csbNode:getSubNodeByName("Button_tab")
	self._num = self._csbNode:getSubNodeByName("Text_index")
	self._btn:addClickEventListenerEx(function( )
		self._callBack(self._index)
	end)
	self._btn:setTouchSwallowEnabled(false)
	self._btn:setSwallowTouches(false)
	self._num:setString(tostring(self._index))

	self:render()
end

--是否显示选中背景框图片
function MineTabCell:showSelect(curPageIndex)

end

function MineTabCell:render()
	if self._index == self._data:getNowIndex() then
		self._btn:loadTextureNormal(G_Url:getUIUrl("mine","tab2"))
	else
		self._btn:loadTextureNormal(G_Url:getUIUrl("mine","tab1"))
	end
end

function MineTabCell:onCleanup()
	self:removeAllChildren()
end

return MineTabCell