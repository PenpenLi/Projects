--
-- Author: wyx
-- Date: 2018-04-26 20:18:57
--
local FormationEnemyList=class("FormationEnemyList",function()
	return display.newNode()
end)

local FormationIcon = require("app.scenes.guild.mission.pop.FormationIcon")

FormationEnemyList.WIDTH = 88
FormationEnemyList.HEIGHT = 106
FormationEnemyList.BLANK_X = 40
FormationEnemyList.BLANK_Y = 10

function FormationEnemyList:ctor()
	self._icons = {}
	self:_initUI()
end

function FormationEnemyList:_initUI()
	local posX,posY = 0,0
	local row = 0
	for i=1,6 do
		local icon = FormationIcon.new():addTo(self)
		self._icons[i] = icon

		local row = i%3 == 0 and math.floor(i/3) or math.floor(i/3) + 1 -- 1 start
		local col = i%3 == 0 and 3 or i%3

		posX = (col - 1) * (FormationEnemyList.WIDTH + FormationEnemyList.BLANK_X)
		posY = (row - 1) * (FormationEnemyList.HEIGHT + FormationEnemyList.BLANK_Y)
		icon:setPosition(posX, posY)
	end
end

function FormationEnemyList:update(data)
	if not data then
		return
	end

	self._data = data
	for i=1, 6 do
		self._icons[i]:update(data[i])
	end
end

return FormationEnemyList