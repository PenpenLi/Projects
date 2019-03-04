local RecruitingReviewScene = class("RecruitingReviewScene", function ()
	return display.newScene("RecruitingReviewScene")
end)

----招募预览场景
function RecruitingReviewScene:ctor(layerClass)
	self._layerClass = layerClass
end

function RecruitingReviewScene:onEnter()
    self:regeditWidgets("mainmenu","topbarLevel2Block")
    self._layer = self._layerClass.new()
	---background
	self._bgLayer = display.newSprite(G_Url:getUI_background("bg_practice"))
    self._bgLayer:align(display.BOTTOM_CENTER, display.cx, 0)
	self:addChild(self._bgLayer)

	local bgSize = self._bgLayer:getContentSize()
	self._bgLayer:setScale(display.width / bgSize.width)

	self:addChild(self._layer)
	self:addChatFloatNode()
end

function RecruitingReviewScene:onExit()
	self._layer:setVisible(false)
	self._bgLayer:setVisible(false)
	self:removeChild(self._layer)
	self:removeChild(self._bgLayer)
	self._layer = nil
	self._bgLayer = nil
end

return RecruitingReviewScene