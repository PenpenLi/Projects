--
-- Author: Your Name
-- Date: 2018-02-27 11:29:56
--
--otherBookWarDetailLayer.lua

--[====================[

    其他人兵书详情layer
    
]====================]

local otherBookWarDetailLayer=class("otherBookWarDetailLayer",function()
    return cc.Layer:create()
end)

local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local BookWarCommon = require("app.scenes.bookWar.BookWarCommon")
local BookWarInfo = require("app.cfg.bookwar_info")
local EffectNode = require("app.effect.EffectNode")
local ParameInfo = require ("app.cfg.parameter_info")

local AttrOffsetX = 5
--[[
@param = {
    id = 1111, 装备serverId
    pos = 1,阵位
    slot = 1,槽位
}
@data：阵容数据
]]
function otherBookWarDetailLayer:ctor(params,data)
    assert(type(data) == "table", "otherBookWarDetailLayer:params error~")
    self._teamData = data
    self._userData = self._teamData:getUserData()
    self._bookWarId = params.id or 0  --当前装备ID
    self._pos = params.pos or 0
    self._slot = params.slot or 0
    print("self._bookWarId,pospospospos=============",self._bookWarId,params.pos,params.slot)
    self._curPageIndex = 1
    self._bookWarData = nil           -- 当前装备数据
    self:enableNodeEvents()

    self._bookWars = {}  --兵书数据

    self._pageView = nil
    self._btnChange = nil
    self._btnUnload = nil
    self._btnLf = nil
    self._btnRt = nil
end

function otherBookWarDetailLayer:onEnter()

    self:_initUI()
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_CHANGE_EQUIPMENT,self._onRecvEquipWeared,self)
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_TREASURE_CHANGE,self._onRecvEquipUnload,self)

    uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_GUIDE_STEP, nil, false)

end

function otherBookWarDetailLayer:onExit()
    uf_eventManager:removeListenerWithTarget(self)
    if self._csbNode ~= nil then
        self._csbNode:removeFromParent(true)
        self._csbNode = nil
    end
end

