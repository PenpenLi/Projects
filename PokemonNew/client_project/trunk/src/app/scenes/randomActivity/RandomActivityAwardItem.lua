--RandomActivityAwardItem.lua

--[====================[

	随机活动奖励列表Cell

]====================]

local RandomActivityAwardItem = class ("RandomActivityAwardItem", function (  )
      return cc.TableViewCell:new()
end)

local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local TypeConverter = require "app.common.TypeConverter"
local UpdateButtonHelper = require("app.common.UpdateButtonHelper")


function RandomActivityAwardItem:ctor(btnCallback)
   
    local container =  cc.CSLoader:createNode(G_Url:getCSB("RandomActivityAwardItem","randomActivity")):addTo(self)

    self._iconNode = container:getSubNodeByName("ProjectNode_1")

    self._btnCallback = btnCallback or nil

end


function RandomActivityAwardItem:updateData(awardInfo)
   
   	if type(awardInfo) ~= "table" then return end

    -- local current_score = G_Me.randomActivityData:getScore()

    local function _onButtonCallback()
        if self._btnCallback then
            self._btnCallback(awardInfo.cfgData.id)
        end
    end

    local cfgData = awardInfo.cfgData
    
    local itemInfo = TypeConverter.convert(
        {type = cfgData.type,value = cfgData.value,
            size = cfgData.size, nameVisible = false,levelVisible = false,
            sizeVisible = true})

    --默认显示第一个奖品icon
    if cfgData.type > 0 then
        UpdateNodeHelper.updateCommonListCellNode(self._iconNode, 
        	itemInfo)
    end

    local getAwardButton = self:getSubNodeByName("Button_get")

    local hasGetAward = awardInfo.getAward

    UpdateButtonHelper.updateNormalButton(getAwardButton, 
        {   
            desc = G_LangScrap.get("common_btn_get_award"),
            state = not awardInfo.isReach and UpdateButtonHelper.STATE_GRAY or 
                UpdateButtonHelper.STATE_ATTENTION,
            callback = _onButtonCallback,
            delay = 50
        })

    self:updateImageView("Image_got", {visible = hasGetAward})

    getAwardButton:setVisible(not hasGetAward)

    self:updateLabel("Text_item_name",{text = itemInfo.cfg.name})
    self:updateLabel("Text_desc",{
        text = G_LangScrap.get("random_activity_txt_get_award",{
            score=cfgData.score}),
        color=G_ColorsScrap.COLOR_POPUP_DESC_NORMAL, fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL})


end

return RandomActivityAwardItem

