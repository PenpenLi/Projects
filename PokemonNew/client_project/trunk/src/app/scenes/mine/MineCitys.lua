--
-- Author: yutou
-- Date: 2018-09-18 20:36:45
--

local MineCitys=class("MineCitys",function()
	return ccui.Layout:create()
end)
local Parameter_info = require("app.cfg.parameter_info")
local MineCity = require("app.scenes.mine.MineCity")

function MineCitys:ctor(index)
	self._index = index
	self._data = G_Me.mineData
	self._pageNum = nil
	self:enableNodeEvents()
	self:init()
end

function MineCitys:init()
	self._pageNum = tonumber(Parameter_info.get(584).content)
end

function MineCitys:render()
	if self._isRender == true then
		return
	end
	self._isRender = true
	self._csbNode = cc.CSLoader:createNode("csb/mine/MineCitys.csb")
	self:addChild(self._csbNode)
	self._csbNode:setContentSize(display.width,display.height)
	ccui.Helper:doLayout(self._csbNode)

	self._citys = {}
	for i=1,5 do
		self._citys[i] = self:getSubNodeByName("Node_city_" .. i)
	end

    self:setTouchEnabled(true)
    self:setSwallowTouches(false)
end

function MineCitys:focusOnPage()
    local data = self._data:getCitysByIndex(self._index)
    if data and #data >= 5 then
    	self:renderCity()
    else
    	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_UPDATE_INFO,self.renderCity,self)
    	local needIndexs = {self._index}
    	G_HandlersManager.mineHandler:sendGetInfoList(needIndexs,true)
    end
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_ATTACK,self.attacking,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_ATTACK_OVER,self.attackover,self)
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_APPLY_JOB,self.renderCity,self)
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_FIRE,self.renderCity,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_REFRESH_ONE,self.renderCity,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_QUIT,self.renderCity,self)
end

function MineCitys:attacking()
    self._isAttacking = true
end

function MineCitys:attackover()
    self._isAttacking = false
    self:renderCity()
end

function MineCitys:focusOutPage()
	uf_eventManager:removeListenerWithTarget(self)
	local data = self._data:getCitysByIndex(self._index)
	if self._citys and data then
		for i=1,#data do
			self._citys[i]:removeAllChildren()
		end
	end
end

function MineCitys:renderCity()
    local data = self._data:getCitysByIndex(self._index)
	if self._isRender == false then
		return
	end
	if data == nil or #data ~= 5 then
		-- if buglyReportLuaException ~= nil then
		-- 	dump(data)
		-- 	local allNum = 0
		-- 	if data then
		-- 		allNum = #data
		-- 	end
	 --    	buglyReportLuaException("MineCitys:renderCity: data == "..tostring(data) .. " " .. tostring(self._index) .. " " .. tostring(allNum))
	 --    end
		return
	end
	
	for i=1,#data do
		local mineCity = MineCity.new(data[i])
		self._citys[data[i]:getMinePosition()]:removeAllChildren()
		self._citys[data[i]:getMinePosition()]:addChild(mineCity)
	end
end

function MineCitys:clear()
	if self._isRender == false then
		return
	end
	self._isRender = false
	self._citys = nil
	self:removeAllChildren()
end

function MineCitys:onEnter()

end

function MineCitys:onExit()
	
end

function MineCitys:onCleanup()
	uf_eventManager:removeListenerWithTarget(self)
	self:removeAllChildren()
end

return MineCitys