--
-- Author: Your Name
-- Date: 2018-01-24 14:16:45
--
---=====================
--- 装备传承layer
--RecycleEquipInheritLayer.lua
---=====================
local RecycleEquipInheritLayer = class("RecycleEquipInheritLayer", function ()
	return display.newLayer()
end)

local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local TeamUtils = require "app.scenes.team.TeamUtils"
local EquipCommon = require("app.scenes.equip.EquipCommon")

function RecycleEquipInheritLayer:ctor(size)
	self:enableNodeEvents()
    self:setTouchEnabled(false)
    self._csbNode = nil

    self._attrPanel = nil -- 属性面板
    self._equipNode = nil -- 装备
    self._eqBeginPosY = nil -- 装备节点初始垂直位置
    self._touchSwallow = nil -- 触摸吞噬层

    self._tabSize = size or cc.size(0, 0)
    self._awards = {} 

    self._parentEquipId = nil -- 父装备Id
    self._childEquipId = nil -- 子装备id 
end

function RecycleEquipInheritLayer:onEnter()
	print("RecycleEquipInheritLayer:onEnter")
	self:_initUI()
	uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_EQUIPMENT_INHERITANCE_RET, self._recvMsg, self)
end

function RecycleEquipInheritLayer:onExit()
    self._parentEquipId = nil -- 父装备Id
    self._childEquipId = nil -- 子装备id 
    if self._csbNode ~= nil then
        self._csbNode:removeFromParent()
    end
    uf_eventManager:removeListenerWithTarget(self)
end

function RecycleEquipInheritLayer:_initUI()
    if self._csbNode == nil then
        self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("RecycleTabEquipInheritLayer", "recycle"))
        self:addChild(self._csbNode)
        self._csbNode:setContentSize(cc.size(display.width,display.height))
        ccui.Helper:doLayout(self._csbNode)
    end

	self._attrPanel = self._csbNode:getSubNodeByName("Panel_attr")
    self._equipNode = self._csbNode:getSubNodeByName("Node_select")
    self._eqBeginPosY = self._equipNode:getPositionY()

    self._touchSwallow = self._csbNode:getSubNodeByName("Panel_touch_swallow")
    self._touchSwallow:setTouchEnabled(true)
    self._touchSwallow:setVisible(false)

    self._csbNode:updatePanel("Panel_parent", {
        callback = function ( ... )
            self:_onSelectEquip(EquipCommon.EQUIP_PARENT_TYPE)
        end
        })
    self._csbNode:updatePanel("Panel_child", {
        callback = function ( ... )
            self:_onSelectEquip(EquipCommon.EQUIP_CHILD_TYPE)
        end
        })

    self._csbNode:updateLabel("Text_costValue", {
        text = tostring(G_Me.equipData:getInheritedMoney()),
        })

    --传承
    UpdateButtonHelper.updateNormalButton(
        self._csbNode:getSubNodeByName("Button_inherit"),{
        state = UpdateButtonHelper.STATE_ATTENTION,
        desc = "传承",
        callback = function ()
            G_HandlersManager.equipHandler:sendEquipInheritance(self._parentEquipId,self._childEquipId)
            dump(self._childEquipId)
        end
    })

    --帮助
    --local helpText = G_Lang.get("recycle_help_equip_inherit")
    local btnHelp = self._csbNode:getSubNodeByName("Button_help")
    btnHelp:addClickEventListenerEx(function (sender)
    	G_Popup.newHelpPopup(G_FunctionConst.FUNC_EQUIP_INHERIT)
    end)

	self:_fresh()
end

function RecycleEquipInheritLayer:_recvMsg(data)
    print("传承 recv data:")
    dump(data)
    local paraentData = G_Me.equipData:getEquipInfoByID(data.eq_id)
    local awardsList = rawget(data, "awards") or {}
    --dump(data.awards)
    --加入子装备
    dump(self._childEquipId)
    local childData = G_Me.equipData:getEquipInfoByID(self._childEquipId)
    local award1 = {
        type = G_TypeConverter.TYPE_EQUIPMENT,
        value = childData.cfgData.id,
        sizeVisible = false,
        level = childData.serverData.level,
        levelVisible = true,
    }
    --加入父装备,是新生成的一件装备
    local paraentData = G_Me.equipData:getEquipInfoByID(data.eq_id)
    local award2 = {
        type = G_TypeConverter.TYPE_EQUIPMENT,
        value = paraentData.cfgData.id,
        sizeVisible = false,
        level = paraentData.serverData.level,
        levelVisible = true,
    }
    table.insert(awardsList, 1,award2)
    table.insert(awardsList, 1,award1)
    
    
	self._touchSwallow:setVisible(true)
	TeamUtils.playEffect("effect_wujiangchongsheng",{x=0,y=0},self._csbNode:getSubNodeByName("Node_inherit_effect"),"finish",function()
        self._childEquipId = nil
        self._parentEquipId = nil
        self:_fresh()
	   	G_Popup.awardSummary(awardsList, nil, nil, function()
			G_widgets:getTopBar():resumeWidget()
			self._touchSwallow:setVisible(false)
	    	uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false)
	    end)
	end)
