--
-- Author: suMSun
-- Date: 2017-5-11 21:31:35
--
local CampaignLayer=class("CampaignLayer",function()
	return cc.Layer:create()
end)

local RedPointHelper = require("app.common.RedPointHelper")
local FunctionLevelHelper = require("app.common.FunctionLevelHelper")
local EffectMovingNode = require("app.effect.EffectMovingNode")
local EffectNode = require("app.effect.EffectNode")

local FrameList = 
{
	-- [G_FunctionConst.FUNC_ROB_TREASURE] = "Image_treasure",
	--[G_FunctionConst.FUNC_MONSTER_TOWER] = "Image_tower",
	-- [G_FunctionConst.FUNC_MOUNTAIN] = "Image_mountain",
	-- [G_FunctionConst.FUNC_SPOOKY] = "Image_spook",
	-- [G_FunctionConst.FUNC_RICH] = "Image_tiangong",
	[G_FunctionConst.FUNC_WORLD_BOSS] = "Image_tiangong",
}

function CampaignLayer:ctor()
	-- body
	self:enableNodeEvents()
	self._buildingList = nil
	self._csbNode = nil
	self._clicked = false
	self._btnWorldBoss = nil -- 世界boss按钮
end

function CampaignLayer:_initUI( ... )
	self._csbNode = cc.CSLoader:createNode("csb/campaign/CampaignLayer.csb")
	self._csbNode:setContentSize(display.width,display.height)
	self._csbNode:setPosition(0,(display.height - 1140) / 2)
	self:addChild(self._csbNode)
	ccui.Helper:doLayout(self._csbNode)

	local offsetY = (display.height - 1140)*0.5

	for k,name in pairs(FrameList) do
	 	self:getSubNodeByName(name):setOpacity(0)
	end

	local function onBuildingClick(functionId)
		if self._clicked == true then
			return
		end

		if functionId == G_FunctionConst.FUNC_MONSTER_TOWER then
		    self._clicked = true
			-- G_ModuleDirector:pushModule(G_FunctionConst.FUNC_MONSTER_TOWER, function()
		 --    	self._clicked = false
		 --        return require("app.scenes.thirtyThree.MainThirtyThreeScene").new()
		 --    end)
			G_ModuleDirector:pushModule(G_FunctionConst.FUNC_MONSTER_TOWER, function()
		    	self._clicked = false
		        return require("app.scenes.tower.TowerScene").new()
		    end)
		elseif functionId == G_FunctionConst.FUNC_WORLD_BOSS then
		    self._clicked = true
		    dump("FUNC_WORLD_BOSS ready push!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
			G_ModuleDirector:pushModule(G_FunctionConst.FUNC_WORLD_BOSS, function()
		    	self._clicked = false
		    dump("FUNC_WORLD_BOSS ready new!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")

                return require("app.scenes.worldBoss.WorldBossScene").new()
            end)
		-- elseif functionId == G_FunctionConst.FUNC_ROB_TREASURE then
		--     self._clicked = true
		-- 	G_ModuleDirector:pushModule(G_FunctionConst.FUNC_ROB_TREASURE, function()
		--     	self._clicked = false
  --               return require("app.scenes.treasure.TreasureComposeScene").new()
  --           end)
		-- elseif functionId == G_FunctionConst.FUNC_SPOOKY then
		--     self._clicked = true
		-- 	G_ModuleDirector:pushModule(G_FunctionConst.FUNC_SPOOKY, function()
		--     	self._clicked = false
  --               return require("app.scenes.spooky.SpookyScene").new()
  --           end)
		-- elseif functionId == G_FunctionConst.FUNC_MOUNTAIN then
		--     self._clicked = true
		-- 	G_ModuleDirector:pushModuleWithAni(G_FunctionConst.FUNC_MOUNTAIN, function()
		--     	self._clicked = false
		--         return require("app.scenes.mountain.MountainScene").new()
		--     end)
		-- elseif functionId == G_FunctionConst.FUNC_RICH then
		-- 	-- G_ModuleDirector:pushModule(G_FunctionConst.FUNC_MONSTER_TOWER, function()
		--  --        return require("app.scenes.thirtyThree.MainThirtyThreeScene").new()
		--  --    end)
		end

		if G_Responder.funcIsOpened(functionId) == false then
			self._clicked = false
		end

		uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false)
	end

	local function onShowFrame( functionId, isDown )
		local frameName = FrameList[functionId]
		if frameName ~= nil then
			local node = self:getSubNodeByName(frameName)
			if isDown then
				node:setOpacity(255)
				self:scaleBackground()
			else
				node:stopAllActions()
				node:runAction(cc.FadeOut:create(0.2))
			end
		end
	end

	local panelWorldBoss = require("app.scenes.campaign.Building").new(cc.size(600,425),G_FunctionConst.FUNC_WORLD_BOSS,onBuildingClick,onShowFrame)
	panelWorldBoss:setPosition(310,260 + offsetY)
	panelWorldBoss:setName("Panel_worldBoss")
	

	-- local panelRob = require("app.scenes.adventure.Building").new(cc.size(225,220),G_FunctionConst.FUNC_ROB_TREASURE,onBuildingClick,onShowFrame)
	-- panelRob:setPosition(135,550 + offsetY)
	-- panelRob:setName("Panel_gem")
	

	local panelThirtyThree = require("app.scenes.adventure.Building").new(cc.size(200,200),G_FunctionConst.FUNC_MONSTER_TOWER,onBuildingClick,onShowFrame)
	panelThirtyThree:setPosition(483,550 + offsetY)
	panelThirtyThree:setName("Panel_thirtyThree")
	

	-- local panelSpooky = require("app.scenes.adventure.Building").new(cc.size(288,273),G_FunctionConst.FUNC_SPOOKY,onBuildingClick,onShowFrame)
	-- panelSpooky:setPosition(530,740 + offsetY)
	-- panelSpooky:setName("Panel_spooky")
	

	-- local panelMountain = require("app.scenes.adventure.Building").new(cc.size(200,160),G_FunctionConst.FUNC_MOUNTAIN,onBuildingClick,onShowFrame)
	-- panelMountain:setPosition(100,760 + offsetY)
	-- panelMountain:setName("Panel_mountain")
	

	-- local panelSky = require("app.scenes.adventure.Building").new(cc.size(250,200),G_FunctionConst.FUNC_RICH,onBuildingClick,onShowFrame)
	-- panelSky:setPosition(320,887 + offsetY)
	-- panelSky:setName("Panel_tiangong")
	

	self._buildingList = {panelWorldBoss,panelRob,panelThirtyThree,panelSpooky,panelMountain,panelSky}

	local tag = 2
	--self:addChild(panelSky,tag)
	-- self:addChild(panelMountain,tag)
	-- self:addChild(panelSpooky,tag)
	self:addChild(panelThirtyThree,tag)
	--self:addChild(panelRob,tag)
	self:addChild(panelWorldBoss,tag)


	local function onAllLoaded()
		local effectSun = EffectNode.new("effect_jct_csgc_sunshine")
		effectSun:play()
		effectSun:setPosition(160,650 + offsetY)
		self:addChild(effectSun, 3)

		local effectCloud = EffectNode.new("effect_mxcj_bj")
		effectCloud:play()
		self:addChild(effectCloud, 0)
		effectCloud:setPosition(display.cx,display.cy)

		local arena_vs = ccui.ImageView:create("newui/arena/arena_vs.png")
		arena_vs:setPosition(310, 390 + offsetY)
		self:addChild(arena_vs, tag)
		-- local node = display.newNode()
		-- node:addChild(arena_vs)
		-- self:addChild(node, 3)

		--panelArena:addEffectNode("effect_mxcj_rw",cc.p(0,130))
		panelWorldBoss:addEffectNode("effect_mxcj_maoxian_1",cc.p(12,-107))
		panelSpooky:addEffectNode("effect_mxcj_jz",cc.p(-20,60))
		panelMountain:addEffectNode("effect_mxcj_jz3",cc.p(20,30))
		panelRob:addEffectNode("effect_hj_xing_2",cc.p(-5,-25))
	end

	panelWorldBoss:startUp()
	--panelRob:startUp()
	panelThirtyThree:startUp()
	--panelSpooky:startUp()
	--panelMountain:startUp()
	--panelSky:startUp(onAllLoaded)

	self:_addBossButton()
