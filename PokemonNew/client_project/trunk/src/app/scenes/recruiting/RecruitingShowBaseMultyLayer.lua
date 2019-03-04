
---===========
---10连抽展示的基类
local RecruitingShowBaseLayer = require "app.scenes.recruiting.RecruitingShowBaseLayer"
local RecruitingShowBaseMultyLayer = class("RecruitingShowBaseMultyLayer", RecruitingShowBaseLayer)


function RecruitingShowBaseMultyLayer:ctor(recruitType)
	RecruitingShowBaseMultyLayer.super.ctor(self,RecruitingShowBaseLayer.RecruitypeTen,recruitType)
end

function RecruitingShowBaseMultyLayer:_getStarFrameIndex()
	return 1
end

function RecruitingShowBaseMultyLayer:_getKnightScaleAfterShow()
	return 0.65
end

return RecruitingShowBaseMultyLayer