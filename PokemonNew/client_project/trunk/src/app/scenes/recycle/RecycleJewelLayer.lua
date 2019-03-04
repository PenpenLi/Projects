--
--Author:                   cqh
--Desc:                     宝石分解界面
--

local ShopCommonFixedLayer = require "app.scenes.shopCommon.ShopCommonFixedLayer"
local UpdateNodeHelper = require "app.common.UpdateNodeHelper"
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local RecycleReturnBookWarLayer = require "app.scenes.recycle.RecycleReturnBookWarLayer" 
local RecycleConfirmLayer = require "app.scenes.recycle.RecycleConfirmLayer" 
local RoundEffectHelper = require "app.common.RoundEffectHelper"
local RecycleChooseJewelLayer = require("app.scenes.recycle.RecycleChooseJewelLayer")
local RecycleChooseScene = require("app.scenes.recycle.RecycleChooseScene")
local TeamUtils = require("app.scenes.team.TeamUtils")

local RecycleJewelLayer = class("RecycleJewelLayer", function()
        return display.newLayer()
    end)

function RecycleJewelLayer:ctor()
    self._selectList = {}
    self._effectNodes = {}
    self._iconNodes = {}
    self._addButtons = {}
    self._delButtons = {}
    self._iconCount = 5
    self:enableNodeEvents()
    self:_initWidget()
end

function RecycleJewelLayer:onEnter()
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_JEWEL_FENJIE_CHOOSE, self.onSelectListConfirmed, self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECYCLE_GET_DECOMPOSE_RES, self._onReceiveDecomposeReply, self)
end

function RecycleJewelLayer:_initWidget()
    self._layer = cc.CSLoader:createNode(G_Url:getCSB("RecycleJewelLayer", "recycle"))
	self._layer:updateLabel("Text_help", G_Lang.get("recycle_decompose_jewel_tips"))
    self._layer:setContentSize(display.width, display.height)
    self:addChild(self._layer)
    ccui.Helper:doLayout(self._layer)

    self._touchSwallow = self._layer:getSubNodeByName("Panel_touch_swallow")
    if self._touchSwallow then
        self._touchSwallow:setTouchEnabled(false)
    end

    for i = 1, self._iconCount do
        self._iconNodes[i] = self._layer:getSubNodeByName("Node_icon" .. i)
        self._addButtons[i] = self._layer:updateButton("Button_add"..i, {callback = function ()
            self:_openRecycleChooseLayer()
        end})
        self._delButtons[i] = self._layer:updateButton("Button_del"..i, {callback = function ()
            self._selectList[tostring(i)] = nil
            self:_updateWidget()
        end})

        local fadeout = cc.FadeTo:create(1, 80)
        local fadein= cc.FadeTo:create(1, 255)
        local seq=cc.Sequence:create(fadeout, fadein)
        local repeatAction=cc.RepeatForever:create(seq)
        self._addButtons[i]:runAction(repeatAction)
    end    

    UpdateButtonHelper.updateNormalButton(
        self._layer:getSubNodeByName("Button_auto"),{
        state = UpdateButtonHelper.STATE_NORMAL,
        desc = G_LangScrap.get("recycle_auto"),
        callback = function ()
            self:_autoAddItems()
        end
    })

    UpdateButtonHelper.updateNormalButton(
        self._layer:getSubNodeByName("Button_decompose"),{
        state = UpdateButtonHelper.STATE_ATTENTION,
        desc = G_LangScrap.get("recycle_decompose"),
        callback = function ()
            self:_decompose()
        end
    })

    self:updateButton("Button_shop", function ()
        G_ModuleDirector:pushModule(G_FunctionConst.LUANSHI_SHOP, function()
           return require("app.scenes.shopCommon.ShopCommonScene").new(ShopCommonFixedLayer.TAB_LUANSHI)
        end)
    end)	

    self._layer:updateButton("Button_help", function ()
        G_Popup.newHelpPopup(G_FunctionConst.FUNC_JEWELFENJIE)
    end)    

    self:_updateWidget()
end

function RecycleJewelLayer:_updateWidget()
    ---更新红点,在5个全部添加的情况下，自动添加按钮不显示红点
    local filedPropNum = table.nums(self._selectList)

    local canAuto = G_Me.jewelData:hasRedPointJewelRecycle()
    if canAuto and filedPropNum ~= 5 and self._aroundEffect == nil then
        self._aroundEffect = RoundEffectHelper.addNormalBtnRoundEffect(self:getSubNodeByName("Button_auto"):getSubNodeByName("Button_common"))
    elseif self._aroundEffect ~= nil and (filedPropNum == 5 or not canAuto) then
        self._aroundEffect:removeFromParent()
        self._aroundEffect = nil
    end

    for i = 1, self._iconCount do
        if(self._selectList[tostring(i)])then
            self._iconNodes[i]:setVisible(true)
            self:_updateIconNode(i, self._selectList[tostring(i)].id)
            self._addButtons[i]:setVisible(false)
            self._delButtons[i]:setVisible(true)
        else
            self._iconNodes[i]:setVisible(false)
            self._delButtons[i]:setVisible(false)
            self._addButtons[i]:setVisible(true)
        end
    end

    UpdateNodeHelper.updateCommonSysResNode(
        self._layer:getSubNodeByName("Node_item_info"),
        G_TypeConverter.TYPE_WEIWANG,
        1,
         G_Me.userData.weiwang
        ,nil,nil,G_Colors.title[11],nil,true--,G_Colors.outline[12]
    )    
