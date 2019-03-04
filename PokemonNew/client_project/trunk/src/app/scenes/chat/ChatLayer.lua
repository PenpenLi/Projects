
----==================
----聊天模块。
local ChatLayer = class("ChatLayer", function ()
	return display.newLayer()
end)

local ChatScrollView = require "app.scenes.chat.ChatScrollView"
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local UpdateNodeHelper = require "app.common.UpdateNodeHelper"
local ParameterInfo = require "app.cfg.parameter_info"
local ChatFaceLayer = require "app.scenes.chat.ChatFaceLayer"
local SchedulerHelper = require "app.common.SchedulerHelper" 
local UTF8 = require("app.common.tools.Utf8")

ChatLayer.TAB_WORLD = 1 -- 本服
ChatLayer.TAB_PRIVATE = 2 -- 私聊
ChatLayer.TAB_BANG = 3 --军团/帮派
ChatLayer.TAB_TEAM = 4 -- 跨服
--ChatLayer.TAB_GANG = 2

ChatLayer.PARAM_KEY_MAX_WORD = 227
ChatLayer.PRIVATE_NEED_POWER = 604
local ChatMaxTab = 4
function ChatLayer:ctor(tabindex,priName)
	self:enableNodeEvents()

	self._tabButtons = nil
	self._view = nil
	self._btnSend = nil
	self._priName = priName
	self._listViews = {}
	if tabindex == nil then
		local channel = G_Me.chatData:getLastChannel()
		if channel then
			self._initIndex = channel
			self._currentChannel = channel ---当前的频道
		else
			self._initIndex = nil
			self._currentChannel = 0 ---当前的频道
		end
	else
		self._initIndex = tabindex
		self._currentChannel = tabindex ---当前的频道
	end
	
	self._currentIndex = 0
	self._curInput = nil --当前输入框
	self._palaceHolder = nil --输入框提示文字
	self._scheduler = nil
	self._isPlayerInput = false
	self._maxInputLength = 35--tonumber(ParameterInfo.get(ChatLayer.PARAM_KEY_MAX_WORD).content)
	self._inputTxt = nil 	-- 非私聊输入框
	self._pri_playerInput = nil -- 私聊昵称输入框
	self._pri_contentInput = nil -- 私聊内容输入框
	self._currentList = nil
	self._temp_ctrl = false
	self._faceNode = nil
	self._isSwitchOpen = nil  -- 悬浮窗开关
	G_Me.chatData:setChatLayerState(true,self)

end
       
function ChatLayer:onEnter()
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAT_GET_MESSAGE, self._onGetMsg, self)
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAT_HISTORY, self._onGetHistoryMsg, self)
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAT_SELECTE_FACE, self._onSelectedFace, self)
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAT_SEND_SUCCESS, self._onSendSuccess, self)
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAT_HIT_PRI_MSG, self._onHitMsg, self)

	-- uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_GUILD_HELP_DATA, self._updataLimitChat, self)

	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RED_POINT_UPDATE_CHART, self._onUpdateRedPoint, self)
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RED_POINT_UPDATE, self._onUpdateRedPoint, self)
	
	self:_initUI()

	-- G_HandlersManager.guildBattleHandler:sendGetCityHelpInfo()

	--请求历史消息
	dump(G_Me.chatData:isExpired())
	if G_Me.chatData:isExpired() then
    	G_HandlersManager.chatHandler:sendRequestChatHistory()
    else
    	self:_initTab()
	end

	

end

function ChatLayer:onExit()
	uf_eventManager:removeListenerWithTarget(self)
	uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_RED_POINT_UPDATE_CHART, nil, false)
	G_Me.chatData:setChatLayerState(false,nil)
	self:_clearCountDown()

	self._listViews = {}
	local glView = cc.Director:getInstance():getOpenGLView()
	if glView then
		glView:setIMEKeyboardState(false)
	end

	if self._view then
		self._view:removeFromParent()
		self._view = nil
	end

end

function ChatLayer:_initUI()

	-- if not _data then
	-- 	return
	-- end 

	self._view = cc.CSLoader:createNode(G_Url:getCSB("ChatLayer", "chat"))
	self:addChild(self._view)

	self._view:setContentSize(display.width, display.height)
	ccui.Helper:doLayout(self._view)

	--标题
	self._view:updateLabel("Text_title", {text = G_Lang.get("lang_chat_title")})

	self._view:updateButton("Button_close", function ()
		G_Me.chatData:setChatLayerState(false,nil)
		self:removeFromParent()
	end)

	local isSwitchOpen = G_Me.chatData:getChatLeviwindowSwitchState()
	self._view:updateCheckBox("CheckBox_switch",{
		selected = isSwitchOpen,
		touchEnable = true,
		callback = function(sender,eventType)
	        if eventType == ccui.CheckBoxEventType.selected then
	        	G_Me.chatData:setChatLevitationSwitch(true)
	        	display.getRunningScene():addChatFloatNode()
	        elseif eventType == ccui.CheckBoxEventType.unselected then
	        	G_Me.chatData:setChatLevitationSwitch(false)
	        	display.getRunningScene():clearChatFloatNode()
	        end
	    end
		})

    self._image_list_bg = self._view:getSubNodeByName("Image_list_bg")
    self._panel_list_con = self._view:getSubNodeByName("Panel_list_con")

    self._image_list_bg_h = self._image_list_bg:getContentSize().height
    self._image_list_bg_w = self._image_list_bg:getContentSize().width
    self._panel_list_con_h = self._panel_list_con:getContentSize().height
    self._panel_list_con_w = self._panel_list_con:getContentSize().width

    self._image_huawen = self._view:getSubNodeByName("Image_huawen")

	self._unPriNode = self._view:getSubNodeByName("Image_input_bg")
	self._unPriNode_w = self._unPriNode:getContentSize().width
	self._unPriNode_h = self._unPriNode:getContentSize().height
	self._privateNode = self._view:getSubNodeByName("Node_private")
	self._faceNode = self._view:getSubNodeByName("Node_face")
	self._Panel_touch_shade = self._view:getSubNodeByName("Panel_touch_shade")
	if self._Panel_touch_shade then
		self._Panel_touch_shade:setTouchEnabled(true)
		self._Panel_touch_shade:setSwallowTouches(true)
		self._Panel_touch_shade:setVisible(false)
	end

	self._view:getSubNodeByName("Node_bottom"):setVisible(false)

	self._faceNode:setVisible(false)
	ChatFaceLayer.new():addTo(self._faceNode)
	
	-- self._view:updateButton("Button_voice", 
	-- {
	-- 	visible = G_Setting.get("appstore_version") ~= "1",
	-- 	callback = function ()
	-- 		G_Popup.tip(G_LangScrap.get("chat_voice_will_come"))
	-- 	end
	-- })
