local UserBiblePageUnit = class("UserBiblePageUnit")

----月光宝盒里面每一页的数据对象
function UserBiblePageUnit:ctor()
	self._opened = false ---是否开启
	self._clear = false --是否全部点亮
	self._gotReward = false ---是否已经领取了奖励
	self._index = 0 ---在章节中的下标
	self._items = {} --对应的子碎片数组，UserBibleUnit
	--self._id = 0 --页签id
end

function UserBiblePageUnit:setInfo(info)
	assert(info or type(info) == "table", "invalide info value " .. tostring(info)) 
	self._info = info --对应的表数据
end

function UserBiblePageUnit:getId()
	return self._info.tabs
end

function UserBiblePageUnit:setClear()
	self._clear = true
end

function UserBiblePageUnit:getClear()
	return self._clear
end

-----设置为已经领取了奖励
function UserBiblePageUnit:setGotReward()
	self._gotReward = true
end

----是否已经领取了奖励
function UserBiblePageUnit:getGotReward()
	return self._gotReward 
end

----设置为打开状态
function UserBiblePageUnit:setOpen()
	self._opened = true
end

function UserBiblePageUnit:getOpen()
	return self._opened
end

function UserBiblePageUnit:getRewardType()
	return self._info.reward_type
end

function UserBiblePageUnit:getRewardValue()
	return self._info.reward_value
end

----是否能够领取章节奖励
function UserBiblePageUnit:isCanGetPageReward()
	return self._items[#self._items]:getLighting()
end

function UserBiblePageUnit:getType()
	return self._info.type
end

function UserBiblePageUnit:setIndex(value)
	assert(value or type(value) == "number", "invalide Index value " .. tostring(value)) 		
	self._index = value
end

function UserBiblePageUnit:getIndex()
	return self._index
end

function UserBiblePageUnit:getName()
	return self._info.name
end

function UserBiblePageUnit:addItem(value)
	assert(value or type(value) == "table", "invalide Items value " .. tostring(value)) 	
	self._items[#self._items + 1] = value
	table.sort(self._items, function (a, b)   ---从小到大排列
		if a:getNextId() == 0 then -------最后一个的值为0
            return false
        else
            return a:getNextId() < b:getNextId()
        end
	end)
end

function UserBiblePageUnit:getNextId()
	return self._info.next_id
end

function UserBiblePageUnit:getItems()
	return self._items
end


function UserBiblePageUnit:getItemById(id)
	for i = 1, #self._items do
		local item = self._items[i]
		if item:getId() == id then
			return item
		end
	end

	return nil
end

----获取当前进度的珠宝数据
function UserBiblePageUnit:getProgressItem()
	if not self._opened then return nil end

	for i = 1, #self._items do
		local item = self._items[i]
		if not item:getLighting() then
			return item
		end
	end

	return nil
end

----获取最后一个珠宝数据
function UserBiblePageUnit:getLastItem()
	return self._items[#self._items]
end


----获取向客户端请求领取选择单个奖励的ID
---原因是服务器将奖励与最后的一个珠宝绑定。所以此处返回的是最后一个珠宝ID
function UserBiblePageUnit:get2ServerSelectRewardId()
	local lastItem = self:getLastItem()
	return lastItem:getId()
end

----获取显示的URL
function UserBiblePageUnit:getIconUrl()
	return tostring((self._info.tabs - 1) % 5 + 1)
end

function UserBiblePageUnit:getTips()
	return self._info.seen_directions
end

return UserBiblePageUnit