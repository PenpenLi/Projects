--
-- Author: YouName
-- Date: 2016-03-25 16:58:58
--
local OthersBuilding = class("OthersBuilding",function()
	return display.newNode()
end)

function OthersBuilding:ctor( ... )
	-- body
	self:enableNodeEvents()
	self._img = nil
	self._prevFileName = nil
end

function OthersBuilding:loadTexture( fileName )
	-- body
	if self._prevFileName == fileName then return end
	self:_unbindAsync()
	if fileName == nil then return end
	cc.Director:getInstance():getTextureCache():addImageAsync(fileName, function(texture)
        if self._img == nil then
        	self._img = display.newSprite(texture)
        	self:addChild(self._img)
        else
        	self._img:setTexture(texture)
        end
    end)
    self._prevFileName = fileName
end

function OthersBuilding:_unbindAsync( ... )
	-- body
	if self._prevFileName ~= nil then
		cc.Director:getInstance():getTextureCache():unbindImageAsync(self._prevFileName)
		self._prevFileName = nil
	end
end

function OthersBuilding:onEnter( ... )
	-- body
end

function OthersBuilding:onExit( ... )
	-- body
	self:_unbindAsync()
end

return OthersBuilding