
-- SpEntry.lua

--[=========================[

    sp特效播放类

    主要是针对战斗中使用的sp_xxx.json格式的数据文件进行解析并播放

]=========================]

local SpEntry = class("SpEntry", require("app.scenes.battle.entry.Entry"))
local spriteFrameCache = cc.SpriteFrameCache:getInstance()

SpEntry.SCALE = 1.14--特效固定缩放

function SpEntry:ctor(spJson, objects, battleField, hasColor, ...)

    -- 创建这个sp时是否附带颜色变化，主要是考虑到sp之间的嵌套关系
    self._hasColor = hasColor
    -- 资源缓存列表
    self._spriteFrames = {}
    -- 用来保存sp的数组
    self._spArr = {}
    -- 用来保存spStep数据用数组
    self._spStepArr = {}

    -- 读取配置
    local spId = spJson.spId
    local spFilePath = "battle/sp/"..spId.."/"..spId
    self._spFilePath = spFilePath
    
    local spJsonName = spFilePath..".json"
    self._spJsonName = spJsonName

    local configCache = battleField:getConfigCache()
    local configContent, isNewCreate = configCache:getSpConfig(spJsonName)

    self._spJsonContent = configContent

    -- 加载资源，考虑到异步资源已经加载了，所以这里应该只是去走一圈而已
    if self._spJsonContent.png and self._spJsonContent.png ~= "" then
        display.loadSpriteFrames(spFilePath..".plist", spFilePath..".png")
    end   

    -- 是否是永久播放
    local events = self._spJsonContent.events
    if events then
        for k, v in pairs(events) do
            self.isForever = v == "forever"
            if self.isForever then break end
        end
    end

    -- 这里是sp特效的根节点
    self._node = display.newNode()
    self._node:setCascadeOpacityEnabled(true)
    self._node:setCascadeColorEnabled(true)
    self._node:retain() 
    
    -- 默认的colorOffset
    self._colorOffset = cc.c4f(0, 0, 0, 0)

    SpEntry.super.ctor(self, spJson, objects, battleField, ...)

    self:initWithSpJson(spJson)

end

function SpEntry:changeSp( spJson )
    -- 读取配置
    local spId = spJson.spId
    local spFilePath = "battle/sp/"..spId.."/"..spId
    self._spFilePath = spFilePath
    
    local spJsonName = spFilePath..".json"
    self._spJsonName = spJsonName

    local configCache = self._battleField:getConfigCache()
    local configContent, isNewCreate = configCache:getSpConfig(spJsonName)

    self._spJsonContent = configContent

    -- 加载资源，考虑到异步资源已经加载了，所以这里应该只是去走一圈而已
    if self._spJsonContent.png and self._spJsonContent.png ~= "" then
        display.loadSpriteFrames(spFilePath..".plist", spFilePath..".png")
    end   

    -- 是否是永久播放
    local events = self._spJsonContent.events
    if events then
        for k, v in pairs(events) do
            self.isForever = v == "forever"
            if self.isForever then break end
        end
    end
    self:initEntry()
    self:update(1)--yutou  initEntry会清除元素出现空白  这里要立刻刷新一帧
end

function SpEntry:initEntry()
    
    SpEntry.super.initEntry(self)
    
    --销毁之前的
    if self._spArr then
        for k, sp in pairs(self._spArr) do
            if sp.isEntry then
                if sp:getObject():getParent() then
                    sp:getObject():removeFromParent()
                end
            elseif sp.clipNode and sp.clipNode:getParent() then
                sp.clipNode:removeFromParent()
            elseif sp:getParent() then
                sp:removeFromParent()
            end
        end
    end

    -- 清理sp的step函数
    self._spStepArr = {}

    -- 这里添加需要增加的序列
    self:addEntryToQueue(self, self.update)
    
end

function SpEntry:getObject() return self._node end
function SpEntry:getData() return self._spJsonContent end