function otherBookWarDetailLayer:_initUI( ... )
    -- body

    self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("BookWarDetailLayer","bookWar"))
    self:addChild(self._csbNode)
    self._csbNode:setContentSize(display.width,display.height)
    ccui.Helper:doLayout(self._csbNode)

    local image_bg = self._csbNode:getSubNodeByName("Image_bg_all")
    G_WidgetTools.autoTransformBg(image_bg)

    self:updateButton("Button_close", {
        callback = function(sender)
            self:removeFromParent()
        end})

    --隐藏所有养成按钮
    local btn_enhance = self._csbNode:getSubNodeByName("Button_enhance")
    local btn_refine = self._csbNode:getSubNodeByName("Button_jinglian")
    btn_enhance:setVisible(false)
    btn_refine:setVisible(false)

    -- local btnChange = self._csbNode:getSubNodeByName("Button_change")
    -- local btnUnload = self._csbNode:getSubNodeByName("Button_unload")

    -- btnChange:addClickEventListenerEx(handler(self,self._onEquipChangeClick))
    -- btnUnload:addClickEventListenerEx(handler(self,self._onEquipUnloadClick))

    --更换卸载按钮是否隐藏  暂时屏蔽
    self._csbNode:getSubNodeByName("Image_bot_mask"):setVisible(false)

    --重新定位并设置scroll contentsize
    self._scrollCon1 = self._csbNode:getSubNodeByName("Image_base")
    self._scrollCon2 = self._csbNode:getSubNodeByName("Image_enhance")
    self._scrollCon3 = self._csbNode:getSubNodeByName("Image_jinglian")
    self._scrollCon4 = self._csbNode:getSubNodeByName("Image_describe") 

    local scrollView = self._csbNode:getSubNodeByName("ScrollView_info")
    scrollView:setScrollBarEnabled(false)
    self._scrollViewSize = scrollView:getContentSize()

    local img_shade = self._csbNode:getSubNodeByName("Image_translucent")
    local shade_size = img_shade:getContentSize()

    --调整位置
    --if not self._isFromTeam then
    scrollView:setContentSize(self._scrollViewSize.width, self._scrollViewSize.height + 60)
    img_shade:setContentSize(shade_size.width,shade_size.height + 64)
    local scrollViewParent = scrollView:getParent()
    scrollViewParent:setPositionY(-12)
    scrollViewParent:setContentSize(scrollViewParent:getContentSize().width,
        scrollViewParent:getContentSize().height + 60)
    self._scrollViewSize = scrollViewParent:getContentSize()
    scrollViewParent:getSubNodeByName("Node_item_name"):setPositionY(self._scrollViewSize.height - 45)
    --end

    
    self._btnLf = self._csbNode:getSubNodeByName("Button_lf")
    self._btnLf:setVisible(false)
    self._btnRt = self._csbNode:getSubNodeByName("Button_rt")
    self._btnRt:setVisible(false)


    --装备page
    --------------------------
    self._pageView = self:getSubNodeByName("PageView_item")
    self._pageView:setTouchEnabled(true)

    local pageSize = self._pageView:getContentSize()

    self._bookWars = {} 

    -- if self._pos > 0 and self._isFromTeam then
    --     self._btnLf:addClickEventListenerEx(handler(self,self._onTurnLeft))
    --     self._btnRt:addClickEventListenerEx(handler(self,self._onTurnRight))
    --     self._btnLf:setVisible(true)
    --     self._btnRt:setVisible(true)
    --     local bookWarNum = 0

    --     for pos=1, 6 do
    --         local resourceData =  G_Me.teamData:getPosResourcesByFlag(pos, 2)
    --         if resourceData then
    --             for i = 1, 2 do
    --                 local bookWarId = resourceData["slot_"..i]

    --                 --可能为nil
    --                 if bookWarId and bookWarId > 0 then
    --                     bookWarNum = bookWarNum + 1
    --                     self._bookWarIds[#self._bookWarIds + 1] = {id = bookWarId,pos = pos,slot = i}

    --                     if bookWarId == self._bookWarId then
    --                         self._curPageIndex = bookWarNum
    --                     end

    --                     local page = self:_createPage(bookWarId, pageSize)
    --                     self._pageView:addPage(page)
    --                 end
    --             end
    --         end
    --     end

    --     self._pageView:addEventListener(handler(self,self._onPageChange))
    --     self._pageView:setCurrentPageIndex(self._curPageIndex-1)
    --     self:_jumpToPage(self._curPageIndex)

    -- else
    --     local page = self:_createPage(self._bookWarId, pageSize)
    --     self._pageView:addPage(page)
    --     self._pageView:setTouchEnabled(false)
    --     self:_updateView()
    -- end
    local bookwar = self._teamData:getTreasureData(self._pos,self._slot)
    assert(bookwar ~= nil,"other's bookwar data error")
    self._bookWarData = bookwar

    local page = self:_createPage(self._bookWarData, pageSize)
    self._pageView:addPage(page)
    self._pageView:setTouchEnabled(false)
    self:_updateView()
end

function otherBookWarDetailLayer:_createPage( data, pageSize )
    -- body
    local page = ccui.Layout:create()
    page:setContentSize(pageSize.width, pageSize.height)

    local cfgData = data.cfgData

    local imageUrl = G_Url:getImage_treasure(cfgData.res_id)
    local bookWarImage = ccui.ImageView:create(imageUrl)
    bookWarImage:setScale(BookWarCommon.BOOKWAR_NORMAL_SCALE)
    bookWarImage:setContentSize(250,250)
    bookWarImage:setAnchorPoint(cc.p(0.5, 0.5))
    bookWarImage:setPosition(cc.p(pageSize.width*0.55,pageSize.height*0.60))

    BookWarCommon.playFloatEffect(bookWarImage)

    page:addChild(bookWarImage)

    return page
end

--穿戴
function otherBookWarDetailLayer:_onEquipChangeClick( sender )
    -- body
    local list = G_Me.bookWarData:getBookWarInfoListByTypeUnWear(self._slot) or {}
    if(#list < 1)then
        G_Popup.tip(G_Lang.get("book_war_no_other"))
        return
    end

    local layer = require("app.scenes.bookWar.BookWarChangeLayer").new(self._pos,self._slot,true)
    display.getRunningScene():addToPopupLayer(layer)
end

--卸下
function otherBookWarDetailLayer:_onEquipUnloadClick( sender )
    -- body
    G_HandlersManager.bookWarHandler:sendEquipBookWar(self._pos,self._slot,0)
end

function otherBookWarDetailLayer:_enhance()
    local isFromPack = false
    if not self._isFromTeam then    
        isFromPack = true
    end

    G_ModuleDirector:replaceModule(G_FunctionConst.FUNC_BOOKWAR_ENHANCE,function ()
        return require("app.scenes.bookWar.BookWarDevelopScene").new(self._bookWarId, 1,isFromPack)
    end)

end


function otherBookWarDetailLayer:_onclickJinglian()
    local isFromPack = false
    if not self._isFromTeam then    
        isFromPack = true
    end

    G_ModuleDirector:replaceModule(G_FunctionConst.FUNC_BOOKWAR_REFINE,function ()
        return require("app.scenes.bookWar.BookWarDevelopScene").new(self._bookWarId, 2,isFromPack)
    end)
end

--点击左箭头
function otherBookWarDetailLayer:_onTurnLeft( sender )
    -- body
    local targetPos = math.max(self._curPageIndex - 1,1)
    self:_jumpToPage(targetPos)
    self._pageView:scrollToPage(targetPos - 1)
end

--点击右箭头
function otherBookWarDetailLayer:_onTurnRight( sender )
    -- body
    local pageCount = #(self._pageView:getItems())
    local targetPos = math.min(self._curPageIndex + 1,pageCount)
    self:_jumpToPage(targetPos)
    self._pageView:scrollToPage(targetPos - 1)
end


--翻页事件
function otherBookWarDetailLayer:_onPageChange( sender,eventType )
    -- body
    if eventType == ccui.PageViewEventType.turning then
        local newPageIndex = self._pageView:getCurrentPageIndex()
        local targetPos = newPageIndex + 1
        if(targetPos ~= self._curPageIndex)then
            self:_jumpToPage(targetPos)
        end
    end
end

function otherBookWarDetailLayer:_jumpToPage( page )
    -- body
    self._curPageIndex = page

    self._bookWarId = self._bookWarIds[self._curPageIndex].id

    self._slot = self._bookWarIds[self._curPageIndex].slot

    self._pos = self._bookWarIds[self._curPageIndex].pos

    self:_updateView()

    self:_updateArrowStatus()
end

--更新箭头的显示状态
function otherBookWarDetailLayer:_updateArrowStatus( ... )
    -- body
    local pos = self._curPageIndex

    local pageCount = #(self._pageView:getItems())

    if pageCount == 1 then
        self._btnLf:setVisible(false)
        self._btnRt:setVisible(false)  
    elseif pos >= pageCount  then
        self._btnLf:setVisible(true)
        self._btnRt:setVisible(false)
    elseif pos <= 1 then
        self._btnLf:setVisible(false)
        self._btnRt:setVisible(true)
    else
        self._btnLf:setVisible(true)
        self._btnRt:setVisible(true)    
    end
end

function otherBookWarDetailLayer:_updateView()

    -- self._bookWarData = G_Me.bookWarData:getbookWarInfoByID(self._bookWarId)
    -- assert(type(self._bookWarData) == "table", " bookwar data error~~~~~~")

    local color = G_TypeConverter.quality2Color(self._bookWarData.cfgData.quality)

    --类型(兵书、符印)
    self:updateImageView("Image_category", G_Url:getTreasureTypeImage(self._bookWarData.cfgData.type))
    -- self:updateLabel("Text_bookWar_type",{
    --     text = G_Lang.get("book_war_type"..tostring(self._bookWarData.cfgData.type)),
    --     textColor = G_Colors.qualityColor2Color(color),
    --     --outlineColor = G_Colors.qualityColor2OutlineColor(color),
    --     })

    -- 品质
    self:updateLabel("Text_quality",{
        text = G_Lang.get("equip_text_quality_color"..tostring(color)),
        textColor = G_Colors.qualityColor2Color(color,true),
        outlineColor = G_Colors.qualityColor2OutlineColor(color),
        })

    --兵书名
    local itemName = self._csbNode:getSubNodeByName("Text_itemName")
    self:updateLabel("Text_itemName",{
        text = self._bookWarData.cfgData.name,
        textColor = G_Colors.qualityColor2Color(color),
        --outlineColor = G_Colors.qualityColor2OutlineColor(color),
        fontSize = 25
        })

    -- 神将名
    -- if self._isFromTeam then
    --     self._pos = self._bookWarIds[self._curPageIndex].pos
    --     print("knight_pos knight_pos=====",self._pos)
    -- end

    --G_Me.teamData:setTeamLayerInitPos(self._pos)

    --神将名称
    local textName = self._csbNode:getSubNodeByName("Text_knighName")
    if self._pos < 1 then
        textName:setString("")
        textName:setVisible(false)
    else
        textName:setVisible(true)
        local knightData = self._teamData:getKnightDataByPos(self._pos)
        local knightColor = G_TypeConverter.quality2Color(knightData.cfgData.quality)
        print("knightData.cfgData.name",knightData.cfgData.name)
        if knightData.cfgData.type == 1 then -- 主角
            self._csbNode:updateLabel("Text_knighName", {
                text = "（"..self._userData.name.."）",
                textColor = G_Colors.qualityColor2Color(knightColor),
                --outlineColor = G_Colors.qualityColor2OutlineColor(knightColor),
                fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL
                })
        else
            self._csbNode:updateLabel("Text_knighName", {
                text = "（"..knightData.cfgData.name.."）",
                textColor = G_Colors.qualityColor2Color(knightColor),
                --outlineColor = G_Colors.qualityColor2OutlineColor(knightColor),
                fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL
                })
        end
    end

    --名字节点居中
    local nameNode = self._csbNode:getSubNodeByName("Node_item_name")
    local totalW = itemName:getPositionX()+itemName:getContentSize().width + textName:getContentSize().width
    textName:setPositionX(itemName:getPositionX()+itemName:getContentSize().width + AttrOffsetX)
    nameNode:setPositionX(display.width/2 - totalW/2)

    --资质
	UpdateNodeHelper.updateQualityLabel(self._csbNode:getSubNodeByName("Text_potential"),
		color, 
		G_Lang.get("equip_text_quality",{quality=self._bookWarData.cfgData.quality}))
	
    -- 兵书属性
    self:_updateBase()
    self:_updateEnhance()
    self:_updateJinglian()

    --描述
    self:updateLabel("Text_describe",{text=self._bookWarData.cfgData.directions,
        textColor=G_Colors.getColor(2), fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL})

    --属性排版
    self:_resizeAttrPanel()
end

--属性面板排版
function otherBookWarDetailLayer:_resizeAttrPanel()
    local scrollView = self._csbNode:getSubNodeByName("ScrollView_info")
    local scrollViewSize = self._scrollViewSize

    local spaceY = 0
    local conH1 = self._scrollCon1:getContentSize().height
    local conH2 = self._scrollCon2:getContentSize().height
    local conH3 = self._scrollCon3:getContentSize().height
    local conH4 = self._scrollCon4:getContentSize().height

    local conList = {}
    local HList = {}

    local attrs = self:_getAttrsDescription(self._bookWarData, "base")
    self._scrollCon1:setVisible(#attrs > 0)
    if #attrs > 0 then
        conList = {self._scrollCon1,self._scrollCon2,self._scrollCon3,self._scrollCon4}
        HList = {conH1,conH2,conH3,conH4}
    else
        conList = {self._scrollCon2,self._scrollCon3,self._scrollCon4}
        HList = {conH2,conH3,conH4}
    end

    local totalH = 0
    local len = #conList
    conList[len]:setPositionY(0)
    for i=1,len do
        totalH = totalH + conList[i]:getContentSize().height
        if i < len then
            conList[len-i]:setPositionY(conList[len - i + 1]:getPositionY() + HList[len - i + 1] + spaceY)
        end
    end
    totalH = totalH + len * spaceY 
    
    scrollView:setInnerContainerSize(cc.size(scrollViewSize.width,totalH))

    if scrollViewSize.height > totalH then
        local offsetY = self._isFromTeam and scrollViewSize.height-totalH or scrollViewSize.height-totalH - 85
        for i=1,len do
            conList[i]:setPositionY(conList[i]:getPositionY()+offsetY)
        end
        -- self._scrollCon3:setPositionY(self._scrollCon3:getPositionY()+offsetY)
        -- self._scrollCon2:setPositionY(self._scrollCon2:getPositionY()+offsetY)
        -- self._scrollCon1:setPositionY(self._scrollCon1:getPositionY()+offsetY)
    end
end

--获取属性信息
function otherBookWarDetailLayer:_getAttrsDescription(data,category)
    local cfgData = data and data.cfgData or nil
    assert(type(cfgData) == "table", " bookWar data error~~~")

    local svrData = data
    local level = nil

    local attribute_info = require("app.cfg.attribute_info")

    local attrs = {}

    category = category or "enhance"   --默认

    --强化
    if category == "enhance" then

        if level == nil then
            level = svrData and svrData.level or 1  --兵书初始强化等级1级
        end

        for i = 1, BookWarCommon.ENHANCE_ATTR_NUM do
            --如果有配置
            if cfgData["strength_type_"..i] > 0 then
                local description = attribute_info.get(cfgData["strength_type_"..i])
                if description then  
                    local enhance_value = cfgData["strength_value_"..i]
                    local enhance_growth = cfgData["strength_growth_"..i]

                    local enhanceValue = enhance_value+(level-1)*enhance_growth   

                    local enhance_type = description["type"]

                    -- 添加兵书天赋
                    -- for i=1,#talentList do
                    --     local data = talentList[i]
                    --     if data.cur_Level >= data.open_level then -- 天赋已激活
                    --         if enhance_type == data.attr_type then
                    --             enhanceValue = enhanceValue + data.num_value
                    --         end
                    --     end
                    -- end

                    -- 数值类型：1.绝对值  2.百分比  

                    --免疫属性
                    if enhance_type == 3 then
                        enhanceValue = ""
                    --百分比
                    elseif enhance_type == 2 then
                        enhanceValue = tostring(enhanceValue/10).."%"   --一个%在富文本中显示不出来
                        enhance_growth = tostring(enhance_growth/10).."%"                       
                    else
                        enhanceValue = tostring(enhanceValue)
                        enhance_growth = tostring(enhance_growth)
                    end

                    table.insert(attrs, {type = description.cn_name.."：",value = enhanceValue,
                        val_type = enhance_type, growth = enhance_growth} )
                end
            end
        end
    --基础属性
    elseif category == "base" then
        if cfgData["base_type"] and cfgData["base_type"] > 0 then
            local description = attribute_info.get(cfgData["base_type"])
            if description then  
                local enhance_value = cfgData["base_value"]

                local enhance_type = description["type"]

                -- 数值类型：1.绝对值  2.百分比  

                --免疫属性
                if enhance_type == 3 then
                    enhance_value = ""
                --百分比
                elseif enhance_type == 2 then
                    enhance_value = tostring(enhance_value/10).."%"   --一个%在富文本中显示不出来
                else
                    enhance_value = tostring(enhance_value)
                end

                table.insert(attrs, {type = description.cn_name.."：",value = enhance_value,
                    val_type = enhance_type} )
            end
        end
    --精炼
    elseif category == "refine" then

        if level == nil then
            level = svrData.refine_level or 0 --兵书初始精炼等级0级
        end

         for i = 1, BookWarCommon.REFINE_ATTR_NUM do
            --如果有配置
            if cfgData["advance_type_"..i] then
                local description = attribute_info.get(cfgData["advance_type_"..i])
                if description then  
                    local refine_growth = cfgData["advance_growth_"..i]
                    local refine_value = level*refine_growth
                    local refine_type = description["type"]

                    -- 添加兵书天赋
                    -- if level > 0 then
                    --     for i=1,#talentList do
                    --         local data = talentList[i]
                    --         if data.cur_Level >= data.open_level then -- 天赋已激活
                    --             if refine_type == data.attr_type then
                    --                 refine_value = refine_value + data.num_value
                    --             end
                    --         end
                    --     end
                    -- end

                    -- 数值类型：1.绝对值  2.百分比  3.免疫属性 
                    
                    --免疫属性
                    if refine_type == 3 then
                        refine_value = ""
                    --百分比形式
                    elseif refine_type == 2 then
                      refine_value = tostring(refine_value/10).."%"
                      refine_growth = tostring(refine_growth/10).."%"
                    else
                      refine_value = tostring(refine_value)
                      refine_growth = tostring(refine_growth)
                    end 

                    table.insert(attrs, {type = description.cn_name.."：", value = refine_value, 
                        val_type = refine_type, growth = refine_growth})
                end
            end
        end
    end
    return attrs
end

function otherBookWarDetailLayer:_updateBase()
    local parentLay = self:getSubNodeByName("Image_base")
    local attrs = self:_getAttrsDescription(self._bookWarData, "base")
    if #attrs == 0 then
        return
    end

    for i=1,#attrs do
        local typeLabel = parentLay:updateLabel("Text_baseType"..i,
            { text = attrs[i].type,
            visible = true,
            textColor = G_Colors.getColor(2),
            fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL})

        --属性值
        local textName = "Text_attrValue"..i
        BookWarCommon.updateCreatedLabel({
            parent = parentLay,
            name = textName,
            strContent = attrs[i].value,
            preNode = typeLabel,
            color = G_Colors.getColor(3),
            showAni = false})
    end
end

--强化信息
function otherBookWarDetailLayer:_updateEnhance()
    --===== 强化等级
    local enhanceLay = self:getSubNodeByName("Image_enhance")
    local levelTitle = self:getSubNodeByName("Text_enhanceLevelInfo")
    local maxLevel = tonumber(ParameInfo.get(283).content) 
    enhanceLay:updateLabel("Text_enhanceLevelInfo", {textColor=G_Colors.getColor(2), fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL})
    -- curlevel/maxlevel
    local textNum = self._bookWarData["level"].."/"..maxLevel
    local textName = "text_attrLvlValue1"
    BookWarCommon.updateCreatedLabel({
                parent = enhanceLay,
                name = textName,
                color = G_Colors.getColor(3),
                strContent = textNum,
                preNode = levelTitle,
                })
    --BookWarCommon.updateCreatedLabel(enhanceLay,textName,textNum,levelTitle)
    
    --======强化属性
    local attrs = self:_getAttrsDescription(self._bookWarData, "enhance")
    local attrNum = math.min(table.nums(attrs),BookWarCommon.ENHANCE_ATTR_NUM)
    dump(attrs)

    for i=1, BookWarCommon.ENHANCE_ATTR_NUM do
        --属性title
        local typeLabel = self:getSubNodeByName("Text_enhanceType"..i)
        local attrLabel = enhanceLay:getChildByName("Text_attrValue"..i)
        --local attrAdd = enhanceLay:getChildByName("Text_attrValue_add"..i)
        if i > attrNum then
            if typeLabel then
                typeLabel:setVisible(false)
            end
            if attrLabel then
                attrLabel:setVisible(false)
            end
            -- if attrAdd then
            --     attrAdd:setVisible(false)
            -- end
        else
            enhanceLay:updateLabel("Text_enhanceType"..i,
            { text = attrs[i].type ,visible = true,
            textColor = G_Colors.getColor(2), fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL})

            --属性值
            textName = "Text_attrValue"..i
            BookWarCommon.updateCreatedLabel({
                parent = enhanceLay,
                name = textName,
                strContent = attrs[i].value,
                preNode = typeLabel,
                color = G_Colors.getColor(3),
                showAni = false})
            --BookWarCommon.updateCreatedLabel(enhanceLay,textName,attrs[i].value,typeLabel,G_Colors.getColor(4))

            --to next level 的 addvalue
            -- local attrLabel = enhanceLay:getChildByName(textName)
            -- if attrLabel then
            --     textName = "Text_attrValue_add"..i
            --     textNum = "（+"..attrs[i].growth.."）" 
            --     BookWarCommon.updateCreatedLabel(enhanceLay,textName,textNum,attrLabel,G_Colors.getColor(13),G_Colors.getOutlineColor(13))
            -- end
        end
    end

    --强化按钮
    -- local isEnhance = G_Me.bookWarData:isShowEnhanceRed(self._bookWarId)
    -- self._csbNode:updateButton("Button_enhance",{
    --     callback = handler(self,self._enhance),
    --     enable = self._bookWarData.cfgData.type ~= BookWarCommon.BOOKWAR_TYPE_EXP,
    --     redPointVisible = isEnhance})
end

--精炼信息
function otherBookWarDetailLayer:_updateJinglian()
    -- local isRefine = G_Me.bookWarData:isShowRefineRed(self._bookWarId)
    -- self._csbNode:updateButton("Button_jinglian",{
    --     callback = handler(self,self._onclickJinglian),
    --     enable = self._bookWarData.cfgData.type ~= BookWarCommon.BOOKWAR_TYPE_EXP,
    --     redPointVisible = isRefine})
    
    local parentPanel = self._csbNode:getSubNodeByName("Image_jinglian")
    parentPanel:updateLabel("Text_level_title", {textColor=G_Colors.getColor(2), fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL})
    --等级
    local maxLevel = tonumber(ParameInfo.get(282).content)
    local curlevel = self._bookWarData.refine_level
    parentPanel:updateLabel("Text_level_value",
            { text = tostring(curlevel).."/"..tostring(maxLevel),
            textColor = G_Colors.getColor(3), fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL})
    --属性
    local attrs = self:_getAttrsDescription(self._bookWarData, "refine")
    local attrNum = math.min(table.nums(attrs),BookWarCommon.REFINE_ATTR_NUM)
   
    for i=1, BookWarCommon.REFINE_ATTR_NUM do
        --属性title
        local typeLabel = self:getSubNodeByName("Text_attr"..i)
        local attrLabel = parentPanel:getChildByName("Text_attr_value"..i)
        --local attrAddLabel = parentPanel:getChildByName("Text_attr_add"..i)
        if i > attrNum then
            if typeLabel then
                typeLabel:setVisible(false)
            end
            if attrLabel then
                attrLabel:setVisible(false)
            end
            -- if attrAddLabel then
            --     attrAddLabel:setVisible(false)
            -- end
        else
            parentPanel:updateLabel("Text_attr"..i,
            { text = attrs[i].type ,visible = true,
            textColor = G_Colors.getColor(2), fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL})

            -- 属性值
            parentPanel:updateLabel("Text_attr_value"..i,{
                text = attrs[i].value,
                visible = true,
                textColor = G_Colors.getColor(3), 
                fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL})

            -- local txt = parentPanel:getSubNodeByName("Text_attr_value"..i)
            -- txt:updateTxtValue(attrs[i].value)
            --local size = typeLabel:getContentSize()
            --attrLabel:setPositionX(typeLabel:getPositionX()+size.width+5)
            attrLabel:setPositionX(typeLabel:getPositionX()+5)

            -- add属性值
            -- parentPanel:updateLabel("Text_attr_add"..i,
            -- { text = "（+"..attrs[i].growth.."）" ,visible = true,
            -- --textColor = G_Colors.getColor(13),
            -- --outlineColor = G_Colors.getOutlineColor(13),
            -- fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL})
            -- local size = attrLabel:getContentSize()
            -- attrAddLabel:setPositionX(attrLabel:getPositionX()+size.width+5)
        end
    end
end

--收到穿戴返回
function otherBookWarDetailLayer:_onRecvEquipWeared( buffValue )

	G_ModuleDirector:popModule()

end

--收到卸下返回
function otherBookWarDetailLayer:_onRecvEquipUnload( buffValue )

 	G_ModuleDirector:popModule()

end

return otherBookWarDetailLayer
