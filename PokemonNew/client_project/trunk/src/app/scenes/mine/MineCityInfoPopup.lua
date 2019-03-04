--
-- Author: yutou
-- Date: 2018-09-20 14:27:52
--

local MineCityInfoPopup=class("MineCityInfoPopup",function()
	return display.newNode()
end)

local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local MineCityInfoCell = require("app.scenes.mine.MineCityInfoCell")
local ConfirmAlert = require("app.common.ConfirmAlert")
local Parameter_info = require("app.cfg.parameter_info")
local MineCityData = require("app.scenes.mine.data.MineCityData")
local EffectNode = require("app.effect.EffectNode")
local MinePlayerData = require("app.scenes.mine.data.MinePlayerData")

function MineCityInfoPopup:ctor(cityID)
	self:enableNodeEvents()
    self._canRefreshOne = true
	self._mineData = G_Me.mineData
    self._cityID = cityID
    if self._cityID == self._mineData:getMyCityData():getID() then
        self._data = self._mineData:getMyCityData()
    else
        self._data = self._mineData:getCityDataByID(self._cityID)
    end

	self:_init()
end

function MineCityInfoPopup:_init()
	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("MineCityInfoPopup","mine"))
	self._csbNode:setPosition(display.cx,display.cy)
	self._csbNode:addTo(self)
	
    UpdateNodeHelper.updateCommonNormalPop(self._csbNode,self._data:getName(),function ( ... )
        self:removeFromParent(true)
    end,780)

    self._text_quality = self:getSubNodeByName("Text_quality")
    self._text_city_output = self:getSubNodeByName("Text_city_output")
    self._text_city_power = self:getSubNodeByName("Text_city_power")
    self._node_city_icon = self:getSubNodeByName("Node_city_icon")
    self._text_city_name = self:getSubNodeByName("Text_city_name")

    self._fileNode_city = self:getSubNodeByName("FileNode_1")
    self._fileNode_owner = self:getSubNodeByName("FileNode_2")
    self._fileNode_worker = self:getSubNodeByName("FileNode_3")
    self._fileNode_lover = self:getSubNodeByName("FileNode_4")
    self._button_formation = self:getSubNodeByName("Button_formation")
    self._fileNode_formation = self:getSubNodeByName("FileNode_8")

    self._ownerBind = MineCityInfoCell.new(self._fileNode_owner,self._data:getOwner(),self._data)
    self._workerBind = MineCityInfoCell.new(self._fileNode_worker,self._data:getWorker(),self._data)
    self._loverBind = MineCityInfoCell.new(self._fileNode_lover,self._data:getLover(),self._data)

    self._node_city_icon = self:getSubNodeByName("Node_city_icon")
    local citySp = display.newSprite(G_Url:getUIUrl("mine/citys", self._data:getQuality()))
    citySp:setScale(0.8)
    self._node_city_icon:addChild(citySp)

    local effectCfgs = {
        [MineCityData.QUALITY_TIE] = {name = "effect_mine_jin",x =0,y =0,scale = 0.8},
        [MineCityData.QUALITY_TONG] = {name = "effect_mine_jin",x =0,y =0,scale = 0.8},
        [MineCityData.QUALITY_YIN] = {name = "effect_mine_jin",x =0,y =0,scale = 0.8},
        [MineCityData.QUALITY_HUANGJIN] = {name = "effect_mine_jin",x =0,y =0,scale = 0.8},
        [MineCityData.QUALITY_SHUIJING] = {name = "effect_mine_shuijing",x =0,y =0,scale = 0.8},
        [MineCityData.QUALITY_ZUANSHI] = {name = "effect_mine_zhuanshi",x =0,y =0,scale = 0.8},
        [MineCityData.QUALITY_WUCAI] = {name = "effect_mine_wucai",x =0,y =0,scale = 0.8},
    }
    -- self._effectNode:removeAllChildren()
    local effectCfg = effectCfgs[self._data:getQuality()]
    local effect = EffectNode.createEffect( effectCfg.name,{x = effectCfg.x,y = effectCfg.y},self._node_city_icon)
    effect:setScale(effectCfg.scale)

    self:render()
    self:onUpdate(handler(self, self._update))
end

