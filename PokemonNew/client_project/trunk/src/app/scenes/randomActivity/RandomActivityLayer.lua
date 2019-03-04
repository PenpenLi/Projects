--[====================[
    定制类活动（天宫宝库）
    其实就是随机活动
    kaka
]====================]

local RandomActivityLayer=class("RandomActivityLayer",function()
	return cc.Layer:create()
end)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local TypeConverter = require("app.common.TypeConverter")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
-- local ActivityRandomInfo = require("app.cfg.activity_random_info")
local WidgetTools = require("app.common.WidgetTools")
local CommonBuyCount = require("app.common.CommonBuyCount")

function RandomActivityLayer:ctor(actType)
	-- body

	self._actType = actType or 1 

	self._refreshWarning = false    --刷新时提示

	self._goldRefreshWarning = false    --元宝刷新时提示

	self:enableNodeEvents()
	self._csbNode = nil

	self._dataList = nil

	self._countDownHandler = nil

	self._goodsItems = nil

	self._textResOwn = nil

	self._panelCostSxl = nil
	self._panelCostGold = nil

	self._scrollView = nil           --推荐物品

	self._textNextAddBuyCount = nil     --自动增加开宝箱次数

	self._commonSysResNode = nil

end

--UI界面初始化
function RandomActivityLayer:_initUI( ... )
	-- body
	self._csbNode = cc.CSLoader:createNode("csb/randomActivity/RandomActivityLayer.csb")
	self:addChild(self._csbNode)
	self._csbNode:setContentSize(display.width,display.height)
	ccui.Helper:doLayout(self._csbNode)

	--积分信息  特殊处理
	self._commonSysResNode = self._csbNode:getSubNodeByName("ProjectNode_sys_res")
	local resTitle = self._commonSysResNode:getSubNodeByName("Text_res_title")
	self._resTitlePosX = resTitle:getPositionX()
	local resLabel = self._commonSysResNode:getSubNodeByName("Text_res")
	resLabel:setAnchorPoint(cc.p(0,0.5))
	resLabel:setPositionX(resLabel:getPositionX() - 50)

	self._commonSysResNode:updateImageView("Image_res",{visible = false})


	self._csbNode:updateLabel("Text_buy_count", {
		outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,outlineSize = 2})

	self._csbNode:updateLabel("Text_title_buy_count", {
		text = G_LangScrap.get("random_activity_txt_can_buy"),
		outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,outlineSize = 2})

	self._csbNode:updateLabel("Text_next_add_buy_count", {
		outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,outlineSize = 2})

	self._csbNode:updateLabel("Text_title_free_refresh", {
		text = G_LangScrap.get("random_activity_txt_free_refresh"),
		outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,outlineSize = 2})

	self._csbNode:updateLabel("Text_sxl_own_num", {
		outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,outlineSize = 2})
	self._csbNode:updateLabel("Text_res_cost", {
		outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,outlineSize = 2})

	local btnRefresh = self._csbNode:getSubNodeByName("ProjectNode_refresh")
	UpdateButtonHelper.updateNormalButton(btnRefresh,{
    	state = UpdateButtonHelper.STATE_ATTENTION,
		desc = G_LangScrap.get("lang_shop_button_refresh"),
		redPoint = false,	-- 是否显示红点
		callback = handler(self,self._onRefreshClick)
	})

	local nodeBack = self._csbNode:getSubNodeByName("ProjectNode_back")
	local btnBack = nodeBack:getSubNodeByName("Button_back")
	btnBack:addClickEventListenerEx(function(sender)
		G_ModuleDirector:popModule()
	end)

	self._csbNode:updateButton("Button_help", {
        callback = function ( ... )
            G_Popup.newHelpPopup(G_LangScrap.get("common_title_help"), G_LangScrap.get("random_activity_txt_help"))
        end})

    self._csbNode:updateLabel("Text_help_btn",{
        --text = G_LangScrap.get("treasure_btn_mianzhan"),
        color = G_ColorsScrap.COLOR_SCENE_DESC_NORMAL,
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
        fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL,
        outlineSize = 2,
        visible = true
    })

    self._csbNode:updateButton("Button_award", {
        callback = handler(self, self._showAwardsPanel)})
    self._csbNode:updateLabel("Text_award_btn",{
        text = G_LangScrap.get("common_btn_award"),
        color = G_ColorsScrap.COLOR_POPUP_SPECIAL_NOTE,
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
        fontSize = 22,
        outlineSize = 2,
    })

    self:updateButton("Button_add", {
        callback = handler(self, self._showBuyCountPanel)})

	self._textNextAddBuyCount  = self._csbNode:getSubNodeByName("Text_next_add_buy_count")

	self._scrollView = self._csbNode:getSubNodeByName("ScrollView_items")

	self._panelCostSxl = self._csbNode:getSubNodeByName("Panel_sxl")
	self._panelCostGold = self._csbNode:getSubNodeByName("Panel_cost_gold")

	self._goodsItems = {}

	for i=1,6 do
		local node = self._csbNode:getSubNodeByName("Node_"..tostring(i))
		local item = require("app.scenes.randomActivity.RandomActivityItem").new(handler(self,self._onBuyClick))
		node:addChild(item)
		item:setVisible(false)
		self._goodsItems[i] = item
	end

	local textDesc = self._csbNode:getSubNodeByName("Text_desc")
	local nodeSpine = self._csbNode:getSubNodeByName("Node_spine")

	-- local bubbleInfo = require("app.cfg.bubble_info").get(shopInfo.npc_dialog_id)
	-- assert(bubbleInfo,"bubble_info can't find id = "..tostring(shopInfo.npc_dialog_id))
	textDesc:setString(G_LangScrap.get("random_activity_title_bubble"))

	local knightSpine = require("app.common.KnightImg").new(1311)  --太白金星
	nodeSpine:addChild(knightSpine)

	self:_addMaskLayer()