--self._inputTxt
	self._view:updateButton("Button_face", function ()
		if self._isPlayerInput then
			G_Popup.tip(G_Lang.get("chat_player_warning"))
			return
		end
		self:_onShowFaceLayer()
	end)
	self._btnSend = self._view:getSubNodeByName("Button_send")
	self._btn_title = self._btnSend:getSubNodeByName("button_title")
	self._btnSend:setSwallowTouches(false)
	self._btnSend:loadTextureNormal(G_Url:getUI_btn("btn_small_gray01"))

  --   if tonumber(ParameterInfo.get(221)) > G_Me.userData.level then -- 世界聊天未开启
		-- self._btnSend:loadTextureNormal(G_Url:getUI_btn("btn_small_gray01"))
	 -- 	self._btn_title:setTextColor(G_Colors.btn[303])
  --   	self._btn_title:enableOutline(G_Colors.outline[303],2) --描边统一为2，这里先写死
  --   end

	--UpdateButtonHelper.reviseButton(self._btnSend,{isBig = false,color = UpdateButtonHelper.COLOR_GRAY})
    self._btn_title:setTextColor(G_Colors.btn[303])
    self._btn_title:enableOutline(G_Colors.outline[303],2) --描边统一为2，这里先写死
	self._btnSend:addClickEventListenerEx(function ()
			--if self._currentChannel == G_Me.chatData.CHANNEL_WORLD then
				local canSend = G_Me.chatData:isCanSendWorldMsg()
				if canSend then
					self:_onSendMsg()
				else	
					if tonumber(ParameterInfo.get(221).content) > G_Me.userData.level then
						G_Popup.tip(G_Lang.get("chat_no_enough_lv_send2"))
					else
						G_Popup.tip(G_Lang.get("chat_no_enough_lv_send"))
					end
				end
			-- else
			-- 	self:_onSendMsg()
			-- end
			self._faceNode:setVisible(false)
			self._btnSend:loadTextureNormal(G_Url:getUI_btn("btn_small_gray01"))
			--UpdateButtonHelper.reviseButton(self._btnSend,{isBig = false,color = UpdateButtonHelper.COLOR_GRAY})
		 	self._btn_title:setTextColor(G_Colors.btn[303])
    		self._btn_title:enableOutline(G_Colors.outline[303],2) --描边统一为2，这里先写死
        end)
	-- UpdateButtonHelper.updateNormalButton(
 --        self._view:getSubNodeByName("Button_send"),{
 --        state = UpdateButtonHelper.STATE_NORMAL,
 --        desc = G_LangScrap.get("chat_send_message"),
 --        callback = function ()
 --        	local canSend, openLv = G_Me.chatData:isCanSendMsg()
	-- 		if canSend then
	-- 			self:_onSendMsg()
	-- 		else	
	-- 			G_Popup.tip(G_LangScrap.get("chat_no_enough_lv_send", {num = openLv}))
	-- 		end
 --        end
 --    })
	
	--=======================编辑框 start
	--非私聊输入
    -- local imageTextBg = self._view:getSubNodeByName("Image_input_bg")
    -- self._inputTxt = ccui.EditBox:create(cc.size(188, 41), G_Url:getUI_createRole("create_role_input_bg"))
    -- self._inputTxt:setFontName(G_Path.getNormalFont())
    -- self._inputTxt:setFontSize(19)
    -- self._inputTxt:setFontColor(cc.c4b(0xff, 0xff, 0xff, 0xff))
    -- self._inputTxt:setPlaceHolder(G_Lang.get("chat_max_words", {num = self._maxInputLength}))
    -- self._inputTxt:setPlaceholderFontName(G_Path.getNormalFont())
    -- self._inputTxt:setPlaceholderFontSize(19)
    -- self._inputTxt:setPlaceholderFontColor(cc.c4b(0xff, 0xff, 0xff, 0xff))
    -- self._inputTxt:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    -- self._inputTxt:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    -- self._inputTxt:registerScriptEditBoxHandler(handler(self, self.editBoxTextEventHandle))
    -- self._inputTxt:setAnchorPoint(0, 0)
    -- self._inputTxt:setPosition(6, 0)

    -- imageTextBg:addChild(self._inputTxt, 0)

    -- -- 私聊输入
    -- local img_priBg1 = self._view:getSubNodeByName("Img_input_private_player")
    -- self._pri_playerInput = ccui.EditBox:create(cc.size(153, 41), G_Url:getUI_createRole("create_role_input_bg"))
    -- self._pri_playerInput:setFontName(G_Path.getNormalFont())
    -- self._pri_playerInput:setFontSize(19)
    -- self._pri_playerInput:setPlaceHolder(G_Lang.get("chat_player_input_txt"))
    -- self._pri_playerInput:setPlaceholderFontColor(cc.c4b(0xff, 0xff, 0xff, 0xff))
    -- self._pri_playerInput:setFontColor(cc.c4b(0xff, 0xff, 0xff, 0xff))
    -- self._pri_playerInput:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    -- self._pri_playerInput:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    -- self._pri_playerInput:setAnchorPoint(0, 0)
    -- self._pri_playerInput:setTag(33)
    -- self._pri_playerInput:setPosition(5, 0)

    -- img_priBg1:addChild(self._pri_playerInput, 0)

    -- local img_priBg2 = self._view:getSubNodeByName("Img_input_private_content")
    -- self._pri_contentInput = ccui.EditBox:create(cc.size(156, 41), G_Url:getUI_createRole("create_role_input_bg"))
    -- self._pri_contentInput:setFontName(G_Path.getNormalFont())
    -- self._pri_contentInput:setFontSize(19)
    -- self._pri_contentInput:setPlaceHolder("点击输入内容")
    -- self._pri_contentInput:setPlaceholderFontColor(cc.c4b(0xff, 0xff, 0xff, 0xff))
    -- self._pri_contentInput:setFontColor(cc.c4b(0xff, 0xff, 0xff, 0xff))
    -- self._pri_contentInput:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    -- self._pri_contentInput:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    -- self._pri_contentInput:setAnchorPoint(0, 0)
    -- self._pri_contentInput:setPosition(5, 0)

    -- img_priBg2:addChild(self._pri_contentInput, 0)
    --=======================编辑框 end
    
    --=======================输入框
    --非私聊输入
    self._inputTxt = self._view:getSubNodeByName("TextField_input")
    self._inputTxt:setPlaceHolder(G_Lang.get("chat_max_words", {num = self._maxInputLength}))
    self._inputTxt:setCursorEnabled(true)
    self._inputTxt:setMaxLength(self._maxInputLength)
    self._inputTxt:setPlaceHolderColor(cc.c4b(0xff,0xff,0xff,0xaa))
    --self._inputTxt:setTouchSize(cc.size(200,33))
    self._inputTxt:setFocusEnabled(true)
    self._inputTxt:addEventListener(handler(self,self.onInputEvent))
    --self._inputTxt:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    --self._inputTxt:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    self._inputTxt_h = self._inputTxt:getContentSize().height
    self._inputTxt_w = self._inputTxt:getContentSize().width


    --私聊输入
    self._img_priBg2 = self._view:getSubNodeByName("Img_input_private_content")
    self._img_priBg2_h = self._img_priBg2:getContentSize().height
    self._img_priBg2_w = self._img_priBg2:getContentSize().width
    self._pri_playerInput = self._privateNode:getSubNodeByName("TextField_private_player")
    self._pri_playerInput:setPlaceHolder(G_Lang.get("chat_player_input_txt"))
    self._pri_playerInput:setPlaceHolderColor(cc.c4b(0xff,0xff,0xff,0xaa))
    --self._pri_playerInput:setTouchSize(cc.size(166,33))
    self._pri_playerInput:setFocusEnabled(true)
    self._pri_playerInput:setTag(33)
    self._pri_playerInput:addEventListener(handler(self,self.onInputEvent))
    self._pri_playerInput:setCursorEnabled(true)

	self._pri_contentInput = self._privateNode:getSubNodeByName("TextField_private_content")
	self._pri_contentInput:setPlaceHolder("点击输入内容")
    self._pri_contentInput:setMaxLength(self._maxInputLength)
    self._pri_contentInput:setPlaceHolderColor(cc.c4b(0xff,0xff,0xff,0xaa))
    --self._pri_contentInput:setTouchSize(cc.size(170,33))
    self._pri_contentInput:setFocusEnabled(true)
    self._pri_contentInput:addEventListener(handler(self,self.onInputEvent))
    self._pri_contentInput:setCursorEnabled(true)
    self._pri_contentInput_h = self._pri_contentInput:getContentSize().height
    self._pri_contentInput_w = self._pri_contentInput:getContentSize().width

    --先显示有红点的页签
    -- if G_Me.chatData:hasRedPointWorld() then
    -- 	self._initIndex = ChatLayer.TAB_WORLD
    -- elseif G_Me.chatData:hasRedPointGang() then
    -- 	self._initIndex = ChatLayer.TAB_GANG
    -- end

	local buttonTabNode = self._view:getSubNodeByName("Node_tab_buttons")
	local funcOpen = {}
	local noOpenTip = {}
	funcOpen[1], noOpenTip[1]  = G_Responder.funcIsOpened(G_FunctionConst.FUNC_CHAT)                --世界	
	funcOpen[2], noOpenTip[2]  = G_Responder.funcIsOpened(G_FunctionConst.FUNC_CHAT_PRIVATE)		--私聊
    funcOpen[3], noOpenTip[3]  = G_Responder.funcIsOpened(G_FunctionConst.FUNC_CHAT_GUILD)			--帮派
    funcOpen[4], noOpenTip[4]  = G_Responder.funcIsOpened(G_FunctionConst.FUNC_CHAT_SERVER)			--本服

	if G_Me.userData.power < 500000  then
    	-- noOpenTip[2] = "战力达到30W开启"
    	noOpenTip[2] = G_Lang.get("power_limit_50")
    	funcOpen[2] = false
    end

    if funcOpen[3] and (not G_Me.userData.guild_id or G_Me.userData.guild_id <= 0)  then
    	noOpenTip[3] = G_Lang.get("guild_limit")
    	funcOpen[3] = false
    end

    if  G_Me.userData.sigData  then
    	noOpenTip[4] = G_Lang.get("serverNum_limit")
    	funcOpen[4] = false
    end



	local tabs = {}
    for i=1,ChatMaxTab do
        tabs[i] =  {text = G_Lang.get("chat_tab_title"..i),noOpen= not funcOpen[i],  noOpenTips = noOpenTip[i]}
    end
	-- tabs[ChatLayer.TAB_WORLD] = {
	-- 	text = G_Lang.get("chat_tab_channel_world")
	-- }
	-- tabs[ChatLayer.TAB_GANG] = {
	-- 	text = G_LangScrap.get("chat_tab_channel_gang"),
	-- 	noOpen = G_Me.userData.guild_id == 0,
	-- 	noOpenTips = G_LangScrap.get("chat_gang_not_open")
	-- }

	if self._initIndex == 2 and funcOpen[2] == false then
		self._initIndex = 1
		self._currentIndex = 1
		G_Popup.tip(noOpenTip[2])
	end

	if self._initIndex == nil and funcOpen[1] then
		self._initIndex = 1
		self._currentIndex = 1
	end
	

	local params = {
    	tabs = tabs,
		isBig = false
	}

	self._tabButtons = require("app.common.TabButtonsHelper").updateTabButtons(buttonTabNode, params, handler(self,self._onTabChange))
    --self._tabButtons.setSelected(self._initIndex)

    local tab1 = buttonTabNode:getSubNodeByName("Button_tab_1")
    local tab2 = buttonTabNode:getSubNodeByName("Button_tab_2")
    local tab3 = buttonTabNode:getSubNodeByName("Button_tab_3")
    local tab4 = buttonTabNode:getSubNodeByName("Button_tab_4")
    if tab2 and tab3 and tab4 then
    	local pos1 = tab1:getPositionX()
    	local pos2 = tab2:getPositionX()
    	local pos3 = tab3:getPositionX()
    	local pos4 = tab4:getPositionX()
    	tab4:setPositionX(pos1)

    	tab2:setPositionX(pos4)
    	tab3:setPositionX(pos3)
    	tab1:setPositionX(pos2)
    end
