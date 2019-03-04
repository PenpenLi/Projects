-- Entry

local Entry = class("Entry")

-- 指的是每一个逻辑入口所操作的数据和对象
-- yutou 这些数据是 这个类所持有的   仅仅是持有 内部并没有真正去使用(eventHandler有条件的使用了)  喵的就不能分开吗
function Entry:ctor(data, objects, battleField, eventHandler)
    
    self._data = data
    self._objects = objects
    self._battleField = battleField
    self._eventHandler = eventHandler
    
    self._retainCount = 0
    
    self.isEntry = true

    self:initEntry()
end

-- 此方法用来初始化入口以及队列，主要把一些类中的标记位和安插子队列的工作放在这里。如果这个入口需要重新播放，则只需要调用一下此方法
-- 标记位和队列即会重置

function Entry:initEntry()

    -- 这是一个二维数组, 用来保存所有执行的队列，里面的结构类似flash里的层，依据下标来保存每一层
    -- 先清空原有的entry
    if self._queue then
        for i=1, #self._queue do
            for j=1, #self._queue[i] do
                local curQueue = self._queue[i][j]
                if curQueue._target and curQueue._target.isEntry and curQueue._target ~= self then
                    curQueue._target:releaseEntry()
                end
            end
        end
    end
    
    self._queue = {
        nil, nil, nil, nil, nil, nil, nil, nil,
        nil, nil, nil, nil, nil, nil, nil, nil,
        nil, nil, nil, nil, nil, nil, nil, nil,
        nil, nil, nil, nil, nil, nil, nil, nil,
    }
    
    -- 事件标记
    self._event = nil
    
    -- 预处理事件，指在执行entry之前的事件处理
    self._preEvent = nil

    self._lastFrameIndex = nil
    
end

function Entry:setEventHandler(handler) self._eventHandler = handler end

function Entry:pause() self._event = "pause" end
function Entry:resume() self._event = "resume" end
function Entry:stop() self._event = "stop" end
function Entry:setEvent(event) self._event = event end
function Entry:getEvent()
    local event = self._event
    self._event = nil
    return event
end

function Entry:reset() self._preEvent = "reset" end
function Entry:setPreEvent(event) self._preEvent = event end
function Entry:getPreEvent()
    local event = self._preEvent
    self._preEvent = nil
    return event
end

function Entry:retainEntry()
    self._retainCount = self._retainCount + 1
end

function Entry:releaseEntry()
    self._retainCount = self._retainCount - 1
    if self._retainCount == 0 then
        self:destroyEntry()
    end
end

function Entry:destroyEntry()
    
    if self._queue then
        for i=1, #self._queue do
            for j=1, #self._queue[i] do
                local target = self._queue[i][j]._target
                -- 这里需要排除掉自己的子入口
                if target and target.isEntry and target ~= self then
                    target.releaseEntry(target)
                end
            end
        end
    end
    
    self._queue = nil
end

function Entry:isDone() return not self._queue or #self._queue == 0 end

-- 返回入口所操作的数据
function Entry:getData() return self._data end
-- 返回入口所操作的实际显示对象，可能是新创建的也可能是在创建入口时确定的
function Entry:getObject() return self._objects end

function Entry:getTotalFrame() return 1 end

