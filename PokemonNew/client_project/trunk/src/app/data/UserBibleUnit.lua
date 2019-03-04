local UserBibleUnit = class("UserBibleUnit")

---月光宝盒的基础数据单元
function UserBibleUnit:ctor()
	self._lighting = false -- 是否闪光，已点亮
	self._info = nil ------表数据
	self._picUrl = ""
	self._isEndOfChapter = false ---是否是章节里面的最后一个
	self._chapterTips = "" -----章节提示。最后一个珠子显示的
end

function UserBibleUnit:getId()
	return self._info.id
end

function UserBibleUnit:getChapterId()
	return self._info.tabs
end

----传入策划表数据，进行初始化
function UserBibleUnit:setInfo(info)
	self._info = info
end

function UserBibleUnit:getNextId()
	return self._info.next_id
end

----获取提示
function UserBibleUnit:getTips()
	return self._info.directions
end

function UserBibleUnit:setChapterTips(value)
	assert(value or type(value) == "string", "invalide ChapterTips value " .. tostring(value)) 
	self._chapterTips = value
end

----获取章节奖励的提示文字
function UserBibleUnit:getChapterTips()
	return self._chapterTips
end

---设置是否点亮
function UserBibleUnit:setLighting(value)
	assert(value or type(value) == "boolean", "invalide Lighting value " .. tostring(value)) 
	self._lighting = value
end

---获取是否点亮
function UserBibleUnit:getLighting()
	return self._lighting
end

---获取显示ICON的地址
function UserBibleUnit:getPicUrl()
	return self._picUrl
end

function UserBibleUnit:setPicUrl(value)
	assert(value or type(value) == "string", "invalide PicUrl value " .. tostring(value)) 	
	self._picUrl = (value - 1) % 5 + 1
end

---提示是否是一直显示的
function UserBibleUnit:isImportant()
	return self._info.resident == 1
end

----设置为章节里面的最后一个
function UserBibleUnit:set2EndOfChapter()
	self._isEndOfChapter = true
end


function UserBibleUnit:isEndOfChapter()
	return self._info.resident == 1
end

function UserBibleUnit:getRewardType()
	return self._info.type
end

function UserBibleUnit:getAttributeType()
	return self._info.value
end

function UserBibleUnit:getAttributeValue()
	if self._info.type ~= 101 then 
		return 0
	end

	if  self._info.value < 99 then -- 单个属性
		return self._info["attr_" .. self._info.value]
	else -- 全属性
		return {self._info.attr_1,self._info.attr_2,self._info.attr_3}
	end
	return self._info.attribute_value
end

function UserBibleUnit:getLimitType()
	return self._info.limit_type
end

function UserBibleUnit:getLimitValue()
	return self._info.value
end

function UserBibleUnit:getChapterTipColor()
	--local chapterInfo = require("app.cfg.main_growth_chapter").get(self._info.chapter_id)
	return 5
end

---获得消耗的道具或者材料
---返回的为, 1,材料的名字 2,需要材料的数量，3，当前材料总数
function UserBibleUnit:getCostData()
	local TypeConverter = require("app.common.TypeConverter")
	local ItemConst = require("app.const.ItemConst")
	local costData = {
		type = TypeConverter.TYPE_ITEM,
		value = ItemConst.YING_XIONG_LING_ID,
		size = self._info.cost_num,
	}

	costData = TypeConverter.convert(costData)
	return costData.cfg.name, costData.size , G_Me.propsData:getPropItemNum(costData.cfg.id)
end

return UserBibleUnit