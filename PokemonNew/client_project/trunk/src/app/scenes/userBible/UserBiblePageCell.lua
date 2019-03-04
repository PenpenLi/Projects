local UserBiblePageCell = class("UserBiblePageCell", function ()
	return cc.TableViewCell:new()
end)

local UserBibleConfigConst = require "app.const.UserBibleConfigConst" 

local LIGHT_COLOR = cc.c3b(0xff,0xff,0xff)
local DARK_COLOR = cc.c3b(0x66,0x66,0x66)
---==============
---月光宝盒目录元件
---==============
function UserBiblePageCell:ctor(onClick)
	self:enableNodeEvents()
	self._onClick = onClick
	self._pageData = nil
	self._index = 0
	self._activeAnim = nil
	self._content = cc.CSLoader:createNode(G_Url:getCSB("UserBiblePageCell", "userBible"))
	self:addChild(self._content)
	self._frontCon = self:getSubNodeByName("Panel_front")
	self._frontCon:setSwallowTouches(false)
	local contentSize = self._frontCon:getContentSize()
	self._content:setPosition(contentSize.width/2, contentSize.height/2)
	self._frontCon:addTouchEventListenerEx(handler(self, self._onClicked))
	--self:updateLabel("Text_name", {outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE, outlineSize = 2})
end

----传入的为UserBiblePageUnit对象
function UserBiblePageCell:updateCell( view,idx,cellValue)
	assert(cellValue or type(cellValue) ~= "table", "invalide cellValue" .. tostring(cellValue))
	self._index = idx 
	self:updateImageView("Image_icon", {texture = G_Url:getUI_userBible("bg_userbible_" .. cellValue:getIconUrl())})
	self._content:updateLabel("Text_name", {text = cellValue:getName(),visible = true})
	--dump(cellValue:getName())
	self._pageData = cellValue
	self._activeAnim = nil
	self:_updateEffect()
end

function UserBiblePageCell:freshData()
	self._pageData = G_Me.userBibleData:getPageBibleDataById(self._pageData:getId())
end

function UserBiblePageCell:getIndex()
	return self._pageData:getIndex()
end

function UserBiblePageCell:_onClicked(sender, eventType)
	if eventType == ccui.TouchEventType.ended then
		local pos = sender:convertToWorldSpace(CCPoint(0,0))
		dump(pos)
		local moveOffset=math.abs(sender:getTouchEndPosition().x-sender:getTouchBeganPosition().x)
		if moveOffset <= 20 then
			self._onClick(self._index,nil)
		end
     end
end

------
-----是否显示特效
function UserBiblePageCell:setEffectIndex(effectIndex)
	self._effectIndex = effectIndex
	self:_updateEffect()
end

----更新特效显示
function UserBiblePageCell:_updateEffect()
	self._frontCon:removeAllChildren()
	local contentSize = self._frontCon:getContentSize()
	self:getSubNodeByName("Image_light"):setVisible(self._effectIndex == self._pageData:getIndex())

	local opened = self._pageData:getOpen()
	self._content:setColor(opened and LIGHT_COLOR or DARK_COLOR)
end

return UserBiblePageCell