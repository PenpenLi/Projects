
-- CustomNumber

--[=================[
	
	自定义数字模块
	支持美术单独切碎的数字图片格式

]=================]

local CustomNumber = class("CustomNumber", function()
	return display.newNode()
end)

function CustomNumber.create(spriteFrames, num, nosign)
	assert(spriteFrames and num, "spriteFrames and num could not be nil !")
	return CustomNumber.new(spriteFrames, num, nosign)
end

function CustomNumber.createUITxt(spriteFrames, num, nosign)
	assert(spriteFrames and num, "spriteFrames and num could not be nil !")
	return CustomNumber.new(spriteFrames, num, nosign, true)
end

function CustomNumber:ctor(spriteFrames, num, nosign, isUI)

	self:setCascadeOpacityEnabled(true)
    self:setCascadeColorEnabled(true)

	local node = display.newNode()
	node:setCascadeOpacityEnabled(true)
    node:setCascadeColorEnabled(true)
	self:addChild(node)

	self._numberNode = node

	-- 数字纹理资源
	self._spriteFrames = spriteFrames

	local png, plist
	if isUI then
		png, plist = G_Url:getText_UINum(spriteFrames)
	else
		png, plist = G_Url:getText_battleNum(spriteFrames)
	end

	display.loadSpriteFrames(plist, png)

	self._noSign = nosign

	self:setNumber(tonumber(num))

end

function CustomNumber:setNumber(num)

	num = checknumber(num)
	self._number = num

	self._numberNode:removeAllChildren()

	-- 添加每一个数字，现在还不支持小数
	-- 拆分数字
	local function _splitNumber(num)
		if num == 0 then return end
		local unit = num % 10
		return tostring(unit), _splitNumber((num - unit) / 10)
	end

	-- 这里获取的数据是逆序的
	local nums = {_splitNumber(tonumber(math.abs(num)))}
	if not self._noSign then
		if num < 0 then
			table.insert(nums, "-")
		elseif num > 0 then
			table.insert(nums, "+")
		else
			table.insert(nums, "0")
		end
	else
		if num == 0 then --等于0的时候，上面的方法没有加入0.所以这里再判断一次。
			table.insert(nums, "0")
		end
	end

	local size = cc.size(0, 0)

	-- 绘制数字
	local _i = 1
	for i=#nums, 1, -1 do
		local sprite = display.newSprite("#"..self._spriteFrames.."_"..tostring(nums[i])..".png")
		if self._numberUnitWidth == nil then
			self._numberUnitWidth = display.newSprite("#"..self._spriteFrames.."_"..tostring(nums[1])..".png"):getContentSize().width
		end

		self._numberNode:addChild(sprite)

        local index = (_i-1) - #nums/2 + 0.5
        sprite:setPosition(index * self._numberUnitWidth, 0)
        _i = _i + 1

        -- self._numberUnitWidth = self._numberUnitWidth or sprite:getContentSize().width
        
        size.width = size.width + sprite:getContentSize().width
        size.height = sprite:getContentSize().height
	end

	self:setContentSize(size)
	self:setIgnoreAnchorPointForPosition(false)
	self:setAnchorPoint(cc.p(0.5, 0.5))

	self._numberNode:setPosition(cc.p(size.width/2, size.height/2))

end

function CustomNumber:getNumber()
	return self._number
end

-- 获取数字的位数

function CustomNumber:getNumberUnit()
	local strNum = tostring(math.abs(self._number))
	return string.len(strNum) + (self._noSign and 0 or 1)
end

-- 获取单个数字宽度

function CustomNumber:getNumberUnitWidth()
	return self._numberUnitWidth
end

function CustomNumber:addNumber(number)
	self:setNumber(self._number + number)
end

return CustomNumber