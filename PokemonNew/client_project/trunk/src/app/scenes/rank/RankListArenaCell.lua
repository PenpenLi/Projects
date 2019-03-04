--
-- Author: Your Name
-- Date: 2017-08-04 16:06:32
--
--  ==[[
--		RankLisArenaCell
--     	排行榜 竞技场榜  cell
--    ]]
local RankListBaseCell = require("app.scenes.rank.RankListBaseCell")
local RankLisArenaCell = class ("RankLisArenaCell", RankListBaseCell)

local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local UpdateButtonHelper = require("app.common.UpdateButtonHelper")

function RankLisArenaCell:ctor(view,_handler)
    RankLisArenaCell.super.ctor(self,view,_handler)
end

--数据带入，更新显示 
function RankLisArenaCell:updateInfo(data,index)
	if not data then return end
	self._data = data
	self._index = index
    
    --dump(data)
    local color = G_TypeConverter.quality2Color(data.leader_quality)
    local icon_frame = G_Url:getUI_frame("img_frame_0"..color)

    --头像
    local params = {
        type = G_TypeConverter.TYPE_KNIGHT, 
        value = data.avater,
        sizeVisible = false,
        nameVisible = false,
        scale = UpdateNodeHelper.NODE_SCALE_81,
        icon_bg = icon_frame,
        frame_value = data.pic_frame
    }
    
    UpdateNodeHelper.updateCommonIconNode(self._commonIcon,params,function ()
            if data.user_id ~= G_Me.userData.id then
                print("nnnnn",data.user_id)
                G_HandlersManager.commonHandler:sendGetCommonBattleUser(data.user_id,1)
            else
                G_Popup.newPopup(function ()
                    local UserDetailLayer = require "app.scenes.userDetail.UserDetailLayer"
                    local panel = UserDetailLayer.new()
                    return panel
                end)
            end
        end)

    -- 等级
    if data.rank < 4 then -- 前三名,专用图标
        self:updateLabel("Text_Level", {visible = false})
        self:updateImageView("Image_Level", {texture = G_Url:getRankLvlIcon(data.rank),visible = true})
    else
        self:updateLabel("Text_Level", {text = data.rank,visible = true})
        self:updateImageView("Image_Level", {visible = false})
    end

    -- 名称
    self:updateLabel("Text_item_name", {
        text = data.name,
        textColor = G_Colors.qualityColor2Color(color),
        --outlineColor = G_Colors.qualityColor2OutlineColor(color)
        })

    -- 战力、帮派
        --标题
    self:updateLabel("Text_title1", {text = G_Lang.get("rank_title_power")})
    self:updateLabel("Text_title2", {text = G_Lang.get("rank_title_guild")})
        --数值
    local power = data.power
    -- if power > 100000 then
    -- 	power = tostring(math.floor(power/10000)).."万"
    -- end
    self:updateLabel("Text_value1", {text = tostring(power)})
    self:updateLabel("Text_value2", {text = data.guild_name == "" and "无" or data.guild_name}) -- 帮派暂无
    self:updateLabel("Text_value3", {text = G_Lang.get("common_title_x_level",{level = data.level})})

    -- 等级
    self:updateImageView("Image_valueName", {visible = false})
    local btn_team = self:updateButton("Button_team",{visible = data.user_id ~= G_Me.userData.id,callback = function( ... )
        G_HandlersManager.commonHandler:sendGetCommonBattleUser(data.user_id,2)
    	-- local CommonEnemyFormation = require("app.scenes.team.lineup.CommonEnemyFormation")
     --    local SimpleFormationList = require("app.scenes.team.lineup.SimpleFormationList")
     --    G_Popup.newPopup(function()
     --        local commonEnemyFormation = CommonEnemyFormation.new(SimpleFormationList.TYPE_PLAYER,G_FunctionConst.FUNC_ARENA,nil,
     --            G_Lang.get("rank_check_team"),SimpleFormationList.ORDER_ICON_CIRCLE)
     --        --10010001000039是怪物的id
     --        commonEnemyFormation:updateEnemyUserID(data.user_id)
     --        return commonEnemyFormation
     --    end)
    end})

    UpdateButtonHelper.reviseButton(btn_team)
end

return RankLisArenaCell
