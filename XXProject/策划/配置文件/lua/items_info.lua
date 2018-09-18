道具信息_items_info = {
	_data = {
	[1] = {1,"西瓜",50,2,1,500,1,"1|35,2|30|50|60","1|35",1,"1|1|1000","1|1|1000","1|1|2000",},
	[2] = {2,"瓜子",50,3,2,500,1,0,0,2,"1|2|2000","1|2|2000","1|1|1000",},
	[3] = {3,"月饼",50,4,3,500,1,0,0,0,"1|1|3000","1|1|1000","1|1|2000",},
	}
}

local __index_id = {
	[1] = 1,
	[2] = 2,
	[3] = 3,
}

local __key_map = {
	id = 1,
	name = 2,
	desc = 3,
	quality = 4,
	icon = 5,
	type = 6,
	storage = 7,
	getway = 8,
	toway = 9,
	compose = 10,
	sell = 11,
	fenjie = 12,
	usecost = 13,
}

local m = {
		__index = function(t,k)
			if k == "toObject"then
			return function()
				local o = {}
				for key, v in pairs (__key_map) do
					o[key] = t._raw[v]
				end
				return o
			end
		end

		assert(__key_map[k], "cannot find ".. k .. " in record_道具信息_items_info")
		return t._raw[__key_map[k]]
		end
}

function 道具信息_items_info.getLength()
		return #道具信息_items_info._data
end
function 道具信息_items_info.hasKey(k)
	if __key_map[k] == nil then
		return false  else
	return true
	end
end

function 道具信息_items_info.indexOf(index)
		if index == nil then
			return nil
		end
return setmetatable({_raw = 道具信息_items_info._data[index]}, m)
end

function 道具信息_items_info.get(id)
		return 道具信息_items_info.indexOf(__index_id[id])
end

function 道具信息_items_info.set(id, key, value)
		local record = 道具信息_items_info.get(id)
		if record then
			local keyIndex = __key_map[key]
			if keyIndex then
				record._raw[keyIndex] = value
			end
		end
end

function 道具信息_items_info.get_index_data()
    return __index_id
end