end


----添加透明遮罩，防止开宝箱点的太快
function RandomActivityLayer:_addMaskLayer()

    self._layerColor = cc.LayerColor:create(cc.c4b(0, 0, 0, 0))
    self._layerColor:setContentSize(display.width, display.height)
    self._layerColor:setAnchorPoint(0.5,0.5)
    self:addChild(self._layerColor)
    
    self._layerColor:setTouchEnabled(false)
    self._layerColor:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self._layerColor:registerScriptTouchHandler(function(event)
        return true
    end)
end

function RandomActivityLayer:_addBuyCountTimer()

	local nextRecoverTime = G_Me.randomActivityData:getNextRecoverTime()
	local leftSeconds = G_ServerTime:getLeftSeconds(nextRecoverTime)

    self:_updateBuyCount()

    self:_removeBuyCountTimer()

    --不启动计时器
    if nextRecoverTime == 0 then
    	return
    end

    if self._countDownHandler == nil and leftSeconds > 0 then

        self._countDownHandler = GlobalFunc.addTimer(1, function ( ... )
        	leftSeconds = G_ServerTime:getLeftSeconds(nextRecoverTime)
          
    		self:_updateBuyCount()

			if leftSeconds <= 0 then
    			self:_removeBuyCountTimer()

				G_HandlersManager.randomActivityHandler:sendRefreshBuyCount()
				self._textNextAddBuyCount:setString("")

            end

        end)
    end

end

function RandomActivityLayer:_removeBuyCountTimer()

	if(self._countDownHandler ~= nil)then
		GlobalFunc.removeTimer(self._countDownHandler)
		self._countDownHandler = nil
	end

end



--点击刷新按钮
function RandomActivityLayer:_showAwardsPanel()
    G_Popup.newPopup(function() 
        return require("app.scenes.randomActivity.RandomActivityAwardPanel").new(self._actType)
    end)             
end 

--点击购买 开宝箱次数
function RandomActivityLayer:_showBuyCountPanel()


	local left_buy_count = G_Me.randomActivityData:getLeftCanBuyCount(self._actType)
	if left_buy_count <= 0 then
		G_Popup.tip(G_LangScrap.get("common_item_buy_limit")) --random_activity_txt_buy_max
		return
	end

    G_Popup.newPopup(function() 
        return require("app.scenes.randomActivity.RandomActivityBuyCountPanel").new(self._actType)
    end)             
