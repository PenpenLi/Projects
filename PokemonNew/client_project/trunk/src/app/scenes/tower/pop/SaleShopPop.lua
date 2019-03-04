--
-- Author: YouName
-- Date: 2015-10-20 14:24:24
--
--[[
	折扣商店
]]
local SaleShopPop=class("SaleShopPop",function()
	return display.newNode()
end)

local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local TypeConverter = require("app.common.TypeConverter")
local UpdateButtonHelper = require("app.common.UpdateButtonHelper")

function SaleShopPop:ctor( )
	-- body
	self:enableNodeEvents()
	self._csbNode = nil
end

function SaleShopPop:_initUI( ... )
	-- body
	self:setPosition(display.cx,display.cy)
	self._csbNode = cc.CSLoader:createNode("csb/tower/SaleShopPop.csb")
	self:addChild(self._csbNode)

	UpdateNodeHelper.updateCommonNormalPop(self._csbNode:getSubNodeByName("FileNode_com"),"折扣商店",function ( ... )
		self:removeFromParent(true)
	end,460)

	self._csbNode:updateLabel("Text_shop_desc", {
		text = G_Lang.get("tower_star_num",{num = G_Me.thirtyThreeData:getNowStar()}),
		textColor = G_Colors.getColor(1),
		})
	
	self:_updateAllAwards()
end

--刷新所有商品状态
function SaleShopPop:_updateAllAwards( ... )
	-- body
	local shopIdList = G_Me.thirtyThreeData:getShopBuy()
	if(shopIdList == nil or #shopIdList == 0)then return end

	self:_updatePanelItem(shopIdList[1].Key,shopIdList[1].Value > 0)
end

--刷新单个商品状态
function SaleShopPop:_updatePanelItem( shopId,isBuyed )
	-- body
	if(shopId == nil)then return end
	local towerShopInfo = require("app.cfg.tower_discount_info").get(shopId)
	assert(towerShopInfo,"tower_shop_info can't find id = "..tostring(shopId))
	local icon = self._csbNode:getSubNodeByName("ProjectNode_item")
	local buyParams = {
		type=towerShopInfo.award_type,
		value=towerShopInfo.award_value,
		size=towerShopInfo.award_size,
		sizeVisible=true,
		nameVisible=false,
		levelVisible=false,
		scale = 0.9,
		needVisible = G_Me.equipData:isUpRankMaterialNeed(towerShopInfo.award_type, towerShopInfo.award_value),
	}
	require("app.common.UpdateNodeHelper").updateCommonIconItemNode(icon,buyParams)
	buyParams = TypeConverter.convert(buyParams)

	local costGold = towerShopInfo.cost
	local isGoldEnough = G_Me.userData.gold >= costGold
	local textColor = isGoldEnough and G_Colors.getColor(3)  or G_Colors.LACK
	local salePercent = math.floor(towerShopInfo.cost/towerShopInfo.cost1*10)

	self._csbNode:updateLabel("Text_item_name", {
		text = buyParams.cfg.name,
		textColor = G_Colors.qualityColor2Color(buyParams.cfg.color),
		--outlineColor = G_Colors.qualityColor2OutlineColor(buyParams.cfg.color),
		outlineSize = 2,
	})

	self._csbNode:updateLabel("Text_init_price",{
		text=tostring(towerShopInfo.cost1),
		textColor = G_Colors.getColor(3)
	})

	self._csbNode:updateLabel("Text_sale_price",{
		text=tostring(towerShopInfo.cost),
		textColor=textColor,
		visible = salePercent < 10,
	})

	self._csbNode:updateLabel("Text_sale_price",{
		visible = salePercent < 10,
	})

	self._csbNode:updateImageView("Image_cost_type_button", {
		visible = salePercent < 10,
	})

	self._csbNode:updateImageView("Image_sale_line", {
		visible = salePercent < 10,
	})

	self._csbNode:updateImageView("Text_title_sale", {
		visible = salePercent < 10,
	})

	
	if(salePercent > 0 and salePercent < 10)then
		self._csbNode:updateImageView("Image_sale_cornor", {visible = true,texture = "newui/text/system/txt_sys_activity_sale0"..tostring(salePercent)..".png"})
	else
		self._csbNode:updateImageView("Image_sale_cornor", {visible = false})
	end

	local btnBuy = self._csbNode:getSubNodeByName("ProjectNode_buy")
	UpdateButtonHelper.updateBigButton(btnBuy,{
		desc = G_LangScrap.get("common_btn_buy"),
		state = UpdateButtonHelper.STATE_ATTENTION,
		callback = function()
			require("app.responder.Responder").enoughGold(towerShopInfo.cost,function()
				G_Popup.buyOnceConfirm(buyParams,{type=TypeConverter.TYPE_GOLD,value=0,size=costGold},function()
					G_HandlersManager.thirtyThreeHandler:sendBuyTowerShop(shopId)
				end)
			end)
		end
	})

	-- self._itemList["key_"..tostring(shopId)] = self._csbNode

	if(isBuyed == true)then
		UpdateButtonHelper.updateBigButton(btnBuy,{
			desc = G_LangScrap.get("shop_has_been_bought"),
			state = UpdateButtonHelper.STATE_GRAY,
		})
	end
end

function SaleShopPop:_onBuyTowerShop( buffValue )
	-- body
	self:_updateAllAwards()
	if buffValue == nil or type(buffValue) ~= "table" then return end
	local buyId = buffValue.buy_id
	local buyInfo = require("app.cfg.tower_discount_info").get(buyId)
	assert(buyInfo,"tower_shop_info can't find id = "..tostring(buyId))
	local awards = {{type = buyInfo.award_type,value = buyInfo.award_value,size = buyInfo.award_size}}
	
	G_Popup.awardTips(awards)

	self:removeFromParent(true)
end

function SaleShopPop:onEnter( ... )
	-- body
	self:_initUI()
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MT_BUY_TOWER_SHOP, self._onBuyTowerShop, self)
end

function SaleShopPop:onExit( ... )
	-- body
	if(self._csbNode ~= nil)then
		self._csbNode:removeFromParent(true)
		self._csbNode = nil
	end
	uf_eventManager:removeListenerWithTarget(self)
end

return SaleShopPop