--==============
--	关卡地图背/前景

local MissionStageBackgroundNode=class("MissionStageBackgroundNode",function( ... )
	return display.newNode()
end)

--@mapName 地图的名字
function MissionStageBackgroundNode:ctor(mapName)
	-- body
	self:enableNodeEvents()
	self._mapName = mapName 
	self._images = nil ---存储所有的图片
end

function MissionStageBackgroundNode:onEnter( ... )
	--加载全部的图片
	local resPath = G_Url:getMapBg(self._mapName)
	
	local image = display.newSprite(resPath)
	image:setAnchorPoint(0.5, 0)
	image:setPosition(display.cx,0)
	image:setScale(640/269)
	self:addChild(image)
end

function MissionStageBackgroundNode:onExit( ... )
	-- body
	self._images = nil
	self:removeAllChildren(true)
end

return MissionStageBackgroundNode