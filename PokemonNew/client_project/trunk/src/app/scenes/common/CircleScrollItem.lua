--
-- Author: YouName
-- Date: 2016-01-14 22:04:20
--
local CircleScrollItem=class("CircleScrollItem",function()
	return display.newNode()
end)

function CircleScrollItem:ctor()
	-- body
    --self.super.ctor(self,...)   
    self.pos = 0  --位置
    self.angle = 0 -- 角度
    self.EndAngle = 0 -- 旋转时目标角度
    self.speed = 0
end

return CircleScrollItem