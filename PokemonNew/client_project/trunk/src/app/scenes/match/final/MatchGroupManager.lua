local MatchGroupManager=class("MatchGroupManager")

local NAME_RES_MAP = {
    [1] = "a",
    [2] = "B",
    [3] = "c",
    [4] = "d",
}
local MatchFinalPkData = require("app.data.MatchFinalPkData")

function MatchGroupManager:ctor(index,csb,data,progress,clickCallBack)
    self._index = index
    self._csbNode = csb
    self._data = data
    self._progress = progress
    self._clickCallBack = clickCallBack
    self._grouData = self._data:getBigGroupData(index)
    self._selecte = false

	self:_init()
end

function MatchGroupManager:_init()
    self._sprite_big_name = self._csbNode:getSubNodeByName("Sprite_big_name")
    self._sprite_big_name:setTexture(G_Url:getUIUrl("match/pk",NAME_RES_MAP[self._index]))
    self._bigGroup = self._csbNode:getSubNodeByName("Button_big_group")
    self._bigGroup:addClickEventListenerEx(function( ... )
        self._clickCallBack(self._index,1)
    end)

    self._smallNames = {}
    self._smallGroups = {}
    for i=1,4 do
    	self._smallNames[i] = {}
    	local smallGroup = self._csbNode:getSubNodeByName("Button_small_group"..i)
        self._smallGroups[i] = smallGroup
    	self._smallNames[i][1] = smallGroup:getChildByName("Sprite_small_name_1")
    	self._smallNames[i][2] = smallGroup:getChildByName("Sprite_small_name_2")
        smallGroup:addClickEventListenerEx(function( ... )
            self._clickCallBack(self._index,2,i)
        end)
        self._smallNames[i][1]:setTexture(G_Url:getUIUrl("match/pk",NAME_RES_MAP[self._index]))
        self._smallNames[i][2]:setTexture(G_Url:getUIUrl("match/pk",i))
    end
    self:render()
end

function MatchGroupManager:update( data, progress )
    self._data = data
    self._progress = progress
    self:render()
end

function MatchGroupManager:render()
	if self._progress == MatchFinalPkData.PROGRESS_3 then--大组出现  可以决赛四选一了  直接隐藏
        self._csbNode:setVisible(false)
    elseif self._progress == MatchFinalPkData.PROGRESS_2 then--小组出现 大组没有出现 可以大组四选一了  小组直接隐藏
        self._csbNode:setVisible(true)
        self._bigGroup:setVisible(true)
        for i=1,4 do
            self._smallGroups[i]:setVisible(false)
        end
    elseif self._progress == MatchFinalPkData.PROGRESS_1 then--
        self._csbNode:setVisible(true)
        self._bigGroup:setVisible(not self._selecte)
        for i=1,4 do
            self._smallGroups[i]:setVisible(self._selecte)
        end
    end
end

function MatchGroupManager:selecte(value)
    self._selecte = value
    self:render()
end

return MatchGroupManager