end

function ChatLayer:_renderInputHeight()
	local perHeight = 23
	if self._currentIndex == ChatLayer.TAB_PRIVATE then
		if self._pri_contentInput:getAutoRenderSize().width > self._pri_contentInput:getVirtualRendererSize().width - 9 then
			local numH = math.floor(self._pri_contentInput:getAutoRenderSize().width / (self._pri_contentInput:getVirtualRendererSize().width - 9))

			self._img_priBg2:setContentSize(self._img_priBg2_w,self._img_priBg2_h + perHeight * numH)
	    	self._pri_contentInput:setContentSize(self._pri_contentInput_w,self._pri_contentInput_h + perHeight * numH)

		    self._image_list_bg:setContentSize(self._image_list_bg_w,self._image_list_bg_h - perHeight * numH)
		    self._panel_list_con:setContentSize(self._panel_list_con_w,self._panel_list_con_h - perHeight * numH)
		else
			self._img_priBg2:setContentSize(self._img_priBg2_w,self._img_priBg2_h)
	    	self._pri_contentInput:setContentSize(self._pri_contentInput_w,self._pri_contentInput_h)

		    self._image_list_bg:setContentSize(self._image_list_bg_w,self._image_list_bg_h)
		    self._panel_list_con:setContentSize(self._panel_list_con_w,self._panel_list_con_h)
		end
		self._listViews[G_Me.chatData.CHANNEL_PRIVATE]:refreshSize(self._panel_list_con:getContentSize())
    	self._image_huawen:setPositionY(self._panel_list_con:getContentSize().height/2)
		-- ccui.Helper:doLayout(self._view)
	elseif self._currentIndex == ChatLayer.TAB_WORLD or self._currentIndex == ChatLayer.TAB_BANG or self._currentIndex == ChatLayer.TAB_TEAM then
		if self._inputTxt:getAutoRenderSize().width > self._inputTxt:getVirtualRendererSize().width - 9 then
			local numH = math.floor(self._inputTxt:getAutoRenderSize().width / (self._inputTxt:getVirtualRendererSize().width - 9))

			self._unPriNode:setContentSize(self._unPriNode_w,self._unPriNode_h + perHeight * numH)
	    	self._inputTxt:setContentSize(self._inputTxt_w,self._inputTxt_h + perHeight * numH)

		    self._image_list_bg:setContentSize(self._image_list_bg_w,self._image_list_bg_h - perHeight * numH)
		    self._panel_list_con:setContentSize(self._panel_list_con_w,self._panel_list_con_h - perHeight * numH)
		else
			self._unPriNode:setContentSize(self._unPriNode_w,self._unPriNode_h)
	    	self._inputTxt:setContentSize(self._inputTxt_w,self._inputTxt_h)

		    self._image_list_bg:setContentSize(self._image_list_bg_w,self._image_list_bg_h)
		    self._panel_list_con:setContentSize(self._panel_list_con_w,self._panel_list_con_h)
		end
		if self._currentIndex == ChatLayer.TAB_WORLD then
			self._listViews[G_Me.chatData.CHANNEL_WORLD]:refreshSize(self._panel_list_con:getContentSize())
		elseif self._currentIndex == ChatLayer.TAB_BANG then
			self._listViews[G_Me.chatData.CHANNEL_GANG]:refreshSize(self._panel_list_con:getContentSize())
		elseif self._currentIndex == ChatLayer.TAB_TEAM and self._listViews[G_Me.chatData.CHANNEL_TEAM] then
			self._listViews[G_Me.chatData.CHANNEL_TEAM]:refreshSize(self._panel_list_con:getContentSize())
		end
    	self._image_huawen:setPositionY(self._panel_list_con:getContentSize().height/2)
		-- ccui.Helper:doLayout(self._view)
	end