end

-- 更新Icon显示内容
function RecycleJewelLayer:_updateIconNode(index, id)
    local data = G_Me.jewelData:getJewelDataById(id)
    local param = 
    {
        type = G_TypeConverter.TYPE_JEWEL,
        value = data.base_id,
        nameVisible = true,
        disableTouch = true,
        bgVisible = false,
        namePosY = 20,
        isOutline = true,
        isImageUrl = true
    }
    local nodeIcon = self._iconNodes[index]
    local nameTxt = nodeIcon:getSubNodeByName("Text_icon_name")
    local nameContent = nameTxt:getContentSize()
    nameTxt:setContentSize(nameContent.width + 40, nameContent.height)
    local bgImage = nodeIcon:getSubNodeByName("Image_icon_bg")
    bgImage:setPositionY(- 30)
    nodeIcon:updateLabel("Text_item_num", {
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE, 
        outlineSize = 2
    })
    UpdateNodeHelper.updateCommonIconItemNode(nodeIcon, param)
    -- self._effectNodes[index] = nodeIcon:getSubNodeByName("Image_icon_icon"):clone()
    -- self._effectNodes[index]:retain()
    -- self._effectNodes[index]:setContentSize(cc.size(100,100))
    -- self._nodeScale = 0.3
end

-- 打开装备材料选择界面
function RecycleJewelLayer:_openRecycleChooseLayer()
    local jewels = G_Me.jewelData:getUnSetJewelList()

    if #jewels == 0 then
        G_Popup.tip(G_LangScrap.get("recycle_no_more_equips_materials"))
        return
    end
    
	G_ModuleDirector:pushModule(nil,function ()
        local layer = RecycleChooseJewelLayer.new(self._selectList)
        return RecycleChooseScene.new(layer)
    end)
end

--选择宝石列表选择确定回调
function RecycleJewelLayer:onSelectListConfirmed( selectList )
    self._selectList = {}
    for k, v in ipairs(selectList)do
        self._selectList[tostring(k)] = v
    end
    self:_updateWidget()
end

-- 自动添加宝石
function RecycleJewelLayer:_autoAddItems()
    local selecteds = G_Me.jewelData:getAutoRecycleJewels()
	if #selecteds == 0 then
		G_Popup.tip(G_LangScrap.get("recycle_no_more_extra_equip_materials"))
        return
	end

    self._selectList = {}
    local num = #selecteds >= 5 and 5 or #selecteds
    for i = 1, num do        
        self._selectList[tostring(i)] = selecteds[i]
    end
	self:_updateWidget()
end

function RecycleJewelLayer:_decompose()
    if table.nums(self._selectList) == 0 then
        G_Popup.tip(G_Lang.get("recycle_add_equips_material_first"))
        return
    end

    --预览返还材料
    local ret, isConfirm = self:_getReturnResource()
    dump(ret)
    local preview = function ()
        RecycleReturnBookWarLayer.popup(ret, function ()
            local r = {}
            for i=1, self._iconCount do
                local jewelData = self._selectList[tostring(i)]
                if jewelData then
                    local item = {
                        type = G_TypeConverter.TYPE_JEWEL,
                        value = jewelData.id,
                        size = 1
                    }
                    r[#r+1] = item
                end
            end

            G_HandlersManager.recycleHandler:recovery(r)
        end)
    end

    if isConfirm then
        --高品质装备需要确认
        local text = G_Lang.get("recycle_purple_jewel_decompose_tips")
        RecycleConfirmLayer.popup(text, preview)
    else
        preview()
    end

end

function RecycleJewelLayer:_onReceiveDecomposeReply( data )
    if(data.ret ~= 1)then return end
    self._awards = data.awards
    self._touchSwallow:setTouchEnabled(true)
    local num = table.nums(self._selectList)
    for i = 1, num do
        self._effectNodes[i] = self._iconNodes[i]:getSubNodeByName("Image_icon_icon"):clone()
        self._effectNodes[i]:retain()
        self._effectNodes[i]:setContentSize(cc.size(100,100))
        self._nodeScale = 0.3        
        local posX,posY = self._iconNodes[i]:getPosition()
        TeamUtils.playEffect("effect_fenjie",{x=posX,y=posY},self._iconNodes[i]:getParent(),"finish",function()
            if self._awards then
                G_Popup.awardSummary(self._awards, nil, nil, function()
                    G_widgets:getTopBar():resumeWidget()
                    self._touchSwallow:setTouchEnabled(false)

                    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false)
                end)
                self._awards = nil
            end
        end,1.40,{name = "item_3",node = self._effectNodes[i],scale = self._nodeScale})
    end

    self._selectList = {}
    self:_updateWidget()    
end

-- 获取返还材料数据
function RecycleJewelLayer:_getReturnResource()
    local idlist = {}
    for _, v in pairs(self._selectList)do
        idlist[#idlist+1] = v.id
    end
	local returns, isConfirm = G_Me.jewelData:getResolveRes(idlist)
    return returns, isConfirm
end

function RecycleJewelLayer:onExit()
end

function RecycleJewelLayer:onCleanup()
    uf_eventManager:removeListenerWithTarget(self)
end

return RecycleJewelLayer