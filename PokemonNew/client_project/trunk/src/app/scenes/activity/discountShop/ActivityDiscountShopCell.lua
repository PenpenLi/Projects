
--===================
--折扣商店列表cell
--==================
local ActivityDiscountShopCell = class("ActivityDiscountShopCell", function ()
	return cc.TableViewCell:new()
end)

local TypeConverter = require "app.common.TypeConverter"
local UpdateNodeHelper = require "app.common.UpdateNodeHelper"
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"

function ActivityDiscountShopCell:ctor()
	self._data = nil

	self._view = cc.CSLoader:createNode(G_Url:getCSB("ActivityDiscountShopCell", "activity"))
	self:addChild(self._view)
end

function ActivityDiscountShopCell:updateCell(data, index)
	self._data = data
	self:freshView()
end

function ActivityDiscountShopCell:getId()
	return self._data.id
end

function ActivityDiscountShopCell:freshView()
	self:_updateView()
end

function ActivityDiscountShopCell:_updateView()
	self._view:updateLabel("Text_next_condition","")
	self._view:updateLabel("Text_title", G_Lang.get("activity_level_reward_need_level", {num = self._data.level}))
	local needMoneyStr = "" 
	local buttonDesc = ""
	local buttonState = UpdateButtonHelper.STATE_NORMAL
	local buttonVisible = true
	local callFunc = nil
	local btnVisible = false
	local strTexture = ""

	-- 按钮相关
	--buttonState = UpdateButtonHelper.STATE_ATTENTION
	--dump(self._data.limit_buy)
	--dump(self._data.buyCount)
	if self._data.limit_buy > self._data.buyCount then -- 可以购买
		buttonDesc = G_Lang.get("common_btn_buy")
		btnVisible = true
	elseif self._data.limit_buy <= self._data.buyCount then -- 已达购买上限
		strTexture = "newui/common/icon/icon_bought01.png"
	else
		strTexture = "newui/common/icon/icon_daysign01.png"
	end

	-- 渲染
	UpdateButtonHelper.updateNormalButton(
        self._view:getSubNodeByName("Button_award"),{
        state = buttonState,
        desc = buttonDesc,
        visible = btnVisible,
        callback = function ()
        	--if self._data.discount ~= nil or G_Me.vipData:getVipLevel() >= self._data.vipLevel then
        		G_HandlersManager.activityHandler:sendGetLevelReward(self._data.discount == nil and 1 or 2,self._data.id)
        	-- else
        	-- 	G_Popup.newPopup(function ()
         --            local panel = VipLayer.new(VipLayer.TAB_INDEX_RECHARGE) ---显示充值面板
         --            return panel
         --        end)
        	-- end
        end
    })

	-- 剩余次数
    self._view:updateLabel("Text_buy_max",self._data.buyCount .. "/" .. self._data.limit_buy)
    self._view:updateFntLabel("BitmapFontLabel_discount",self._data.discount)

    --dump(strTexture)
    --dump(strTexture ~= "")
    --self._view:updateImageView("Image_pass", {texture = strTexture, visible = (strTexture ~= "")})
	--self._view:getSubNodeByName("Image_pass"):loadTexture(strTexture)
end

function ActivityDiscountShopCell:_getAwards()
	return self._data.awards
end

return ActivityDiscountShopCell