function MineCityInfoPopup:render()
    if self._isAttacking then
        return
    end
    if self._cityID == self._mineData:getMyCityData():getID() then
        self._data = self._mineData:getMyCityData()
    else
        self._data = self._mineData:getCityDataByID(self._cityID)
    end

    self._zhan = self:getSubNodeByName("Button_zhan")
    
    print("MineCityInfoPopup:renderMineCityInfoPopup:render")
    print(debug.traceback(""))
    self._ownerBind:setData(self._data:getOwner(),self._zhan,self._data)
    self._workerBind:setData(self._data:getWorker(),self._zhan,self._data)
    self._loverBind:setData(self._data:getLover(),self._zhan,self._data)

    self._text_city_output:setString(self._data:getAward(1,4))
    -- self._text_city_power:setString(self._data:getOwnerPower())
    self._node_city_icon = self:getSubNodeByName("Node_city_icon")
    self._text_quality:setString(self._data:getQuality())
    self._text_city_name:setString(self._data:getIndex() .. "-" .. self._data:getMinePosition())
    
    self._text_city_power = self._fileNode_city:getSubNodeByName("Text_city_power")
    self._text_lefttime = self:getSubNodeByName("Text_lefttime")

    if self._data:getOwner():hasData() then
        self._text_city_power:setString(GlobalFunc.ConvertNumToCharacter(self._data:getOwner():getPower(),0))
        self._text_lefttime:setString( G_ServerTime:getLeftSecondsString(self._data:getOverTime()))

        self._zhan:setVisible(true)
        self._zhan:addClickEventListenerEx(function()

            G_Responder.enoughSpirit(tonumber(Parameter_info.get(580).content), function () 
                -- ConfirmAlert.createConfirmText(
                --     G_Lang.get("common_title_tip"),
                --     G_Lang.get("mine_attack2",{num = tonumber(Parameter_info.get(580).content),name = self._data:getOwner():getName()}),
                --     function()
                        self._canRefreshOne = false
                        G_HandlersManager.mineHandler:sendAttack(self._data:getID())
                --     end
                -- )
            end,true)
            
        end 
        )
        self._button_title = self._zhan:getSubNodeByName("button_title")
        self._button_title:setString("抢 夺")
        self._Text_des = self._zhan:getSubNodeByName("Text_des")
        self._Text_num = self._zhan:getSubNodeByName("Text_num")
        self._Text_num:setString(Parameter_info.get(580).content)
        self._Text_des:setVisible(true)

        if self._data:getID() == self._mineData:getMyCityData():getID() and self._mineData:getMyCityData():getMyPos() ==  MinePlayerData.JOB_OWNER then
            self._fileNode_formation:setVisible(false)
        else
            self._fileNode_formation:setVisible(true)
        end
        
        self._button_formation:addClickEventListenerEx(function() 
                uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_TEAM_GET_USER_FORMATION,function(_, emenyInfo )
                    print("dgadahahdfahahah43535")
                    dump(emenyInfo)
                    G_Popup.newPopup(function()
                        return require("app.scenes.team.lineup.CommonVsFormation").new(2,G_FunctionConst.FUNC_MINE,emenyInfo,0)
                    end)
                    uf_eventManager:removeListenerWithEvent(self,G_EVENTMSGID.EVENT_TEAM_GET_USER_FORMATION)
                end,self)
                G_HandlersManager.teamHandler:sendGetUserDefFormation(self._data:getOwner():getID())
            end
        )
    else
        self._fileNode_formation:setVisible(false)
        self._zhan:setVisible(true)
        self._zhan:addClickEventListenerEx(function()
            G_Responder.enoughSpirit(tonumber(Parameter_info.get(580).content), function () 
                -- ConfirmAlert.createConfirmText(
                --     G_Lang.get("common_title_tip"),
                --     G_Lang.get("mine_attack",{num = tonumber(Parameter_info.get(580).content),name = self._data:getName()}),
                --     function()
                        self._canRefreshOne = false
                        G_HandlersManager.mineHandler:sendAttack(self._data:getID())
                --     end
                -- )
            end,true)
        end 
        )
        self._button_title = self._zhan:getSubNodeByName("button_title")
        self._button_title:setString("占 领")
        self._Text_des = self._zhan:getSubNodeByName("Text_des")
        self._Text_num = self._zhan:getSubNodeByName("Text_num")
        self._Text_num:setString(Parameter_info.get(580).content)
        self._Text_des:setVisible(true)
        
        self._text_city_power:setString("无")
        self._text_lefttime:setString("无人占领")
    end

    self._ownerBind:render()
    self._workerBind:render()
    self._loverBind:render()
    
    UpdateNodeHelper.updateCommonNormalPop(self._csbNode,self._data:getName(),function ( ... )
        self:removeFromParent(true)
    end,780)
end

function MineCityInfoPopup:_update()
    if self._data:getOwner():hasData() then
        self._text_lefttime:setString(G_ServerTime:getLeftSecondsString(self._data:getOverTime()))
    end
    self._ownerBind:update()
    self._workerBind:update()
    self._loverBind:update()
end

function MineCityInfoPopup:onEnter()
    print("MineCityInfoPopup:renderMineCityInfoPopup:onEnter")
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_APPLY_JOB,self.render,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_FIRE,self.render,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_ATTACK,self.attacking,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_ATTACK_OVER,self.attackover,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_REFRESH_ONE,self.refreshOne,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_QUIT,self.render,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MINE_CONTINUE,self.render,self)
end

function MineCityInfoPopup:refreshOne()
    if self._canRefreshOne then
        self:render()
    end
end

function MineCityInfoPopup:attacking()
    self._isAttacking = true
end

function MineCityInfoPopup:attackover()
    self._isAttacking = false
    self:render()
    self._canRefreshOne = true
end

function MineCityInfoPopup:onExit()
    print("MineCityInfoPopup:renderMineCityInfoPopup:onExit")
	uf_eventManager:removeListenerWithTarget(self)
end

function MineCityInfoPopup:onCleanup()
    print("MineCityInfoPopup:renderMineCityInfoPopup:onCleanup")
	
end

return MineCityInfoPopup