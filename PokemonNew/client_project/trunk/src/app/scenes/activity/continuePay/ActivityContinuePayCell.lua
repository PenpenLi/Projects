
--===========
--领取每日奖励界面的单列数据

local ActivityContinuePayCell = class("ActivityContinuePayCell", function ( )
	return cc.TableViewCell:new()
end)

local UpdateNodeHelper = require "app.common.UpdateNodeHelper"
local RoundEffectHelper = require "app.common.RoundEffectHelper"
local ActivityLoginRewardPopupLayer = require "app.scenes.activity.loginReward.ActivityLoginRewardPopupLayer"
local ActivityLoginRewardPopupVipLayer = require "app.scenes.activity.loginReward.ActivityLoginRewardPopupVipLayer"

local UpdateButtonHelper = require "app.common.UpdateButtonHelper"

function ActivityContinuePayCell:ctor()
	self._view = cc.CSLoader:createNode(G_Url:getCSB("ActivityContinuePayCell", "activity"))
	self._itemDatas = nil
	self:addChild(self._view)

    self._data = G_Me.activityData.activityContinuePayData
end

---包含四个数据的数组
function ActivityContinuePayCell:updateCell(idx, itemDatas)
	self:updateView(itemDatas)
end

-- cell状态刷新
function ActivityContinuePayCell:_updateStatue(itemDatas)
	--self._view:getSubNodeByName("Image_shade_red"):setVisible(itemDatas:getCanReceive())
	-- self._view:getSubNodeByName("Image_shade_red"):setVisible(false)
	-- self._view:getSubNodeByName("button_title"):setLocalZOrder(99)

	local state = UpdateButtonHelper.STATE_ATTENTION
	if itemDatas.day > self._data.next_lc or (itemDatas.day == self._data.next_lc and self._data.lc < self._data.next_lc) then
		state = UpdateButtonHelper.STATE_GRAY
	end
	UpdateButtonHelper.updateNormalButton(self._view:getSubNodeByName("Button_award"),{
		visible = itemDatas.day >= self._data.next_lc,
		enableEffect = itemDatas.day == self._data.next_lc,self._data.lc >= self._data.next_lc,
		callback = function ( ... )
	        G_HandlersManager.rechargeHandler:sendGetLianchongAwards(2,itemDatas.day)
		end,
		desc = G_Lang.get("activity_text_continue_pay_get"),
		state = state,
		effect = state == UpdateButtonHelper.STATE_ATTENTION
		}
	)

	self._view:getSubNodeByName("Text_title_2"):setString(G_Lang.get("activity_text_continue_pay_day",{num = itemDatas.day}))

	-- -- 已领取图标
	self._view:getSubNodeByName("Image_pass"):setVisible(not self._view:getSubNodeByName("Button_award"):isVisible())

	-- -- 未达成图标
	-- self._view:getSubNodeByName("Image_unreach"):setVisible(not itemDatas:getHasBeenGot() and not itemDatas:getCanReceive())
end

-- 刷新cell
function ActivityContinuePayCell:updateView(data)
	self._itemDatas = data

	-- 第几天
	-- self._view:getSubNodeByName("Text_day"):setString(G_Lang.get("activity_daylogin_day",{num = data.num}))

	-- cell状态设置
	self:_updateStatue(data)

	self:_showDrops(data.awards)
end

--展示商品
function ActivityContinuePayCell:_showDrops(dropItems)
    local con_size = 112*0.8
    local dropList = self:getSubNodeByName("ListView_awards")
    dropList:setScrollBarEnabled(false)
    dropList:setGravity(ccui.ListViewGravity.bottom)
    dropList:setSwallowTouches(false)
    dropList:removeAllItems()
    dropList:setItemsMargin(10)
    local Helper = require("app.common.UpdateNodeHelper")
    local Converter = require("app.common.TypeConverter")
    local Url = require "app.setting.Url"
    local item
    local data
    local outframe 
    local size
    local putIndex = 0
    for i = 1,#dropItems do
        item = cc.CSLoader:createNode(Url:getCSB("MissionDropsItem", "missionnew"))
        data = dropItems[i]
        data.nameVisible = false
        data.sizeVisible = true
        data.levelVisible = false
        data.disableTouch = false
        data.scale = Helper.NODE_SCALE_80
        data.needVisible = G_Me.equipData:isUpRankMaterialNeed(data.type,data.value)
        Helper.updateCommonIconItemNode(item:getSubNodeByName("content"), Converter.convert(data))
        outframe = item:getSubNodeByName("holder")
        item:removeChild(outframe, false)
        outframe:setContentSize(con_size,con_size)
        outframe:getSubNodeByName("content"):setPositionY(outframe:getSubNodeByName("content"):getPositionY() + 2)
        -- outframe:setPositionY(-50)
        dropList:insertCustomItem(outframe, putIndex)
        putIndex = putIndex + 1
    end
end

return ActivityContinuePayCell