--背包不足弹框

local CommonPackFullPanel =  class("CommonPackFullPanel",function()
    return cc.Node:create()
end)

local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local TypeConverter = require ("app.common.TypeConverter")
local RoleInfo = require("app.cfg.role_info")


function CommonPackFullPanel:ctor(_type)
   
    assert(type(_type) == "number" and _type > 0, "CommonPackFullPanel: type error~~~~")

    self._type = _type or 0    --类型

    self:enableNodeEvents()

end

function CommonPackFullPanel:_init()

    self:setPosition(display.cx, display.cy)
 
    self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("CommonPackFullNode","common"))
    self:addChild(self._csbNode)
    ccui.Helper:doLayout(self._csbNode)

    UpdateNodeHelper.updateCommonSmallPop(self,G_LangScrap.get("common_pack_full_title"),function()
        self:removeFromParent(true)
    end)

    self:_updateView()
end

function CommonPackFullPanel:_updateView()

    local notEnoughText = ""
    local levelupTips = ""
    local functionType = 0
    local vipLevel = G_Me.vipData:getVipLevel()
    local nextVipLevel = 0
    local nextVipData = nil
    local btn1Desc = ""
    local btn2Desc = ""

    local btn2Hide = false

    local roleInfo = RoleInfo.get(G_Me.userData.level)

    if not roleInfo then
        return 
    end

    local basic_info = require("app.cfg.basic_figure_info")
    local vip_param = basic_info.get(7)
    local maxVipLevel = vip_param and tonumber(vip_param.max_limit) or 12
    local isMaxVipLevel = vipLevel >= maxVipLevel


    --提升VIP
    self._csbNode:updateButton("Button_vip", {visible = not isMaxVipLevel,
        callback = function ( ... )
            G_Popup.newPopup(function ()
                return require("app.scenes.vip.VipLayer").new()
            end)
            self:removeFromParent()
        end})

    --取下一级
    if not isMaxVipLevel then
        nextVipLevel = vipLevel + 1
    end


    --神将
    if self._type == TypeConverter.TYPE_KNIGHT then
        functionType = G_VipConst.FUNC_TYPE_KNIGHT_BAG
        notEnoughText = G_LangScrap.get("common_pack_full_knight")
        nextVipData = G_Me.vipData:getVipFunctionDataByType(functionType, true)
        if nextVipData then
            levelupTips = G_LangScrap.get("common_pack_full_knight_tip",{level=nextVipLevel, 
                maxNum = roleInfo.knight_bag_num_client + nextVipData.value_1})
        end
        btn1Desc = G_LangScrap.get("common_btn_sell_knight")
        btn2Desc = G_LangScrap.get("common_btn_enhance_knight")

    --装备
    elseif self._type == TypeConverter.TYPE_EQUIPMENT then
        functionType = G_VipConst.FUNC_TYPE_EQUIP_BAG
        notEnoughText = G_LangScrap.get("common_pack_full_equip")
        nextVipData = G_Me.vipData:getVipFunctionDataByType(functionType, true)
        if nextVipData then
            levelupTips = G_LangScrap.get("common_pack_full_equip_tip",{level=nextVipLevel, 
                maxNum = roleInfo.equipment_bag_num_client + nextVipData.value_1})
        end
        btn1Desc = G_LangScrap.get("common_btn_recycle_equip")
        btn2Desc = G_LangScrap.get("common_btn_reborn_equip")
        btn2Hide = true
    -- --宝物
    -- elseif self._type == TypeConverter.TYPE_TREASURE then
    --     functionType = G_VipConst.FUNC_TYPE_TREASURE_BAG
    --     notEnoughText = G_LangScrap.get("common_pack_full_treasure")
    --     nextVipData = G_Me.vipData:getVipFunctionDataByType(functionType, true)
    --     if nextVipData then
    --         levelupTips = G_LangScrap.get("common_pack_full_treasure_tip",{level=nextVipLevel, 
    --             maxNum = roleInfo.treasure_bag_num_client + nextVipData.value_1})
    --     end
    --     btn1Desc = G_LangScrap.get("common_btn_enhance_treasure")
    --     btn2Desc = G_LangScrap.get("common_btn_reborn_treasure")
    --     btn2Hide = true

    else
       --TODO 
    end

    self._csbNode:updateLabel("Text_goto_tip", {visible = not isMaxVipLevel, 
        text = G_LangScrap.get("common_pack_full_to_vip")})
    self._csbNode:updateLabel("Text_not_enough", notEnoughText)
    self._csbNode:updateLabel("Text_vip_tip", {visible = not isMaxVipLevel,
        text = levelupTips})


    --按钮1
    local goButton1 = self._csbNode:getSubNodeByName("Button_go1")
    UpdateButtonHelper.updateNormalButton(goButton1,
        {state = UpdateButtonHelper.STATE_NORMAL,
        desc = btn1Desc,
        callback = function( sender )
            self:_goto1Handler()
        end})

    --按钮2
    local goButton2 = self._csbNode:getSubNodeByName("Button_go2")
    UpdateButtonHelper.updateNormalButton(goButton2,
        {state = UpdateButtonHelper.STATE_ATTENTION,
        desc = btn2Desc,
        callback = function( sender )
            self:_goto2Handler()
        end})

    goButton2:setVisible(not btn2Hide)

    if btn2Hide then
        goButton1:setPositionX((goButton1:getPositionX()+goButton2:getPositionX())/2)
    end

end

function CommonPackFullPanel:_goto1Handler()
    
    if self._type == TypeConverter.TYPE_KNIGHT then
        G_ModuleDirector:pushModule(nil, function()
            return require("app.scenes.team.KnightSellLayer").new()
        end,true)
    elseif self._type == TypeConverter.TYPE_EQUIPMENT then
        G_ModuleDirector:pushModule(G_FunctionConst.FUNC_RECYCLE, function()
            return require("app.scenes.recycle.RecycleScene").new(2)
        end)
    -- elseif self._type == TypeConverter.TYPE_TREASURE then
    --     G_ModuleDirector:pushModule(nil, function()
    --         return require("app.scenes.treasure.TreasureListScene").new()
    --     end)
    end

    self:removeFromParent()
end

function CommonPackFullPanel:_goto2Handler()

    if self._type == TypeConverter.TYPE_KNIGHT then
        G_ModuleDirector:pushModule(nil, function()
            return require("app.scenes.team.TeamKnightListScene").new()
        end)
    elseif self._type == TypeConverter.TYPE_EQUIPMENT then
        G_ModuleDirector:pushModule(G_FunctionConst.FUNC_RECYCLE, function()
            return require("app.scenes.recycle.RecycleScene").new(4)
        end)
    -- elseif self._type == TypeConverter.TYPE_TREASURE then
    --     G_ModuleDirector:pushModule(G_FunctionConst.FUNC_RECYCLE, function()
    --         return require("app.scenes.recycle.RecycleScene").new(5)
    --     end)
    end

    self:removeFromParent()
end

function CommonPackFullPanel:onEnter()

    self:_init()

end

function CommonPackFullPanel:onExit()

    if self._csbNode ~= nil then
        self._csbNode:removeFromParent(true)
        self._csbNode = nil
    end
end

return CommonPackFullPanel