function SpEntry:update(frameIndex)

    --相当于 fx = "f" .. frameIndex
    local fx = string.gsub("f0", "%d", frameIndex)
    local spJson = self._spJsonContent
    
    local event = spJson.events[fx]

    -- 优先找遮罩层
    local maskKeys = {}
    for k, v in pairs(spJson) do
        if type(v) == "table" and v.mask_info then
            maskKeys[k] = true
            self._spStepArr[k] = self._spStepArr[k] or self:_spStep(k, v)
            self._spStepArr[k](frameIndex, event)
        end
    end
    
    for k, v in pairs(spJson) do
        if type(v) == "table" and k ~= "events" and not maskKeys[k] then
            self._spStepArr[k] = self._spStepArr[k] or self:_spStep(k, v)
            self._spStepArr[k](frameIndex, event)
        end
    end

    if event == "finish" then
        for k, sp in pairs(self._spArr) do
            if sp.isEntry then
                sp:stop()
            end
        end
    end
    
    return event == "finish", event

end

function SpEntry:_spStep(key, spNode)
           
    -- 这里的sp表示实际显示的节点
    local sp = nil

    local stepFunc = nil
    local frameCounts = 0
    local isTweenAni = false

    return function(frameIndex, event)

        local fx = string.gsub("f0", "%d", frameIndex)

        if spNode[fx] then

            stepFunc = nil
            frameCounts = 0

            -- 移除sp            
            if spNode[fx].remove then
                if sp then
                    if sp.isEntry then
                        sp:stop()
                        sp:getObject():removeFromParent()
                    else
                        if sp.clipNode then
                            sp.clipNode:removeFromParent()
                        else
                            sp:removeFromParent()
                        end
                    end
                    sp = nil
                end
                return
            end
            
            -- 创建sp
            if not sp then
                sp = self:createDisplayNodeWithSpNode(key, spNode, frameIndex, self._spArr[key])
                assert(sp, "Sp could not be nil with key: "..key)
                
                if not self._spArr[key] then
                    if sp.isEntry then
                        sp:retainEntry()
                    elseif sp.clipNode then
                        sp.clipNode:retain()
                    else
                        sp:retain()
                    end
                else
                    if sp.isEntry then
                        sp:initEntry()
                    end
                end
                
                self._spArr[key] = sp
            end

            local curKeyFrame = spNode[fx]
            local nextKeyFrame = spNode[curKeyFrame.nextFrame] or curKeyFrame

            isTweenAni = checkbool(curKeyFrame.nextFrame)

            -- 带remove的可能也是下一个补间，这个时候要过滤掉
            if not nextKeyFrame.remove then

                stepFunc = self:_getStepFunc(sp, curKeyFrame, nextKeyFrame)

                if self._battleField:isLastFrame() or event == "forever" or event == "finish" then
                    
                    stepFunc(frameCounts)
                    -- 非补间动画则执行完就移除递进函数了
                    if not isTweenAni then
                        stepFunc = nil
                        frameCounts = 0
                    end
                end
            end

        elseif stepFunc then

            frameCounts = frameCounts + 1

            if self._battleField:isLastFrame() or event == "forever" or event == "finish" then
                -- 执行递进函数
                stepFunc(frameCounts)
                -- 没有补间，所以执行完之后就可以去掉递进函数了
                if not isTweenAni then
                    stepFunc = nil
                    frameCounts = 0
                end
            end
        end

    end

end

