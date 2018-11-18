
local sharedApplication = CCApplication:sharedApplication()
local target = sharedApplication:getTargetPlatform()

function canTrack()
    if IS_TASTE_VERSION then
        return false
    end
    if target == kTargetIphone or target == kTargetIpad or target == kTargetAndroid then
        return true
    else
        return false
    end
end


function track_event(eventName, keyList)
    print("talkingData:eventccc", eventName, canTrack())
    if canTrack() then
        --[[
        TDGAMission:onBegin
        onCompleted
        onFailed
        ]]
        print("talkingData:event", eventName)
        TalkingDataGA:onEvent(eventName,keyList)
    end
end

local _sendObj={}

function track_event_guide(value)
    talkingEvent("guide",value)
    track_user_event(3, value)
end

function track_event_game(value)
    talkingEvent("game",value)
    track_user_event(2, value)
end

function track_user_event(logType, value)
    local sid = 0 
    local server = G_PlatformProxy:getLoginServer()
    if server ~= nil then
        sid = server.id
    end
    local uid =  G_PlatformProxy:getUid()
    --print("aaaaaa", sid)
    track_event(logType, value .. "," .. sid .. "," .. uid)
end

function track_event_start(value)
    talkingEvent("start",value)
    track_event(1, value)
end

function talkingEvent(t,v)
    if TalkingDataGA ~= nil then
        TalkingDataGA:onEvent(t,{step=v})
    end
end

function track_event(logType, value)
    --print("track_event:",logType, value)
    --track_event("start_game", {step=step})
    if canTrack() then
        targetS = "x"
        if target == kTargetIphone or target == kTargetIpad then
            targetS = "i"
        elseif target == kTargetAndroid then
            targetS = "a"
        end
        if _sendObj[value] == nil then
            _sendObj[value] = true
            preStr = targetS .. "-" .. TalkingDataGA:getDeviceId() .. "-" .. logType
            --urlStr = "http://120.26.16.95:8088/log?msg=" .. preStr .. "-" .. value
            print(urlStr)
            --__sendTrack(urlStr)
        end
    end
end

function __sendTrack( url )
    local network = require("framework.network")
    local httpHandler = function ( event )
    end
    local request = network.createHTTPRequest(httpHandler, url, "GET")
    request:start()
end

