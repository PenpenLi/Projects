local MatchTopKnightNode=class("MatchTopKnightNode",function()
	return display.newNode()
end)

local KnightImg = require("app.common.KnightImg")

function MatchTopKnightNode:ctor(data,top,click)
	self:enableNodeEvents()
	
	self._top = top
	self._data = data
	self._click = click
	self._img = nil
	self:_init()
end

function MatchTopKnightNode:_init()
	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("MatchTopKnightNode","match/common"))
	self._csbNode:setContentSize(display.width,display.height)
	self._csbNode:setPosition(0,0)
	ccui.Helper:doLayout(self._csbNode)
	self._csbNode:addTo(self)

	self._con = self._csbNode:getSubNodeByName("Node_con")
	self._text_name = self._csbNode:getSubNodeByName("Text_name")
	self._sprite_top = self._csbNode:getSubNodeByName("Sprite_top")
	self._text_server = self._csbNode:getSubNodeByName("Text_server")

	self._node_info = self._csbNode:getSubNodeByName("Node_info")
	if self._top == nil then
		self._node_info:setPositionY(240)
	end
	
	self:render()
end

function MatchTopKnightNode:update(data)
	self._data = data
	self:render()
end

function MatchTopKnightNode:render()
	self._con:removeAllChildren()
	if self._data then
		local knight_info = require("app.cfg.knight_info").get(self._data.knight)
  		local ex_lv = knight_info.quality >= 10 and 3 or 0
		local knightImg = KnightImg.new(self._data.knight,15,ex_lv)
		self._con:addChild(knightImg)

		if self._click then
 			knightImg:setTouchEnabled(true)
			knightImg:addClickEventListenerEx(function(  )
				self._click()
			end)
		end
		self._img = knightImg

		-- self._text_name:setString(self._data.name)
		self._csbNode:updateLabel("Text_name", {text = self._data.name,
		textColor = G_Colors.qualityColor2Color(G_TypeConverter.quality2Color(self._data.leader_quality),true),
		outlineColor = G_Colors.qualityColor2OutlineColor(G_TypeConverter.quality2Color(self._data.leader_quality)),outlineSize = 2})
		local sidText = self._data.sid%1000
		self._text_server:setString("<S".. sidText  ..">")
		self._text_server:setVisible(true)
		self._text_name:setVisible(true)
	else
		local hero_empty = cc.CSLoader:createNode(G_Url:getCSB("Hero_" .. self._top,"match/common"))
		self._con:addChild(hero_empty)
		self._text_server:setString(G_Lang.get("match_space_hero"))
		self._text_name:setVisible(false)
	end

	if self._top then
		self._sprite_top:setTexture(G_Url:getUI_match("common/top" .. self._top))
		self._sprite_top:setVisible(true)
	else
		self._sprite_top:setVisible(false)
	end
end

function MatchTopKnightNode:setImgScaleX( value )
	self._img:setScaleX(value)
end

function MatchTopKnightNode:onEnter()

end

function MatchTopKnightNode:onExit()
	uf_eventManager:removeListenerWithTarget(self)
end

function MatchTopKnightNode:onCleanup()
	
end


return MatchTopKnightNode