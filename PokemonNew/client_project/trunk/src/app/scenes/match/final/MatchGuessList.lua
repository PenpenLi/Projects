--
-- Author: yutou
-- Date: 2018-04-25 12:03:18
--
local MatchGuessList = class("MatchGuessList")


function MatchGuessList:ctor(data,con)
	self._data = data
	self._con = con
	self:_init()
end

function MatchGuessList:_init()
	local listSize = self._con:getContentSize()

    local MatchGuessCell = require("app.scenes.match.final.MatchGuessCell")
	self._viewList = require("app.ui.WListView").new(listSize.width, listSize.height, listSize.width, 130, true)
    self._viewList:setCreateCell(function(view, idx)
        local cell = MatchGuessCell.new()
        return cell
    end)
    
    self._viewList:setFirstCellPaddigTop(0)
    self._con:addChild(self._viewList)
end

function MatchGuessList:render()
    ----------------------------------------------------------------
    self._viewList:setUpdateCell(function(view, cell, idx)
        cell:updateCell(self._data[idx + 1], idx) --数据下标从0开始
    end)
    self._viewList:setCellNums(#self._data, true, 0)
    ----------------------------------------------------------------

    self._viewList:setListTouchEnabled(#self._data > 4)
end

function MatchGuessList:onEnter()

end

function MatchGuessList:onExit()
	uf_eventManager:removeListenerWithTarget(self)
end

function MatchGuessList:onCleanup( ... )
	
end

return MatchGuessList