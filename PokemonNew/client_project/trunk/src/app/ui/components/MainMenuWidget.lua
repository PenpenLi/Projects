--
-- Author: YouName
-- Date: 2015-08-15 15:55:31
--
--[[
    主菜单 导航条
]]
local MainMenuWidget = class("MainMenuWidget", function()
    return display.newNode()
end)

local RedPointHelper = require("app.common.RedPointHelper")

function MainMenuWidget:ctor()
    self:enableNodeEvents()
    self._csbNode = nil
    self._posBtns = {}
    self._funcList = {}
    self._selectedIndex = 0
    self._targetIndex = 0
    self._imageMenuSelected = nil
    self._redDotMap = {}
    self._enableClick = false
    self:_initUI()

    self:setName("MainMenuWidget")
end

function MainMenuWidget:_initUI()
    self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("NavigationBotMenu", "navigation"))
    self:addChild(self._csbNode)
    self._imageMenuSelected = self._csbNode:getSubNodeByName("Image_menu_selected")

    local btnHome = self:updateButton("Button_home", {callback = handler(self,self._onMenuClick)})
    local btnTeam = self:updateButton("Button_team", {callback = handler(self,self._onMenuClick)})
    local btnFuben = self:updateButton("Button_fuben", {callback = handler(self,self._onMenuClick)})
    --local btnAdventure = self:updateButton("Button_adventure", {callback = handler(self,self._onMenuClick)})
    --local btnTask = self:updateButton("Button_task", {callback = handler(self,self._onMenuClick)})
    local btnPve = self:updateButton("Button_pve", {callback = handler(self,self._onMenuClick)})
    local btnPvp = self:updateButton("Button_pvp", {callback = handler(self,self._onMenuClick)})
    local btnShop = self:updateButton("Button_shop", {callback = handler(self,self._onMenuClick)})

    self._btns = {}
    self._btns[1] = btnHome
    self._btns[2] = btnTeam
    self._btns[3] = btnFuben
    --self._btns[4] = btnAdventure
    --self._btns[5] = btnTask
    self._btns[4] = btnPve
    self._btns[5] = btnPvp
    self._btns[6] = btnShop
  
    self._funcList = {
        0,
        G_FunctionConst.FUNC_TEAM,
        G_FunctionConst.FUNC_MAIN_MISSION,
        G_FunctionConst.FUNC_PVE,
        G_FunctionConst.FUNC_PVP,
        0,
    }

    self:_setRedDotData(btnHome:getSubNodeByName("Image_red_dot"),RedPointHelper.KEYLIST["home"])
    self:_setRedDotData(btnTeam:getSubNodeByName("Image_red_dot"),{G_FunctionConst.FUNC_TEAM})
    self:_setRedDotData(btnFuben:getSubNodeByName("Image_red_dot"),RedPointHelper.KEYLIST["mission"])
    self:_setRedDotData(btnPve:getSubNodeByName("Image_red_dot"),RedPointHelper.KEYLIST["pve"])
    self:_setRedDotData(btnPvp:getSubNodeByName("Image_red_dot"),RedPointHelper.KEYLIST["pvp"])
    self:_setRedDotData(btnShop:getSubNodeByName("Image_red_dot"),{G_FunctionConst.FUNC_SHOP})
    -- self:_setRedDotData(btnAdventure:getSubNodeByName("Image_red_dot"),RedPointHelper.KEYLIST["advanture"])
    -- self:_setRedDotData(btnTask:getSubNodeByName("Image_red_dot"),{G_FunctionConst.FUNC_DAILY_TASK})

    self._posBtns = {}
    for i=1,#self._btns do
        self._posBtns[i] = {x=self._btns[i]:getPositionX(),y=self._btns[i]:getPositionY()}
    end
end

function MainMenuWidget:_onMenuClick( sender )
    -- body
    if(self._enableClick == false)then return end
    local btnIndex = table.indexof(self._btns,sender)
    if(btnIndex ~= false)then
        self._targetIndex = btnIndex
        if(self._isSuspend == true)then
            uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_MAIN_MENU_SUSPEND,nil,false,btnIndex)
            return
        end
        self:setSelected(btnIndex)
        G_Me.teamCacheData:setNowTeamPos(0)
    end
end

function MainMenuWidget:setSuspend( bool )
    -- body
    self._isSuspend = bool
end

