
-- MapEntry.lua

local ActionEntry = require "app.scenes.battle.entry.ActionEntry"
local SpEntry = require "app.scenes.battle.entry.SpEntry"
local TweenActionEntry = require "app.scenes.battle.entry.TweenActionEntry"
local Entry = require "app.scenes.battle.entry.Entry"

local MapEntry = class("MapEntry", require "app.scenes.battle.entry.TweenEntry")

function MapEntry:ctor(tweenJson, curWave, ...)

	MapEntry.super.ctor(self, tweenJson, curWave, ...)

    self._battleField:addToMapNode(self._node)
end

function MapEntry:initEntry()

    Entry.initEntry(self)

    if self._tweenArr then
        for k, tween in pairs(self._tweenArr) do
            if tween.isEntry then
                tween:initEntry()
                if tween:getObject():getParent() then
                    tween:getObject():removeFromParent()
                end
            elseif tween.clipNode and tween.clipNode:getParent() then
                tween.clipNode:removeFromParent()
            elseif tween:getParent() then
                tween:removeFromParent()
            end
        end
    end
    
    self._tweenStepArr = {}

    self:addEntryToQueue(self, self.update, function(event, ...)
        if event == "base_show" then
            local knights = self._battleField:getHeroKnight()
            for i=1, 6 do
                local knight = knights[tostring(i)]
                if knight then
                    knight:getCardBase():setVisible(true)
                end
            end
        elseif string.match(event, "_stop") then
            if self._eventHandler then
                self._eventHandler("finish")
            end
        end
    end)

end

-- 根据所选帧数判断当前已保存的节点是否存在并且是否是entry，如果有就初始化(initEntry)
function MapEntry:initEntryAtFrame(frameIndex)
    for k, v in pairs(self._tweenJson) do
        if v["f"..frameIndex] and self._tweenArr[k] and self._tweenArr[k].isEntry then
            self._tweenArr[k]:initEntry()
        end
    end
end

function MapEntry:createDisplayWithTweenNode(tweenNode, frameIndex, tween, node)

	local displayNode = node
	local fx = string.gsub("f0", "%d", frameIndex)
    
    if not displayNode then
    	-- 分别创建前景，背景和人物
        if tweenNode == "scene_knight" then

            displayNode = display.newNode()
            displayNode:setCascadeOpacityEnabled(true)
            displayNode:setCascadeColorEnabled(true)

            self._cardTweens = {}

            local knights = self._battleField:getHeroKnight()
            for i=1, 6 do
                local object = knights[tostring(i)]
                if object then
                    -- 创建人物动作，每一个人的动作都是tween
                    local tween = TweenActionEntry.create(i, nil, self._battleField)
                    displayNode:addChild(tween:getObject(), object:getLocalZOrder())

                    self._cardTweens[tostring(i)] = tween
                    tween:retainEntry()
                end
            end

        elseif tweenNode == "blue" then

            displayNode = cc.LayerColor:create(cc.c4b(105, 206, 213, 255))
            displayNode:setIgnoreAnchorPointForPosition(false)
            displayNode:setAnchorPoint(cc.p(0.5, 0.5))

        elseif tween[fx].start and tween[fx].start.spId then

            displayNode = SpEntry.new(tween[fx].start, nil, self._battleField)

        end

    end

    if displayNode then
	
		if tweenNode == "scene_knight" then
            -- 添加到跟节点
            self._node:addChild(displayNode, tween.order or 0)

            for _, tween in pairs(self._cardTweens) do
                self:addEntryToNewQueue(tween, tween.updateEntry)
                if tween:isDone() then
                    tween:initEntry()
                end
            end

        elseif tweenNode == "blue" then

            self._node:addChild(displayNode, tween.order or 0)

        else
            -- 添加到根节点
            self._node:addChild(displayNode:getObject(), tween.order or 0)
            self:addEntryToNewQueue(displayNode, displayNode.updateEntry)
		end

    end
    
    return displayNode

end

function MapEntry:resetKnight()
    if self._cardTweens then
        for _, tween in pairs(self._cardTweens) do
            tween:resetKnight()
            self._battleField:getHeroKnight()[tostring(tween:getData())]:getCardBase():setVisible(true)
            tween:getTweenNode("base"):setVisible(false)
        end
    end
end

function MapEntry:relocateKnight()
    if self._cardTweens then
        for _, tween in pairs(self._cardTweens) do
            tween:relocateKnight()
            self._battleField:getHeroKnight()[tostring(tween:getData())]:getCardBase():setVisible(false)
            tween:getTweenNode("base"):setVisible(true)
        end
    end
end

function MapEntry:destroyEntry()

    MapEntry.super.destroyEntry(self)

    if self._cardTweens then
        for _, tween in pairs(self._cardTweens) do
            tween:releaseEntry()
        end
    end

    self._cardTweens = nil

end

return MapEntry