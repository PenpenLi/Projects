
local CircleScroll = class("CircleScroll", function()
	return cc.Layer:create()
end)

-- local TurnNode = require("app.scenes.common.turnplate.TurnNode")

local CCSize = cc.size
local ccp = cc.p


--local self._angles = {55, 90, 125, 200, 270, 340}


function CircleScroll:ctor(size, angles, startIndex)
    self:onUpdate(handler(self,self._moveBackAnimation))
    self._angles = angles
    self._startIndex = startIndex
    self._showList = {}
    self:setContentSize(CCSize(size.width,size.height))
    
    self.isMove = false

    -- 圆心
    self.m_nCenter = ccp(size.width*0.5,size.height*0.5)
 
    -- 椭圆长轴
    self.m_longAxis = size.width*0.45
    
    -- 椭圆短轴
    --self.m_shortAxis = self.m_longAxis*0.85
    self.m_shortAxis = self.m_longAxis*1-- 控制圆形弧度

    --zorder起点
    self.m_ZStart = 0
    
    -- 最小Y轴
    self.YMin =  self.m_nCenter.y - self.m_shortAxis
    
    -- 最大Y轴
    self.YMax = self.m_nCenter.y + self.m_shortAxis
    
    self._knightsLayer = display.newNode()

    self:addChild(self._knightsLayer)

    
    self.m_nTouchBegin = ccp(0,0)
    self.m_nTouchMove = false 
    
    -- local touchNode = cc.LayerColor:create(cc.c4b(0xff,0xff,0xff,100))
    local touchNode = cc.Layer:create()
    touchNode:setContentSize(CCSize(size.width,size.height))
    self:addChild(touchNode)
    self._touchNode = touchNode
    self._touchRect = nil
    
    local listener=cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(false)
    listener:registerScriptHandler(handler(self,self._onTouchBegan),cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(handler(self,self._onTouchMoved),cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(handler(self,self._onTouchEnded),cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener,touchNode)
end

function CircleScroll:_onTouchBegan( touch,event )
    if(self._touchRect == nil)then
        local worldPos = self._touchNode:convertToWorldSpace(cc.p(0,0))
        local size = self._touchNode:getContentSize()
        self._touchRect = cc.rect(worldPos.x,worldPos.y,size.width,size.height)
    end

    

    if self.isMove  then
        return
    end
    -- self:_removeTimer()
    self.m_nTouchBegin = touch:getLocation()
    return cc.rectContainsPoint(self._touchRect,touch:getLocation())
end

function CircleScroll:_onTouchMoved(touch,event)
    if self.isMove  then
        return
    end    
    local pt = touch:getLocation()
    local deltaX = pt.x - self.m_nTouchBegin.x
    for k,v in pairs(self._showList) do
        local  startAngle, endAngle = self:_calcStartAndEndAngle(v.pos, deltaX > 0 and 1 or -1, 1)
        local percent = math.abs(deltaX/300)
        if percent > 1 then percent = 1 end  
        v.angle = startAngle + (endAngle - startAngle)*percent
    end
    self:_arrange()
    self:onTouchMove()
end


function CircleScroll:_onTouchEnded(touch,event)
    local pt = touch:getLocation()
    --self:judgeNeedMoveBack()
    local fDist = math.abs(pt.x - self.m_nTouchBegin.x)
    --print("fdist=" .. fDist)
    if fDist > 10 then 
        local step = 1
        local dir = (pt.x - self.m_nTouchBegin.x)/math.abs(pt.x - self.m_nTouchBegin.x)
        self:judgeNeedMoveBack(dir, step)
        return
    else
        --这个时候可能位置有点移动, 修正一下
        self:_refresh()
        self:onMoveStop("refresh")
    end
end

-- @desc 检查是否回滚回去
function CircleScroll:judgeNeedMoveBack(dir, step)
    --print("judgeNeedMoveBack " .. dir .. "," ..  step .. "," .. tostring(self.isMove)  )
    if self.isMove == true then
        return 
    end
    self.isMove = true
    -- 计算下一个位置的角速度

    for k,v in pairs(self._showList) do

        v.speed,v.pos,v.EndAngle = self:_calcAngleSpeed(v,v.pos,dir, step)
    end
    
    self:onUpdate(handler(self,self._moveBackAnimation))
end

function CircleScroll:addNode(node, pos)
    node.pos = pos
    node.angle = self:_calcStartAndEndAngle(pos, 1)
    node.EndAngle = node.angle

    self._knightsLayer:addChild(node)
    
    table.insert(self._showList,node)

    self:_arrange()
end

function CircleScroll:_refresh()
    for k,v in pairs(self._showList) do
        v.angle = self:_calcStartAndEndAngle(v.pos, 1)
    end
    self:_arrange()
end

function CircleScroll:getOrderList()
    local _list = self:_orderByY()
    return _list
end


--根据节点当前角度angle计算位置, 缩放, zorder
function CircleScroll:_arrange()
    --self:arrangeAngle()
    self:_arrangePosition()
    self:_arrangeScale()
    self:_arrangeZOrder()
end

-- @desc 设置位置
function CircleScroll:_arrangePosition()
    for k,v in pairs(self._showList) do
        local fAngle = math.fmod(v.angle, 360.0)
        local x = math.cos(fAngle/180.0*3.14159)*self.m_longAxis + self.m_nCenter.x
        local y = math.sin(fAngle/180.0*3.14159)*self.m_shortAxis*0.5 + self.m_nCenter.y
        v:setPosition(x, y)
    end
end

-- @desc 重新设置z轴
function CircleScroll:_arrangeZOrder()
    local ZMax = self.m_ZStart + #self._showList

    local _list = self:_orderByY()

    for k,v in pairs(_list) do
        v:setLocalZOrder(ZMax)
        ZMax = ZMax + 1
    end
end

function CircleScroll:_orderByY()
    local _list = {}
    for k,v in pairs(self._showList) do
        table.insert(_list,v)
    end
    table.sort(_list,function(p1,p2)
        return p1:getPositionY() > p2:getPositionY()
    end)
    return _list
end

function CircleScroll:_arrangeScale ()
     for k,v in pairs(self._showList) do
        local fy = v:getPositionY() 
        if fy < 0 then fy = 0 end
        --local fScale = fy /(self.m_shortAxis*2)
        local fScale = fy /(self.m_shortAxis*1.5) -- 控制前后大小差
        --v:setScale(1- 1*fScale)
        v:setScale(1- 0.8*fScale) -- 控制整体大小
    end
end

--当自动滑动的过程中,根据速度修改卡牌的角度, 当卡牌到达目标角度时,返回,停止
function CircleScroll:_moveShow()
    local finished = true
    for k,v in pairs(self._showList) do  
        if v.speed ~= 0 then
            --print( k .. " " .. math.abs(v.angle - v.EndAngle) .. " ---" .. math.abs(v.speed))

            -- if math.abs(v.angle - v.EndAngle) <= math.abs(v.speed)
            if math.abs(v.angle - v.EndAngle) <= 0.5
              or  (v.speed <0 and v.angle <= v.EndAngle ) 
              or (v.speed >0 and v.angle >= v.EndAngle ) then 
                v.angle = v.EndAngle
                v.speed = 0
            else
                -- v.angle = v.angle+v.speed
                v.angle = v.angle + (v.EndAngle - v.angle)/4
                finished = false
            end
        end
    end
    return finished
end

-- @desc 计算角速度
--自动滑动的时候, 需要知道现在要往哪个方向(dir)滑动多少格(step), 然后计算出一个速度, 然后在movieShow里修改angle
function CircleScroll:_calcAngleSpeed(sprite,pos,dir, step)
    if step == nil then
        step = 1  --滑多少格
    end
    local temp = pos + dir*step
    local len = #self._angles
    if temp > len then 
        temp = temp - len 
    end
    
    if temp  < 1 then 
        temp = temp + len 
    end
    local _startAngle,_endAngle = self:_calcStartAndEndAngle(pos,dir, step)
    --sprite.angle = _startAngle
    local subValue = _endAngle - sprite.angle
    return subValue/3,temp,_endAngle
end

-- @desc 计算下一个位置的角度
-- @return param1 开始角度 @param2终点角度
function CircleScroll:_calcStartAndEndAngle(index,dir,step)
    if step == nil then
        step = 1
    end


    local startIndex = self._startIndex + index 
    if startIndex > #self._angles then
        startIndex = startIndex - #self._angles
    end


    local endIndex = startIndex + dir*step 
    if endIndex > #self._angles then
        endIndex = endIndex -  #self._angles
    end
    if endIndex < 1 then
        endIndex = endIndex +  #self._angles
    end


    local startAngle = self._angles[startIndex]
    local endAngle  = self._angles[endIndex]
    
    if dir == 1 then
        if startAngle > endAngle then
            if startAngle - 360 < 0 then
                endAngle = endAngle + 360
            else
                startAngle = startAngle - 360
            end
        end
    else
        if startAngle < endAngle then
            if endAngle - 360 < 0 then
                startAngle = startAngle + 360
            else
                endAngle = endAngle - 360
            end
        end
    end
    return startAngle, endAngle
end


function CircleScroll:_removeTimer()
    self:unscheduleUpdate()
end

function CircleScroll:onMoveStop(reason)
    
end

function CircleScroll:onTouchMove( ... )
    -- body
end

function CircleScroll:_moveBackAnimation()
    if self:_moveShow() then
        self:_removeTimer()
        self.isMove = false
        self:onMoveStop("back")
    end
    self:_arrange()
end

function CircleScroll:onEnter( ... )
    -- body
end

function CircleScroll:onExit( ... )
    -- body
end

return CircleScroll