end

function RecycleEquipInheritLayer:_onSelectEquip(e_type)
    local data = G_Me.equipData:getInheritEquipList(self._parentEquipId,self._childEquipId)
    --dump(data)
    if #data == 0 then
        G_Popup.tip(G_Lang.get("recycle_inherit_not_equips"))
        return
    end
    local layer = require("app.scenes.recycle.RecycleChooseEquipInheritLayer").new(handler(self, self._selectBack),e_type,
        data)
    display.getRunningScene():addToPopupLayer(layer)
end

function RecycleEquipInheritLayer:_selectBack(in_type,equipId)
    if in_type == EquipCommon.EQUIP_PARENT_TYPE then
        self._parentEquipId = equipId
    elseif in_type == EquipCommon.EQUIP_CHILD_TYPE then
        self._childEquipId = equipId
    end

    self:_fresh()
end

function RecycleEquipInheritLayer:_fresh()
    dump(self._parentEquipId)
    dump(self._childEquipId)
	if not self._parentEquipId and not self._childEquipId then
		self._attrPanel:setVisible(false)
    	self._equipNode:setPositionY(self._eqBeginPosY - 20)
    else
    	self._attrPanel:setVisible(true)
    	self._equipNode:setPositionY(self._eqBeginPosY - 10)
    	
	end

    self:_showConvertLevel()
    self:_updateParentEquip()
    self:_updateChildEquip()
	self:_updateBottomShow()
end

function RecycleEquipInheritLayer:_showConvertLevel()
    local parentLvNode = self._csbNode:getSubNodeByName("Node_convert_parent")
    local childLvNode = self._csbNode:getSubNodeByName("Node_convert_child")
    if not self._parentEquipId or not self._childEquipId then
        parentLvNode:setVisible(false)
        childLvNode:setVisible(false)
        return
    end

    parentLvNode:setVisible(false)
    childLvNode:setVisible(false)
    EquipCommon.playBlinkEffect1(parentLvNode)
    EquipCommon.playBlinkEffect1(childLvNode)

    --父装备等级变化
    local equipData = G_Me.equipData:getEquipInfoByID(self._parentEquipId)
    assert(equipData,"equip data error with id = "..self._parentEquipId)

    parentLvNode:updateLabel("Text_cur_level", {
        text = "LV"..tostring(equipData.serverData.level),
        })
    parentLvNode:updateLabel("Text_end_level", {
        text = "LV"..tostring(1),
        })

    --子装备等级变化
    equipData = G_Me.equipData:getEquipInfoByID(self._childEquipId)
    assert(equipData,"equip data error with id = "..self._childEquipId)

    local inheritedInfo = G_Me.equipData:getInheritedEquipInfo(self._parentEquipId,self._childEquipId)
    local level = inheritedInfo.enhanceLv

    childLvNode:updateLabel("Text_cur_level", {
        text = "LV"..tostring(equipData.serverData.level),
        })
    childLvNode:updateLabel("Text_end_level", {
        text = "LV"..tostring(level),
        })
end

function RecycleEquipInheritLayer:_updateParentEquip()
	--icon
	local iconNode = self._equipNode:getSubNodeByName("Node_parent")
	local imgAdd = iconNode:getChildByName("Image_add")
	if not self._parentEquipId then
		iconNode:updateLabel("Text_e_level", {
			text = "",
			})
		local params = {
	        icon = G_Url:getUI_common_special("spe_add01"),
            iconVisible = false,
	        color = 1,
	        levelVisible = false,
	        nameVisible = false,
	        --scale = 0.8,
	    }

	    UpdateNodeHelper.updateCommonModuleIconNode(iconNode,params)

	    --+号
	    imgAdd:setVisible(true)
	    TeamUtils.playBlinkEffect(imgAdd)
	else
		local equipData = G_Me.equipData:getEquipInfoByID(self._parentEquipId)
		assert(equipData,"equip data error with id = "..self._parentEquipId)

		iconNode:updateLabel("Text_e_level", {
			text = "LV:"..tostring(equipData.serverData.level),
			textColor = G_Colors.getColor(12),
			outlineColor = G_Colors.getOutlineColor(12),
			})

		local params = {
        type = G_TypeConverter.TYPE_EQUIPMENT,
	        value = equipData.cfgData.id,
	        sizeVisible = false,
	        levelVisible = false,
	        nameVisible = true,
            isOutline = true,
	    }

		UpdateNodeHelper.updateCommonIconKnightNode(iconNode,params)

		--+号
	    imgAdd:setVisible(false)
	end
    --attr
    self:_updateParentAttr()
