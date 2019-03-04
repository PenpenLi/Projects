--
-- Author: YouName
-- Date: 2016-01-13 21:23:56
--
--BUFF
local FastPkCell2=class("FastPkCell2",function()
	return display.newNode()
end)

function FastPkCell2:ctor( stage,buffSelected,costStar )
	-- body
	self._csbNode = cc.CSLoader:createNode("csb/thirtyThree/FastPkCell2.csb")
	self:addChild(self._csbNode)

	local strBuffDesc = ""
	dump(buffSelected)
	if(buffSelected ~= nil)then
		for i=1,#buffSelected do
			local buffId = buffSelected[i].Key
			local buffValue = buffSelected[i].Value
			if(buffValue > 0)then
				local buffInfo = require("app.cfg.common_buff_info").get(buffId)
				assert(buffInfo,"common_buff_info can't find buffId = "..tostring(buffId))
				local strName,strValue = GlobalFunc.getAttrDesc(buffInfo.type, buffInfo.value)

				strBuffDesc = strBuffDesc..strName.."+"..strValue.."  "
			end
		end
	end

	local strTitle = G_LangScrap.get("lang_tower_text_stage_name",{stage = stage,stageName = G_LangScrap.get("lang_tower_text_chose_buff")})
	self._csbNode:updateLabel("Text_title", {text = strTitle})

	self._csbNode:updateLabel("Text_buff_name", {text = strBuffDesc})
	self._csbNode:updateLabel("Text_star_cost", {text = G_LangScrap.get("lang_tower_text_num_star",{num = costStar})})

end


return FastPkCell2