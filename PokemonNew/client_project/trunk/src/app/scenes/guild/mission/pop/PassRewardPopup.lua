--
-- Author: wyx
-- Date: 2018-04-29 11:40:09
--
--PassRewardPopup.lua
--[====================[

    帮派副本通关奖励预览面板
    
]====================]

local PassRewardPopup =  class("PassRewardPopup",function()
    return cc.Node:create()
end)

local UpdateNodeHelper = require("app.common.UpdateNodeHelper")

local TypeConverter = require("app.common.TypeConverter")
local TextHelper = require ("app.common.TextHelper")
local worldboss_rankaward_info = require("app.cfg.worldboss_rankaward_info")
local PassRewardCell = require("app.scenes.guild.mission.pop.PassRewardCell")

local LIST_NUM = 2  --列表个数

function PassRewardPopup:ctor()
    self:enableNodeEvents()

    self._csbNode = nil
    self._scrollList = nil
end

function PassRewardPopup:onEnter()
    self:_initUI()
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_GUILD_RECV_REWARD,self._updateList,self)

end

function PassRewardPopup:_initUI( ... )
    self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("PassRewardPopup","guild/mission/pop"))
    self:addChild(self._csbNode)
    self._csbNode:setContentSize(display.width,display.height)
    self:setPosition(display.cx,display.cy)
    ccui.Helper:doLayout(self._csbNode)

    UpdateNodeHelper.updateCommonNormalPop(self,G_Lang.get("worldboss_title_boss_reward"),nil,730)

    self._csbNode:updateButton("Button_sure",function ( ... )
        self:removeFromParent()
    end)

    self._chapters = G_Me.guildMissionData:getAllChapters(true)
    local curChapter = G_Me.guildMissionData:getCurChapter()

    local cellNum = #self._chapters
    -- 列表创建
    local panelCon = self._csbNode:getSubNodeByName("Panel_con")
    local size = panelCon:getContentSize()

    self._scrollList = require("app.ui.WListView").new(size.width,size.height,size.width,158)
    self._scrollList:setCreateCell(function(list,index)
        local cell = PassRewardCell.new()
        return cell
    end)

    self._scrollList:setUpdateCell(function(list,cell,index)
        cell:updateData(self._chapters[index+1])
    end)

    self._scrollList:setCellNums(cellNum, true)
    self._scrollList:setPositionX(3)
    panelCon:addChild(self._scrollList)

    self._csbNode:updateLabel("Text_progress_title", {
    	text = "当前进度：",
    	textColor = G_Colors.getColor(2),
    	})
    
    self._csbNode:updateLabel("Text_progress_chapter", {
    	text = G_Lang.get("mission_guild_pass_progress",{num = curChapter:getOrder()})..curChapter:getCfgInfo().name,
    	textColor = G_Colors.getColor(3),
    	})
end

--type:奖励类型1.章节奖励，2，关卡奖励
function PassRewardPopup:_updateList(type)
    if type == 2 then
        return
    end
    self._chapters = G_Me.guildMissionData:getAllChapters(true)
    self._scrollList:setCellNums(#self._chapters, false)
end


function PassRewardPopup:onExit()
    uf_eventManager:removeListenerWithTarget(self)
    if self._csbNode ~= nil then
        self._csbNode:removeFromParent(true)
        self._csbNode = nil
    end
end

return PassRewardPopup