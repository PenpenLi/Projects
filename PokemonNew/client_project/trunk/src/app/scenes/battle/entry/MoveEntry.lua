-- MoveEntry

local sin = math.sin
local cos = math.cos
local deg = math.deg
local rad = math.rad
local abs = math.abs

local ActionFactory = require "app.common.action.Action"
local ActionEaseFactory = require "app.common.action.ActionEase"
local LocationFactory = require "app.scenes.battle.Location"


local MoveEntry = class("MoveEntry", require "app.scenes.battle.entry.Entry")

function MoveEntry:ctor(position, object, battleField, duration)
    
    self._duration = duration

    local rootNode = display.newNode()
    battleField:addToNormalSpNode(rootNode)

    self._rootNode = rootNode
    rootNode:retain()

    MoveEntry.super.ctor(self, position, object, battleField)

end

function MoveEntry:initEntry()

    MoveEntry.super.initEntry(self)

    self:addEntryToQueue(nil, self:updateMove())
    
end

function MoveEntry:updateMove()
    
    local action = nil
    local actionBody = nil
    local actionShadow = nil

    local target = self._objects

    local durationUp = 1
    local durationDown = 1
    -- duration
    local duration = (self._duration and self._duration >= (durationUp + durationDown)) and self._duration or 3
    
    return function(_, frameIndex)
        
        -- 创建action
        if not action then
            
            -- 绘制线，用来描述贝塞尔曲线的两个控制点
            local target = self._objects
            local oriPosition = cc.p(target:getPosition())
            local dstPosition = cc.pAdd(oriPosition, self._data)

            -- 两点之间的距离
            local distance = cc.pGetDistance(dstPosition, oriPosition)
            -- 两点连线的角度
            local angle = deg(cc.pToAngleSelf(cc.pSub(dstPosition, oriPosition))) * -1

            -- 贝塞尔曲线的参数为ccBezierConfig
            -- 其参数为两个控制点和一个终止位置，其初始位置为target的当前位置

            local bezierConfig = {}
            
            -- 这里贝塞尔曲线看成一个三角形，angle4XXX分别是其两个角的度数
            local absAngle = abs(angle)
            local angle4Start = absAngle > 90 and absAngle - 90 or 90 - absAngle
            local angle4End = (absAngle < 90 and 180 - absAngle or absAngle) * 0.05

            -- 根据不同站位，角度方向略有不同
            local direction = 1
            if oriPosition.x < dstPosition.x and oriPosition.y < dstPosition.y then
                direction = -1
            elseif oriPosition.x > dstPosition.x and oriPosition.y > dstPosition.y then
                direction = -1
            end

            angle4Start, angle4End = angle4Start * direction, angle4End * direction

            local distance1 = distance / cos(rad(angle4Start))
            local angle1 = angle + angle4Start
            distance1 = cc.pAdd(oriPosition, cc.pMul(cc.pForAngle(rad(angle1 * -1)), distance1))

            local distance2 = distance / cos(rad(angle4End))
            local angle2 = angle + (180 - angle4End)
            distance2 = cc.pAdd(dstPosition, cc.pMul(cc.pForAngle(rad(angle2 * -1)), distance2))

            bezierConfig[1] = cc.pSub(cc.pGetIntersectPoint(oriPosition, distance1, distance2, dstPosition), oriPosition)
            bezierConfig[2] = bezierConfig[1]
            bezierConfig[3] = self._data

            -- debug
            -------------------------------------------------------------------
            -- local controlLine1 = cc.LayerColor:create(cc.c4b(255, 0, 0, 130), cc.pGetLength(bezierConfig[1]), 5)
            -- self._rootNode:addChild(controlLine1)
            -- controlLine1:setIgnoreAnchorPointForPosition(false)
            -- controlLine1:setAnchorPoint(cc.p(0, 0.5))
            -- controlLine1:setRotation(angle1)
            -- controlLine1:setPosition(oriPosition)

            -- local controlLine2 = cc.LayerColor:create(cc.c4b(0, 255, 0, 130), cc.pGetDistance(cc.pAdd(oriPosition, bezierConfig[2]), dstPosition), 5)
            -- self._rootNode:addChild(controlLine2)
            -- controlLine2:setIgnoreAnchorPointForPosition(false)
            -- controlLine2:setAnchorPoint(cc.p(0, 0.5))
            -- controlLine2:setRotation(angle2)
            -- controlLine2:setPosition(dstPosition)
            ----------------------------------------------------------------------

            action = ActionEaseFactory.newEaseSineOut(
                ActionFactory.newSpawn{
                    ActionFactory.newBezierBy(duration, bezierConfig),
                    ActionFactory.newScaleTo(duration, LocationFactory.getScaleByPosition{dstPosition.x, dstPosition.y}),
                }
            )
            
            -- 开启action
            action:startWithTarget(target)
            action:retain()
            
            -- 接下来是body和shadow的动画
            actionBody = ActionEaseFactory.newEaseSineOut(
                ActionFactory.newSequence{
                    ActionFactory.newSpawn{
                        ActionFactory.newScaleTo(durationUp, 1.1),
                        ActionFactory.newMoveBy(durationUp, cc.p(0, 180)),
                    },
                    ActionFactory.newDelayTime(duration - durationUp - durationDown),
                    ActionFactory.newSpawn{
                        ActionFactory.newScaleTo(durationDown, 1),
                        ActionFactory.newMoveBy(durationDown, cc.p(0, -180))
                    }
                }
            )

            actionBody:startWithTarget(target:getCardBody())
            actionBody:retain()

            actionShadow = ActionEaseFactory.newEaseSineOut(
                    ActionFactory.newSequence{
                    ActionFactory.newSpawn{
                        ActionFactory.newScaleTo(durationUp, 0.8),
                        ActionFactory.newFadeTo(durationUp, 0.6 * 255)
                    },
                    ActionFactory.newDelayTime(duration - durationUp - durationDown),
                    ActionFactory.newSpawn{
                        ActionFactory.newScaleTo(durationDown, 1),
                        ActionFactory.newFadeTo(durationDown, 255)
                    },
                }
            )

            actionShadow:startWithTarget(target:getCardShadow())
            actionShadow:retain()

        end
        
        -- step这个方法主要是计算从开始action累加的时间占总时间的百分比，然后调用update方法，将百分比传入
        -- 所以只需把需要计算的时间分量（帧数）传入即可
        action:step(1)
        actionBody:step(1)
        actionShadow:step(1)
        -- 重新计算order
        target:setLocalZOrder(target:getPositionY() * -1)
        
        -- print("action curFrame: "..action._curFrame.." totalFrame: "..action._totalFrame)
        -- print("actionBody curFrame: "..actionBody._curFrame.." totalFrame: "..actionBody._totalFrame)
        -- print("actionShadow curFrame: "..actionShadow._curFrame.." totalFrame: "..actionShadow._totalFrame)

        if action:isDone() then
            action:release()
            actionBody:release()
            actionShadow:release()
            return true
        end
        
        return false
    end
    
end

function MoveEntry:destroyEntry()

    MoveEntry.super.destroyEntry(self)

    if self._rootNode then
        if self._rootNode:getParent() then
            self._rootNode:removeFromParent()
        end
        self._rootNode:release()
        self._rootNode = nil
    end

end

return MoveEntry
