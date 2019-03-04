--
-- Author: Your Name
-- Date: 2018-02-09 12:19:14
--  ==[[
--     	排行榜 演武场榜  cell
--    ]]

local PracticeRankCell = class ("PracticeRankCell", function (  )
    return cc.TableViewCell:new()
end)

local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local TextHelper = require ("app.common.TextHelper")
local guildConfigInfo = require("app.cfg.sept_info")

function PracticeRankCell:ctor(view,_handler)
    self._index = nil --单元序号
    self._data = nil --数据绑定

    local node = cc.CSLoader:createNode(G_Url:getCSB("PracticeRankCell","practice")) --创建CSB
    self:addChild(node)  

    self._commonIcon = node:getSubNodeByName("Node_common")
    self._Image_bg_rank = node:getSubNodeByName("Image_bg_rank")
end

--数据带入，更新显示 
function PracticeRankCell:updateInfo(data,index)
    if not data then return end
    dump(data)
	self._data = data
	self._index = index
    local score = 0

    if rawget(data,"leader_quality") then -- 个人榜
        local color = G_TypeConverter.quality2Color(data.leader_quality)
        local icon_frame = G_Url:getUI_frame("img_frame_0"..color)
        local value = rawget(data,"title_pic") or rawget(data,"avater")--and data.exploit_rank or {}
        local user_id = rawget(data,"user_id") or rawget(data,"uid")
       -- dump(value)
        --头像
        local params = {
            type = G_TypeConverter.TYPE_KNIGHT, 
            value = value,
            sizeVisible = false,
            nameVisible = false,
            scale = 0.8,
            icon_bg = icon_frame,
            frame_value = data.pic_frame
        }
        UpdateNodeHelper.updateCommonIconNode(self._commonIcon,params,function ()
                if user_id and user_id ~= G_Me.userData.id then
                    G_HandlersManager.commonHandler:sendGetCommonBattleUser(user_id,1)
                else
                    G_Popup.newPopup(function ()
                        local UserDetailLayer = require "app.scenes.userDetail.UserDetailLayer"
                        local panel = UserDetailLayer.new()
                        return panel
                    end)
                end
            end)

         -- 名称
        self:updateLabel("Text_item_name", {
            text = data.name,
            textColor = G_Colors.qualityColor2Color(color,false),
           -- outlineColor = G_Colors.qualityColor2OutlineColor(color)
            })

         -- 等级、帮派
        --标题
        local value = rawget(data,"score") or rawget(data,"value")     
        score = TextHelper.getAmountText(value)
        self:updateLabel("Text_title1", {text = G_Lang.get("rank_title_power")})
        self:updateLabel("Text_title2", {text = G_Lang.get("rank_title_guild")})
            --数值
        self:updateLabel("Text_value1", {text = tostring(data.power)})
        self:updateLabel("Text_value2", {text = data.guild_name == "" and "无" or data.guild_name}) -- 帮派暂无
        self:updateLabel("Text_value3", {text = G_Lang.get("common_title_x_level",{level = data.level})})
    else -- 帮派榜
        local params = {
        icon = "newui/guild/guild_icon_0"..tostring(data.icon)..".png",
        icon_bg = "newui/common/img_frame_empty05"..".png",
        scale = 0.8
        }

        UpdateNodeHelper.updateCommonModuleIconNode(self._commonIcon,params,function ()
             end)

         -- 名称
        self:updateLabel("Text_item_name", {text = rawget(data,"name") and data.name or data.guild_name})

         -- 帮主名、成员数量
        --标题
        local cfgInfo = guildConfigInfo.get(rawget(data,"level") and data.level or data.guild_level)
        --assert(cfgInfo,"can not find sept_info for id = "..data.level)
        self:updateLabel("Text_title1", {text = G_Lang.get("rank_guild_chief")})
        self:updateLabel("Text_title2", {text = G_Lang.get("rank_guild_member")})
       
        self:updateLabel("Text_value1", {text = rawget(data,"leader_name") and data.leader_name or data.guild_leader_name})
        self:updateLabel("Text_value2", {text = tostring(rawget(data,"member_num") and data.member_num or data.guild_member_size).."/"..tostring(cfgInfo.number)}) 
        self:updateLabel("Text_value3", {text = rawget(data,"sid") and ("<S" .. data.sid%1000 .. ">") or G_Lang.get("common_title_x_level",{level = rawget(data,"level") and data.level or data.guild_level})})
        score = TextHelper.getAmountText(rawget(data,"score") and data.score or data.guild_power)
    end

    -- 等级
    if data.rank < 4 then -- 前三名,专用图标
        self:updateLabel("Text_Level", {visible = false})
        self:updateImageView("Image_Level", {texture = G_Url:getRankLvlIcon(data.rank),visible = true})
       -- self:updateImageView("Image_bg_rank", {texture = G_Url:getRankCellBg(data.rank),visible = true})
        self:getSubNodeByName("Image_bg_rank"):loadTexture(G_Url:getRankCellBg(data.rank), ccui.TextureResType.localType)
    else
        self:updateLabel("Text_Level", {text = data.rank,visible = true})
        self:updateImageView("Image_Level", {visible = false})
        --self:updateImageView("Image_bg_rank", {texture = G_Url:getRankCellBg(4),visible = true})
        self:getSubNodeByName("Image_bg_rank"):loadTexture(G_Url:getRankCellBg(4), ccui.TextureResType.localType)
    end

    -- 积分
    if rawget(data,"sid") == nil then -- 非帮战赛区战力排行
        self:updateImageView("Image_valueName", {texture = G_Url:getRankTextIcon(rawget(data,"score") and "score" or "hurt"),visible = true})
    end
    self:updateFntLabel("TextBM_value", tostring(score))
end

return PracticeRankCell

