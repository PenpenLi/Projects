--
-- Author: wyx
-- Date: 2018-04-29 16:12:33

--[[排名奖励预览cell]]

local RankRewardCell=class("RankRewardCell",function()
	return cc.TableViewCell:new()
end)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local WidgetTools = require("app.common.WidgetTools")

function RankRewardCell:ctor()
	-- body
	self._cellValue = nil

	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("RankRewardCell","guild/mission/pop"))
	self:addChild(self._csbNode)

	self._scrollList = self._csbNode:getSubNodeByName("ScrollView_awards")
    self._scrollList:setSwallowTouches(false)
end


function RankRewardCell:_updateAwardList(scrollView, awards)

    if not scrollView or type(awards) ~= "table" then return end

    scrollView:removeAllChildren(true)

    local scrollViewSize = scrollView:getContentSize()

    local goodList = awards or {}

    local IconSpace = 5  -- icon间隔
    local IconWidth = 88  -- icon宽度

    WidgetTools.createIconsInPanel(scrollView, {awards=goodList, 
        xOffset = 20,
        yOffset = 7,
        scale = 0.8})

    if #goodList >= 5 then
        scrollView:setBounceEnabled(true)
    else
        scrollView:setBounceEnabled(false)
    end

    --总宽度
    local width = IconSpace*(#goodList+1) + (#goodList)*IconWidth
    local innerWidth = width > scrollViewSize.width and width or scrollViewSize.width
    scrollView:setInnerContainerSize(cc.size(innerWidth,scrollViewSize.height))
    scrollView:setScrollBarEnabled(false)
end

--刷新单元格
function RankRewardCell:updateData( cellValue )
	-- body
	self._cellValue = cellValue

	local awards = cellValue.dropList
	self._scrollList:removeAllChildren(true)

	self:_updateAwardList(self._scrollList,awards)

	local str = cellValue.rank_min == cellValue.rank_max and cellValue.rank_min or cellValue.rank_min .. "-" .. cellValue.rank_max
    self:updateLabel("Text_reward_rank", {
    	text=G_Lang.get("worldboss_reward_rank",{num = str}),
    	textColor = G_Colors.getColor(9),
    	outlineColor = G_Colors.getOutlineColor(9),
    	})
end

return RankRewardCell