end 


--点击刷新按钮
function RandomActivityLayer:_onRefreshClick( sender )
	-- body
	if(self._dataList == nil)then return end

	local commonCount = G_Me.randomActivityData:getBuyCommonCount()
	if not commonCount then
		return
	end

	local refreshCount = G_Me.randomActivityData:getFreeRefreshCount(self._actType)
	local maxRefreshCount = G_Me.randomActivityData:getMaxFreeRefreshCount(self._actType)

	--剩余描述刷新次数
	local leftRefreshCount = maxRefreshCount - refreshCount 

	--send refresh
	local function sendRefresh( ... )

		--暂时不考虑VIP机制
	    -- local functionType = self._shopInfo.refresh_vip_type
	    -- local vipData = G_Me.vipData:getVipFunctionDataByType(functionType)
	    -- if vipData ~= nil then
	    -- 	maxRefreshCount = vipData.value_1
	    -- end

		if leftRefreshCount > 0 then
			G_HandlersManager.randomActivityHandler:sendRefreshGoods(1)
		else

			-- G_Responder.vipTimeOutCheck(functionType, {
			--    usedTimes = refreshCount,
			--    tips = G_LangScrap.get("knight_shop_refresh_used_up") 
			-- })

			local costGold = G_Me.randomActivityData:getRefreshCost(self._actType)

			G_Responder.enoughGold(costGold,function()
				G_HandlersManager.randomActivityHandler:sendRefreshGoods(2)
			end)

		end
	end


	local left_buy_count = G_Me.randomActivityData:getLeftCanBuyCount(self._actType)

	--没有开宝箱次数了 且没有免费刷新次数 且不能购买开宝箱次数 提示下
	if not self._goldRefreshWarning and commonCount.left_count <= 0 and 
		left_buy_count <= 0 and leftRefreshCount <= 0 then
		require("app.common.ConfirmAlert").createConfirmText(nil, 
			G_LangScrap.get("random_activity_gold_refresh_warning"),
        	function ()
            	sendRefresh() 
           	end)
		self._goldRefreshWarning = true
	elseif not self._refreshWarning then
		require("app.common.ConfirmAlert").createConfirmText(nil, 
			G_LangScrap.get("random_activity_refresh_warning"),
        	function ()
            	sendRefresh() 
           	end)
		self._refreshWarning = true
	else
		sendRefresh()
	end
	

end


--更新开宝箱次数信息
function RandomActivityLayer:_updateBuyCount()
	-- body
	local nextRecoverTime = G_Me.randomActivityData:getNextRecoverTime()

	-- print("nnnnnnnnnnnnnnnext = "..G_ServerTime:getTimeString(nextRecoverTime))

	local commonCount = G_Me.randomActivityData:getBuyCommonCount()
	if not commonCount then
		return
	end

	local maxCount = G_Me.randomActivityData:getMaxBuyCount()
	self._csbNode:updateLabel("Text_buy_count",{
		text=commonCount.left_count.."/"..maxCount,
		color = commonCount.left_count > 0 and G_ColorsScrap.COLOR_SCENE_DESC_NOTE or G_ColorsScrap.COLOR_SCENE_NOTE
	})

	


	--已满
	if nextRecoverTime == 0 or commonCount.left_count >= maxCount then
		self._textNextAddBuyCount:setString(G_LangScrap.get("lang_user_restore_full"))
	else
	    local leftSeconds = G_ServerTime:getLeftSeconds(nextRecoverTime)

	    local strTimeFormat = GlobalFunc.fromatHHMMSS(leftSeconds)
		self._textNextAddBuyCount:setString("（"..strTimeFormat..
			G_LangScrap.get("random_activity_txt_buy_count_down").."）")
	end


end

