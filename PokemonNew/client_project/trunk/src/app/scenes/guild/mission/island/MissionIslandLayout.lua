--
-- Author: wyx
-- Date: 2018-04-24 11:45:58
--
local MissionIslandBaseLayout = require "app.scenes.missionnew.missionLayout.MissionIslandBaseLayout"
local MissionIslandLayout = class("MissionIslandLayout", MissionIslandBaseLayout)

local EffectNode = require("app.effect.EffectNode")
local GuildMissionConst = require("app.scenes.guild.mission.GuildMissionConst")
local ParameterInfo = require "app.cfg.parameter_info"

MissionIslandLayout.UNLCOKOPACITY = 138
MissionIslandLayout.UIOFFSET = -60 ---总体偏移
MissionIslandLayout.TOUCHDIST = 15---多大距离内算点击
---==================
---章节岛屿
---==================
function MissionIslandLayout:ctor()
    MissionIslandLayout.super.ctor(self,MissionIslandBaseLayout.TYPE_GUILD)

    self._data = nil
    self._chapterNumImage = nil
    self._titleBg = nil
    self._hasRendered = false
    self._showRedPoint = false
   self._effectNode = nil
end

function MissionIslandLayout:onEnter()
    MissionIslandLayout.super.onEnter(self)

    self:_updateRedPoint()
    -- uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAPTER_ISLAND_SHOW_RED_POINT, self._updateRedPoint, self)
    -- uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHAPTER_HIDE_ISLAND_EFFECT, self._hideIslandEffect, self)

    self:render()
end

function MissionIslandLayout:onExit()
    MissionIslandLayout.super.onExit(self)
    uf_eventManager:removeListenerWithTarget(self)
end

---设置岛的数据
function MissionIslandLayout:setData(data, dataIndex)
    MissionIslandLayout.super.setData(self, data, dataIndex)

    self:render()
end

function MissionIslandLayout:clearRender()
  if self._hasRendered == true then
    self._holder:removeAllChildren()
    self._hasRendered = false
    self._river = nil
  end
  -- print("--------------------------------------",self._showIndex)
end

--刷新
function MissionIslandLayout:render()
  if self._isShow ~= true or self._hasRendered == true then
    return false
  end

  self:clearRender()
  local island = self:getIsland()
  self._islandImg = island.new(self._showIndex)
  self._holder:addChild(self._islandImg)

  self._infoHolder = self._islandImg:getInfoHolder()


  if self._data == nil then
    return false
  end

  self._hasRendered = true
    
  local island = self:getIsland()
  self._islandImg = island.new(self._showIndex)
  self._holder:addChild(self._islandImg)

  self._infoHolder = self._islandImg:getInfoHolder()

	local flag = self._data:getChapterFlag()
  --  -1:上一关卡未通关,0:上一关卡已通关等级未到，1：开启，2：通关 
    -- GuildMissionConst.STATE_NOT_OPEN_PRE_NOT_OVER  = -1
	-- GuildMissionConst.STATE_NOT_OPEN_PRE_GUILD_LV_NOT_ENOUGH = 0
	-- GuildMissionConst.STATE_OPEN_ACTIVE = 1
	-- GuildMissionConst.STATE_OPEN_FINISH = 2
  if flag == GuildMissionConst.STATE_NOT_OPEN_PRE_NOT_OVER or 
    flag == GuildMissionConst.STATE_NOT_OPEN_PRE_GUILD_LV_NOT_ENOUGH then
    self:_set2CloseState(flag)
  elseif flag == GuildMissionConst.STATE_OPEN_ACTIVE then
    self:_set2OpenState()
    self:_set2ActiveState()
    
  elseif flag == GuildMissionConst.STATE_OPEN_FINISH then
    self:_set2OpenState()
  end

  --通关
  local cfg = self._data:getCfgInfo()
  self._islandImg:hasOver(flag == GuildMissionConst.STATE_OPEN_FINISH)
  self._islandImg:showTip(flag == GuildMissionConst.STATE_OPEN_ACTIVE)
  self._islandImg:setCity(cfg.island)
  self:_renderRedPoint()
  
  if self._river == nil then
    local conSize = self:getContentSize()

    local river = nil
    if self._type == MissionIslandBaseLayout.TYPE_GUILD then
      --特效编号调整
      local mapIndex = (self._showIndex - 1)%3 + 1
      if mapIndex == 1 then
        mapIndex = 1
      elseif mapIndex == 2 then
        mapIndex = 3
        self._islandImg._city:setPositionX(396 - 25)
        self._islandImg._infoHolder:setPositionX(416 - 25)
      elseif mapIndex == 3 then
        mapIndex = 2
      end
      river = EffectNode.createEffect( "effect_lava_map"..mapIndex,cc.p(conSize.width/2,conSize.height-189))
    else
      --特效编号调整
      local mapIndex = (self._showIndex - 1)%3 + 1
      if mapIndex == 1 then
        mapIndex = 2
      elseif mapIndex == 2 then
        mapIndex = 1
      elseif mapIndex == 3 then
        mapIndex = 3
      end
      river = EffectNode.createEffect( "effect_river_map"..mapIndex,cc.p(conSize.width/2,conSize.height-60))
    end

    river:retain()
    local SchedulerHelper = require "app.common.SchedulerHelper"
    SchedulerHelper.newScheduleOnce(function()
      if self._islandImg.nodeTop and tolua.isnull(self._islandImg.nodeTop) ~= true  then
        self._islandImg.nodeTop:addChild(river)
      end
      river:setLocalZOrder(-99)
      river:release()
    end, 0)

    self._river = river
  end

  return true
end

function MissionIslandLayout:getIsland()
    return require("app.scenes.guild.mission.island.MissionIslandMapNode")