function MainMenuWidget:_setTabSelected( index )
    -- body
    self._selectedIndex = index
    if(index < 1 or index > 6)then
        self._imageMenuSelected:setVisible(false)
        return
    end

    self._imageMenuSelected:setVisible(true)
    local pos = self._posBtns[index]
    self._imageMenuSelected:setPositionX(pos.x)
end

function MainMenuWidget:_checkOpen( index,callback )
    -- body
    if(index > 6 or index < 1)then
        if(callback ~= nil)then
            callback()
        end
        return
    end

    local funcId = self._funcList[index]
    if(funcId == 0)then
        funcId = nil
    end
    require("app.responder.Responder").funcIsOpened(funcId,callback)
end

------------------------主菜单按钮点击响应
function MainMenuWidget:setSelected(index,param)
    if(index == self._selectedIndex)then
        -- 发送更多收回事件
        uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_HOME_MORE_INIT, nil, false, nil)

        local currScene = display.getRunningScene()
        if currScene ~= nil and currScene.name == "TeamMainScene" then
            display.getRunningScene():gotoMainPage()
        end
        return
    end
    self:_checkOpen(index,function()
        if(index==1)then
            --主城
            G_ModuleDirector:popToRootAndReplaceModule(G_FunctionConst.FUNC_MAIN_CITY, function()
                return require("app.scenes.mainCity.MainCityScene").new()
            end)
            self:_setTabSelected(index)
        elseif(index==2)then
            --阵容
            G_ModuleDirector:popToRootAndReplaceModule(G_FunctionConst.FUNC_TEAM, function()
                return require("app.scenes.team.TeamMainScene").new()
            end)
            self:_setTabSelected(index)
        elseif(index==3)then
            --副本
            G_ModuleDirector:popToRootAndReplaceModule(G_FunctionConst.FUNC_MAIN_MISSION, function()
                return require("app.scenes.missionnew.MissionScene").new(nil,nil,param)
            end)
            -- G_ModuleDirector:pushModule(nil, function()
            --     return require("app.scenes.simulateBattle.SimulateBattleScene").new()
            -- end)
            self:_setTabSelected(index)
        -- elseif(index==4)then
        --     G_ModuleDirector:popToRootAndReplaceModule(G_FunctionConst.FUNC_ADVENTURE, function()
        --         return require("app.scenes.adventure.AdventureScene").new()
        --     end)
        --     self:_setTabSelected(index)
        -- elseif(index==5)then
        --     G_Popup.tip("开发中...")
            --包裹
            -- G_ModuleDirector:popToRootAndReplaceModule(G_FunctionConst.FUNC_DAILY_TASK, function()
            --     return require("app.scenes.dailyTask.DailyTaskScene").new()
            -- end)
            --self:_setTabSelected(index)

        elseif(index==4)then
            -- 讨伐 pve
            -- G_ModuleDirector:popToRootAndReplaceModule(G_FunctionConst.FUNC_CAMPAIGN, function()
            --     return require("app.scenes.campaign.CampaignScene").new()
            -- end)

            G_ModuleDirector:popToRootAndReplaceModule(G_FunctionConst.FUNC_PVE, function()
                self._clicked = false
                return require("app.scenes.adventure.PvEScene").new()
            end)

            self:_setTabSelected(index)
        elseif(index==5)then

            -- 征战 pvp
            G_ModuleDirector:popToRootAndReplaceModule(G_FunctionConst.FUNC_PVP, function()
                self._clicked = false
                return require("app.scenes.adventure.PvPScene").new()
            end)
            
            -- G_ModuleDirector:popToRootAndReplaceModule(G_FunctionConst.FUNC_ADVENTURE, function()
            --     return require("app.scenes.adventure.AdventureScene").new()
            -- end)
            self:_setTabSelected(index)

            -----------------------------战斗test
            -- G_ModuleDirector:pushModuleWithAni(nil, function()
            --     self._battleScene = require("app.scenes.missionnew.missionStage.MissionBattleScene").new()
            --     local decodeBuffer= {--后端的战斗数据
            --         next_wave_id = 0,
            --         battle = require("BattleReportTest"),--战报
            --         awards = nil,
            --         stage_star = 3,
            --         stage_money = 3,
            --         stage_exp = 3,
            --     }
            --     self._battleScene:playBattle(decodeBuffer,100101,false, true, true)
            --     return self._battleScene
            -- end)

            -----------------------------战斗test

        elseif(index==6)then
            --G_Popup.tip("开发中...")
            --集市
            G_ModuleDirector:popToRootAndReplaceModule(nil, function()
                return require("app.scenes.shop.ShopScene").new()
            end)
            self:_setTabSelected(index)
        end

        --uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false)

    end)
