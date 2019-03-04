--
-- Author: Your Name
-- Date: 2018-04-29 11:40:29
--[[
	通关奖励cell
]]

local PassRewardCell=class("PassRewardCell",function()
	return cc.TableViewCell:new()
end)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local WidgetTools = require("app.common.WidgetTools")

function PassRewardCell:ctor( getHandler )
	-- body
	self._cellValue = nil
	self._cellIdx = 0

	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("PassRewardCell","guild/mission/pop"))
	self:addChild(self._csbNode)

	self._scrollList = self._csbNode:getSubNodeByName("ScrollView_awards")
	self._scrollList:setSwallowTouches(false)

	self._btnGet = self._csbNode:getSubNodeByName("Button_get")
	self._btnGet:addClickEventListenerEx(handler(self,self._onGetHandler))
end

--点击领奖
function PassRewardCell:_onGetHandler( sender )
	-- body
	G_HandlersManager.guildHandler:sendGetReward(1,self._cellValue:getId())
	-- local passTime = self._cellValue:getPassTime()
	-- local joinTime = G_Me.guildMissionData:getJoinTime()
	-- dump(joinTime)
	-- dump(passTime)
	-- if passTime > 0 and joinTime < passTime then
	-- 	G_HandlersManager.guildHandler:sendGetReward(1,self._cellValue:getId())
	-- else -- 过24小时可领
	-- 	local endTime = joinTime + 86400
	-- 	local serverTime = G_ServerTime:getTime()
	-- 	local coolTime = endTime - serverTime
	-- 	if coolTime > 0 then -- 未到领奖时间
	-- 		G_Popup.tip("mission_guild_reward_cd_tips",{time = GlobalFunc.fromatHHMMSS2(coolTime)})
	-- 	else -- 时间已到，数据未同步
	-- 		G_HandlersManager.guildHandler:sendGetReward(1,self._cellValue:getId())
	-- 	end
	-- end
end

function PassRewardCell:_updateAwardList(scrollView, awards)

    if not scrollView or type(awards) ~= "table" then return end

    scrollView:removeAllChildren(true)

    local scrollViewSize = scrollView:getContentSize()

    local goodList = awards or {}

    local IconSpace = 5  -- icon间隔
    local IconWidth = 88  -- icon宽度

    WidgetTools.createIconsInPanel(scrollView, {awards=goodList, 
        xOffset = 8,
        yOffset = 2,
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
function PassRewardCell:updateData( cellValue )
	-- body
	self._cellValue = cellValue

	local awards = cellValue:getPassRewards()
	self._scrollList:removeAllChildren(true)
	dump(awards)
	self:_updateAwardList(self._scrollList,awards)

	self._csbNode:updateLabel("Text_pass_title", {
		text = G_Lang.get("mission_guild_pass_chapter",{num = cellValue:getOrder()}),
		textColor = G_Colors.getColor(1),
		})

	--name
	self._csbNode:updateLabel("Text_pass_name", {
		text = cellValue:getCfgInfo().name,
		textColor = G_Colors.getColor(1),
		})

	local hasGet = G_Me.guildMissionData:IsGotPassReward(cellValue:getId())
	local hasFinished = cellValue:getHasFinished()
	--未达成
	self._csbNode:getSubNodeByName("Image_no_reach"):setVisible(not hasFinished and not hasGet)
	--已领取
	self._csbNode:getSubNodeByName("Image_gotten"):setVisible(hasGet)
	--可领取
	local passTime = cellValue:getPassTime()
	UpdateButtonHelper.reviseButton(self._csbNode:getSubNodeByName("Button_get"), {text = "领取"})
	self._csbNode:updateButton("Button_get",{
		visible = hasFinished and not hasGet,
		enableEffect = passTime > 0,
		})
end

return PassRewardCell