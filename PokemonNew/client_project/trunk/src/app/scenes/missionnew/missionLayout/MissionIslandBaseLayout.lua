--================================
--章节岛屿展示对象
--基类 主要了了显示的逻辑部分 数据部分再子类中实现
--================================

local MissionIslandBaseScroller = require("app.scenes.missionnew.missionLayout.MissionIslandBaseScroller")
local AutioConst = require "app.const.AudioConst"

local MissionIslandBaseLayout = class("MissionIslandBaseLayout", function ()
    local layout = ccui.Layout:create()
    layout:setAnchorPoint(0.5, 0)
    layout:setContentSize(640, MissionIslandBaseScroller.GAP) --设置默认的宽度
    return layout
end)

local MissionIslandMapNode = require("app.scenes.missionnew.missionLayout.MissionIslandMapNode")
local scheduler = require("framework.scheduler")

MissionIslandBaseLayout.UNLCOKOPACITY = 138-- un lock opacity
MissionIslandBaseLayout.UIOFFSET = -60 ---总体偏移
MissionIslandBaseLayout.TOUCHDIST = 15---多大距离内算点击

MissionIslandBaseLayout.TYPE_NORMAL = "TYPE_NORMAL"
MissionIslandBaseLayout.TYPE_GUILD = "TYPE_GUILD"

function MissionIslandBaseLayout:ctor(showType)
  self._type = showType or MissionIslandBaseLayout.TYPE_NORMAL
   self._angle = 0
   self._holder = nil
   self._size = nil
   self._xyscale = 0
   self._xpos = 0
   self._ypos = 0
   self._rate = 0
   self._moveData = nil
   self._locked = false
   self._dataIndex = 0
   self._islandImg = nil
   self._lockIcon = nil
   self._actTag = 0
   self._isMoveOver = false
   self._cacheX = 0
   self._cacheY = 0
   
   self:setTouchEnabled(true)
   self:enableNodeEvents()
   self:setTouchSwallowEnabled(false)
   self._size = self:getContentSize() 
   self._holder = ccui.Layout:create()
   self._holder:setName("holder")
   self._holder:enableNodeEvents()
   self._holder:setCascadeColorEnabled(true)
   self._holder:setCascadeOpacityEnabled(true)
   self._holder:setTouchSwallowEnabled(false)
   self._holder:setPosition(self._size.width * 0.5, self._size.height * 0.5)
   self:addChild(self._holder)

   self:addTouchEventListenerEx(function (sender, eventType)
      if eventType == ccui.TouchEventType.began then
          --self:_doScaleAction(1.1)
      elseif eventType == ccui.TouchEventType.ended then
          local moveOffset=math.abs(sender:getTouchEndPosition().y-sender:getTouchBeganPosition().y)
          if moveOffset<=MissionIslandBaseLayout.TOUCHDIST then
              self:_onSelect()
              G_AudioManager:playSoundById(AutioConst.SOUND_BUTTON)
          end
          --self:_doScaleAction(1)
      elseif eventType == ccui.TouchEventType.canceled then
          --self:_doScaleAction(1)
      end
   end,false)
end

function MissionIslandBaseLayout:onEnter()
    
end

function MissionIslandBaseLayout:onExit()
    -- self._holder:removeFromParent()
    self:removeAllChildren()
    self._onSelectCall = nil
end

---设置岛的数据
function MissionIslandBaseLayout:setData(data, dataIndex)
    self._data = data
    self._actTag = dataIndex
    self._dataIndex = dataIndex
    self:_setDisplay(dataIndex)
end

---设置初始化数据
function MissionIslandBaseLayout:setStart(moveData)
    assert(type(moveData) == "table", "invalide moveData " .. tostring(moveData))
    self._xpos=moveData.x
    self._ypos=moveData.y
    self._xyscale=moveData.scale
    self:setPosition(self._xpos,self._ypos)
    self:setScale(self._xyscale)
end

--设置点击回调
function MissionIslandBaseLayout:setOnSelectCall(onSelectCall)
     self._onSelectCall = onSelectCall
end

---设置移动速率
function MissionIslandBaseLayout:setRate(rate)
    self._rate = rate
end

function MissionIslandBaseLayout:getIsland()
    
end


---设置岛的显示
function MissionIslandBaseLayout:_setDisplay(index)
    --local islandCfg = require("app.scenes.missionnew.islandcfg." .. islandName)
    self._showIndex = index
    self:render()

    --self:setContentSize(self._islandImg:getContentSize())
end

---选择之后调用
function MissionIslandBaseLayout:_onSelect()
    if self._onSelectCall ~= nil then
      print("on island selected ", self._dataIndex)
      self._onSelectCall(self._dataIndex)
    end
end

function MissionIslandBaseLayout:show(value)
  -- print("valuevaluevaluevalue",self._dataIndex,value)
  -- if self._isShow == value then
  --    return
  -- end
  self._isShow = value
  if value then
    self:render()
  else
    self:clearRender()
  end
    
end

----点击之后缩放
function MissionIslandBaseLayout:_doScaleAction(scale)
    local action=cc.ScaleTo:create(0.2,scale)
    local ease=cc.EaseSineOut:create(action)
    self._holder:runAction(ease)
end

---指定移动数据
function MissionIslandBaseLayout:setMoveData(moveData)
    self._moveData = moveData
    self._isMoveOver = false
end

function MissionIslandBaseLayout:isMoveOver()
    return self._isMoveOver
end

---是否锁定
function MissionIslandBaseLayout:isLocked()
    return self._locked
end


return MissionIslandBaseLayout