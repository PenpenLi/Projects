--
-- Author: yutou
-- Date: 2018-12-10 11:38:33
--
--
-- Author: yutou
-- Date: 2018-12-10 11:33:27
--

local MatchRankPopCell = class ("MatchRankPopCell", function (  )
    return cc.TableViewCell:new()
end)

local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local TextHelper = require ("app.common.TextHelper")
local guildConfigInfo = require("app.cfg.sept_info")

function MatchRankPopCell:ctor(tabIndex)
    self._tabIndex = tabIndex
    self._index = nil --单元序号
    self._data = nil --数据绑定

    local node = cc.CSLoader:createNode(G_Url:getCSB("MatchServerRankCell","match/pk")) --创建CSB
    self:addChild(node)  

    self._commonIcon = node:getSubNodeByName("Node_common")
    self._Image_bg_rank = node:getSubNodeByName("Image_bg_rank")
    self._Image_valueName = node:getSubNodeByName("Image_valueName")

    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_MATCH_BET_OVER,self.render,self)--
end

--数据带入，更新显示 
function MatchRankPopCell:updateInfo(data,index)
    if not data then return end
	self._data = data
	self._index = index

    local color = G_TypeConverter.quality2Color(data.leader_quality)
    local icon_frame = G_Url:getUI_frame("img_frame_0"..color)
    local value = data.knight--and data.exploit_rank or {}
    local user_id = data.uid
    --头像
    local params = {
        type = G_TypeConverter.TYPE_KNIGHT, 
        value = value,
        sizeVisible = false,
        nameVisible = false,
        scale = 0.8,
        icon_bg = icon_frame,
        frame_value = data.pic_frame,
        disableTouch = false
    }
    dump(params)
    UpdateNodeHelper.updateCommonIconNode(self._commonIcon,params,function ()
            -- if user_id and user_id ~= G_Me.userData.id then
            --     G_HandlersManager.matchHandler:sendGetBattleUser(user_id,data.sid)
            -- else
            --     G_Popup.newPopup(function ()
            --         local UserDetailLayer = require "app.scenes.userDetail.UserDetailLayer"
            --         local panel = UserDetailLayer.new()
            --         return panel
            --     end)
            -- end
        end)

     -- 名称
    self:updateLabel("Text_item_name", {
        text = data.name,
        textColor = G_Colors.qualityColor2Color(color,false),
       -- outlineColor = G_Colors.qualityColor2OutlineColor(color)
        })
    local nameText = self:getSubNodeByName("Text_item_name")
    self:getSubNodeByName("Text_value3"):setPositionX(nameText:getPositionX() + nameText:getContentSize().width + 5)

     -- 等级、帮派
    --标题
    self:updateLabel("Text_title1", {text = G_Lang.get("rank_title_power")})
    self:updateLabel("Text_title2", {text = G_Lang.get("rank_title_guild")})
        --数值
    self:updateLabel("Text_value1", {text = tostring(data.power)})
    self:updateLabel("Text_value2", {text = data.guild == "" and "无" or data.guild}) -- 帮派暂无
    local sidText = data.sid%1000
    self:updateLabel("Text_value3", {text = "<S" .. sidText .. ">"})

    local rank = index + 1
    -- 等级
    if rank < 4 then -- 前三名,专用图标
        self:updateLabel("Text_Level", {visible = false})
        self:updateImageView("Image_Level", {texture = G_Url:getRankLvlIcon(rank),visible = true})
       -- self:updateImageView("Image_bg_rank", {texture = G_Url:getRankCellBg(rank),visible = true})
        self:getSubNodeByName("Image_bg_rank"):loadTexture(G_Url:getRankCellBg(rank), ccui.TextureResType.localType)
    else
        self:updateLabel("Text_Level", {text = rank,visible = true})
        self:updateImageView("Image_Level", {visible = false})
        --self:updateImageView("Image_bg_rank", {texture = G_Url:getRankCellBg(4),visible = true})
        self:getSubNodeByName("Image_bg_rank"):loadTexture(G_Url:getRankCellBg(4), ccui.TextureResType.localType)
    end


    self:render()
    
    -- 积分
    -- if data.sid == nil then -- 非帮战赛区战力排行
    --     self:updateImageView("Image_valueName", {texture = G_Url:getRankTextIcon(data.score and "score" or "hurt"),visible = true})
    -- end
end

function MatchRankPopCell:render()
    local score = 0
    local value = self._data.score or self._data.value    
    score = TextHelper.getAmountText(value)
    local button_guess = self:getSubNodeByName("Button_guess")
    local sprite_state = self:getSubNodeByName("Sprite_state")
    if self._tabIndex == 1 then
        self._Image_valueName:setVisible(true)
        button_guess:setVisible(false)
        sprite_state:setVisible(false)
        self:updateFntLabel("TextBM_value", tostring(score))
    elseif self._tabIndex == 2 then
        self._Image_valueName:setVisible(false)
        button_guess:setVisible(true)
        sprite_state:setVisible(true)

        if G_Me.matchData:getFinalPkData():dataIsWin(self._data.uid) == false then
            button_guess:setVisible(false)
            sprite_state:setVisible(true)
            sprite_state:setTexture(G_Url:getUI_match("pk/passed"))
        elseif G_Me.matchData:hasGuessed(self._data.uid) == false then
            button_guess:setVisible(true)
            sprite_state:setVisible(false)

            UpdateButtonHelper.updateBigButton(
                button_guess,
                {
                    -- state = UpdateButtonHelper.STATE_ATTENTION,
                    desc = G_Lang.get("match_guess"),
                    callback = function()
                        G_HandlersManager.matchHandler:sendBet(self._data.uid)
                    end
                }
            )

        elseif G_Me.matchData:hasGuessed(self._data.uid) then
            button_guess:setVisible(false)
            sprite_state:setVisible(true)
            sprite_state:setTexture(G_Url:getUI_match("pk/guessed"))
        end
        -- sprite_state:setVisible(false)
        -- button_guess:setVisible(false)
    end
end

function MatchRankPopCell:onExit()
    uf_eventManager:removeListenerWithTarget(self)
end

return MatchRankPopCell

