--
-- Author: yutou
-- Date: 2018-09-20 14:25:58
--
local MineCityInfoCell=class("MineCityInfoCell")

local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local MinePlayerData = require("app.scenes.mine.data.MinePlayerData")
local ConfirmAlert = require("app.common.ConfirmAlert")
local Parameter_info = require("app.cfg.parameter_info")

function MineCityInfoCell:ctor(csb,data,cityData)
	self._csb = csb
	self._data = data
	self._cityData = cityData
	self._mineData = G_Me.mineData
    self._node_icon = self._csb:getSubNodeByName("Node_icon")
    self._text_name = self._csb:getSubNodeByName("Text_name")
    self._text_time = self._csb:getSubNodeByName("Text_time")
    self._text_get = self._csb:getSubNodeByName("Text_get")
    self._button_big = self._csb:getSubNodeByName("Button_big")
    self._button_title = self._csb:getSubNodeByName("button_title")
    self._text_guide = self._csb:getSubNodeByName("Text_guide")
    self._text_name_job = self._csb:getSubNodeByName("Text_name_job")
    self._image_icon_bg = self._csb:getSubNodeByName("Image_icon_bg")
    self._sprite_head = self._csb:getSubNodeByName("Sprite_head")

    self._button_big:setVisible(false)
end

function MineCityInfoCell:setData( data ,bottomBtn,cityData)
	self._data = data
	self._bottomBtn = bottomBtn
	self._cityData = cityData
end

function MineCityInfoCell:render()
print("aaaaaaaaaaarenderrender1")
	-- if self._cityData:getOwner() == nil or self._cityData:getOwner():hasData() == false then
	-- 	self._csb:setVisible(false)
	-- 	return
	-- else
	-- 	self._button_big:setVisible(false)
	-- 	self._csb:setVisible(true)
	-- end
