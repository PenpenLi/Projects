---寻侣回应item
--local FriendBaseCell = require "app.scenes.friend.FriendBaseCell"
--local FriendLoversRespondCell = class("FriendLoversRespondCell", FriendBaseCell)
local FriendLoversRespondCell = class("FriendLoversRespondCell", function ( ... )
    return cc.TableViewCell:new()
end)
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local FriendLoversPopup = require("app.scenes.friend.FriendLoversPopup")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")

function FriendLoversRespondCell:ctor(call)
    self._friendUnit = nil
    self._callBack = call
	--FriendLoversRespondCell.super.ctor(self)
    self:_initUI()
end

function FriendLoversRespondCell:_initUI( ... )
    self._csbNode = cc.CSLoader:createNode("csb/friend/FriendLoversRespondCell.csb")
    self:addChild(self._csbNode)
end

function FriendLoversRespondCell:updateCell( cellValue,cellIdx )
    self._friendUnit = cellValue
    self:updateLabel("Label_lv_value", self._friendUnit:getLevel())
    self:updateLabel("Label_power_value", self._friendUnit:getPower())
    self:updateLabel("Label_gang_value", self._friendUnit:getGuidName() == "" and G_Lang.get("friend_no_guild") or self._friendUnit:getGuidName())
    self:updateLabel("Label_time", self:_getTimeDesc())

    --dump(self._friendUnit:getQuality())
    local color = G_TypeConverter.quality2Color(self._friendUnit:getQuality())
    local icon_frame = G_Url:getUI_frame("img_frame_0"..color)
    local sex = self._friendUnit:getSex()
    --dump(sex)
    self:updateLabel("Text_item_name",
    {
        text = self._friendUnit:getName(),
        textColor = G_Colors.qualityColor2Color(color,false),
      --  outlineColor = G_Colors.qualityColor2OutlineColor(color)
    })
    self:updateImageView("Image_sex", sex == 1 and G_Url:getUI_common_icon("nan") or G_Url:getUI_common_icon("nv"))

    --更新ICON
    local param = {
        type = G_TypeConverter.TYPE_KNIGHT,
        value = self._friendUnit:getHeadIcon(),
        nameVisible = false,
        sizeVisible = false,
        icon_bg = icon_frame,
        scale = 0.9,
        frame_value = self._friendUnit:getHeadFrame()
    }
    UpdateNodeHelper.updateCommonIconKnightNode(
        self:getSubNodeByName("Node_item_icon"),
        param,
        function()
            G_HandlersManager.commonHandler:sendGetCommonBattleUser(self._friendUnit:getId() , 1)
        end
    )

    --按钮回调
    UpdateButtonHelper.updateNormalButton(self:getSubNodeByName("FileNode_refuse"), {state = self._friendUnit.res == 1 and UpdateButtonHelper.STATE_GRAY or UpdateButtonHelper.STATE_NORMAL, 
        desc = self._friendUnit.res == 1 and "已拒绝" or "拒绝", callback = function ( ... )
            G_HandlersManager.friendHandler:sendRefuseRespond(self._friendUnit:getId())
    end})
    UpdateButtonHelper.updateNormalButton(self:getSubNodeByName("FileNode_accept"), {state = self._friendUnit.res == 1 and UpdateButtonHelper.STATE_GRAY or UpdateButtonHelper.STATE_ATTENTION, 
        desc ="接受", callback = function ( ... )
            FriendLoversPopup.newSureBeLoversPopup({id = self._friendUnit:getId(),name = self._friendUnit:getName()})
        --G_HandlersManager.friendHandler:sendAcceptRespond(self._friendUnit:getId())
        --self._callBack()
    end})
end

--组合时间字符
function FriendLoversRespondCell:_getTimeDesc()
    local retStr
    local time = self._friendUnit:getOffLineSeconeds()
    if time == 0 then
        retStr = G_LangScrap.get("friend_time_txt")
    else
        local offLineTime = G_ServerTime:getTime() - time
        local hour = math.floor(offLineTime / 3600)
        local min = math.ceil((offLineTime - hour * 3600) / 60)
        
        if hour == 0 then
            min = min == 0 and 1 or min
            retStr = G_Lang.get("friend_time_no_txt",{num1 = min , num2 = G_Lang.get("friend_time_muin")})
        elseif hour < 24 then
            retStr = G_Lang.get("friend_time_no_txt",{num1 = hour , num2 = G_Lang.get("friend_time_hours")})
        elseif hour >= 24 and hour < 24 * 7 then
            retStr = G_Lang.get("friend_time_no_txt",{num1 = math.floor(hour/24), num2 = G_Lang.get("friend_time_day")})
        elseif hour >= 24 * 7 and hour < 24 * 30 then
            retStr = G_Lang.get("friend_time_no_txt",{num1 = math.floor(hour/(24 * 7)), num2 = G_Lang.get("friend_time_no_week")})
        elseif hour >= 24 * 30 then
            retStr = G_Lang.get("friend_time_no_txt",{num1 = math.floor(hour/(24 * 30)), num2 = G_Lang.get("friend_time_no_month")})
        end
    end

    return retStr
end

return FriendLoversRespondCell