--更新时间 
function RandomActivityLayer:_updateTimeInfo()

    local fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL

    --活动结束时间
    self._csbNode:updateLabel("Text_endTitle", {
        text=G_LangScrap.get("activity_text_start_time"), 
        color=G_ColorsScrap.COLOR_SCENE_TIP,
        outlineColor=G_ColorsScrap.COLOR_SCENE_OUTLINE,
        outlineSize=2,
        fontSize=fontSize})

    --领奖结束时间
    self._csbNode:updateLabel("Text_rewardTitle", {
        text=G_LangScrap.get("activity_text_close_time"), 
        color=G_ColorsScrap.COLOR_SCENE_TIP,
        outlineColor=G_ColorsScrap.COLOR_SCENE_OUTLINE,
        outlineSize=2,
        fontSize=fontSize})

    local start_time, end_time, reward_end_time = G_Me.randomActivityData:getTimeInfo()
    
    self._csbNode:updateLabel("Text_endTime", {
        text=G_ServerTime:getDateYMDHFormat(start_time),
        color=G_ColorsScrap.COLOR_SCENE_DESC_NORMAL,
        outlineColor=G_ColorsScrap.COLOR_SCENE_OUTLINE,
        outlineSize=2,
        fontSize=fontSize})

    self._csbNode:updateLabel("Text_rewardTime", {
        text=G_ServerTime:getDateYMDHFormat(reward_end_time),
        color=G_ColorsScrap.COLOR_SCENE_DESC_NORMAL,
        outlineColor=G_ColorsScrap.COLOR_SCENE_OUTLINE,
        outlineSize=2,
        fontSize=fontSize})

end

--刷新道具列表
function RandomActivityLayer:_updateGoods( isAni )
	-- body
	self._dataList = G_Me.randomActivityData:getGoodsList() or {}

	local goodsNum = #self._dataList
	local topIndex = 0
	local botIndex = 0

	local recommendGoods = {}

	for i=1,#self._goodsItems do
		local itemIcon = self._goodsItems[i]
		local itemData = i<=goodsNum and self._dataList[i] or nil

		itemIcon:updateData(itemData)
		
		if isAni then
			itemIcon:setVisible(false)
			local index = 1
			if(i > 3)then
				botIndex = botIndex + 1
				itemIcon:setPositionY(-70)
				index = botIndex
			else
				topIndex = topIndex + 1
				itemIcon:setPositionY(70)
				index = topIndex
			end
			local action = cc.MoveTo:create(0.3,cc.p(0,0))
			local ease = cc.EaseBackOut:create(action)
			local seq = cc.Sequence:create(cc.DelayTime:create((index-1)*0.07),
				cc.CallFunc:create(function(nodeParams)
					nodeParams:setVisible(true)
				end),
				ease)
			itemIcon:runAction(seq)

		end

	end

end

