
local MatchGuessCell = class("MatchGuessCell", function ()
	return cc.TableViewCell:new()
end)

local TypeConverter = require "app.common.TypeConverter"
local UpdateNodeHelper = require "app.common.UpdateNodeHelper"
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local VipLayer = require "app.scenes.vip.VipLayer"
local MyGuessPop = import(".MyGuessPop")
local MatchOnePKLog = require("app.scenes.match.final.MatchOnePKLog")

function MatchGuessCell:ctor()
	self._data = nil
    self._finalPkData = G_Me.matchData:getFinalPkData()

	self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("PkGuessCell","match/pk"))
	self:addChild(self._csbNode)

    self._index = nil --单元序号
    self._data = nil --数据绑定

    -- node:setPosition(G_CommonUIHelper.LIST_CELL_OFFSET_X, G_CommonUIHelper.LIST_CELL_OFFSET_Y)

    self._commonIcon = self._csbNode:getSubNodeByName("Node_item_icon")
end

function MatchGuessCell:updateCell(data, index)
	self._data = data
	self:render()
end

-- knight = data.knight
-- name = data.name
-- quality = data.quality
-- levle = data.levle
-- power = data.power
-- result = data.result
function MatchGuessCell:render()
	if not self._data then return end
	local data = self._data
	self._index = index
    local color = G_TypeConverter.quality2Color(data.leader_quality)

    local icon_frame = G_Url:getUI_frame("img_frame_0"..color)
    --头像
    local params = {
        type = G_TypeConverter.TYPE_KNIGHT, 
        value = data.avater,
        sizeVisible = false,
        nameVisible = false,
        scale = 0.8,
        icon_bg = icon_frame,
        frame_value = data.pic_frame
    }

    UpdateNodeHelper.updateCommonIconNode(self._commonIcon,params,function ()
            -- if data.user_id ~= G_Me.userData.id then
            --     G_HandlersManager.commonHandler:sendGetCommonBattleUser(data.user_id,1)
            -- else
            --     G_Popup.newPopup(function ()
            --         local UserDetailLayer = require "app.scenes.userDetail.UserDetailLayer"
            --         local panel = UserDetailLayer.new()
            --         return panel
            --     end)
            -- end
        end)

    -- -- 等级
    -- if data.rank < 4 then -- 前三名,专用图标
    --     self:updateLabel("Text_Level", {visible = false})
    --     self:updateImageView("Image_Level", {texture = G_Url:getRankLvlIcon(data.rank),visible = true})
    -- else
    --     self:updateLabel("Text_Level", {text = data.rank,visible = true})
    --     self:updateImageView("Image_Level", {visible = false})
    -- end

    -- 名称
    local color = G_TypeConverter.quality2Color(data.leader_quality)
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
    self:updateLabel("Text_value1", {text = tostring(data.power)})
    self:updateLabel("Text_value2", {text = data.guild_name == "" and "无" or data.guild_name}) -- 帮派暂无
    local sidText = data.sid%1000
    self:updateLabel("Text_value3", {text = "<S" .. sidText .. ">"})

    local item_name = self:getSubNodeByName("Text_item_name")
    self:getSubNodeByName("Text_value3"):setPositionX(item_name:getContentSize().width + item_name:getPositionX() + 5)

	local button_guess = self:getSubNodeByName("Button_guess")
    local sprite_state = self:getSubNodeByName("Sprite_state")
    -- local sprite_passed = self:getSubNodeByName("Sprite_passed")
    -- if data.state == 0 then
	button_guess:setVisible(true)
    sprite_state:setVisible(true)
    sprite_state:setTexture(G_Url:getUI_match("pk/guessed"))

	UpdateButtonHelper.updateBigButton(
		button_guess,
		{
			-- state = UpdateButtonHelper.STATE_ATTENTION,
			desc = G_Lang.get("match_check_pk"),
			callback = function()
				-- G_Popup.newPopup(function( ... )
				-- 	return MyGuessPop.new(self._data)
				-- end)

                local battleReports = G_Me.matchData:getFinalPkData():getOnePlayerList(data.uid)
                if battleReports and #battleReports > 0 then
                    G_Popup.newPopup(function( ... )
                        return MatchOnePKLog.new(battleReports)
                    end)
                else
                    G_Popup.tip(G_Lang.get("match_has_no_report"))
                end
			end
		}
	)

    local isWin = self._finalPkData:dataIsWin(data.uid)
    if isWin == false then
        sprite_state:setTexture(G_Url:getUI_match("pk/passed"))
        -- button_guess:setVisible(false)
        -- sprite_passed:setVisible(true)
    else
        sprite_state:setTexture(G_Url:getUI_match("pk/guessed"))
        -- button_guess:setVisible(true)
        -- sprite_passed:setVisible(false)
    end

    -- elseif data.state == 1 then
    -- 	button_guess:setVisible(false)
    -- elseif data.state == 2 then
    -- 	button_guess:setVisible(false)
    -- 	sprite_state:setVisible(true)
    -- 	sprite_state:setTexture(G_Url:getUI_match("pk/passed"))
    -- end

	-- local textName = node:getSubNodeByName("Text_name")
	-- local textPower = node:getSubNodeByName("Text_power")
	-- local textRank = node:getSubNodeByName("Text_rank")
	-- local iconCon = node:getSubNodeByName("Node_icon")
	-- local btnPk = node:getSubNodeByName("Button_guess")
	-- local spriteGuessed = node:getSubNodeByName("Sprite_guessed")

	-- textPower:setString(data.power)
	-- textRank:setString(data.seaRank)
	-- textName:setString(data.name)

	-- btnPk:addClickEventListenerEx(function( ... )
	-- 	G_HandlersManager.matchHandler:sendBet()
	-- end)

	-- if self._hasGuessed then
	-- 	if data.guess then
	-- 		spriteGuessed:setVisible(true)
	-- 		btnPk:setVisible(false)
	-- 	else
	-- 		spriteGuessed:setVisible(false)
	-- 		btnPk:setVisible(true)
	-- 		btnPk:setTouchEnabled(false)
	-- 	end
	-- else
	-- 	spriteGuessed:setVisible(false)
	-- 	btnPk:setVisible(true)
	-- 	btnPk:setTouchEnabled(true)
	-- end

	-- local item = cc.CSLoader:createNode(G_Url:getCSB("CommonIconItemNode", "common"))
	-- local param = {}
	-- param.nameVisible = false
	-- param.type = TypeConverter.TYPE_KNIGHT
	-- param.value = 1
	-- param.scale = UpdateNodeHelper.NODE_SCALE_80
	-- param.sizeVisible = false
	-- UpdateNodeHelper.updateCommonIconItemNode(item, param)
	-- item:addTo(iconCon)
end

return MatchGuessCell