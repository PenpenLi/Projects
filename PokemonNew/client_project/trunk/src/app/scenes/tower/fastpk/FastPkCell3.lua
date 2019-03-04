--
-- Author: YouName
-- Date: 2016-01-13 21:24:44
--
--奖励
local FastPkCell3=class("FastPkCell3",function()
	return display.newNode()
end)

local TypeConverter = require("app.common.TypeConverter")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local ItemConst = require("app.const.ItemConst")

function FastPkCell3:ctor( stage,awards )
	-- body
	self._csbNode = cc.CSLoader:createNode("csb/thirtyThree/FastPkCell3.csb")
	self:addChild(self._csbNode)
	self._conH = 270

	local strTitle = G_LangScrap.get("lang_tower_text_stage_name",{stage = stage,stageName = G_LangScrap.get("lang_tower_text_box_award")})
	self._csbNode:updateLabel("Text_title", {text = strTitle})

	local nodeAward = self._csbNode:getSubNodeByName("Node_award_con")

	local cols = 5
	local initW = 550
	local spaceX = 105
	local spaceY = 103
	local offsetY = -50
	local offsetX = (initW - (cols * spaceX))/2
	self._conH = 185 + (math.ceil(#awards/cols) - 1)*spaceY
	-- self._conH =  > 1 and 270 or 176

	local awardParams = {}
	for i = 1,#awards do
		local itemAward = awards[i]
		local params = {
			type = itemAward.type,
			value = itemAward.value,
			size = itemAward.size,
			nameVisible = false,
			disableTouch = true,
			needVisible = G_Me.equipData:isUpRankMaterialNeed(itemAward.type, itemAward.value),
		}
		params = TypeConverter.convert(params)
		awardParams[#awardParams + 1] = params
	end

	table.sort(awardParams,function(a,b)
		local aType = 0 
		if a.type == TypeConverter.TYPE_ITEM then
			if a.cfg.item_type == ItemConst.ITEM_TYPE_PAPER then
				aType = 2
			elseif a.cfg.item_type == ItemConst.ITEM_TYPE_GEM then
				aType = 1
			end
		end
		local bType = 0 
		if b.type == TypeConverter.TYPE_ITEM then
			if b.cfg.item_type == ItemConst.ITEM_TYPE_PAPER then
				bType = 2
			elseif b.cfg.item_type == ItemConst.ITEM_TYPE_GEM then
				bType = 1
			end
		end

		if aType ~= bType then
			return aType > bType
		end

		if aType == bType and aType == 2 then
			return a.cfg.id > b.cfg.id
		end

		if aType == bType and aType == 1 then
			return a.cfg.color > b.cfg.color
		end

		if a.cfg.color ~= b.cfg.color then
			return a.cfg.color > b.cfg.color
		end
	end)

	for i=1,#awardParams do
		local itemParams = awardParams[i]
		local icon = cc.CSLoader:createNode("csb/common/CommonIconItemNode.csb")
		nodeAward:addChild(icon)
		icon:setPosition(offsetX + spaceX/2 + (i-1)%cols*spaceX,offsetY - math.floor((i-1)/cols)*spaceY)
		UpdateNodeHelper.updateCommonIconItemNode(icon,itemParams)
		icon:setScale(0.9)
	end

	local imageBg = self._csbNode:getSubNodeByName("Image_bg")
	imageBg:setContentSize(550,self._conH-4)
	ccui.Helper:doLayout(imageBg)
end

function FastPkCell3:getConH()
	-- body
	return self._conH
end

return FastPkCell3