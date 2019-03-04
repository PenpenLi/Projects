--[====================[
    随机活动物品item
    kaka
]====================]

local RandomActivityItem=class("RandomActivityItem",function()
	return display.newNode()
end)

local TypeConverter = require("app.common.TypeConverter")
local RoundEffectHelper = require ("app.common.RoundEffectHelper")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local CommonBuyCount = require("app.common.CommonBuyCount")

function RandomActivityItem:ctor(onBuyClick)
	self._onBuyClick = onBuyClick

	self._csbNode = nil
	self._itemData = nil
	self._costInfo = nil

	self._costPanel = nil
	
	self._boxNode = nil

	self._roundEffect = nil

	self:_initUI()
end

--UI界面初始化
function RandomActivityItem:_initUI()
	self._csbNode  = cc.CSLoader:createNode("csb/randomActivity/RandomActivityItem.csb")
	self:addChild(self._csbNode)
	
	self._costPanel = self._csbNode:getSubNodeByName("Panel_cost")

	--宝箱待机动画
    self._boxNode = self._csbNode:getSubNodeByName("Node_box")
    self._itemNode = self._csbNode:getSubNodeByName("Node_item_icon")

    -- self._imageDiscount = self._csbNode:getSubNodeByName("Image_discount")

	self._csbNode:updateLabel("Text_cost", {
		outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,outlineSize = 2})

	self._touchPanel = self._csbNode:getSubNodeByName("Panel_touch")
	self._touchPanel:addClickEventListenerEx(function ( sender )
		-- body
		self:_onBuyButtonClick()
	end)

end

--点击购买
function RandomActivityItem:_onBuyButtonClick(sender)

	if not self._itemData or not self._costInfo or 
		self._itemData.buyCount > 0 then 
		return 
	end

	if self._onBuyClick and self._itemData.buyCount == 0 then
		self._onBuyClick(self._itemData,self._costInfo)
	end
end

--绑定数据
function RandomActivityItem:updateData(value)

	self._itemData = value

	if not self._itemData then return end

	-- dump(self._itemData)
	self._costInfo = nil

	local buyCount = self._itemData.buyCount
	local cfgData = self._itemData.cfgData

	-- assert(cfgData, " item data error ="..self._itemData.goodId)

	local hasBought = buyCount > 0
	local isRecommend = false--cfgData.recommend > 0

	self._boxNode:removeAllChildren(true)

	self._costPanel:setVisible(not hasBought)
	self._boxNode:setVisible(not hasBought)
	self._itemNode:setVisible(hasBought)
	self._touchPanel:setTouchEnabled(not hasBought)

	self:_clearEffect()

	if hasBought and cfgData then
		local good = {type=cfgData.type, value=cfgData.value, size=cfgData.size}
		self:showGoodItem(good, self._itemData.goodId)

	else
		
		local effectIdle = require("app.effect.EffectNode").new("effect_jct_bxx_1")
		effectIdle:play()
		effectIdle:setScale(0.55)
		self._boxNode:addChild(effectIdle)

		--购买开宝箱次数对应的功能id
		local message = {
			func_id = 10333, 
			buy_count = G_Me.randomActivityData:getBuyGoodCount()
		}
		local priceType = TypeConverter.TYPE_GOLD  --cfgData.price_type  --不用了
		local price = CommonBuyCount.getBuyCost( message ) --cfgData.price --不用了

		self._costInfo = TypeConverter.convert({type=priceType,value=0,size=price})
		self:updateCost(self._costPanel,self._costInfo)

		-- local isDiscount = cfgData.discount_rate < 10 and cfgData.discount_rate > 0
		-- self._imageDiscount:setVisible(false)
		
		-- --打折
		-- if isDiscount then
		-- 	local numSale = cfgData.discount_rate
		-- 	self._imageDiscount:setVisible(true)
		-- 	--print("dddddddddddddddddddddddddddddddddddis = "..numSale)
		-- 	self._imageDiscount:loadTexture(G_Url:getText_system("txt_sys_activity_sale0"..numSale))
		-- end

	end

end


function RandomActivityItem:showGoodItem(goodItem, boxId)

	self._itemNode:setVisible(true)

	local scale = 0.9

	local params = TypeConverter.convert({
		type = goodItem.type,
		value = goodItem.value,
		size = goodItem.size,
		scale = scale,
		sizeVisible = true,
		levelVisible = false,
		-- disableTouch = true,
		needVisible = G_Me.equipData:isUpRankMaterialNeed(goodItem.type, goodItem.value),
	})

	UpdateNodeHelper.updateCommonIconKnightNode(self._itemNode,params)

	if type(boxId) == "number" then
		if G_Me.randomActivityData:isRecommended(boxId) then
			self._roundEffect = RoundEffectHelper.addCommonIconRoundEffect(self._itemNode)
		end
	end

end

--更新花费显示
function RandomActivityItem:updateCost(node,info)
	if(node ~= nil and info ~= nil)then
		local img = node:getChildByName("Icon_cost")
		if(info.icon_mini_tex_type ~= nil)then
			img:loadTexture(info.icon_mini)
		else
			img:loadTexture(info.icon)
		end

		local label=node:getChildByName("Text_cost")
		-- label:setString(tostring(math.ceil(info.size*self._numSaleRate)))
		local TextHelper = require("app.common.TextHelper")
		label:setString(TextHelper.getAmountText2(info.size))
		local bool = require("app.scenes.shopCommon.ShopUtils").isCostEnough(info.type,info.value,info.size)
		if(bool == true)then
			label:setColor(G_ColorsScrap.COLOR_SCENE_DESC_NOTE)
		else
			label:setColor(G_ColorsScrap.COLOR_POPUP_NOTE)
		end
	end
end

--开启宝箱特效
function RandomActivityItem:addOpenBoxEffect( openCallback )
	-- body

	local nodeEffect = self._csbNode:getSubNodeByName("Node_openEffect")
	nodeEffect:removeAllChildren(true)

	--G_AudioManager:playSoundById(9041)

	local effectOpen = require("app.effect.EffectNode").new("effect_jct_bxx_2",function(event,frame,node)
		if(event == "open")then
			--G_AudioManager:playSoundById(9042)
			self._boxNode:setVisible(false)
			self._costPanel:setVisible(false)

			if type(openCallback) == "function" then
				openCallback()
			end
		end
	end)
	effectOpen:setScale(0.7)
	effectOpen:play()
	effectOpen:setAutoRelease(true)
	nodeEffect:addChild(effectOpen)

end

function RandomActivityItem:_clearEffect()
	if self._roundEffect then
		self._roundEffect:removeFromParent(true)
		self._roundEffect = nil
	end
end

function RandomActivityItem:onExit()

	if self._csbNode ~= nil then
		self._csbNode:removeFromParent(true)
		self._csbNode = nil
	end

	self:_clearEffect()
end

return RandomActivityItem