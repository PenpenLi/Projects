--ActivityExchangeCell.lua

--[====================[

	可配置活动兑换列表Cell
]====================]

local ActivityCommonListCell = require("app.scenes.activity.ActivityCommonListCell")


local ActivityExchangeCell = class("ActivityExchangeCell", ActivityCommonListCell)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local TypeConverter = require ("app.common.TypeConverter")
local TeamUtils = require("app.scenes.team.TeamUtils")

local IconScale = 0.75
local IconSpace = 10  -- icon间隔
local IconWidth = 110*IconScale  -- icon宽度

function ActivityExchangeCell:ctor(btnCallback)

    self._btnCallback = btnCallback or nil

	self._container = cc.CSLoader:createNode(G_Url:getCSB("ActivityExchangeCell","activity"))
    self:addChild(self._container)
    self._container:setPosition(G_CommonUIHelper.LIST_CELL_OFFSET_X, G_CommonUIHelper.LIST_CELL_OFFSET_Y)

	self._scrollView = self:getSubNodeByName("ScrollView_items")
	self._scrollView:setScrollBarEnabled(false)
	self._scrollView:setSwallowTouches(false)
	self._leftTimesTagLabel = self:getSubNodeByName("Text_leftTimesTag")
	self._leftTimesLabel = self:getSubNodeByName("Text_leftTimes")
	self._Image_has_exchange = self:getSubNodeByName("Image_has_exchange")
	self._Node_not_exchange = self:getSubNodeByName("Node_not_exchange")
	self._Node_effect_highlight = self:getSubNodeByName("Node_effect_highlight")
	self._Node_effect_highlight:setVisible(true)
    -- self._effectNode = TeamUtils.playEffect("effect_jiangli_zhuan",{x=0,y=0},self._Node_effect_highlight,"finish")
    -- self._effectNode:setVisible(true)

	self._leftTimesTagPosX = self._leftTimesTagLabel:getPositionX()
	self._leftTimesPosX = self._leftTimesLabel:getPositionX()
	--剩余次数
	self._leftTimesLabel:setString("")
	self._leftTimesTagLabel:setString("")

	self._exchangeButton = self:getSubNodeByName("Button_exchange")
	
end

function ActivityExchangeCell:updateData(quest)
	self._leftTimesLabel:setString("")
	self._leftTimesTagLabel:setString("")
	self:getSubNodeByName("BitmapFontLabel_discount"):setVisible(false)

	local quest = quest or nil

	local curQuest = G_Me.activityData.custom:getCurQuestByQuest(quest)

	if not quest or not curQuest then
		return
	end

	-- 高亮特效
	self._Node_effect_highlight:removeAllChildren()
    --self._effectNode = TeamUtils.playEffect("effect_jiangli_zhuan",{x=0,y=0},self._Node_effect_highlight,"finish")
 --    dump(quest.is_highlight)
	-- if quest.is_highlight == 1 then
 --    	self._effectNode = TeamUtils.playEffect("effect_jiangli_zhuan",{x=0,y=0},self._Node_effect_highlight,"finish")
	-- 	--self._Node_effect_highlight:setVisible(true)
	-- else
	-- 	--self._Node_effect_highlight:setVisible(false)
	-- end

	--先设定默认按钮状态
	UpdateButtonHelper.updateNormalButton(self._exchangeButton, {
        state = UpdateButtonHelper.STATE_NORMAL,
        desc = G_LangScrap.get("common_btn_exchange"),
        callback = function()
			if type(self._btnCallback) == "function" then
		        self._btnCallback(quest, curQuest)
		    end
		end
    })


	local value02 = 0
	local value01 = 0

	local buttonState = UpdateButtonHelper.STATE_NORMAL

	self._leftTimesTagLabel:setString(G_LangScrap.get("activity_text_left_times"))

	--判断是全服剩余还是普通的
	if quest.server_limit > 0 then   --全服限制

		value02 = quest.server_limit or 0   --限制次数
		value01 = quest.server_times or 0   --当前进度
		local leftTime = string.format("%s/%s",(value02-value01),value02)
		self._leftTimesLabel:setString(leftTime)

		--判断兑换次数
		self._Image_has_exchange:setVisible(false)
		self._Node_not_exchange:setVisible(true)
		if value01 >= value02 or curQuest.award_times >= quest.award_limit then
			buttonState = UpdateButtonHelper.STATE_GRAY 
			self._Image_has_exchange:setVisible(true)
			self._Node_not_exchange:setVisible(false)
		else
			if quest.is_highlight == 1 then -- 高亮特效
    			self._effectNode = TeamUtils.playEffect("effect_jiangli_zhuan",{x=0,y=0},self._Node_effect_highlight,"finish")
			end
		end
	else
		value02 = quest.award_limit or 0   --限制次数
		value01 = curQuest.award_times or 0   --当前进度
		local leftimes = value02 > value01 and (value02-value01) or 0
		local leftTime = string.format("%s/%s",leftimes,value02)
		self._leftTimesLabel:setString(leftTime)

		--判断兑换次数
		self._Image_has_exchange:setVisible(false)
		self._Node_not_exchange:setVisible(true)
		if value01 >= value02 and value02 > 0 then
			buttonState = UpdateButtonHelper.STATE_GRAY 
			self._Image_has_exchange:setVisible(true)
			self._Node_not_exchange:setVisible(false)
		else
			if quest.is_highlight == 1 then -- 高亮特效
    			self._effectNode = TeamUtils.playEffect("effect_jiangli_zhuan",{x=0,y=0},self._Node_effect_highlight,"finish")
			end
		end

		--没有兑换次数限制 隐藏次数信息
		if value02 == 0 then
			self._leftTimesTagLabel:setString("")
			self._leftTimesLabel:setString("")
		end

	end

	--剩余位置调整
	local offSetX = self._leftTimesLabel:getContentSize().width - 24
	self._leftTimesTagLabel:setPositionX(self._leftTimesTagPosX - offSetX/2)
	self._leftTimesLabel:setPositionX(self._leftTimesPosX - offSetX/2)

	--local redPoint = G_Me.activityData.custom:checkExchangeCondition(quest)
	--redPoint = redPoint and (buttonState == UpdateButtonHelper.STATE_NORMAL) 

	UpdateButtonHelper.updateNormalButton(self._exchangeButton, {
        state = buttonState,
        --redPoint = redPoint
    })

	--刷新是否有折扣
	local isInDiscount,discount = G_Me.activityData.custom:isExchangeInDiscount(quest)
	
	self:updateFntLabel("BitmapFontLabel_discount",{visible=isInDiscount, 
		text=G_LangScrap.get("common_text_x_discount",{discount=discount})})

	self:initScrollView(quest)

