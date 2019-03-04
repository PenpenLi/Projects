local MissionIslandMapNode = class("MissionIslandMapNode",function ()
	return display.newNode()
end)


function MissionIslandMapNode:ctor(mapData)
	self._mapData = mapData
	self._mapCsb = nil
	self._mapCsbName = "IsLand_"..((mapData - 1)%4 + 1)..".csb"
	self._cityCfg = require("app.scenes.missionnew.mapcfg.MapCityCfg")

	self:enableNodeEvents()
end

function MissionIslandMapNode:onEnter()
	local cardPath = "csb/missionnew/islands/" .. self._mapCsbName
    self._mapCsb = cc.CSLoader:createNode(cardPath)
    self:addChild(self._mapCsb)

    local panel = self._mapCsb:getChildByName("Panel_1")
    local success = panel:getChildByName("Sprite_success")
    local city = panel:getChildByName("Sprite_city")
    local bg = panel:getChildByName("Image_1")
    local fileNode = panel:getChildByName("FileNode_1")

    local progress = fileNode:getChildByName("Text_progress")
    local star = fileNode:getChildByName("Sprite_star")
    local title = fileNode:getChildByName("Sprite_title")
    local zhangjie = fileNode:getChildByName("Sprite_zhangjie")

    city:setTexture(G_Url:getUI_mission("island/" .. self._cityCfg[self._mapData]))

	-- for i = 1, #images do
	-- 	local data = images[i]
	-- 	if data.isEffect == "1" then
	-- 		---添加特效
	-- 		---特效有id, x, y 属性
	-- 		local effectNode = EffectNode.new(data.res)
 --            effectNode:setAutoRelease(true)
 --            effectNode:play()
 --            effectNode:setPosition(data.x, data.y)
 --            effectNode:setScale(data.scale == nil and 1 or data.scale)
 --            self:addChild(effectNode, i)
	-- 	else
	-- 		--添加图片，
	-- 		--异步加载图片创建函数
	-- 		local create = function(texture, imgData)
	--             --图片有res, x, y, width, height, scaleX, scaleY属性
	-- 			local image = display.newSprite(texture)
	-- 			local imageSize = image:getContentSize()
	-- 			local scaleX = tonumber(imgData.width) / imageSize.width
	--             local scaleY = tonumber(imgData.height) / imageSize.height
	--             local rotation = tonumber(imgData.rotation)
	-- 			image:setAnchorPoint(0.5, 0)
	-- 			self:addChild(image)
	-- 			image:setRotation(rotation)
	-- 			image:setPosition(tonumber(imgData.x), tonumber(imgData.y) - 200)
	--             image:setScaleX(scaleX)
	--             image:setScaleY(scaleY)
	--             image:setFlippedX(tonumber(imgData.flipX) < 0)
	--             image:setFlippedY(tonumber(imgData.flipY) < 0)
	--         end

	--         local filename = preUrl .. data.res
	--         cc.Director:getInstance():getTextureCache():addImageAsync(filename, 
	--         	function(texture)
 --                	create(texture, data)
 --            end)
	-- 	end
	-- end
end

function MissionIslandMapNode:onExit()
	---取消图片的异步加载
	local images = self._mapData.images
	local preUrl = self._mapData.preUrl
	
	for i = 1, #images do
		local data = images[i]
		if data.isEffect ~= "1" then
	        local filename = preUrl .. data.res
	        cc.Director:getInstance():getTextureCache():unbindImageAsync(filename)
		end
	end

	self:removeAllChildren()
end

function MissionIslandMapNode:showRedPoint()
	if self._imageTip == nil then
		self._imageTip = display.newSprite(G_Url:getText_signet("w_img9_signet01"))
		local posStart = cc.p(-120, 100)
		self._imageTip:setPosition(posStart)

		require("app.scenes.team.TeamUtils").playSkewFloatEffect(self._imageTip)

		self:addChild(self._imageTip, 200)
	end

	self._imageTip:setVisible(true)
end

function MissionIslandMapNode:hideRedPoint()
	if self._imageTip ~= nil then
		self._imageTip:setVisible(false)
	end
end

return MissionIslandMapNode