end

function ChatLayer:isCheckBoxSelected(isSelect)

end

function ChatLayer:editBoxTextEventHandle(strEventName,pSender)
	--local edit = tolua.cast(pSender,"CCEditBox")
	if strEventName == "began" then
		self._curInput = pSender
		if self._currentChannel == G_Me.chatData.CHANNEL_PRIVATE and txt:getTag() == 33 then
        	self._isPlayerInput = true
        else
        	self._isPlayerInput = false
        end
	elseif strEventName == "ended" then --编辑框完成时调用
		self._isPlayerInput = false
	elseif strEventName == "return" then --编辑框return时调用
		self._isPlayerInput = false
	elseif strEventName == "changed" then --编辑框内容改变时调用
		local str = pSender:getText()
		local is = self:containsEmoji(str)
	end

end

function ChatLayer:containsEmoji(str)
	local len = string.len(str)
	if str == "" then return false end
	for i=1,len do
		if self:isEmojiCharacter(string.byte(str,i)) then
			return true
		end
	end
	return false
end

function ChatLayer:onInputEvent(txt,eventType)
	self:_renderInputHeight()
    if(eventType==ccui.TextFiledEventType.attach_with_ime)then
    	self._curInput = txt
    	self._palaceHolder = txt:getPlaceHolder()
    	txt:setPlaceHolder("")
        txt:setHighlighted(true)
        if self._currentChannel == G_Me.chatData.CHANNEL_PRIVATE and txt:getTag() == 33 then
        	self._isPlayerInput = true
        else
        	self._isPlayerInput = false
        end
        self:_upView()
    elseif(eventType==ccui.TextFiledEventType.detach_with_ime)then
        txt:setHighlighted(false)
        txt:setPlaceHolder(self._palaceHolder)
        self._isPlayerInput = false
        if self._curInput == txt then
        	self:_downView()
        end
    elseif(eventType==ccui.TextFiledEventType.insert_text)then
    	-- dump(self._curInput:getString() )

        if self._curInput:getString() == "" or tonumber(ParameterInfo.get(221).content) > G_Me.userData.level then -- 未输入任何文字按钮置灰
        	self._btnSend:loadTextureNormal(G_Url:getUI_btn("btn_small_gray01"))
			--UpdateButtonHelper.reviseButton(self._btnSend,{isBig = false,color = UpdateButtonHelper.COLOR_GRAY})
        	self._btn_title:setTextColor(G_Colors.btn[303])
    		self._btn_title:enableOutline(G_Colors.outline[303],2) --描边统一为2，这里先写死
        else
        	self._btnSend:loadTextureNormal(G_Url:getUI_btn("btn_small03"))
			--UpdateButtonHelper.reviseButton(self._btnSend,{isBig = false,color = UpdateButtonHelper.COLOR_ORANGE})
       		self._btn_title:setTextColor(G_Colors.btn[301])
    		self._btn_title:enableOutline(G_Colors.outline[301],2) --描边统一为2，这里先写死
        end

        -- print("===================",self._curInput:getStringLength() , self._maxInputLength)
    	if self._curInput:getStringLength() - 2 >= self._maxInputLength then
        	G_Popup.tip(G_Lang.get("chat_max_words", {num = self._maxInputLength}))
        end
        
    elseif(eventType==ccui.TextFiledEventType.delete_backward)then
    	dump(self._curInput:getString() )
    	if self._curInput:getString() == "" or tonumber(ParameterInfo.get(221).content) > G_Me.userData.level then -- 未输入任何文字按钮置灰
        	self._btnSend:loadTextureNormal(G_Url:getUI_btn("btn_small_gray01"))
			--UpdateButtonHelper.reviseButton(self._btnSend,{isBig = false,color = UpdateButtonHelper.COLOR_GRAY})
        	self._btn_title:setTextColor(G_Colors.btn[303])
    		self._btn_title:enableOutline(G_Colors.outline[303],2) --描边统一为2，这里先写死
        else
        	self._btnSend:loadTextureNormal(G_Url:getUI_btn("btn_small03"))
			--UpdateButtonHelper.reviseButton(self._btnSend,{isBig = false,color = UpdateButtonHelper.COLOR_ORANGE})
        	self._btn_title:setTextColor(G_Colors.btn[301])
    		self._btn_title:enableOutline(G_Colors.outline[301],2) --描边统一为2，这里先写死
        end
    end
