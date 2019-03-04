--
-- Author: yutou
-- Date: 2019-01-15 15:22:21
--
local SoulPossessionEnemy = require("app.scenes.soulPossession.layer.SoulPossessionEnemy")
local SoulPossessionPage=class("SoulPossessionPage",function()
	return display.newNode()
end)

function SoulPossessionPage:ctor(csb,data)
	self._csbNode = csb
	self:enableNodeEvents()

	self:_init()
	if data then
		self:update(data)
	end
end

function SoulPossessionPage:_init()
	-- self:setContentSize(display.width,display.height)
	-- self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("SoulPossessionPage","soulPossession"))
	-- self._csbNode:setContentSize(display.width,display.height)
	-- self._csbNode:setPosition(0,0)
	-- ccui.Helper:doLayout(self._csbNode)
	-- self._csbNode:addTo(self)
	
	self._nodeCons = {}
	self._nodes = {}
	for i=1,6 do
		local node = self._csbNode:getSubNodeByName("Node_" .. i)
		self._nodeCons[i] = node
        if i == 4 or i == 5 then
            node:setPositionY(node:getPositionY() - (display.height - 853)/(1140 - 853) * 10)
        elseif i == 1 or i == 2 or i == 3 then
            node:setPositionY(node:getPositionY() - (display.height - 853)/(1140 - 853) * 50)
        end
	end
end

function SoulPossessionPage:update(stage,datas)
    self._datas = datas
	self:render(stage)
    self._stage = stage
end

function SoulPossessionPage:render(stage)
    if #self._nodes > 0 then
        if self._stage == stage then
            for i=1,#self._datas do
                local pos = self._datas[i].position
                self._nodes[pos]:update(self._datas[i])
            end
        else
            for i=1,#self._datas do
                local soulPossessionEnemy = SoulPossessionEnemy.new(self._datas[i])
                local pos = self._datas[i].position
                self:fade(self._nodes[pos],soulPossessionEnemy)
                self._nodes[pos] = soulPossessionEnemy
                self._nodeCons[pos]:addChild(soulPossessionEnemy)
            end
        end
    else
    	self:clearNode()

    	for i=1,#self._datas do
    		local soulPossessionEnemy = SoulPossessionEnemy.new(self._datas[i])
    		local pos = self._datas[i].position
    		self._nodes[pos] = soulPossessionEnemy
    		self._nodeCons[pos]:addChild(soulPossessionEnemy)
    	end
    end
end

function SoulPossessionPage:fade(oldNode,newNode)
    local fadeout = cc.FadeOut:create(1)
    local callFunc = cc.CallFunc:create(function( ... )
        oldNode:removeFromParent()
    end)
    local sequence = cc.Sequence:create(fadeout,callFunc)
    oldNode:setAllCascadeOpacityEnabled(true)
    oldNode:runAction(sequence)

    local fadein = cc.FadeIn:create(1)
    newNode:setAllCascadeOpacityEnabled(true)
    newNode:setOpacity(0)
    newNode:runAction(fadein)
end

function SoulPossessionPage:clearNode()
	for i=1,#self._nodeCons do
		self._nodeCons[i]:removeAllChildren()
	end
end

function SoulPossessionPage:onEnter()

end

function SoulPossessionPage:onExit()
	uf_eventManager:removeListenerWithTarget(self)
end

function SoulPossessionPage:onCleanup()
	
end


return SoulPossessionPage