end


function ActivityExchangeCell:initScrollView(quest)
	if self._scrollView then
		self._scrollView:removeAllChildren(true)
	end
	
	self._scrollView:setSwallowTouches(false)

	local consumeList = {}  --消耗的物品

	local awardList = {}    --兑换到的物品

	local widgetWidth = IconWidth   --icon的宽度

	for i=1,4 do
		local _type = quest["consume_type" .. i]
		if _type > 0 then
			local value = quest["consume_value" .. i]
			local size = quest["consume_size" .. i]
			local good = TypeConverter.convert({type=_type,value=value,size=size})
			if good then
				table.insert(consumeList,good)
				local widget = cc.CSLoader:createNode(G_Url:getCSB("CommonIconItemNode", "common"))
				UpdateNodeHelper.updateCommonIconItemNode(widget,{type=_type, value=value, size=size,
					nameVisible = false, levelVisible = false, sizeVisible = true, scale = IconScale})
				
				local height = widget:getContentSize().height
				widget:setPosition(cc.p(IconSpace*i + (i-0.5)*widgetWidth,(self:_getScrollViewHeight()-height)/2))
				self._scrollView:addChild(widget)
			end
		end
	end
	
	--添加一个等号
	--local denghaoImage = ccui.ImageView:create(G_Url:getText_system("txt_sys_activity_sale10"))
	local denghaoImage = ccui.ImageView:create(G_Url:getUI_arrow("img_arrow13"))
	denghaoImage:setPositionY(self:_getScrollViewHeight()/2)
	denghaoImage:setFlippedX(true)

	--等号的x坐标
	local width = IconSpace*(#consumeList) + #consumeList*widgetWidth
	self._scrollView:addChild(denghaoImage,10)
	denghaoImage:setPositionX(width + IconSpace/2)
	denghaoImage:setScale(0.8)

	local awardOffset = 10
	for i=1,4 do
		local _type = quest["award_type" .. i]
		if _type > 0 then
			local value = quest["award_value" .. i]
			local size = quest["award_size" .. i]
			local good = TypeConverter.convert({type=_type,value=value,size=size})
			if good then
				table.insert(awardList,good)
				local widget = cc.CSLoader:createNode(G_Url:getCSB("CommonIconItemNode", "common"))
				UpdateNodeHelper.updateCommonIconItemNode(widget,{type=_type, value=value, size=size,
					nameVisible = false, levelVisible = false, sizeVisible = true, scale = IconScale})
			
				local height = widget:getContentSize().height
				local widgetPosX = width + IconSpace*i + (i-0.5)*widgetWidth + (i-1)*awardOffset
				widget:setPosition(cc.p(widgetPosX,(self:_getScrollViewHeight()-height)/2))
				self._scrollView:addChild(widget)

				--多选的添加一个+或者or标签
				if i > 1 then
					--dump(quest.award_select)
					local orImage = ccui.ImageView:create(quest.award_select ~= 0 and 
						G_Url:getText_system("txt_sys_activity_sale11") or 
						G_Url:getText_system("txt_sys_activity_sale12") )
					orImage:setPositionY(self:_getScrollViewHeight()/2)

					self._scrollView:addChild(orImage,10)
					orImage:setPositionX(widgetPosX - 0.5*widgetWidth - (IconSpace+awardOffset)/2)
				end

			end
		end
	end
	width = width + IconSpace*(#awardList+1) + (#awardList)*widgetWidth

	local totalWidgets = #awardList + #consumeList
	if totalWidgets > 3 then
    	self._scrollView:setBounceEnabled(true)
    	self._scrollView:setSwallowTouches(true)
    else
    	self._scrollView:setBounceEnabled(false)
    end

	local innerWidth = width > self:_getScrollViewWidth() and width or self:_getScrollViewWidth()
	self._scrollView:setInnerContainerSize(cc.size(innerWidth,self:_getScrollViewHeight()))
	self._scrollView:jumpToRight()
end

return ActivityExchangeCell