-- 获取一个运算的递进函数
function SpEntry:_getStepFunc(sp, curKeyFrame, nextKeyFrame)

    local start = curKeyFrame.start
    local nextStart = nextKeyFrame.start
    local duration = curKeyFrame.frames and curKeyFrame.frames - 1 or 1

    return function(frameCounts)

        local percent = frameCounts / duration

        -- 位移
        sp:setPosition(
            start.x + (nextStart.x - start.x) * percent,
            start.y + (nextStart.y - start.y) * percent
        )
        -- 旋转
        sp:setRotation(start.rotation + (nextStart.rotation - start.rotation) * percent)
        -- 缩放
        sp:setScale(
            (start.scaleX + (nextStart.scaleX - start.scaleX) * percent) * sp.autoScale,
            (start.scaleY + (nextStart.scaleY - start.scaleY) * percent) * sp.autoScale
        )
        -- 透明度
        if nextStart.opacity then
            sp:setOpacity(start.opacity + (nextStart.opacity - start.opacity) * percent)
        end
        -- 颜色（flash中的高级颜色）
        if nextStart.color and start.color then
            -- 原色
            sp:setColor(cc.c3b(
                (start.color.red_original + (nextStart.color.red_original - start.color.red_original) * percent) * 255,
                (start.color.green_original + (nextStart.color.green_original - start.color.green_original) * percent) * 255,
                (start.color.blue_original + (nextStart.color.blue_original - start.color.blue_original) * percent) * 255
            ))
            -- 透明色
            sp:setOpacity((start.color.alpha_original + (nextStart.color.alpha_original - start.color.alpha_original) * percent) * 255)
            -- 加色
            sp:setColorOffset(cc.c4f(
                (start.color.red + (nextStart.color.red - start.color.red) * percent) / 255,
                (start.color.green + (nextStart.color.green - start.color.green) * percent) / 255,
                (start.color.blue + (nextStart.color.blue - start.color.blue) * percent) / 255,
                (start.color.alpha + (nextStart.color.alpha - start.color.alpha) * percent) / 255
            ))
        end

        if start.png and start.png ~= "" then
            local source = start.png
            if string.byte(source) == 35 then -- first char is #
                source = string.sub(source, 2)
            end
            local spriteFrame = spriteFrameCache:getSpriteFrame(source)

            -- local spriteFrame = display.newSpriteFrame(start.png)
            
            -- 找不到先再加一次资源
            if not spriteFrame then
                if self._spJsonContent.png and self._spJsonContent.png ~= "" then
                    display.loadSpriteFrames(self._spFilePath..".plist", self._spFilePath..".png")
                end
                spriteFrame = display.newSpriteFrame(start.png)
            end
            if spriteFrame then
                sp:setSpriteFrame(spriteFrame)
            end
        end

    end

end

-- @key 图层名，指的是spJson中每一层的名字
-- @spNode 每一层对应的数据
-- @frameIndex 当前是第几帧
-- @node 缓存中当前key的节点，初次时为空

function SpEntry:createDisplayNodeWithSpNode(key, spNode, frameIndex, node)
    
    local fx = string.gsub("f0", "%d", frameIndex)
    
    local displayNode = node
    
    if not displayNode then
        -- 如果当前节点层是指定sp，表示是嵌套层
        if spNode.sp then
            -- 创建json数据
            local spJsonContent = spNode[fx].start
            spJsonContent.spId = spNode.sp

            displayNode = SpEntry.new(spJsonContent, self._objects, self._battleField, self._hasColor or spNode.hasColor)
            displayNode.autoScale = 1
            
            displayNode:setColor(self:getColor())
            displayNode:setColorOffset(self._colorOffset)
            
        elseif spNode.mask_info then    -- 遮罩层
            
            local stencil = cc.LayerColor:create(cc.c4b(0, 0, 0, 255), spNode.mask_info.width, spNode.mask_info.height)
            stencil:setIgnoreAnchorPointForPosition(false)
            stencil:setAnchorPoint(cc.p(0.5, 0.5))
            
            displayNode = cc.ClippingNode:create()
            displayNode:setStencil(stencil)
            
            displayNode.isMask = true
            stencil.clipNode = displayNode
            stencil.autoScale = 1
            
        else

            local sprite = nil
            if self._hasColor or spNode.hasColor then
                sprite = cc.Sprite:createWithSpriteFrameName(spNode[fx].start.png)
                if not sprite then
                    if self._spJsonContent.png and self._spJsonContent.png ~= "" then
                        display.loadSpriteFrames(self._spFilePath..".plist", self._spFilePath..".png")
                    end
                    sprite = cc.Sprite:createWithSpriteFrameName(spNode[fx].start.png)
                end
                sprite:setColorOffset(self._colorOffset)
                sprite:setColor(self:getColor())
            else
                sprite = display.newSprite("#"..spNode[fx].start.png)
            end

            sprite:setCascadeOpacityEnabled(true)
            sprite:setCascadeColorEnabled(true)
            
            displayNode = sprite
            displayNode.autoScale = self._spJsonContent.scale or 1
            
        end
    end
    
    if displayNode then
        
        local parent = self._node
        -- 如果存在遮罩层且名字相同，则父类切换成clipnode    
        if self._spArr[spNode.mask] then
            parent = self._spArr[spNode.mask].clipNode
        end

        if displayNode.isEntry then
            parent:addChild(displayNode:getObject(), spNode.order)
            self:addEntryToNewQueue(displayNode, displayNode.updateEntry)
        elseif displayNode.clipNode then
            parent:addChild(displayNode.clipNode, spNode.order)
        else
            parent:addChild(displayNode, spNode.order)
        end 
    end
    
    return displayNode.isMask and displayNode:getStencil() or displayNode
    