end

function ChatLayer:_enableSendBtn(bool)
	if bool then
		self._btnSend:loadTextureNormal(G_Url:getUI_btn("btn_small03"))
   		self._btn_title:setTextColor(G_Colors.btn[301])
		self._btn_title:enableOutline(G_Colors.outline[301],2) --描边统一为2，这里先写死
	else
		self._btnSend:loadTextureNormal(G_Url:getUI_btn("btn_small_gray01"))
    	self._btn_title:setTextColor(G_Colors.btn[303])
		self._btn_title:enableOutline(G_Colors.outline[303],2) --描边统一为2，这里先写死
	end
end

function ChatLayer:_upView()
    if device.platform ~= "windows" then
    	self._Panel_touch_shade:setVisible(true)
        self._view:stopAllActions()
        self._view:runAction(cc.MoveTo:create(0.15, cc.p(self._view:getPositionX(), 400)))
    end
end

function ChatLayer:_downView()
    if device.platform ~= "windows" then
    	self._Panel_touch_shade:setVisible(false)
        self._view:stopAllActions()
        self._view:runAction(cc.MoveTo:create(0.15, cc.p(self._view:getPositionX(), 0)))
    end
end

function ChatLayer:_onTabChange(index)
	self._view:getSubNodeByName("Node_bottom"):setVisible(true)

	self._currentIndex = index
	self._currentList = self._listViews[index]
	self:_enableSendBtn(self._inputTxt:getString() ~= "" and tonumber(ParameterInfo.get(221).content) <= G_Me.userData.level)
	if index == ChatLayer.TAB_WORLD then
		self._palaceHolder = self._inputTxt:getPlaceHolder()
		self._currentChannel = G_Me.chatData.CHANNEL_WORLD
		if not self._currentList then
			self:_createWorldList()
			G_HandlersManager.chatHandler:sendReadChat(index)
		end
		self._curInput = self._inputTxt

		-- local chapterData = G_Me.allChapterData:getNormalChapterData()

		-- self._view:getSubNodeByName("Node_bottom"):setVisible(true)   --本服
		self._view:getSubNodeByName("Text_chat_limit"):setVisible(false)

		local normalChapterData = G_Me.allChapterData:getNormalChapterData()
		print("passChapter:::",normalChapterData,#normalChapterData)
		--dump(normalChapterData)
		if normalChapterData and normalChapterData._clientChapters and #normalChapterData._clientChapters > 0 then
			local passChapter = 0
			for i=1,#normalChapterData._clientChapters do
				if normalChapterData._clientChapters[i]._chapterFlag == 2 then
					passChapter = passChapter + 1
				end
			end
			print("passChapter:::",passChapter)
			if passChapter < 12 then--通关十二章
				self._view:getSubNodeByName("Node_bottom"):setVisible(false)   --本服
				self._view:getSubNodeByName("Text_chat_limit"):setVisible(true)
				self._view:getSubNodeByName("Text_chat_limit"):setText(G_Lang.get("chapter_limit"))
			end
	end

	elseif index == ChatLayer.TAB_BANG then
		self._currentChannel = G_Me.chatData.CHANNEL_GANG
		if not self._currentList then
			self:_createGangList()
		end

		self._view:getSubNodeByName("Text_chat_limit"):setVisible(false)

	elseif index == ChatLayer.TAB_TEAM then
		self._currentChannel = G_Me.chatData.CHANNEL_TEAM
		if not self._currentList then
			self:_createServerList()
		end
		self._curInput = self._inputTxt
		self._view:getSubNodeByName("Text_chat_limit"):setVisible(false)
		self._view:getSubNodeByName("Node_bottom"):setVisible(true)
		if G_Me.userData.power < 500000 then
			self._view:getSubNodeByName("Node_bottom"):setVisible(false)
			self._view:getSubNodeByName("Text_chat_limit"):setVisible(true)
			self._view:getSubNodeByName("Text_chat_limit"):setText(G_Lang.get("power_limit_50"))
		end
	elseif index == ChatLayer.TAB_PRIVATE then
		self._palaceHolder = self._pri_contentInput:getPlaceHolder()
		self._currentChannel = G_Me.chatData.CHANNEL_PRIVATE
		self:_enableSendBtn(self._pri_contentInput:getString() ~= "")
		if not self._currentList then
			self:_createPrivateList()
			G_HandlersManager.chatHandler:sendReadChat(index)
		end
		self._curInput = self._pri_contentInput

		self._view:getSubNodeByName("Text_chat_limit"):setVisible(false)

	end

	G_Me.chatData:setLastChannel(self._currentChannel)
	for idx=1,ChatMaxTab do
		local view = self._listViews[idx]
		print("vvv",self._currentIndex,view == nil)
		if view then
			view:setVisible(idx == self._currentIndex)
		end
	end

	if not self._currentList then
		self._currentList = self._listViews[index]
	end

	--私聊
	self._unPriNode:setVisible(self._currentIndex ~= ChatLayer.TAB_PRIVATE)
	self._privateNode:setVisible(self._currentIndex == ChatLayer.TAB_PRIVATE)
	if self._initIndex == ChatLayer.TAB_PRIVATE and self._priName then
		self._pri_playerInput:setText(self._priName)
	end

	
	self:_checkCoolTime()
    self:_onUpdateRedPoint()
	self:_renderInputHeight()
end

function ChatLayer:_onGetHistoryMsg()
	dump(self._currentIndex)
	self:_initTab()
	dump(self._currentIndex)
	local listView = self._listViews[self._currentChannel]
	local dataList = {}
	if self._currentIndex == ChatLayer.TAB_WORLD then
		dataList = G_Me.chatData:getWorldList()
	elseif self._currentIndex == ChatLayer.TAB_PRIVATE then
		dataList = G_Me.chatData:getPrivateList()
	elseif self._currentIndex == ChatLayer.TAB_BANG then
		dataList = G_Me.chatData:getGangList()
	elseif self._currentIndex == ChatLayer.TAB_TEAM then
		dataList = G_Me.chatData:getServerList()
	end
	if listView then
		listView:clearView()
	end
	for i=1,#dataList do
		if listView then
			listView:addNewMsg(dataList[i])
		end
	end
end

function ChatLayer:_onHitMsg(playerName)
	if self._currentChannel == G_Me.chatData.CHANNEL_PRIVATE then
		self._pri_playerInput:setText(playerName)
	end
end

function ChatLayer:_onGetMsg(chatUnit)
	local channel = chatUnit:getChannel()
	print("on get msg ~~~~~", channel)
	local listView = self._listViews[channel]
	if listView ~= nil then
		print("listView..start....")
		listView:addNewMsg(chatUnit)
	end
	-- if chatUnit:getChannel() == G_Me.chatData.CHANNEL_WORLD then
	-- 	if listView ~= nil then
	-- 		listView:addNewMsg(chatUnit)
	-- 	end
	-- elseif chatUnit:getChannel() == G_Me.chatData.CHANNEL_GANG then
	-- 	if listView ~= nil then
	-- 		listView:addNewMsg(chatUnit)
	-- 	end
	-- elseif chatUnit:getChannel() == G_Me.chatData.CHANNEL_GANG then
	-- 	if listView ~= nil then
	-- 		listView:addNewMsg(chatUnit)
	-- 	end
	-- end

	self:_checkCoolTime()
	
end

function ChatLayer:_onSelectedFace(faceId)
	dump(faceId .. " : " .. tostring(self._isPlayerInput) .. " : " .. tostring(self._curInput))
	if not self._isPlayerInput and self._curInput then
		local currentStr = self._curInput:getString()
		currentStr = currentStr .. "#" .. tostring(faceId) .. "#"
		dump(currentStr)
		self._curInput:setText(currentStr)

		if tonumber(ParameterInfo.get(221).content) <= G_Me.userData.level then
			self._btnSend:loadTextureNormal(G_Url:getUI_btn("btn_small03"))
			self._btn_title:setTextColor(G_Colors.btn[301])
			self._btn_title:enableOutline(G_Colors.outline[301],2) --描边统一为2，这里先写死
		end
	end
end

function ChatLayer:_onSendSuccess()
	if self._currentIndex == ChatLayer.TAB_WORLD or self._currentIndex == ChatLayer.TAB_BANG or self._currentIndex == ChatLayer.TAB_TEAM then
		self._inputTxt:setText("") --清空输入文本
		--self._inputTxt:setDetachWithIME(true)
		self._inputTxt:setPlaceHolder(self._palaceHolder)
		self._inputTxt:setCursorPosition(0)
		--self._inputTxt:attachWithIME()
	elseif self._currentIndex == ChatLayer.TAB_PRIVATE then
		self._pri_contentInput:setText("") --清空输入文本
		--self._pri_contentInput:setDetachWithIME(true)
		self._pri_contentInput:setPlaceHolder(self._palaceHolder)
		self._inputTxt:setCursorPosition(0)
		--self._pri_contentInput:attachWithIME()
	end

	--self._pri_playerInput:setText("") --清空输入文本
	self:_renderInputHeight()
end

-- function ChatLayer:_onShowWorld()
-- 	if self._listViewWorld == nil then
-- 		self:_createWorldList()
-- 	end

-- 	self._listViewWorld:setVisible(true)

-- 	if self._listViewGang then
-- 		self._listViewGang:setVisible(false)
-- 	end
-- end

-- function ChatLayer:_onShowGang()
-- 	if self._listViewGang == nil then
-- 		self:_createGangList()
-- 	end

-- 	self._listViewGang:setVisible(true)

-- 	if self._listViewWorld then
-- 		self._listViewWorld:setVisible(false)
-- 	end
-- end

function ChatLayer:_createWorldList()
	local worldList = G_Me.chatData:getWorldList()
	dump(worldList)
	local listCon = self._view:getSubNodeByName("Panel_list_con")
	local view = ChatScrollView.new(worldList, listCon:getContentSize(), G_Me.chatData.CHANNEL_WORLD)
	self._listViews[G_Me.chatData.CHANNEL_WORLD] = view
	listCon:addChild(view)
end

function ChatLayer:_createPrivateList()
	local privateList = G_Me.chatData:getPrivateList()
	local listCon = self._view:getSubNodeByName("Panel_list_con")

	local view = ChatScrollView.new(privateList, listCon:getContentSize(), G_Me.chatData.CHANNEL_PRIVATE)
	self._listViews[G_Me.chatData.CHANNEL_PRIVATE] = view
	listCon:addChild(view)
end

function ChatLayer:_createGangList()
	local gangList = G_Me.chatData:getGangList()
	local listCon = self._view:getSubNodeByName("Panel_list_con")

	local view = ChatScrollView.new(gangList, listCon:getContentSize(), G_Me.chatData.CHANNEL_GANG)
	self._listViews[G_Me.chatData.CHANNEL_GANG] = view
	listCon:addChild(view)
end

function ChatLayer:_createServerList()
	local serverList = G_Me.chatData:getServerList()
	local listCon = self._view:getSubNodeByName("Panel_list_con")

	local view = ChatScrollView.new(serverList, listCon:getContentSize(), G_Me.chatData.CHANNEL_TEAM)
	self._listViews[G_Me.chatData.CHANNEL_TEAM] = view
	listCon:addChild(view)
end

--==向服务端发送聊天信息
function ChatLayer:_onSendMsg()
	if self._currentList and self._currentList:getScrollView() then
		self._currentList:getScrollView():jumpToBottom()
	end
	local glView = cc.Director:getInstance():getOpenGLView()
	if glView then
		glView:setIMEKeyboardState(false)
	end
	--local str = self._inputTxt:getText()
	--self._pri_playerInput:setText("") --清空输入文本
	--self._pri_contentInput:setText("") --清空输入文本
	local strPlayer,strContent = nil,nil
	if self._currentChannel == G_Me.chatData.CHANNEL_PRIVATE then
		--昵称
		strPlayer = self._pri_playerInput:getString()

		local canSend = G_Me.chatData:isCanSendWorldMsg()
		--strPlayer = self._pri_playerInput:getText() -- editbox
		if canSend == false then
			G_Popup.tip(G_Lang.get("chat_no_enough_lv_send"))
			return
		elseif strPlayer == "" then
        	G_Popup.tip(G_Lang.get("chat_player_input_txt"))
        	return
        elseif G_Me.userData.power < tonumber(ParameterInfo.get(ChatLayer.PRIVATE_NEED_POWER).content) then
        	G_Popup.tip(ParameterInfo.get(ChatLayer.PRIVATE_NEED_POWER).description)
        	return
    	end

    	--发送内容
    	strContent = self._pri_contentInput:getString()
		if strContent == "" then
        	G_Popup.tip(G_Lang.get("chat_no_input_txt"))
        	return
    	end

    else
    	strContent = self._inputTxt:getString()
	    if strContent == "" then
	        G_Popup.tip(G_Lang.get("chat_no_input_txt"))
	        return
	    end
	end

    local inputCount = UTF8.utf8len(strContent)
    if inputCount > self._maxInputLength then ---此处控制输入的字符长度。
        G_Popup.tip(G_Lang.get("chat_send_message_too_long", {num = self._maxInputLength}))
        return
    end

    --过滤禁词
    if strPlayer then
    	if strPlayer == G_Me.userData.name then
    		G_Popup.tip(G_Lang.get("chat_send_to_self_warning"))
    		return
    	end
    	strPlayer = GlobalFunc.filterText(strPlayer)
    end
    strContent = GlobalFunc.filterText(strContent) 

    if G_Me.chatData:checkLastMsg(self._currentChannel, strContent) == false then
		G_Popup.tip(G_Lang.get("chat_same_input_txt"))
		return
    end

    if G_Me.chatData:checkBlackMsg(strContent) == false then
		-- if buglyReportLuaException ~= nil then
	 --    	buglyReportLuaException("广告广告广告广告广告广告:"..strContent)
	 --    end
    end

    G_HandlersManager.chatHandler:sendChat(self._currentChannel, strContent,strPlayer)

    G_Me.chatData:onSendMsgSuccess(self._currentChannel)
end

function ChatLayer:_checkCoolTime()
	local coolTime = G_Me.chatData:getCoolTime(self._currentChannel)
	local sendButton = self:getSubNodeByName("Button_send")

	

	self:_clearCountDown()
	if coolTime > 0 then
		--sendButton:setEnabledEx(false)
		sendButton:updateLabel("button_title", {text = coolTime})

		-- UpdateButtonHelper.updateNormalButton(sendButton,{
		-- 	state = UpdateButtonHelper.STATE_GRAY,
		-- 	desc = coolTime
		-- })
			
		self._scheduler = SchedulerHelper.newCountdown(
	        coolTime, 1,
	        function()
	            coolTime = coolTime - 1
	            sendButton:updateLabel("button_title", {text = coolTime})
	   --          UpdateButtonHelper.updateNormalButton(sendButton,{
				-- 	desc = coolTime
				-- })
	        end, 
	        function() 
	        	--sendButton:setEnabledEx(true)
				sendButton:updateLabel("button_title", {text = G_Lang.get("chat_send_message")})
	            -- UpdateButtonHelper.updateNormalButton(sendButton,{
	            -- 	state = UpdateButtonHelper.STATE_NORMAL,
	            -- 	desc = G_LangScrap.get("chat_send_message")
	            -- })
	        end
        )
	else
		--sendButton:setEnabledEx(true)
		sendButton:updateLabel("button_title", {text = G_Lang.get("chat_send_message")})
		-- UpdateButtonHelper.updateNormalButton(sendButton,{
		-- 	state = UpdateButtonHelper.STATE_NORMAL,
		-- 	desc = G_LangScrap.get("chat_send_message")
		-- })
	end

end

function ChatLayer:_clearCountDown()
	if self._scheduler ~= nil then
		SchedulerHelper.cancelCountdown(self._scheduler)
		self._scheduler = nil
	end
end

function ChatLayer:_onShowFaceLayer()
	local isVisible = self._faceNode:isVisible()
	self._faceNode:setVisible(not isVisible)
end

--初始化页签（定位红点页签）
function ChatLayer:_initTab()
	local worldRedPoint = G_Me.chatData:hasRedPointWorld()
    local privateRedPoint = G_Me.chatData:hasRedPointPrivate()
    local gangRedPoint = G_Me.chatData:hasRedPointGang()
    local list = {worldRedPoint,privateRedPoint,gangRedPoint}
    local initIndex = ChatLayer.TAB_WORLD
    for i=1,#list do
    	if list[i] == true then
    		initIndex = i
    		break
    	end
    end
    print("ChatLayer:_initTab()"..tostring(initIndex))
    initIndex = self._initIndex and self._initIndex or initIndex
    print("ChatLayer:_initTab()"..tostring(initIndex))
    
    self._tabButtons.setSelected(initIndex)
end

--更新聊天红点。
function ChatLayer:_onUpdateRedPoint()
	print("ChatLayer:_onUpdateRedPoint")
	if self._currentIndex == ChatLayer.TAB_WORLD then
		G_Me.chatData:clearRedPointWorld()
	elseif self._currentIndex == ChatLayer.TAB_PRIVATE then
		G_Me.chatData:clearRedPointPrivate()
	elseif self._currentIndex == ChatLayer.TAB_BANG then
		G_Me.chatData:clearRedPointGang()
	elseif self._currentIndex == ChatLayer.TAB_TEAM then
		G_Me.chatData:clearRedPointServer()
	end
	
	self._tabButtons.updateRedPoint(ChatLayer.TAB_WORLD, G_Me.chatData:hasRedPointWorld())
	self._tabButtons.updateRedPoint(ChatLayer.TAB_PRIVATE, G_Me.chatData:hasRedPointPrivate())
	self._tabButtons.updateRedPoint(ChatLayer.TAB_BANG, G_Me.chatData:hasRedPointGang())
	self._tabButtons.updateRedPoint(ChatLayer.TAB_TEAM, G_Me.chatData:hasRedPointServer())
	uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_CHAT_FLOAT_UPDATE_RED, nil, false)
end


return ChatLayer