--更新推荐的物品
function RandomActivityLayer:_updateRecommendGoods()
	if self._scrollView then
		self._scrollView:removeAllChildren(true)
	end

	local goodList = {}

	local idList = G_Me.randomActivityData:getRecommendGoodsList()

	-- for i=1, #idList do
	-- 	local award = ActivityRandomInfo.get(idList[i])
	-- 	if award then
	-- 		goodList[i] = {type=award.type, value=award.value, size=award.size}
	-- 	end
	-- end

	-- dump(goodList)

    self._scrollView:setSwallowTouches(false)

    local totalWidth = self._scrollView:getContentSize().width

    local leftMargin = 5
    local xOffset = 8

    local goodNum = #goodList
    if goodNum > 3 then
    	self._scrollView:setBounceEnabled(true)
    	self._scrollView:setSwallowTouches(true)
    else
    	self._scrollView:setBounceEnabled(false)

    	if goodNum < 3 then
    		leftMargin = leftMargin + (80/goodNum) + (3-goodNum)*xOffset
    	end

    end

    WidgetTools.createIconsInPanel(self._scrollView, 
    	{awards=goodList, scale = 0.8, xOffset = xOffset, leftMargin = leftMargin})

	--总宽度
	local width = 8*(#goodList+1) + (#goodList)*80
	local innerWidth = width > totalWidth and width or totalWidth
	self._scrollView:setInnerContainerSize(cc.size(innerWidth,85))

end

--刷新信息栏
function RandomActivityLayer:_updateRefreshPanel( ... )
	-- body
	--底部信息刷新

	local costGold = G_Me.randomActivityData:getRefreshCost(self._actType)

	-- print("-costGoldcostGoldcostGold="..costGold)
	local isCostEnough = G_Me.userData.gold >= costGold
	
	self._panelCostSxl:setVisible(false)
	self._panelCostGold:setVisible(false)

	local maxRefreshCount = G_Me.randomActivityData:getMaxFreeRefreshCount(self._actType)
	local refreshCount = G_Me.randomActivityData:getFreeRefreshCount(self._actType)
	local leftRefreshCount = math.max(maxRefreshCount - refreshCount, 0 )

	if leftRefreshCount > 0 then
		self._panelCostSxl:setVisible(true)
		self._panelCostSxl:updateLabel("Text_sxl_own_num", {
			text = tostring(leftRefreshCount).."/"..tostring(maxRefreshCount),
			color = COLOR_SCENE_DESC_NOTE --G_ColorsScrap.COLOR_SCENE_NOTE
			})

	else
		self._panelCostGold:setVisible(true)

		local costColor = isCostEnough and G_ColorsScrap.COLOR_SCENE_DESC_NOTE or G_ColorsScrap.COLOR_POPUP_NOTE
		self._panelCostGold:updateLabel("Text_res_cost", {text=tostring(costGold),color = costColor})
		-- self._panelCostGold:updateImageView("Image_res_cost", {texture=G_Url:getCommonResIcon("200017")})

	end


end


--更新积分
function RandomActivityLayer:_updateScoreInfo( ... )
	-- body

	local numResValue = G_Me.randomActivityData:getScore()

	UpdateNodeHelper.updateCommonSysResNode(self._commonSysResNode,TypeConverter.TYPE_GOLD,0,numResValue)
	local resTitle = self._commonSysResNode:getSubNodeByName("Text_res_title")
	resTitle:setString(G_LangScrap.get("random_activity_txt_my_score"))
	resTitle:setPositionX(self._resTitlePosX + 50)

end

--更新红点机制
function RandomActivityLayer:_updateAwardTip()
    self:updateImageView("Image_tip", {visible = G_Me.randomActivityData:hasRedPoint(self._actType)})
end


function RandomActivityLayer:_updateView()

	self:_updateTimeInfo()

	self:_updateScoreInfo()

	self:_updateAwardTip()

	self:_updateBuyCount()

	self:_updateRefreshPanel()

	self:_updateRecommendGoods()

	self:_updateGoods(true)

end

--收到银币或者元宝更新通知
function RandomActivityLayer:_updateCosts()
	
	--需要刷新价格文字 

	self:_updateGoods(false)

	self:_updateRefreshPanel()
end


--刷新
function RandomActivityLayer:_refreshView()
	
	self:_updateGoods(true)

	self:_updateRecommendGoods()

	self:_updateRefreshPanel()

end


--收到基本信息
function RandomActivityLayer:_refreshAll()

	self:_addBuyCountTimer()

	self:_updateView()

end


--收到数据通知
function RandomActivityLayer:_onRefreshGoods(decodeBuffer)
	-- body
	if type(decodeBuffer) ~= "table" then
		return
	end

	-- if self._isManualRefresh == true then
	-- 	G_Popup.tip(G_LangScrap.get("knight_shop_refresh_success_tip"))
	-- 	self._isManualRefresh = false
	-- end

	if not G_Me.randomActivityData:getAutoRefreshDelay() then
		self:_refreshView()
	end

end

--点击购买按钮
function RandomActivityLayer:_onBuyClick( goodInfo,costInfo )

	if(goodInfo == nil or costInfo == nil)then return end

	local commonCount = G_Me.randomActivityData:getBuyCommonCount()
	if not commonCount then
		return
	end

	--弹出购买开宝箱次数框
	if commonCount.left_count == 0 then
		self:_showBuyCountPanel()
		return
	end

	local costType,costValue,costSize = 0,0,0

	-- local buyParams = {
	-- 	type = goodInfo.cfgData.type,
	-- 	value = goodInfo.cfgData.value,
	-- 	size = goodInfo.cfgData.size
	-- }

	-- local isPackFull = G_Responder.isPackFull(buyParams.type,buyParams.value)
	-- if(isPackFull == true)then
	-- 	return
	-- end

	costType = costInfo.type
	costValue = costInfo.value
	costSize = costInfo.size

	local function sendBuyGood()
		G_HandlersManager.randomActivityHandler:sendBuyGood(goodInfo.serverIndex)
	end

	local ShopUtils = require("app.scenes.shopCommon.ShopUtils")

	ShopUtils.checkCostEnough(costType,costValue,costSize,function()
		--策划案要求大于200才提示
		-- if(costType == TypeConverter.TYPE_GOLD and costSize > 200 )then
		-- 	G_Popup.buyOnceConfirm(buyParams,costInfo,function()
		-- 		sendBuyGood()
		-- 	end)
		-- else
		-- 	sendBuyGood()
		-- end
		sendBuyGood()
	end)

end


--收到购买成功通知
function RandomActivityLayer:_onBuyResult( decodeBuffer )
	-- body
	if(decodeBuffer ~= nil and decodeBuffer.ret == 1)then

		self:_updateAwardTip()

		self:_addBuyCountTimer()
		
		local awardId = rawget(decodeBuffer, "good_id") and decodeBuffer.good_id or 0
		local index = rawget(decodeBuffer, "index") and decodeBuffer.index or 0

		if awardId > 0 and index > 0 then

            self._layerColor:setTouchEnabled(true)   --禁止其他操作

			--宝箱炸开动画
			self._goodsItems[index]:addOpenBoxEffect(function()

    			self._layerColor:setTouchEnabled(false)  --宝箱打开动画结束

				-- local award = ActivityRandomInfo.get(awardId)
				if award then
					local good = {type=award.type, value=award.value, size=award.size}
					local goods = {good}

					G_Popup.awardSummary(goods, 
						nil, nil, function ( ... )

							self:_updateScoreInfo()  --更新积分

							local autoRefreshDelay = G_Me.randomActivityData:getAutoRefreshDelay()

							self._goodsItems[index]:showGoodItem(good, awardId)

							if autoRefreshDelay then
								self:performWithDelay(function ( ... )
									self:_refreshView()
								end, 0.5)
								G_Me.randomActivityData:setAutoRefreshDelay(false)
							else
								self:_updateGoods(false)
							end
						end)
				end
			end)

		end
	
		--local isEquipNeed = G_Me.equipData:isUpRankMaterialNeed(goodInfo.type, goodInfo.value)
		--if isEquipNeed then
			--uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_RED_POINT_UPDATE,nil,false)
		--end
	end
end


function RandomActivityLayer:onEnter( ... )

	-- body
	
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RANDOM_ACTIVITY_GET_INFO,self._refreshAll,self)
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECV_ROLE_INFO,self._updateCosts,self)
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RANDOM_ACTIVITY_REFRESH_GOODS,self._onRefreshGoods,self)
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RANDOM_ACTIVITY_BUY_GOOD,self._onBuyResult,self)
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RANDOM_ACTIVITY_BUY_COUNT,self._addBuyCountTimer,self)
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RANDOM_ACTIVITY_REFRESH_COUNT,self._addBuyCountTimer ,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RANDOM_ACTIVITY_GET_AWARD, self._updateAwardTip, self)
	
	self:_initUI()

	--数据过期
    if G_Me.randomActivityData:isExpired() then
        G_HandlersManager.randomActivityHandler:sendGetActivityInfo()
    else
    	self:_refreshAll()
    end

end

function RandomActivityLayer:onExit( ... )
	-- body
	uf_eventManager:removeListenerWithTarget(self)

	if self._csbNode ~= nil then
		self._csbNode:removeFromParent(true)
		self._csbNode = nil
	end

	self:_removeBuyCountTimer()
end

return RandomActivityLayer