end

----设置岛为开放的
function MissionIslandLayout:_set2OpenState()
    -- 添加背景
    self._titleBg =  display.newSprite(G_Url:getUI_textBg("img_text_bg_mission"))
    self._titleBg:addTo(self._infoHolder):setPosition(0,5 + MissionIslandLayout.UIOFFSET)

     --添加第几回
    self._chapterNumImage = require("app.scenes.missionnew.common.MissionIndexWordLayout").new(self._data:getOrder())
    self._chapterNumImage:addTo(self._infoHolder):setPosition(0, 30 + MissionIslandLayout.UIOFFSET)
    
    --添加章节标题
    print2("==",G_Url:getText_system(self._data:getCfgInfo().title))
    self._chapterTileImage =  display.newSprite(G_Url:getText_system(self._data:getCfgInfo().title))
    self._chapterTileImage:addTo(self._infoHolder):setPosition(0,10 + MissionIslandLayout.UIOFFSET)

    self:_addLoadingBar()

end

function MissionIslandLayout:_addLoadingBar()
    self._barNode = cc.CSLoader:createNode("csb/guild/mission/common/Loadbar1.csb")
    self._barNode:addTo(self._infoHolder)
    			 :setPosition(0,MissionIslandLayout.UIOFFSET - 30)
    self:updateProcess()
end

function MissionIslandLayout:updateProcess()
    self._barNode:setVisible(self._data:getHpPercent() > 0)
    local percent,str = self._data:getHpPercent()
    local hpBar = self._barNode:getSubNodeByName("LoadingBar_pro")
    hpBar:setPercent(percent)
    local tetBar = self._barNode:getSubNodeByName("Text_percent")
    tetBar:setString(str)
end

---设置为关闭状态
---并且根据相应的关闭原因来显示提示
function MissionIslandLayout:_set2CloseState(flag)
    self._locked = true
    self._lockIcon = display.newSprite(G_Url:getUI_common("img_com_lock04")) 
    self._lockIcon:addTo(self._holder):setScale(1.4)
    self._lockIcon:setPosition(0, 0)
    self._holder:setOpacity(MissionIslandLayout.UNLCOKOPACITY)
    local chapterTable = require("app.cfg.story_chapter_info")
    local openTips = ""
    if flag == GuildMissionConst.STATE_NOT_OPEN_PRE_NOT_OVER then
       local preChapterData =  G_Me.guildMissionData:getPreChapterDataById(self._data:getId())
       if preChapterData == nil then
          openTips = ""
       else
          openTips = G_Lang.get("mission_need_finish", {pre = preChapterData:getCfgInfo().name}) 
       end
    elseif flag == GuildMissionConst.STATE_NOT_OPEN_PRE_GUILD_LV_NOT_ENOUGH then
       openTips = G_Lang.get("mission_guild_level_lack", {level = self._data:getCfgInfo().need_level})
    end

    local opentxt = display.newTTFLabel({size=34,font=G_Path.getNormalFont()})
    opentxt:setColor(cc.c3b(0xee, 0xe1, 0xcf))
    opentxt:enableOutline(cc.c4f(0x55,0x39,0x23,0xff),2)
    self._holder:addChild(opentxt)
    opentxt:setString(openTips)
    opentxt:setPosition(0, -60)
end

--设置为真正攻打
function MissionIslandLayout:_set2ActiveState()
    self._effectNode=require("app.effect.EffectNode").new("effect_knife"):addTo(self._infoHolder):setPosition(0, 40 + MissionIslandLayout.UIOFFSET)
    self._effectNode:play()
    uf_eventManager:removeListenerWithTarget(self)

    self._effectNode:setVisible(G_Me.redPointData:isShopShowRed(38))
end

---添加显示的星星
function MissionIslandLayout:_addStars()
    -- local currentNum = self._data:getCurrentStar()
    -- local totalNum = G_Me.allChapterData:getChpaterAllStar(self._data:getId())
    -- local label=display.newTTFLabel({size=17,font=G_Path.getNormalFont(),text= currentNum .. "/" .. totalNum}):addTo(self._infoHolder):align(display.CENTER,-16,-36 + MissionIslandLayout.UIOFFSET)
    -- local starImg = display.newSprite(G_Url:getUI_other("star"))
    -- label:setColor(G_Colors.getColor(9))
    -- label:enableOutline(G_Colors.getOutlineColor(9),2)
    -- starImg:addTo(self._infoHolder):setPosition(26, -35 + MissionIslandLayout.UIOFFSET)
    -- --starImg:setScale(0.4)

    -- if currentNum == totalNum then
    --   local perfectNode = cc.CSLoader:createNode(G_Url:getCSB("MissionPerfectNode", "missionnew"))
    --   self._infoHolder:addChild(perfectNode)
    --   perfectNode:setPosition(-132, 10 + MissionIslandLayout.UIOFFSET)
    -- end
end

function MissionIslandLayout:_updateRedPoint()
    if self._data and self._data:hasStageAwardRedPoint() then
        self._showRedPoint = true
        self:_renderRedPoint()
    end

    --self._effectNode:setVisible(G_Me.redPointData:isShopShowRed(38))
end

function MissionIslandLayout:_renderRedPoint()
  if self._islandImg == nil then
    return
  end
  if self._showRedPoint == true then
    self._islandImg:showRedPoint()
  else
    self._islandImg:hideRedPoint()
  end
end

function MissionIslandLayout:_hideIslandEffect()
   if self._effectNode ~= nil then
      self._effectNode:setVisible(false)
   end
   self:hideRedPoint()
end

function MissionIslandLayout:hideRedPoint()
    self._showRedPoint = false
    self:_renderRedPoint()
end

return MissionIslandLayout