end

function MainMenuWidget:_validateSelected( sceneName )
    -- body
    local index = 0
    if(sceneName == "MainCityScene")then
        index = 1
    elseif(sceneName == "TeamMainScene")then
        index = 2
    elseif(sceneName == "MissionScene")then
        index = 3
    -- elseif(sceneName == "AdventureScene")then
    --     index = 4
    -- elseif(sceneName == "DailyTaskScene")then
    --     index = 5
    elseif(sceneName == "PvEScene")then
        index = 4
    elseif(sceneName == "PvPScene")then
        index = 5
    elseif(sceneName == "ShopScene")then
        index = 6
    else
        index = 0
    end

    self:_checkOpen(index,function()
        self:_setTabSelected(index)
    end)

end

--给按钮红点绑定检测条件
function MainMenuWidget:_setRedDotData( imgRed,idList )
    -- body
    self._redDotMap[imgRed] = idList
end

--刷新主菜单红点
function MainMenuWidget:_updateRedPoint( ... )
    --dump(debug.traceback("描述:", 2))
    if(self._redDotMap == nil)then return end
    for k,v in pairs(self._redDotMap) do
        local idList = v or {}
        k:setVisible(false)
        for i=1,#idList do
            local item = idList[i]
            local bool = false
            if type(item) == "table" then
                bool = RedPointHelper.isValueReach(item.functionId,item.params)
            else
                bool = RedPointHelper.isValueReach(item)
            end
            if(bool == true)then
                k:setVisible(true)
                break
            end
        end
    end
end

function MainMenuWidget:onEnter( ... )
    -- body
    self:setSuspend(false)
    self:performWithDelay(function()
        self._enableClick = true
        self:setTouchEnabled(self._enableClick)
    end, 0.2)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RED_POINT_UPDATE, self._updateRedPoint, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_GUIDE_START_STEP, self.weekGuide, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_GUIDE_END_STEP, self.weekGuide, self)
    self:_validateSelected(display.getRunningScene():getName())
    self:_updateRedPoint()
    
    self:weekGuide()
end

function MainMenuWidget:weekGuide()
    local chapterUnit1 = G_Me.allChapterData:getChapterDataById(1001)
    local chapterUnit2 = G_Me.allChapterData:getChapterDataById(1002)
    local chapterUnit3 = G_Me.allChapterData:getChapterDataById(1003)
    local scene = display.getRunningScene()

    local ChapterConfigConst = require("app.const.ChapterConfigConst")
    if  ((chapterUnit1:getChapterFlag() == ChapterConfigConst.STATE_OPEN_CLEAR and chapterUnit2:getChapterFlag() ~= ChapterConfigConst.STATE_OPEN_CLEAR ) or
        (chapterUnit2:getChapterFlag() == ChapterConfigConst.STATE_OPEN_CLEAR and chapterUnit3:getChapterFlag() ~= ChapterConfigConst.STATE_OPEN_CLEAR )) and
        (scene.__cname and scene.__cname == "MainCityScene") and 
        G_GuideManager:isGuideing() == false
         then
        local EffectNode = require "app.effect.EffectNode"
        if self._weekGuideEffectNode == nil then
            self._weekGuideEffectNode = EffectNode.new("effect_finger2")
            self._weekGuideEffectNode:setRotation(180)
            self._weekGuideEffectNode:setPosition(60, 40)
            self._csbNode:getSubNodeByName("Button_fuben"):addChild(self._weekGuideEffectNode)
            self._weekGuideEffectNode:play()
        end
    else
        if self._weekGuideEffectNode then
            self._weekGuideEffectNode:removeFromParent()
            self._weekGuideEffectNode = nil
        end
    end
end

function MainMenuWidget:setTouchEnabled(bool)
    for i=1,#self._btns do
        local btn = self._btns[i]
        btn:setTouchEnabled(bool)
    end
end

function MainMenuWidget:onExit( ... )
    -- body
    uf_eventManager:removeListenerWithTarget(self)
    self._enableClick = false
    self:setTouchEnabled(self._enableClick)
end

return MainMenuWidget