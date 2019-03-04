--
-- Author: YouName
-- Date: 2016-01-13 15:59:42
--
--buff显示面板
local BuffAddPop=class("BuffAddPop",function()
	return display.newNode()
end)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local UpdateNodeHelper = require ("app.common.UpdateNodeHelper")

function BuffAddPop:ctor( fromPos )
	-- body
	self:enableNodeEvents()
	self._csbNode = nil
end

function BuffAddPop:_initUI( ... )
	-- body
	self:setPosition(display.cx,display.cy)
	self._csbNode = cc.CSLoader:createNode("csb/tower/BuffAddAllPop.csb")
	self._panelAttr = self._csbNode:getChildByName("Panel_attr")
	self._btn_close = self._csbNode:getChildByName("Button_close")
	self:addChild(self._csbNode)

	-- self._btn_close:addClickEventListener(function( ... )
	-- 	self:removeFromParent()
	-- end)

	UpdateNodeHelper.updateCommonNormalPop(self._csbNode:getSubNodeByName("project_com"),"属性加成",function ( ... )
		self:removeFromParent(true)
	end,316)

	self._csbNode:updateLabel("Text_tips",{
		textColor = G_Colors.getColor(1),
		})

	self._empty_tips = self._csbNode:updateLabel("Text_empty_tips", {
		text = G_Lang.get("tower_buff_empty_tips"),
		textColor = G_Colors.getColor(2),
		visible = false,
		})

	--buff面板
	local buffs = G_Me.thirtyThreeData:getAddedBuffs() or {}
	local len = #buffs

	self._empty_tips:setVisible(len == 0)
	if len == 0 then
		return
	end
	local attrHeight = 30
	local blankH = 5
	local scrollView = self._csbNode:getSubNodeByName("ScrollView_attr")
	local row = len%2 == 0 and len/2 or len/2 + 1
	local totalH = attrHeight*row + blankH*(row + 1)
	totalH = totalH >= scrollView:getContentSize().height and totalH or scrollView:getContentSize().height
	scrollView:setInnerContainerSize(cc.size(scrollView:getContentSize().width,totalH))
	scrollView:setScrollBarEnabled(false)


	if(self._panelAttr ~= nil)then
		--self._panelAttr:setVisible(#buffs > 0)
		for i=1,len do
			local tBuff = buffs[i]
			local attrItem = cc.CSLoader:createNode("csb/tower/AttrItem.csb")
			scrollView:addChild(attrItem)

			--pos
			local posX = i%2 ~= 0 and 30 or 240
			local row = math.floor((i-1)/2) 
			local posY = totalH - 7 - attrHeight * (row + 1) - blankH * row
			attrItem:setPosition(posX, posY)

			local strName,strValue = "",""
			if(tBuff ~= nil)then
				strName,strValue = tBuff.name..":","+"..tBuff.value
			end
			local textTitleAttr = attrItem:updateLabel("Text_title_attr",{text=strName})
			--self._panelAttr:getSubNodeByName("Text_title_attr"..tostring(i))
			local textNumAttr = attrItem:updateLabel("Text_num_attr",{text=strValue})
			--local textNumAttr = self._panelAttr:getSubNodeByName("Text_num_attr"..tostring(i))
			textNumAttr:setPositionX(textTitleAttr:getPositionX() + 3)
			textNumAttr:doScaleAnimation()
			--textNumAttr:setPositionX(textTitleAttr:getPositionX() + textTitleAttr:getContentSize().width + 3)
		end
	end
end

function BuffAddPop:onEnter( ... )
	-- body
	self:_initUI()
end

function BuffAddPop:onExit( ... )
	-- body
	if(self._csbNode ~= nil)then
		self._csbNode:removeFromParent(true)
		self._csbNode = nil
	end
end

return BuffAddPop