end

function CampaignLayer:scaleBackground()
	local background = self._csbNode:getSubNodeByName("Image_bg")
	local scaleB = cc.ScaleTo:create(0.2, 1.001)
	local scaleS = cc.ScaleTo:create(0.2, 1)
	-- scaleB = cc.EaseBackIn:create(scaleB)
	scaleS = cc.EaseBackOut:create(scaleS)
	local seq = cc.Sequence:create(scaleB,scaleS)
	background:runAction(seq)
end

function CampaignLayer:_onUserDataUpdate( ... )
	-- body
	if self._buildingList == nil then return end
	for i=1,#self._buildingList do
		local build = self._buildingList[i]
		build:checkRedPoint()
		build:checkFunctionOpen()
	end
end


function CampaignLayer:onEnter( ... )
	-- body
	self:_initUI()
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECV_ROLE_INFO,self._onUserDataUpdate,self)
	uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false)
end

function CampaignLayer:onExit( ... )
	-- body
	self:removeAllChildren(true)
	uf_eventManager:removeListenerWithTarget(self)
end

 ---添加全服BOSS按钮
function CampaignLayer:_addBossButton()
    self._btnWorldBoss = ccui.Button:create(G_Url:getUI_icon("icon_lv1_boss"))
    local btnSize = self._btnWorldBoss:getContentSize()
    local worldBossText = cc.Label:createWithTTF(G_LangScrap.get("worldboss_entry_btn"),G_Path.getNormalFont(),22) --ccui.ImageView:create(G_Url:getText_system("txt_com_icon90_21"))
    worldBossText:setColor(G_ColorsScrap.COLOR_POPUP_SPECIAL_NOTE)
    worldBossText:enableOutline(G_ColorsScrap.COLOR_SCENE_OUTLINE, 2)
    self._btnWorldBoss:addChild(worldBossText)
    worldBossText:setPosition(btnSize.width/2,-5) --btnSize.height*0.1)

    self._btnWorldBoss:setAnchorPoint(1,1)
    self._btnWorldBoss:setPosition(display.right-20, display.top - 135)
    self:addChild(self._btnWorldBoss, 100)
    self._btnWorldBoss:addClickEventListenerEx(function(sender)
        G_ModuleDirector:pushModule(G_FunctionConst.FUNC_WORLD_BOSS, function()
            return require("app.scenes.worldBoss.WorldBossScene").new()
        end)
    end)
    self._btnWorldBoss:setVisible(true)

    local btnSize = self._btnWorldBoss:getContentSize()
    self._btnWorldBossTip = ccui.ImageView:create(G_Url:getUI_common("img_com_btn_tipred01"))
    self._btnWorldBossTip:setAnchorPoint(cc.p(1,1))
    self._btnWorldBossTip:setPosition(btnSize.width+5, btnSize.height+5)
    self._btnWorldBossTip:setScale(0.8)

    self._btnWorldBoss:addChild(self._btnWorldBossTip)

end

return CampaignLayer