end

function RecycleEquipInheritLayer:_updateChildEquip()
	--icon
	local iconNode = self._equipNode:getSubNodeByName("Node_child")
	local imgAdd = iconNode:getChildByName("Image_add")

	if not self._childEquipId then
		iconNode:updateLabel("Text_e_level", {
			text = "",
			})
		local params = {
	        icon = "",
	        color = 1,
	        levelVisible = false,
	        iconVisible = false,
	        nameVisible = false,
	        --scale = 0.8,
	    }

	    UpdateNodeHelper.updateCommonModuleIconNode(iconNode,params)
	    --+号
	    imgAdd:setVisible(true)
	    TeamUtils.playBlinkEffect(imgAdd)
	else
		local equipData = G_Me.equipData:getEquipInfoByID(self._childEquipId)
        local level = equipData.serverData.level
		if self._parentEquipId then
            local inheritedInfo = G_Me.equipData:getInheritedEquipInfo(self._parentEquipId,self._childEquipId)
			level = inheritedInfo.enhanceLv
		end
		
		assert(equipData,"equip data error with id = "..self._childEquipId)

		iconNode:updateLabel("Text_e_level", {
			text = "LV:"..tostring(level),
            visible = true,
			textColor = G_Colors.getColor(12),
			outlineColor = G_Colors.getOutlineColor(12),
			})

		local params = {
        type = G_TypeConverter.TYPE_EQUIPMENT,
	        value = equipData.cfgData.id,
	        sizeVisible = false,
	        levelVisible = false,
	        nameVisible = true,
            isOutline = true,
	    }

		UpdateNodeHelper.updateCommonIconKnightNode(iconNode,params)
		--+号
	    imgAdd:setVisible(false)
	end
    --attr
    self:_updateChildAttr()
end

function RecycleEquipInheritLayer:_updateParentAttr()
    local parentPanel = self._csbNode:getSubNodeByName("Panel_attr_lf")

    if not self._parentEquipId then
        parentPanel:setVisible(false)
        return
    else
        parentPanel:setVisible(true)
    end
	local attrs = EquipCommon.getAttrsDescription(self._parentEquipId, "xilian")
    local attrNum = math.min(table.nums(attrs),EquipCommon.XILIAN_ATTR_NUM)

    -- 本阶属性
    local textName -- 自己创建的text
    local maxSizeWidth = 0
    for i=1, EquipCommon.XILIAN_ATTR_NUM do
        --属性title
        local typeLabel = self:getSubNodeByName("Text_curLvel_type"..i)
        local attrLabel = parentPanel:getChildByName("Text_curLvel_attr"..i)
        local attrAdd = parentPanel:getChildByName("Text_curLvel_max"..i)
        if i > attrNum then
            if typeLabel then
                typeLabel:setVisible(false)
            end
            if attrLabel then
                attrLabel:setVisible(false)
            end
            if attrAdd then
                attrAdd:setVisible(false)
            end
        else
            parentPanel:updateLabel("Text_curLvel_type"..i,
            { text = attrs[i].type ,
            visible = true,
            textColor = G_Colors.getColor(25),
            --outlineColor = G_Colors.getOutlineColor(17),
            fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL})

            -- 属性值
            textName = "Text_curLvel_attr"..i
            EquipCommon.updateCreatedLabel({
                parent = parentPanel,
                name = textName,
                strContent = attrs[i].value,
                preNode = typeLabel,
                color = G_Colors.getColor(11),
                --outlineColor = G_Colors.getOutlineColor(17),
                showAni = false})

            --maxvalue
            local attrLabel = parentPanel:getChildByName(textName)
            if attrLabel then
                textName = "Text_curLvel_max"..i
                local textNum = "（"..attrs[i].max_value.."）"  
                EquipCommon.updateCreatedLabel({
                parent = parentPanel,
                name = textName,
                strContent = textNum,
                preNode = attrLabel,
                color = G_Colors.getColor(101),
                outlineColor = G_Colors.getOutlineColor(101),
                showAni = false})
            end

            local txt_attr = parentPanel:getChildByName("Text_curLvel_attr"..i)
            if txt_attr:getContentSize().width > maxSizeWidth then
                maxSizeWidth = txt_attr:getContentSize().width
            end
        end
    end

    --调整最大属性位置
    for i=1, attrNum do
        local numText = parentPanel:getSubNodeByName("Text_curLvel_attr"..i)
        local maxText = parentPanel:getSubNodeByName("Text_curLvel_max"..i)
        maxText:setPositionX(numText:getPositionX()+maxSizeWidth+5)
    end
