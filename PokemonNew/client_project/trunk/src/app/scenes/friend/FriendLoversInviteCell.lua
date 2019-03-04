---好友列表item
local FriendLoversInviteCell = class("FriendLoversInviteCell", function ( ... )
    return cc.TableViewCell:new()
end)
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local FriendLoversPopup = require("app.scenes.friend.FriendLoversPopup")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")

function FriendLoversInviteCell:ctor(call)
    self._friendUnit = nil
    self._callBack = call
	--FriendLoversInviteCell.super.ctor(self)
    self:_initUI()
end

function FriendLoversInviteCell:_initUI( ... )
    self._csbNode = cc.CSLoader:createNode("csb/friend/FriendLoversInviteCell.csb")
    self:addChild(self._csbNode)
end

function FriendLoversInviteCell:updateCell( cellValue,cellIdx )
    self._friendUnit = cellValue
    self:updateLabel("Label_lv_value", self._friendUnit:getLevel())
    self:updateLabel("Label_power_value", self._friendUnit:getPower())
    self:updateLabel("Label_gang_value", self._friendUnit:getGuidName() == "" and G_Lang.get("friend_no_guild") or self._friendUnit:getGuidName())
    self:updateLabel("Label_time", self:_getTimeDesc())

    local color = G_TypeConverter.quality2Color(self._friendUnit:getQuality())
    local icon_frame = G_Url:getUI_frame("img_frame_0"..color)
    local sex = self._friendUnit:getSex()
    self:updateLabel("Text_item_name",
    {
        text = self._friendUnit:getName(),
        textColor = G_Colors.qualityColor2Color(color),
       -- outlineColor = G_Colors.qualityColor2OutlineColor(color)
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
    UpdateButtonHelper.updateNormalButton(self:getSubNodeByName("FileNode_send"), {state = self._friendUnit:isSendInvite() and UpdateButtonHelper.STATE_GRAY or UpdateButtonHelper.STATE_NORMAL, 
        desc =self._friendUnit:isSendInvite() and "已发送" or "发送", callback = function ( ... )
            G_HandlersManager.friendHandler:sendTellFriend(self._friendUnit:getId())
    end})
end

--组合时间字符
function FriendLoversInviteCell:_getTimeDesc()
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

return FriendLoversInviteCell