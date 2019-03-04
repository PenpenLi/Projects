--
-- Author: wyx
-- Date: 2018-04-26 20:48:53

local FormationIcon=class("FormationIcon",function()
	return display.newNode()
end)

local UpdateNodeHelper = require ("app.common.UpdateNodeHelper")
local ShaderUtils = require("app.common.ShaderUtils")

function FormationIcon:ctor()
	self:_initUI()
end

function FormationIcon:_initUI()
	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("FormationIconNode", "guild/mission/pop"))
	self:addChild(self._csbNode)
	self._iconNode = self._csbNode:getSubNodeByName("Node_icon")
	self._hpBar = self._csbNode:getSubNodeByName("LoadingBar_hp")
	self._img_dead = self._csbNode:updateLabel("Image_dead", {
		visible = false,
		})
	self._order = self._csbNode:getSubNodeByName("BitmapFontLabel_index")
	self._imgBar = self._csbNode:getSubNodeByName("Image_bar")
end

function FormationIcon:update(data)
	self._data = data
	self:_render()
end

function FormationIcon:_render()
	--shape
	local cfgData = self._data:getCfg()
	if cfgData then
		local params = {
	        type = G_TypeConverter.TYPE_KNIGHT,
	        value = cfgData.knight_id,
	        sizeVisible = false,
	        levelVisible = false,
	        nameVisible = false,
	        scale = 0.8,
	    }
	    UpdateNodeHelper.updateCommonIconKnightNode(self._iconNode,params,function(sender,params)
	        
	    end)
	else
		local params = {
	        icon = "newui/common/formation/empty.png",
            iconVisible = true,
	        color = 1,
	        levelVisible = false,
	        nameVisible = false,
	        scale = 0.8,
	    }

	    UpdateNodeHelper.updateCommonModuleIconNode(self._iconNode,params,function ( ... )
	    	-- body
	    end)
	end

	self._order:setString(tostring(self._data:getOrder()))
	dump(self._data)
    local isDead = self._data:isDead()
    local isExist = self._data:isExist()
    self._img_dead:setVisible(isDead and isExist)
    self._imgBar:setVisible(not isDead)
    ShaderUtils.removeFilter(self._iconNode)
    if not isDead then
    	self:_updateHp()
    elseif isExist then
		ShaderUtils.applyGrayFilter(self._iconNode)
    end
end

function FormationIcon:_updateHp()
	self._hpBar:setPercent(self._data:getHpPercent())
	self._csbNode:updateLabel("Text_hp_percent", {
		text = tostring(self._data:getHpPercent() == 0 and 1 or self._data:getHpPercent()).."%",
		textColor = G_Colors.getColor(11),
		outlineColor = G_Colors.getOutlineColor(26)
	})
end

return FormationIcon