end

function RecycleEquipInheritLayer:_updateChildAttr()
    local parentPanel = self._csbNode:getSubNodeByName("Panel_attr_rt")
    if not self._childEquipId then
        parentPanel:setVisible(false)
        return
    else
        parentPanel:setVisible(true)
    end

    local attrs = nil
    -- if self._parentEquipId and self._childEquipId then
    --     attrs = G_Me.equipData:getInheritedEquipAttr(self._parentEquipId,self._childEquipId)
    -- else
        attrs = EquipCommon.getAttrsDescription(self._childEquipId, "xilian")
    --end
    local attrNum = math.min(table.nums(attrs),EquipCommon.XILIAN_ATTR_NUM)
    

    -- 本阶属性
    local textName -- 自己创建的text
    local maxSizeWidth = 0
    for i=1, EquipCommon.XILIAN_ATTR_NUM do
        --属性title
        local typeLabel = self:getSubNodeByName("Text_nextLvl_type"..i)
        local attrLabel = parentPanel:getChildByName("Text_nextLvl_attr"..i)
        local attrAdd = parentPanel:getChildByName("Text_nextLvl_max"..i)
        if i > attrNum then
            if typeLabel then
                typeLabel:setVisible(false)
            end
            if attrLabel then
                attrLabel:setVisible(false)
            end
            if attrAdd then
                attrAdd:setVisible(false)
            end
        else
            parentPanel:updateLabel("Text_nextLvl_type"..i,
            { text = attrs[i].type ,
            visible = true,
            textColor = G_Colors.getColor(25),
            --outlineColor = G_Colors.getOutlineColor(17),
            fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL})

            -- 属性值
            textName = "Text_nextLvl_attr"..i
            --EquipCommon.updateCreatedLabel(parentPanel,textName,attrs[i].value,typeLabel)
            EquipCommon.updateCreatedLabel({
                parent = parentPanel,
                name = textName,
                strContent = attrs[i].value,
                preNode = typeLabel,
                color = G_Colors.getColor(11),
                --outlineColor = G_Colors.getOutlineColor(17),
                showAni = false})

            --maxvalue
            local attrLabel = parentPanel:getChildByName(textName)
            if attrLabel then
                textName = "Text_nextLvl_max"..i
                local textNum = "（"..attrs[i].max_value.."）"  
                --EquipCommon.updateCreatedLabel(parentPanel,textName,textNum,attrLabel,G_Colors.getColor(13),G_Colors.getOutlineColor(13))
                EquipCommon.updateCreatedLabel({
                parent = parentPanel,
                name = textName,
                strContent = textNum,
                preNode = attrLabel,
                color = G_Colors.getColor(101),
                outlineColor = G_Colors.getOutlineColor(101),
                showAni = false})
            end

            local txt_attr = parentPanel:getChildByName("Text_nextLvl_attr"..i)
            if txt_attr:getContentSize().width > maxSizeWidth then
                maxSizeWidth = txt_attr:getContentSize().width
            end
        end
    end

    --调整最大属性位置
    for i=1, attrNum do
        local numText = parentPanel:getSubNodeByName("Text_nextLvl_attr"..i)
        local maxText = parentPanel:getSubNodeByName("Text_nextLvl_max"..i)
        maxText:setPositionX(numText:getPositionX()+maxSizeWidth+5)
    end
end

function RecycleEquipInheritLayer:_updateBottomShow()
	local node_tips = self._csbNode:getSubNodeByName("Node_tips")
	local node_inherit = self._csbNode:getSubNodeByName("Node_inherit")

	local isCanInherit = self._parentEquipId ~= nil and self._childEquipId ~= nil

	node_tips:setVisible(not isCanInherit)
	node_inherit:setVisible(isCanInherit)
end

return RecycleEquipInheritLayer