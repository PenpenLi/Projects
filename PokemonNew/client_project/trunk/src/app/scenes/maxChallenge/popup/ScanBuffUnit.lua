--
-- Author: wyx
-- Date: 2018-01-30 11:31:25
--
----=================================
-- 查看buff加成  buff面板
----=================================
local ScanBuffUnit = class("ScanBuffUnit", function ()
    return display.newNode()
end)

local BuffItem = require "app.scenes.maxChallenge.popup.BuffItem"
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")

function ScanBuffUnit:ctor(isEnemy)
	self._isEnemy = isEnemy
	self._buffItems = {}
	self._posList = {}

	local csbName = isEnemy == true and "ScanUnit1.csb" or "ScanUnit.csb"
	self._csbNode = cc.CSLoader:createNode("csb/maxChallenge/popup/"..csbName)
   	self:addChild(self._csbNode)

   	self._csbNode:setPositionX(8)

   	self._panel_con = self._csbNode:getSubNodeByName("Panel_con")
   	self._iconNode = self._csbNode:getSubNodeByName("Node_icon")

end

function ScanBuffUnit:setData(data,callback)
	self._data = data
	dump(data)
	--self._idx = idx
	self._callback = callback

	if self._isEnemy then
		self:renderMonster()
	else
		self:renderKnight()
	end

	self._csbNode:updateFntLabel("BitmapFontLabel_index",{
		text = data.order,
	})

	if not data then
		return
	end

	local totalH = self._panel_con:getContentSize().height
	local blankH = 20
	local buffs = data.buffs
	local buffNum = #buffs

	self._csbNode:updateLabel("Text_empty", {
		text = "未分配BUFF",
		textColor = G_Colors.getColor(21),
		visible = buffNum == 0
		})
	for i=1,#buffs do
		print("buff start==========")
		local buffItem = BuffItem.new()
		local size = buffItem:getContentSize()
		buffItem:setData(self._isEnemy,buffs[i],handler(self, self.onBuffItemCall))
		buffItem.data = buffs[i]
		self._panel_con:addChild(buffItem)

		-- local posX = i%2 ~= 0 and 15 or 200
		-- local row = math.floor((i-1)/2) 
		local posX,row = nil,nil
		if self._isEnemy then
			posX = i%2 ~= 0 and 15 or 200
			row = math.floor((i-1)/2)
		else
			posX = 40
			row = i - 1
		end
		-- local posX = 40
		-- local row = i - 1
		local poxY = totalH - 15 - size.height * (row + 1) - blankH * row
		dump(row)
		buffItem:setPosition(posX,poxY)
		local pos = buffItem:getPosition()
		table.insert(self._posList, {x = posX,y = poxY})
		table.insert(self._buffItems, buffItem)
	end
end

function ScanBuffUnit:renderKnight()
	--形象
	local knightData = G_Me.teamData:getKnightDataByID(self._data.id)
	--local master = G_Me.teamData:getKnightDataByPos(1)
	if knightData then
		local params = {
	        type = G_TypeConverter.TYPE_KNIGHT,
	        value = knightData.cfgData.knight_id,
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
	

    --name
    local knightColor = G_TypeConverter.quality2Color(knightData.cfgData.quality)
   
    if knightData.cfgData.type == 1 then -- 主角
        self._csbNode:updateLabel("Text_knight_name", {
            text = G_Me.userData.name,
            textColor = G_Colors.qualityColor2Color(knightColor),
            --outlineColor = G_Colors.qualityColor2OutlineColor(knightColor),
            fontSize = 17
            })
    else
        self._csbNode:updateLabel("Text_knight_name", {
            text = knightData.cfgData.name,
            textColor = G_Colors.qualityColor2Color(knightColor),
            --outlineColor = G_Colors.qualityColor2OutlineColor(knightColor),
            fontSize = 17
            })
    end
end

function ScanBuffUnit:renderMonster()
	local cfgData = self._data.cfg
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

    --name
    local knightColor = G_TypeConverter.quality2Color(cfgData.quality)
  
    self._csbNode:updateLabel("Text_knight_name", {
        text = cfgData.name,
        textColor = G_Colors.qualityColor2Color(knightColor),
        --outlineColor = G_Colors.qualityColor2OutlineColor(knightColor),
        fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL
        })
    
end

-- 点击则去除buff,并进行buff的重新排版
function ScanBuffUnit:onBuffItemCall(buff,target)
	local buffItem = nil
	for i=1,#self._buffItems do
		if target == self._buffItems[i] then
			buffItem = self._buffItems[i]
			table.remove(self._buffItems,i)
			break
		end
	end
	dump(buffItem.data)
	dump(self._data)

	if self._callback then
		self._callback(self._data.id,buffItem.data)
	end
	target:removeFromParent()
	if #self._buffItems == 0 then
		self._csbNode:updateLabel("Text_empty", {
		text = "未分配BUFF",
		textColor = G_Colors.getColor(21),
		visible = true
		})

		return
	end
	local Ease = cc.EaseExponentialOut

	for i=1,#self._buffItems do
		local pos = self._posList[i]
		dump(pos)
		local moveTo = cc.MoveTo:create(0.5,cc.p(pos.x,pos.y))
		self._buffItems[i]:runAction(Ease:create(moveTo))
	end

end
   
return ScanBuffUnit