function Entry:addEntryToQueue(target, entry, event, key, ...)
    -- default key
    key = key or "default"
    local queue = nil
    for i=1, #self._queue do
        if self._queue[i]._key == key then
            queue = self._queue[i]
            break
        end
    end
    local _queue = nil
    if queue then
        _queue = {_target = target, _entry = entry, _event = event, _frameIndex = 1, _key = key, _params = {...}}
        queue[#queue+1] = _queue
        if target and target.isEntry and target ~= self then
            target:retainEntry()
        end
    else
        _queue = self:addEntryToNewQueue(target, entry, event, key, ...)
    end
    
    return _queue
end

-- 测试用全局标记，用来看看哪个队列没有退出
local keyIndex = 1

function Entry:addEntryToNewQueue(target, entry, event, key, ...)
    
    local newQueue = {
        nil, nil, nil, nil, nil, nil, nil, nil,
        nil, nil, nil, nil, nil, nil, nil, nil,
        nil, nil, nil, nil, nil, nil, nil, nil,
        nil, nil, nil, nil, nil, nil, nil, nil,
        _key = key or "key_"..keyIndex
    }
    
    self._queue[#self._queue+1] = newQueue
    -- key = key or "key_"..keyIndex
    newQueue._key = key
    keyIndex = keyIndex + 1

    local queue = {_target = target, _entry = entry, _event = event, _frameIndex = 1, _key = key, _params = {...}}
    newQueue[#newQueue+1] = queue
    if target and target.isEntry and target ~= self then
        target:retainEntry()
    end
    
    return queue
end

function Entry:addOnceEntryToQueue(target, entry, event, key, ...)
    -- default key
    key = key or "default"
    local queue = nil
    for i=1, #self._queue do
        if self._queue[i]._key == key then
            queue = self._queue[i]
            break
        end
    end
    local _queue = nil
    if queue then
        _queue = {_target = target, _entry = entry, _event = event, _frameIndex = 1, _key = key, _once = true, _params = {...}}
        queue[#queue+1] = _queue
        if target and target.isEntry and target ~= self then
            target:retainEntry()
        end
    else
        _queue = self:addEntryToNewQueue(target, entry, event, key, ...)
        _queue._once = true
    end
    
    return _queue
end

function Entry:insertEntryToQueueAtTop(target, entry, event, key, ...)
    -- default key
    key = key or "default"
    local queue = nil
    for i=1, #self._queue do
        if self._queue[i]._key == key then
            queue = self._queue[i]
            break
        end
    end
    local _queue = nil
    if queue then
        _queue = {_target = target, _entry = entry, _event = event, _frameIndex = 1, _key = key, _params = {...}}
        table.insert(queue, 2, _queue)  -- 这里2表示是第2个队列，因为第一个可能正在执行，如果贸然加入到第一个，则可能第一个被执行一半然后执行第二个
        if target and target.isEntry and target ~= self then
            target:retainEntry()
        end
    else
        _queue = self:addEntryToNewQueue(target, entry, event, key, ...)
    end
    
    return _queue
end

function Entry:updateEntry(frameIndex)
    
    if self._queue and (not self._lastFrameIndex or frameIndex > self._lastFrameIndex) then

        self._lastFrameIndex = frameIndex

        local index = 1
        
        -- 开始遍历这一帧
        while self._queue[index] do
            
            -- 重复查找直到找到当前有效的队列, 如果中途有被已经销毁的则直接移除
            local curQueue = nil
            
            while not curQueue or curQueue._once do--如果当前执行过的是once可以再执行一个
                
                repeat
                    if curQueue and curQueue._stop then
                        if curQueue._target and curQueue._target.isEntry and curQueue._target ~= self then
                            curQueue._target:releaseEntry()
                        end
                        table.remove(self._queue[index], 1)
                    end
                    curQueue = self._queue[index][1]
                until not curQueue or not curQueue._stop--直到已经确定没有  或者找到了没有stop的
                
                -- 找不到就直接跳出了
                if not curQueue then break end
                
                -- 最终找到，则执行调用
                if curQueue then

                    -- 预处理消息
                    if curQueue._target and curQueue._target.getPreEvent then
                        local preEvent = curQueue._target:getPreEvent()
                        if preEvent == "reset" then
                            curQueue._frameIndex = 1
                        end
                    end

    --                local finish, event = entry(target, frameIndex, unpack(params))
                    local finish, event, params = curQueue._entry(curQueue._target, curQueue._frameIndex, unpack(curQueue._params))

                    assert(finish ~= nil, "Invalid finish value: "..tostring(finish))
                    assert(not curQueue._once or (curQueue._once and finish), "The once entry must be executed in one frame !")

                    -- 处理事件
                    if event == "forever" then
                        curQueue._frameIndex = 0
                    elseif event == "pause" then
                        curQueue._pause = true
                    elseif event == "resume" then
                        curQueue._pause = false
                    elseif event == "stop" then
                        curQueue._stop = true
                    elseif event == "jumpTo" then
                        curQueue._pause = false
                        curQueue._jumpTo = params[1]
                    elseif event == "next" then
                        if finish then
                            curQueue._once = true
                        end
                    end

                    local eventHandler = curQueue._event or self._eventHandler

                    if eventHandler and event then
                        eventHandler(event, curQueue._target, curQueue._frameIndex)
                    end

                    if not curQueue._pause and not curQueue._jumpTo then
                        curQueue._frameIndex = curQueue._frameIndex + 1
                    elseif curQueue._jumpTo then
                        curQueue._frameIndex = params[1]
                        curQueue._jumpTo = nil
                    end

                    if finish or curQueue._stop then
                        if curQueue._target and curQueue._target.isEntry and curQueue._target ~= self then
                            curQueue._target:releaseEntry()
                        end
                        table.remove(self._queue[index], 1)
                    end
                
                end

            end
            
            -- 这一层完成了，登记到doneQueue，在循环外删除，因为这是循环内无法直接删除，否则会有问题
            if #self._queue[index] == 0 then
                table.remove(self._queue, index)
            else
                -- 下一帧，只有在此情况下才需要将指针往下移，因为如果完成了则使用table.remove方法会使后面的数据往前移一位
                index = index + 1
            end 
            
        end

    end

    return not self._queue or #self._queue == 0, self:getEvent()
    
end

function Entry:desc()

    local function dumpQueue(queues, space)

        space = space or ""

        if queues then
            for i=1, #queues do
                local queue = queues[i]
                print(space.."-->queue: "..tostring(queue._key))
                dumpQueue(queue, space.."  ")
            end
        end
    end

    dumpQueue(self._queue)

end

return Entry