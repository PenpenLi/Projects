-- RecycleSelectPetLayer.lua

require "app.cfg.pet_info"

local function _updateLabel(target, name, text, stroke, color)
    
    local label = target:getLabelByName(name)
    assert(label ~= nil, "label is nil")

    if stroke then
        label:createStroke(stroke, 1)
    end
    if color then
        label:setColor(color)
    end
    
    label:setText(text)
end

local function _updateImageView(target, name, texture, texType)
    
    local img = target:getImageViewByName(name)
    assert(img ~= nil, "img is nil")

    img:loadTexture(texture, texType)
    
end

local ALIGN_CENTER = "align_center"
local ALIGN_LEFT = "align_left"
local ALIGN_RIGHT = "align_right"

-- @basePosition 这里指的是基准点的位置，因为现在只支持居中对齐，所以basePosition指的是中心点的位置
-- @items 需要对齐的子项，是个table
-- @align 对齐方式

local function _autoAlign(basePosition, items, align)
    
    -- 先统计总共的宽度，因为这里居中对齐不需要考虑高度
    local totalWidth = 0
    for i=1, #items do
        totalWidth = totalWidth + items[i]:getContentSize().width
    end
    
    local function _convertToNodePosition(position, item)

        -- print("position.x: "..position.x.." position.y: "..position.y)

        -- 默认是以ccp(0, 0.5)为标准
        local anchorPoint = item:getAnchorPoint()
        return ccp(position.x + anchorPoint.x * item:getContentSize().width, position.y + (anchorPoint.y - 0.5) * item:getContentSize().height)

    end
    
    if align == ALIGN_CENTER then

        -- 然后返回一个函数，用来获取每一项节点的位置（通过index）
        return function(index)

            assert(index > 0 and index <= #items, "Invalid index: "..index)

            -- 统计下目前为止左边项所占据的宽度
            local _width = 0
            for i=1, index-1 do
                _width = _width + items[i]:getContentSize().width
            end

            -- print("basePosition.x: "..basePosition.x.." basePosition.y: "..basePosition.y)
            -- print("totalWidth: "..totalWidth)
            -- print("_width: ".._width)

            return _convertToNodePosition(ccp(basePosition.x - totalWidth/2 + _width, 0), items[index])

        end
        
    elseif align == ALIGN_LEFT then
        
        return function(index)

            assert(index > 0 and index <= #items, "Invalid index: "..index)

            -- 统计下目前为止左边项所占据的宽度
            local _width = 0
            for i=1, index-1 do
                _width = _width + items[i]:getContentSize().width
            end

            -- print("basePosition.x: "..basePosition.x.." basePosition.y: "..basePosition.y)
            -- print("totalWidth: "..totalWidth)
            -- print("_width: ".._width)

            return _convertToNodePosition(ccp(basePosition.x + _width, 0), items[index])

        end
        
    elseif align == ALIGN_RIGHT then
        
        return function(index)

            assert(index > 0 and index <= #items, "Invalid index: "..index)

            -- 统计下目前为止左边项所占据的宽度
            local _width = 0
            for i=1, index-1 do
                _width = _width + items[i]:getContentSize().width
            end

            -- print("basePosition.x: "..basePosition.x.." basePosition.y: "..basePosition.y)
            -- print("totalWidth: "..totalWidth)
            -- print("_width: ".._width)

            return _convertToNodePosition(ccp(basePosition.x - totalWidth + _width, 0), items[index])

        end

    else
        
        assert(false, "Now we don't support other align type :"..align)
        
    end

end

local RecycleSelectPetLayer = class("RecycleSelectPetLayer", UFCCSModelLayer)

function RecycleSelectPetLayer.create(...)
    return RecycleSelectPetLayer.new("ui_layout/recycle_selectPetLayer.json", nil, ...)
end

function RecycleSelectPetLayer:ctor(_, _, pet, selectPet, callback)

    RecycleSelectPetLayer.super.ctor(self)

    self._callback = callback
    
    self:initSelectState(pet, selectPet)
    
    self:registerKeypadEvent(true, false)
end

function RecycleSelectPetLayer:initSelectState(pet, selectPet)
    
    self._pet = pet
    
    -- 因为UIListView在退出"舞台"的时候会把schedule取消，但是重新加载（retain保留起来）没有重新启用，所以这里需要再打开一次
    if self._listView then
        -- 因为这里listview中的标示update的状态量还是true（但实际上和事实不符），因其逻辑判断为问题，所以先关闭一次再开启
        self._listView:setUpdateEnabled(false)
        self._listView:setUpdateEnabled(true)
    end
    
    -- 选中的武将
    self._selectPet = selectPet or {}

end

function RecycleSelectPetLayer:onLayerEnter()
    
    if not self._listView then
        -- 自适应屏幕高度
        self:adapterWithScreen()
        
        -- 创建列表
        local panel = self:getPanelByName("Panel_list")
        -- 因为这里列表的高度无法适配到扣除固定尺寸大小后的大小，所以我们这里手动设置一下
        local size = panel:getSize()
        panel:setSize(CCSizeMake(size.width, display.height - self:getPanelByName("Panel_top"):getSize().height))
        
        local listview = CCSListViewEx:createWithPanel(panel, LISTVIEW_DIR_VERTICAL)
        self._listView = listview
        self:registerListViewEvent("Panel_list", function ( ... )
        -- this function is used for new user guide, you shouldn't care it
        end)

        -- 分别设置创建方法和更新方法
        self._listView:setCreateCellHandler(function(list, index)

            -- 创建item
            local item = CCSItemCellBase:create("ui_layout/recycle_selectPetItem.json")
            -- 设置其按钮响应的方法
            item:setTouchEnabled(true)
            item:registerBtnClickEvent("Button_get", function()
                -- 选中则添加到选择列表里
                self._selectPet[1] = self._pet[item:getCellIndex()+1]
                if self._callback then self._callback() end
                
            end)
            item:registerCellClickEvent(function ( cell, index )
                self._selectPet[1] = self._pet[item:getCellIndex()+1]
                if self._callback then self._callback() end
            end)
            
            return item
        end)

        -- 更新cell显示
        self._listView:setUpdateCellHandler(function(list, index, cell)

            local pet = self._pet[index+1] -- c++从0下标开始...
            assert(pet, "Unknown index: "..index)
            local petConfig = pet_info.get(pet.base_id)

            assert(petConfig, "Unknown petConfig: "..pet.base_id)

            -- 头像
            _updateImageView(cell, "Image_icon", G_Path.getPetIcon(petConfig.res_id), UI_TEX_TYPE_LOCAL)
            
            cell:getImageViewByName("Image_icon"):setTouchEnabled(true)
            
            -- 头像现在需要响应事件用来显示详情
            cell:registerWidgetTouchEvent("Image_icon", function(widget, state)
                -- 对于图片(ImageView)的交互事件来讲，分为手指按下，移动和抬起几个动作, 2表示抬起，只有在抬起的时候才会响应，其余则不响应
                if not (not state or state == 2) then
                    return
                end
                
                require("app.scenes.common.dropinfo.DropInfo").show(G_Goods.TYPE_PET, petConfig.id) 
            end)
            
            -- 品质框
            _updateImageView(cell, "Image_frame", G_Path.getEquipColorImage(petConfig.quality, G_Goods.TYPE_PET), UI_TEX_TYPE_PLIST)
            
            local petAttr = {}
            petAttr[1] = {}
            petAttr[1].typeString = G_lang:get("LANG_RECYCLE_PET_ATTR_1")
            petAttr[1].valueString = pet.level
            petAttr[2] = {}
            petAttr[2].typeString = G_lang:get("LANG_RECYCLE_PET_ATTR_2")
            petAttr[2].valueString = pet.addition_lvl
            
            -- 属性1
            if petAttr[1] then
                self:getPanelByName("Panel_attr1"):setVisible(true)
                _updateLabel(cell, "Label_content_attr1_desc", petAttr[1].typeString)
                _updateLabel(cell, "Label_content_attr1", petAttr[1].valueString)
                local getPosition = _autoAlign(ccp(0, 0), {cell:getLabelByName("Label_content_attr1_desc"),
                cell:getLabelByName("Label_content_attr1")}, ALIGN_LEFT)
                cell:getLabelByName("Label_content_attr1_desc"):setPosition(getPosition(1))
                cell:getLabelByName("Label_content_attr1"):setPosition(getPosition(2))
            else
                cell:getPanelByName("Panel_attr1"):setVisible(false)
            end

            -- 属性2
            if petAttr[2] then
                self:getPanelByName("Panel_attr2"):setVisible(true)
                _updateLabel(cell, "Label_content_attr2_desc", petAttr[2].typeString)
                _updateLabel(cell, "Label_content_attr2", petAttr[2].valueString)
                local getPosition = _autoAlign(ccp(0, 0), {cell:getLabelByName("Label_content_attr2_desc"),
                cell:getLabelByName("Label_content_attr2")}, ALIGN_LEFT)
                cell:getLabelByName("Label_content_attr2_desc"):setPosition(getPosition(1))
                cell:getLabelByName("Label_content_attr2"):setPosition(getPosition(2))
            else
                cell:getPanelByName("Panel_attr2"):setVisible(false)
            end
            
            -- 名字
            _updateLabel(cell, "Label_name", petConfig.name, Colors.strokeBrown, Colors.qualityColors[petConfig.quality])
            
            -- 等级
            _updateLabel(cell, "Label_level","")
            
            -- -- 类型
            -- _updateLabel(cell, "Label_type", "【"..pet:getTypeName().."】", Colors.strokeBrown, Colors.qualityColors[petConfig.quality])
            for index = 1 , 5 do 
                cell:getImageViewByName("Image_Star"..index):loadTexture(petConfig.star >= index and "ui/yangcheng/star_juexing.png" or "ui/yangcheng/star_juexing_kong.png")
            end

            -- -- 精炼几阶
            cell:getImageViewByName("Image_jinlian"):setVisible(false)
            cell:getLabelByName("Label_type"):setVisible(false)
            -- _updateLabel(cell, "Label_jinlian_desc", G_lang:get("LANG_RECYCLE_TREASURE_REBORN_JINLIAN_LEVEL_DESC", {level=pet.refining_level}))
            
        end)
        
        self._listView:initChildWithDataLength(#self._pet, 0.2)
    else
        
        self._listView:reloadWithLength(#self._pet, 0, 0.2)
        
    end
    
end

function RecycleSelectPetLayer:onBackKeyEvent()
    self:close()
    return true
end

function RecycleSelectPetLayer:getSelecteds()
    return self._selectPet
end

return RecycleSelectPetLayer