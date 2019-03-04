-- EntryWrapper

local EntryWrapper = {}

-- 延时用entrywrapper

function EntryWrapper.entryDelay(delay, callback)
    -- 返回entry
    return function(target, frameIndex, ...)
        if frameIndex > delay then
            if not callback then
                return true
            else
                return callback(target, frameIndex - delay, ...)
            end
        end
        return false
    end
end

-- action用entrywrapper

function EntryWrapper.actionEntry(action)
    -- 返回entry
    return function()
        if not action then return true end
        action:step(1)
        return action:isDone()
    end
end

-- condition用entrywrapper

function EntryWrapper.conditionEntry(cond, callback)
    -- 返回entry
    local delay = nil

    return function(target, frameIndex, ...)
        
        local _cond = false
        if type(cond) ~= "function" then
            _cond = checkbool(cond)
        else
            _cond = cond()
        end

        if _cond then
            delay = delay or frameIndex
            if not callback then
                return true
            else
                return callback(target, frameIndex - delay, ...)
            end
        end

        return false
    end
end

return EntryWrapper