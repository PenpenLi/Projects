--
-- Author: Your Name
-- Date: 2018-05-30 20:02:09

--排行榜cell基类
--
local RankListBaseCell = class ("RankListBaseCell", function (  )
    return cc.TableViewCell:new()
end)

local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local UpdateButtonHelper = require("app.common.UpdateButtonHelper")

function RankListBaseCell:ctor(view,_handler)
    self._index = nil --单元序号
    self._data = nil --数据绑定

    local node = cc.CSLoader:createNode(G_Url:getCSB("RankCommonCell","rank")) --创建CSB
    self:addChild(node)
    node:setPosition(G_CommonUIHelper.LIST_CELL_OFFSET_X, G_CommonUIHelper.LIST_CELL_OFFSET_Y)

    self._commonIcon = node:getSubNodeByName("Node_item_icon")
end

return RankListBaseCell
