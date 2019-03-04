--
-- Author: Yutou
-- Date: 2017-02-14 16:02:57
--
--数据管理类 持有并管理这个模块的数据
local FormationsDataManager = class("FormationsDataManager")

--[[
data = {{
		required uint32 id = 1; //阵型对应id
		required uint32 icon = 2; //knight_info_id。
		required string name = 3; //阵型名称。
		repeated uint32 indexs = 4; //对应队伍位置，神将槽位。 1 - 6
		repeated uint32 orders = 5; //出手顺序。 1 - 6
	},
	...
	}
]]

--获取单利
function FormationsDataManager.getInstance( ... )
	return FormationsDataManager.instance
end

function FormationsDataManager:ctor(data)
	FormationsDataManager.instance = self--单例

	self._hasChange = {}--数据是否改变 改变了需要通知后端

	self._formations = data.formations and data.formations or {}
	self._ownIDs = nil--已经拥有的武将id 用于显示可选头像

	--布阵 武将id列表
	for i=1,#self._formations do
		self._hasChange[self._formations[i].id] = false
	end

	self:addEvent()
end

function FormationsDataManager:addEvent( ... )
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_TEAM_CREATEFORMATION,self._addFormation,self)
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_TEAM_DELFORMATION,self._delFormation,self)
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_TEAM_RESETFORMATION,self.updateFormation,self)--重置
end

function FormationsDataManager:getKnightIDByPos( id,index )
	local data = self:get(id)
	local knightID = G_Me.teamData:getKnightIDByPos(data.indexs[index])
	return knightID
end

function FormationsDataManager:getKnightIDs( id )
	local data = self:get(id)
	local knightIDs = {}
	for i=1,#data.indexs do
		local knightID = G_Me.teamData:getKnightIDByPos(data.indexs[i])
		table.insert(knightIDs,knightID)
	end
	
	return knightIDs
end

function FormationsDataManager:setOwnIDs( ids )
	self._ownIDs = ids
end

function FormationsDataManager:getOwnIDs( )
	return self._ownIDs
end

function FormationsDataManager:updateFormation( data )
	for i=1,#self._formations do
		if self._formations[i].id == data.id then
			self._formations[i] = data
			self._hasChange[data.id] = false
		end
	end
	
	uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_TEAM_FORMATION_UPDATE, nil, false,data.id)
end

--已经通知后端了 重新统计
function FormationsDataManager:recoverChange( id )
	self._hasChange[id] = false
end

function FormationsDataManager:hasChange( id )
	return self._hasChange[id]
end

function FormationsDataManager:getData( ... )
	return self._formations
end

function FormationsDataManager:_delFormation( data )
	local id = data.id
	for i=1,#self._formations do
		if self._formations[i].id == id then
			table.remove(self._formations,i)
			break
		end
	end
	uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_TEAM_DELFORMATION2, nil, false,id)
end

function FormationsDataManager:_addFormation( data )
	local formation = data.formation
	table.insert(self._formations,formation)

	uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_TEAM_ADDFORMATION, nil, false,formation)
end

function FormationsDataManager:get( id )
	local data = nil
	for i=1,#self._formations do
		if self._formations[i].id == id then
			data = self._formations[i]
		end
	end
	return data
end

function FormationsDataManager:changeNameAndIcon(id, name,icon )
	local data = self:get(id)
	data.name = name
	data.icon = icon
end

function FormationsDataManager:getOrder( id )
	local data = self:get(id)
	return data.orders
end

function FormationsDataManager:switchKnightPos(id, fromIndex,toIndex )
	local data = self:get(id).indexs
	local from = data[fromIndex]
	data[fromIndex] = data[toIndex]
	data[toIndex] = from

	self._hasChange[id] = true
end

function FormationsDataManager:switchOrderPos(id, fromIndex,toIndex )
	local data = self:get(id).orders
	local from = data[fromIndex]
	data[fromIndex] = data[toIndex]
	data[toIndex] = from

	self._hasChange[id] = true
end

function FormationsDataManager:release( ... )
	uf_eventManager:removeListenerWithTarget(self)
	FormationsDataManager.instance = nil
end

return FormationsDataManager