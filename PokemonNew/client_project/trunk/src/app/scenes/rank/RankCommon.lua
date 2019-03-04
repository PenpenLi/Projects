--
-- Author: Your Name
-- Date: 2017-10-19 16:08:06
--
local RankCommon = {}

function RankCommon.getIconFrame(frameId,quality)
	local color = G_TypeConverter.quality2Color(quality)
	local icon_frame = nil
	if frameId > 100 then
		icon_frame = G_Url:getIconFrame(frameId)
    else
        icon_frame = G_Url:getUI_frame("img_frame_0"..color)
	end

	return icon_frame
end

return RankCommon