print("aaaaaaaaaaarenderrender2")

	if self._data:hasData() then
	    self._text_time:setString(G_ServerTime:_secondToString(self._data:getLeftTime()))
	    self._text_get:setString(self._data:getGeted())
	    if self._data:getGuild() == "" then
	    	self._text_guide:setString("无")
	    else
	    	self._text_guide:setString(self._data:getGuild())
	    end
		UpdateNodeHelper.updateCommonIconKnightNode(self._node_icon,
		{
			type = G_TypeConverter.TYPE_KNIGHT,
			value = self._data:getBaseID(),
			-- level = cellData.level,
			quality = self._data:getQuality(),
			textName = self._data:getName(),
			scale = 0.8,
			nameVisible = true
		},
		handler(self,self._onUserIconClick))

		self._node_icon:getSubNodeByName("Image_icon_icon"):setVisible(true)
		self._node_icon:getSubNodeByName("Image_icon_fragment"):setVisible(false)
		self._node_icon:getSubNodeByName("Text_icon_name"):setVisible(true)
		self._sprite_head:setVisible(false)
	else
	    self._text_time:setString(0)
	    self._text_get:setString(0)
	    self._text_guide:setString("无")
		self._node_icon:getSubNodeByName("Image_icon_icon"):setVisible(false)
		self._node_icon:getSubNodeByName("Image_icon_fragment"):setVisible(false)
		self._node_icon:getSubNodeByName("Text_icon_name"):setVisible(false)
		self._image_icon_bg:loadTexture("newui/common/frame/img_frame_01.png")
		self._sprite_head:setVisible(true)
	end

	if self._data:getJob() == MinePlayerData.JOB_OWNER then
		self._button_big:setVisible(false)
		if self._cityData:getID() == self._mineData:getMyCityData():getID() then
			print("1351164::::",self._mineData:getMyCityData():getMyPos() ,  MinePlayerData.JOB_OWNER , self._mineData:getMyCityData():canContinue())
			if self._mineData:getMyCityData():getMyPos() ==  MinePlayerData.JOB_OWNER then
				
				if self._mineData:getMyCityData():canContinue() then
					self._bottomBtn:setVisible(true)
			        self._button_title_bottomBtn = self._bottomBtn:getSubNodeByName("button_title")
			        self._Text_des = self._bottomBtn:getSubNodeByName("Text_des")
			        self._Text_num = self._bottomBtn:getSubNodeByName("Text_num")
			        self._Text_num:setString(Parameter_info.get(581).content)
			        self._Text_des:setVisible(true)
			        if self._mineData:getMyCityData():getContinueCount() == 0 then
			        	self._button_title_bottomBtn:setString("续 约")
			        else
			        	self._button_title_bottomBtn:setString("再次续约")
			        end
			        self._bottomBtn:addClickEventListenerEx(function()
						G_Responder.enoughSpirit(tonumber(Parameter_info.get(581).content), function () 
							-- ConfirmAlert.createConfirmText(
							-- 	G_Lang.get("common_title_tip"),
							-- 	G_Lang.get("mine_continue",{num = tonumber(Parameter_info.get(581).content),time = self._cityData:getOwner():nextExtTime()}),
							-- 	function()
									G_HandlersManager.mineHandler:sendContinue()
							-- 	end
							-- )
			            end,true)
			        end 
			        )
			    else
					self._bottomBtn:setVisible(false)
				end

				self._button_title:setString("卸 任")
				self._button_big:setVisible(true)
				self._button_big:addClickEventListenerEx(function()

					ConfirmAlert.createConfirmText(
						G_Lang.get("common_title_tip"),
						G_Lang.get("mine_quite_1"),
						function()
	           				G_HandlersManager.mineHandler:sendQuit(1)
						end
					)
				end)
			else
				self._bottomBtn:setVisible(false)
				self._button_big:setVisible(false)
			end
		else
			self._button_big:setVisible(false)

			-- self._button_title:setString("抢 夺")
			-- self._button_big:setVisible(true)
			-- local name = self._data:getName()
			-- self._button_big:addClickEventListenerEx(function( ... )
			-- 	ConfirmAlert.createConfirmText(
			-- 		G_Lang.get("common_title_tip"),
			-- 		G_Lang.get("mine_attack",{num = tonumber(Parameter_info.get(580).content),name = name}),
			-- 		function()
			-- 			G_HandlersManager.mineHandler:sendAttack(self._cityData:getID())
			-- 		end
			-- 	)
			-- end)
		end
		-- self._text_name_job:setString("矿主")
	    self._text_name:setString("矿主")
	elseif self._data:getJob() == MinePlayerData.JOB_WORKER then
		self._button_big:setVisible(false)
		if self._data:hasData() then
			if self._cityData:getID() == self._mineData:getMyCityData():getID() then
				if self._mineData:getMyCityData():getMyPos() ==  MinePlayerData.JOB_OWNER then
					self._button_title:setString("解 雇")
					self._button_big:setVisible(true)
					self._button_big:addClickEventListenerEx(function( ... )
			        	G_HandlersManager.mineHandler:sendFire(2)
					end)
				elseif self._mineData:getMyCityData():getMyPos() ==  MinePlayerData.JOB_WORKER then
					-- self._button_title:setString("罢 工")
					-- self._button_big:setVisible(true)
					-- self._button_big:addClickEventListenerEx(function( ... )
			  --       	G_HandlersManager.mineHandler:sendQuit()
					-- end)
					-- self._button_big:setVisible(false)

					self._bottomBtn:setVisible(true)
			        self._button_title_bottomBtn = self._bottomBtn:getSubNodeByName("button_title")
			        self._button_title_bottomBtn:setString("抢 夺")
			        self._Text_des = self._bottomBtn:getSubNodeByName("Text_des")
			        self._Text_num = self._bottomBtn:getSubNodeByName("Text_num")
			        self._Text_num:setString(Parameter_info.get(580).content)
			        self._Text_des:setVisible(true)
					local name = self._data:getName()
					self._bottomBtn:addClickEventListenerEx(function( ... )
						ConfirmAlert.createConfirmText(
							G_Lang.get("common_title_tip"),
							G_Lang.get("mine_attack2",{num = tonumber(Parameter_info.get(580).content),name = self._cityData:getOwner():getName()}),
							function()
								G_HandlersManager.mineHandler:sendAttack(self._cityData:getID())
							end
						)
					end)

					self._button_title:setString("罢 工")
					self._button_big:setVisible(true)
					self._button_big:addClickEventListenerEx(function( ... )
						ConfirmAlert.createConfirmText(
							G_Lang.get("common_title_tip"),
							G_Lang.get("mine_quite_2"),
							function()
		           				G_HandlersManager.mineHandler:sendQuit(2)
							end
						)
					end)

				else
					self._button_big:setVisible(false)
				end
			else
				self._button_big:setVisible(false)
			end
		else
			print("dddddddddddgadg1414",self._cityData:getOwner():hasData() , self._mineData:getMyCityData():getMyPos() ,  MinePlayerData.JOB_LOVER)
			print(debug.traceback(""))
			if self._cityData:getID() == self._mineData:getMyCityData():getID() and self._mineData:getMyCityData():getMyPos() ==  MinePlayerData.JOB_OWNER then
				self._button_big:setVisible(false)
			-- elseif self._cityData:getOwner():hasData() and self._mineData:getMyCityData():getMyPos() ~=  MinePlayerData.JOB_LOVER then
			elseif self._cityData:getOwner():hasData() then
				self._button_title:setString("应 聘")
				self._button_big:setVisible(true)
				self._button_big:addClickEventListenerEx(function( ... )
		        	G_HandlersManager.mineHandler:sendApplyJob(self._cityData:getID(),2)
				end)
			else
				self._button_big:setVisible(false)
			end
		end
	    self._text_name:setString("监工")
	elseif self._data:getJob() == MinePlayerData.JOB_LOVER then
		self._button_big:setVisible(false)
	    self._text_name:setString("情侣")
		--添加好友
		--情侣相关判断
		local isLovers = false
		local loversInfo = G_Me.loversData:getLoversInfo()
		if loversInfo and self._cityData:getOwner():getID() == loversInfo:getId() then -- 是自己的情侣
			isLovers = true
		end
		self._button_big:addClickEventListenerEx(function( ... )
        	G_HandlersManager.mineHandler:sendApplyJob(self._cityData:getID(),3)
		end)
		if self._data:hasData() and self._cityData:getID() == self._mineData:getMyCityData():getID() then
			print("dagadgahahdgahaha",self._mineData:getMyCityData():getMyPos() ,  MinePlayerData.JOB_LOVER)
			if self._mineData:getMyCityData():getMyPos() ==  MinePlayerData.JOB_OWNER then
				self._button_title:setString("开 除")
				self._button_big:setVisible(true)
				self._button_big:addClickEventListenerEx(function( ... )
		        	G_HandlersManager.mineHandler:sendFire(3)
				end)
			elseif self._mineData:getMyCityData():getMyPos() ==  MinePlayerData.JOB_LOVER then
				-- self._button_title:setString("罢 工")
				-- self._button_big:setVisible(true)
				-- self._button_big:addClickEventListenerEx(function( ... )
		  --       	G_HandlersManager.mineHandler:sendQuit()
				-- end)
				
				self._button_title:setString("退 出")
				self._button_big:setVisible(true)
				self._button_big:addClickEventListenerEx(function( ... )
					ConfirmAlert.createConfirmText(
						G_Lang.get("common_title_tip"),
						G_Lang.get("mine_quite_3"),
						function()
	           				G_HandlersManager.mineHandler:sendQuit(3)
						end
					)
				end)

				self._bottomBtn:setVisible(true)
		        self._button_title_bottomBtn = self._bottomBtn:getSubNodeByName("button_title")
		        self._button_title_bottomBtn:setString("抢 夺")
		        self._Text_des = self._bottomBtn:getSubNodeByName("Text_des")
		        self._Text_num = self._bottomBtn:getSubNodeByName("Text_num")
		        self._Text_num:setString(Parameter_info.get(580).content)
		        self._Text_des:setVisible(true)
				local name = self._data:getName()
				self._bottomBtn:addClickEventListenerEx(function( ... )
					ConfirmAlert.createConfirmText(
						G_Lang.get("common_title_tip"),
						G_Lang.get("mine_attack2",{num = tonumber(Parameter_info.get(580).content),name = self._cityData:getOwner():getName()}),
						function()
							G_HandlersManager.mineHandler:sendAttack(self._cityData:getID())
						end
					)
				end)

			else
				self._button_big:setVisible(false)
			end
		else
			print("ahahfjafdjafjadgadga",self._mineData:getMyCityData():getMyPos() ~=  MinePlayerData.JOB_WORKER)
			-- if isLovers and self._mineData:getMyCityData():getMyPos() ~=  MinePlayerData.JOB_WORKER then
			if isLovers then
				self._button_title:setString("协 助")
				self._button_big:setVisible(true)
			else
				self._button_big:setVisible(false)
			end
		end
	end

print("aaaaaaaaaaarenderrender3")

end

function MineCityInfoCell:update()
	if self._data:hasData() then
	    self._text_get:setString(self._data:getGeted())
	    self._text_time:setString(G_ServerTime:_secondToString(self._data:getLeftTime()))
	end
end

function MineCityInfoCell:_onUserIconClick()
	if self._data:getID() ~= G_Me.userData.id then
		G_HandlersManager.commonHandler:sendGetCommonBattleUser(self._data:getID(),1)
	end
end

return MineCityInfoCell