end

-- 此接口主要是用于在action中引用的sp所带的一些参数设置
function SpEntry:initWithSpJson(spJson)
    if spJson.x and spJson.y then self:setPosition(spJson.x, spJson.y) end
    if spJson.rotation then self:setRotation(spJson.rotation) end
    if spJson.scaleX then self:setScaleX(spJson.scaleX) end
    if spJson.scaleY then self:setScaleY(spJson.scaleY) end
    if spJson.opacity then self:setOpacity(spJson.opacity) end
end

-- 这里的模仿CCNode的接口都是为了可嵌套sp服务的, 因为本身的sp中的根节点在计算的时候不仅仅只是赋值而已，还需要考虑到方向等逻辑问题，所以需要独立运算
-- 注意，这里的setPosition方法仅适用于嵌套时的调用，如果想要设置整个sp的位置变化，请获取object(self._node)后再自行设置即可
function SpEntry:setPosition(positionX, positionY) self._node:setPosition(cc.p(positionX, positionY)) end
function SpEntry:getPosition() return self._node:getPosition() end

function SpEntry:setRotation(rotation) self._node:setRotation(rotation) end
function SpEntry:getRotation() return self._node:getRotation() end

function SpEntry:setScale(scaleX, scaleY)
    if not scaleY then
        self._node:setScale(scaleX*SpEntry.SCALE)
    else
        self._node:setScale(scaleX*SpEntry.SCALE, scaleY*SpEntry.SCALE)
    end
end
function SpEntry:getScale() return self._node:getScale() end

function SpEntry:setScaleX(scaleX) self._node:setScaleX(scaleX*SpEntry.SCALE) end    -- 敌方需要翻转
function SpEntry:getScaleX() return self._node:getScaleX() end

function SpEntry:setScaleY(scaleY) self._node:setScaleY(scaleY*SpEntry.SCALE) end
function SpEntry:getScaleY() return self._node:getScaleY() end

function SpEntry:setOpacity(opacity) self._node:setOpacity(opacity) end
function SpEntry:getOpacity() return self._node:getOpacity() end

function SpEntry:setVisible(visible) self._node:setVisible(visible) end
function SpEntry:isVisibile() return self._node:isVisibile() end

function SpEntry:setColorOffset(colorOffset)
    for k, sp in pairs(self._spArr) do
        local _colorOffset = sp:getColorOffset()
        sp:setColorOffset(cc.c4f(colorOffset.r + _colorOffset.r - self._colorOffset.r, colorOffset.g + _colorOffset.g - self._colorOffset.g, colorOffset.b + _colorOffset.b - self._colorOffset.b, colorOffset.a + _colorOffset.a - self._colorOffset.a))
    end
    self._colorOffset = colorOffset
end
function SpEntry:getColorOffset() return self._colorOffset end

function SpEntry:setColor(color) 
    self._node:setColor(color)
    for k, sp in pairs(self._spArr) do
        if sp.setColor then
            sp:setColor(color)
        end
    end
end
function SpEntry:getColor() return self._node:getColor() end

function SpEntry:getBoundingBox()
    -- 这里主要是子弹的碰撞会使用。因为特效里可能含有很多图层，并且每一层的所使用的图片大小不一，所以先不考虑其他多图层下此方法的问题，默认返回找到的第一层
    for k, node in pairs(self._spArr) do
        return node:getBoundingBox()
    end
    
    return cc.rect(0, 0, 0, 0)
end

function SpEntry:destroyEntry()

    SpEntry.super.destroyEntry(self)

    for k, sp in pairs(self._spArr) do
        if sp.isEntry then
            sp:releaseEntry()
        elseif sp.clipNode then
            sp.clipNode:release()
        else
            sp:release()
        end
    end
    
    if self._node then
        if self._node:getParent() then
            self._node:removeFromParent()
        end
        self._node:release()
        self._node = nil
    end
    
    self._spStepArr = nil
    self._spArr = nil

end

return SpEntry
