local MissionIslandMapNode = class("MissionIslandMapNode",function ()
	return display.newNode()
end)

local EffectNode = require("app.effect.EffectNode")

MissionIslandMapNode.ISLAND_NUM = 3
function MissionIslandMapNode:ctor(index)
	self._index = index
	self._mapCsb = nil
	local mapIndex = (index - 1)%MissionIslandMapNode.ISLAND_NUM + 1
	self._mapCsbName = "IsLand_"..mapIndex..".csb"

	self:enableNodeEvents()

	self:render()
end

function MissionIslandMapNode:render()

	local cardPath = "csb/guild/mission/islands/" .. self._mapCsbName
    self._mapCsb = cc.CSLoader:createNode(cardPath)
    self._mapCsb:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self._mapCsb)
    
    local panel = self._mapCsb:getChildByName("Panel_1")
    self._success = panel:getChildByName("Sprite_success")
    self._city = panel:getChildByName("Sprite_city")
    local bg = panel:getChildByName("Image_1")
    self._infoHolder = panel:getChildByName("Node_info")
    self.nodeTop = panel:getChildByName("Node_top")
    self.nodeTop:setVisible(true)
    self._textTip = panel:updateLabel("Text_tips",{
    	text = G_Lang.get("mission_guild_attack_time_clue"),
    	textColor = G_Colors.getColor(24),
    	outlineColor = G_Colors.getOutlineColor(26)
    	})
    self._textTip:setContentSize(135,55)
    self._textTip:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
    self._textTip:setVisible(false)

    --加特效start
    local conSize = panel:getContentSize()
	
	--local EffectNode = require("app.effect.EffectNode")
    -- EffectNode.createEffect( "effect_river_map" .. mapIndex,cc.p(conSize.width/2,conSize.height-60),self.nodeTop)
    --加特效end
    
    self._city:setVisible(false)
    self._success:setVisible(false)

	--新手引导用
	if self._index == 1 then
		panel:setName("IsLand_1")
	end
end

function MissionIslandMapNode:clearRender()
	
end

function MissionIslandMapNode:getInfoHolder( ... )
	return self._infoHolder
end

function MissionIslandMapNode:setCity( resName )
    self._city:setVisible(true)
    self._city:setTexture(G_Url:getUI_mission("stage_city/"..resName))
end

function MissionIslandMapNode:onEnter()

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
	if self.nodeTop then
		self.nodeTop:removeFromParent()
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

--是否通关
function MissionIslandMapNode:hasOver( value )
	self._success:setVisible(value)
end

--是否提示攻打时间
function MissionIslandMapNode:showTip( value )
	self._textTip:setVisible(value)
end

function MissionIslandMapNode:hideRedPoint()
	if self._imageTip ~= nil then
		self._imageTip:setVisible(false)
	end
end

return MissionIslandMapNode