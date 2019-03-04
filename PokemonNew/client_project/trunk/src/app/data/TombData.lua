--
-- Author: Yutou
-- Date: 2017-09-15 18:28:52
--
local TombData=class("TombData")

local tombexploremain = require("app.cfg.tombexploremain_info")
local tombexplore = require("app.cfg.tombexplore_info")
local TombChapterData = require("app.scenes.tomb.data.TombChapterData")

TombData.VIP_FUNC_INFO_KEY = 20506

function TombData:ctor( ... )
	-- body
	self._chpaters = nil
	self._chpatersIndex = nil
	self._hasInit = false
	self._gobackAwards = nil--回城的奖励
	self.goNewStage = nil
	self.listViewPos = {0,0} -- 章节滑动位置
end

function TombData:init()
	self._chpaters = {}
	self._chpatersIndex = {}
	local len = tombexploremain.getLength()
	local perChapterData = nil
	for i=1,len do
		local chapter_id = tombexploremain.indexOf(i).chapter_id
		local chapterData = TombChapterData.new(chapter_id)
		self._chpaters[chapter_id] = chapterData
		local index = #self._chpatersIndex + 1
		chapterData:setIndex(index)
		self._chpatersIndex[index] = chapterData

		chapterData:setPerData(perChapterData)
		if perChapterData then
			perChapterData:setNextData(chapterData)
		end
		perChapterData = chapterData
	end
	self._hasInit = true
end

-->>>>>>>>>后端数据入口start>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
function TombData:setChapterData( chapters )
	for i=1,#chapters do
		local id = chapters[i].id
		if self._chpaters == nil then return end
		-- dump(self._chpaters)
		-- dump(id .. " : " .. i)
		-- dump(chapters)
		--if self._chpaters[id] then
			self._chpaters[id]:update(chapters[i])
		--end
	end
end

function TombData:setBoughtSpadeCount( value )
	self._boughtSpadeCount = value
end

function TombData:setNextBoughtCost( value )
	self._nextBoughtCost = value
end

function TombData:getBoughtSpadeCount(  )
	return self._boughtSpadeCount
end

function TombData:getNextBoughtCost( ... )
	return self._nextBoughtCost
end

function TombData:getEnteredData()
	if self._chpatersIndex == nil then
		return
	end
	for i=1,#self._chpatersIndex do
		local chpater = self._chpatersIndex[i]
		print2("getEnteredData",chpater._has_entered,chpater._id)
		if chpater:hasEntered() then
			return chpater
		end
	end
	return nil
end

function TombData:setStageData( chapterid,stage )
	self._chpaters[chapterid]:setStagesData(stage)
end

function TombData:updateStageData(stage_id,door )
	local stage = self:getStageByID(stage_id)
	if stage == nil then
	 	if buglyReportLuaException ~= nil then
            buglyReportLuaException("TombData; stage == nil: "..tostring(stage_id) .. ":".. tostring(#self._chpatersIndex))
        end
		return
	end
	assert(stage,"TombData:updateStageData stage nil id:" .. stage_id)
	stage:updateDoor(door)
end

function TombData:setExecuteData(data, stage_id,door,battle )
	if self._hasInit == false then
		return
	end

	local stage_id = data.stage_id
	local door_num = data.door_num
	local stageData = data.stage
	local battle = data.battle

	local stage = self:getStageByID(stage_id)
	for i=1,#stageData.doors do
		if stageData.doors[i].num == door_num then
			stage:updateDoor(stageData.doors[i])
		end
	end
	stage:setIsFinished(stageData.is_finished)

	if rawget(stageData, "boss_door") then
		stage:setBossDoor(rawget(stageData, "boss_door"))
	end
end

-- decodeBuffer.stage_id,
-- decodeBuffer.category,
-- decodeBuffer.awards,
-- decodeBuffer.next_stage_id,--下一关的id
-- decodeBuffer.next_stage--下一关初始化的door
function TombData:setGoBackData( data )
	print("TombData:setGoBackData")
	local stage_id = data.stage_id
	local category = data.category
	self._gobackAwards = data.awards
	local next_stage_id = data.next_stage_id--下一关的id
	local next_stage = data.next_stage--下一关初始化的door
	dump(data)
	if category == 4 then
		local stage = self:getStageByID(next_stage_id)
		--assert(stage,"next_stage_id:"..tostring(next_stage_id))
		if stage == nil then
			return
		end
		stage:update(next_stage)
	end
	if category == 3 and data.chapter then--结束一个章节
		local chapter = data.chapter
		if self._chpaters[chapter.id] then
			self._chpaters[chapter.id]:update(chapter)
		end
	end
end
-->>>>>>>>>后端数据入口end>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

function TombData:getGobackAwards()
	return self._gobackAwards
end

function TombData:getChapterList( ... )
	return self._chpatersIndex
end

function TombData:getChapterByID( id )
	return self._chpaters[id]
end

function TombData:getStageByID( id )
	if self._hasInit == false then
		return
	end
	for i=1,#self._chpatersIndex do
		local chapterData = self._chpatersIndex[i]
		local stage = chapterData:getStageByID(id)
		if stage then
			return stage
		end
	end
	return nil
end

function TombData:release()
	self._chpaters = nil
	self._chpatersIndex = nil
	self._hasInit = false
end

return TombData