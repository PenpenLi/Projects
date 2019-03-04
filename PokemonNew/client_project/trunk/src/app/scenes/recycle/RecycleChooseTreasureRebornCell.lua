--[====================[

    宝物重生选择面板Cell

]====================]
local RecycleChooseBaseCell = require "app.scenes.recycle.RecycleChooseBaseCell"
local RecycleChooseTreasureRebornCell = class ("RecycleChooseTreasureRebornCell", RecycleChooseBaseCell)

--
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local TypeConverter = require "app.common.TypeConverter"
-- local TreasureInfo = require "app.cfg.treasure_info"
local TreasureCommon = require "app.scenes.treasure.TreasureCommon"
--
function RecycleChooseTreasureRebornCell:ctor(call)
    local node =  cc.CSLoader:createNode(G_Url:getCSB("RecycleChooseTreasureRebornCell", "recycle"))
    self:addChild(node)

    self._callBack = call

    UpdateButtonHelper.updateNormalButton(
        self:getSubNodeByName("Button_choose"),{
        state = UpdateButtonHelper.STATE_NORMAL,
        desc = G_LangScrap.get("recycle_choose"),
        callback = function ()
            self._callBack(self:getIdx())
        end
    })
end

--
function RecycleChooseTreasureRebornCell:updateCell(data, index)
    -- 宝物名字
    local treasureData = G_Me.treasureData:getTreasureByID(data.id)
    local treasureInfo = TreasureInfo.get(treasureData.base_id)
    self:updateLabel("Text_item_name",
        {
            text = treasureInfo.name,
            color = G_ColorsScrap.getColor(treasureInfo.color),
        })
    UpdateNodeHelper.updateQualityLabel(self:getSubNodeByName("Text_item_name"), treasureInfo.color, nil , nil ,true)
    
    ---宝物精炼
    self:getSubNodeByName("Node_refine"):setVisible(false) --data.refine_level ~= 0)
    -- self:updateLabel("Label_refine_num", G_LangScrap.get("recycle_refine_lv", {num = data.refine_level}))

    ---宝物描述
    self:updateLabel("Label_lv_title", G_LangScrap.get("recycle_label_lv"))
    self:updateLabel("Label_lv_value", data.level)

    self:_placeText("Label_lv_title", "Label_lv_value")

    local infoDiscs = TreasureCommon.getAttrsDescription(data.id, "enhance", treasureData.level)
    
    for i = 1, 2 do
        local infoDisc = infoDiscs[i]
        local enhanceTitle = self:getSubNodeByName("Label_enhance_title_" .. tostring(i))
        local enhanceValue = self:getSubNodeByName("Label_enhance_value_" .. tostring(i))
        enhanceTitle:setVisible(infoDisc ~= nil)
        enhanceValue:setVisible(infoDisc ~= nil)
        enhanceTitle:setString(infoDisc.type)
        enhanceValue:setString(infoDisc.value)
        self:_placeText("Label_enhance_title_" .. tostring(i), "Label_enhance_value_" .. tostring(i))
    end

    -- 宝物Icon
    UpdateNodeHelper.updateCommonIconKnightNode(self:getSubNodeByName("Node_item_icon"),
        {
            type = TypeConverter.TYPE_TREASURE, 
            value = treasureInfo.id, 
            level = data.level
        })

end


return RecycleChooseTreasureRebornCell