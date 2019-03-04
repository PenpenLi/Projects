
-- TopBarWidget.lua

--[=======================[

    通用顶部条组件

    分为三种基础样式，在样式的基础上有五种变化

]=======================]

local NumberChanger = require "app.ui.number.NumberChanger"

local RoleInfo = require "app.cfg.role_info"
local parameter_info = require "app.cfg.parameter_info"

local TextHelper = require "app.common.TextHelper"
local TypeConverter = require "app.common.TypeConverter"

local TopBarWidget = class("TopBarWidget", function()
    return display.newNode()
end)

-- 五种样式

-- 基础样式，主要显示体力，精力，银两，元宝
TopBarWidget.STYLE_BASE = 1
-- 等级样式1，主要显示等级，体力，银两，元宝
TopBarWidget.STYLE_LEVEL1 = 2
-- 等级样式2，主要显示等级，战力，银两，元宝
TopBarWidget.STYLE_LEVEL2 = 3
-- 等级样式3，主要显示等级，精力，银两，元宝
TopBarWidget.STYLE_LEVEL3 = 4
-- 名字样式，主要显示名字，VIP等级，银两，元宝
TopBarWidget.STYLE_NAME = 5

-- 新样式，主要是没有底了

-- 基础样式，主要显示体力，精力，银两，元宝
TopBarWidget.STYPE_BASE_BLOCK = 6
-- 等级样式1，主要显示等级，体力，银两，元宝
TopBarWidget.STYLE_LEVEL1_BLOCK = 7
-- 等级样式2，主要显示等级，战力，银两，元宝
TopBarWidget.STYLE_LEVEL2_BLOCK = 8
-- 等级样式3，主要显示等级，精力，银两，元宝
TopBarWidget.STYLE_LEVEL3_BLOCK = 9

-- 样式4，主要显示战力，精力，银两，元宝    -- 看了一下，目前好像没用
TopBarWidget.STYLE_POWER = 10

-- 样式5，主要显示战力，资源，银两，元宝  （资源需传入资源类型）
TopBarWidget.STYLE_RES_BLOCK = 11

-- 样式6，主要显示精力，资源，银两，元宝  （资源需传入资源类型）
TopBarWidget.STYLE_RES_MINE = 12

TopBarWidget.STYLE_RES_MATCH = 13

TopBarWidget.STYLE_RES_SOUL_STONE = 14

function TopBarWidget:ctor(style)

    -- 默认样式采用基础款
    style = style or TopBarWidget.STYLE_BASE

    --
    self._stop = false

    -- 当前top条的样式类型
    self._style = nil

    self._res_type = nil -- 当前特有资源类型

    -- 是否暂停更新
    self._pause = false

    -- self:enableNodeEvents()
    self:registerScriptHandler(function(event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        elseif event == "cleanup" then
            self:onCleanup()
        end
    end)

    -- 置于顶部
    self:setPositionY(display.height)

    -- 样式缓存
    self._barCached = {
        -- [TopBarWidget.STYLE_BASE] = "根据类型缓存的csb解析后的node".
        -- ...
    }

    -- 存储数字滚动动画的容器
    self._numberChangers = {
        -- NumberChanger.new()
    }

    -- 存储数字变大的元素容器
    self._numberScales = {
        -- Text
    }

    self._displayNode = display.newNode()
    self:addChild(self._displayNode)

    -- 设置样式
    self:setStyle(style)

end

function TopBarWidget:onEnter()

    -- if not self._stop then
        -- 重进之后重置等待标记
        -- 是否需要动画要看上一次是不是暂停，是暂停就需要动画
        local needAni = self._pause

        self._pause = false

        -- 更新视图
        self:_updateView(needAni)

        -- 清理数据缓存
        self:_clearDataCached()
    -- end

    -- GetUser
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_RECV_ROLE_INFO, self._onRecvRoleInfo, self)
    -- GetVip
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_VIP_STATE_CHANGE, self._onRecvRoleInfo, self)

    -- update resume
    uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_TOP_BAR_UPDATE_RESUME, self.resume, self)
    
end

function TopBarWidget:onExit()

    uf_eventManager:removeListenerWithTarget(self)

    self:_clear()
    
end

function TopBarWidget:onCleanup()
    for i,text in ipairs(self._numberScales) do
        text:stopAllActions()
        text:setScale(1)
    end 
end

function TopBarWidget:pauseWidget(stop)
    self._stop = stop or false
    self._pause = true

    -- 缓存一下当前的数据
    self:_clearDataCached()

    self._dataCached = {
        power = G_Me.userData.power,
        money = G_Me.userData.money,
        gold = G_Me.userData.gold,
        vit = G_Me.userData.vit,
        spirit = G_Me.userData.spirit,
        lingyu = G_Me.userData.lingyu,
        prestige = G_Me.userData.prestige,
        copper = G_Me.userData.copper,
        tower_resource = G_Me.userData.tower_resource,
        wushuang = G_Me.userData.wushuang,
        pet_soul = G_Me.userData.pet_soul,
        score_practice = G_Me.userData.score_practice,
    }

end

function TopBarWidget:resumeWidget(withAni)
    self._stop = false
    self._pause = false
    -- 更新视图
    self:_updateView(withAni or true)

    self:_clearDataCached()
end

function TopBarWidget:reset()
    self._stop = false
    self._pause = false
end

function TopBarWidget:_clearDataCached()
    
    self._dataCached = {}

end

--[=======================[

    设置top条样式

    @param style 样式必须是上面定义的其中一种之一

]=======================]

function TopBarWidget:setStyle(style,res_type)
   -- dump(res_type)
    if res_type then
        self._res_type = res_type
    end
    if style ~= self._style then
        assert(style == TopBarWidget.STYLE_BASE or
            style == TopBarWidget.STYLE_LEVEL1 or
            style == TopBarWidget.STYLE_LEVEL2 or
            style == TopBarWidget.STYLE_LEVEL3 or
            style == TopBarWidget.STYLE_NAME or
            style == TopBarWidget.STYLE_BASE_BLOCK or
            style == TopBarWidget.STYLE_LEVEL1_BLOCK or
            style == TopBarWidget.STYLE_LEVEL2_BLOCK or
            style == TopBarWidget.STYLE_LEVEL3_BLOCK or
            style == TopBarWidget.STYLE_POWER or
            style == TopBarWidget.STYLE_RES_BLOCK or
            style == TopBarWidget.STYLE_RES_MINE or
            style == TopBarWidget.STYLE_RES_MATCH or
            style == TopBarWidget.STYLE_RES_SOUL_STONE,
            "Invalid top bar style: "..tostring(style))

        if not self._barCached[style] then

            local csbFile = nil

            if style == TopBarWidget.STYLE_BASE or 
                style == TopBarWidget.STYLE_POWER then
                csbFile = G_Url:getCSB("NavigationTopBarBaseNode", "navigation")
            elseif style == TopBarWidget.STYLE_NAME then
                csbFile = G_Url:getCSB("NavigationTopBarNameNode", "navigation")
            elseif style == TopBarWidget.STYLE_LEVEL1 or
                style == TopBarWidget.STYLE_LEVEL2 or
                style == TopBarWidget.STYLE_LEVEL3_BLOCK or
                style == TopBarWidget.STYLE_LEVEL3 then
                csbFile = G_Url:getCSB("NavigationTopBarLevelNode", "navigation")
            elseif style == TopBarWidget.STYLE_BASE_BLOCK  then
                csbFile = G_Url:getCSB("NavigationTopBarBlockBaseNode", "navigation")
            elseif style == TopBarWidget.STYLE_LEVEL1_BLOCK or
                style == TopBarWidget.STYLE_LEVEL2_BLOCK then
                --style == TopBarWidget.STYLE_LEVEL3_BLOCK then
                csbFile = G_Url:getCSB("NavigationTopBarBlockLevelNode", "navigation")
            elseif style == TopBarWidget.STYLE_RES_BLOCK then
                csbFile = G_Url:getCSB("NavigationTopBarBlockPowerResNode", "navigation")
            elseif style == TopBarWidget.STYLE_RES_MINE then
                csbFile = G_Url:getCSB("NavigationTopBarBlockPowerResNode", "navigation")
            elseif style == TopBarWidget.STYLE_RES_MATCH then
                csbFile = G_Url:getCSB("NavigationTopBarBlockPowerResNode", "navigation")
            elseif style == TopBarWidget.STYLE_RES_SOUL_STONE then
                csbFile = G_Url:getCSB("NavigationTopBarBlockPowerResNode", "navigation")
            end

            local node = cc.CSLoader:createNode(csbFile)
            self._displayNode:addChild(node)

            self._barCached[style] = node
        end

        self._style = style

        for k, view in pairs(self._barCached) do
            view:setVisible(k == style)
        end

        -- 更新视图
        self:_updateView()

    end

end

-- 清理当前的数字滚动缓存

function TopBarWidget:_clear()

    for i=1, #self._numberChangers do
        self._numberChangers[i]:stop()
    end

    self._numberChangers = {}

end

-- 获取网络消息

function TopBarWidget:_onRecvRoleInfo()

    self:_updateView(true)

end

-- 更新视图
-- @param withAni 是否加上动画

function TopBarWidget:_updateView(withAni)

    if self._pause then return end

    -- 基础样式
    if self._style == TopBarWidget.STYLE_BASE or
        self._style == TopBarWidget.STYLE_BASE_BLOCK or
        self._style == TopBarWidget.STYLE_POWER then

        local node = self._barCached[self._style]
        if not node then return end

        -- 内容格式走type, value, size
        local contents = {
            -- 依次是精力，银两，元宝
            --{type = TypeConverter.TYPE_SPIRIT, size = G_Me.userData.spirit},
            {type = TypeConverter.TYPE_MONEY, size = G_Me.userData.money},
            {type = TypeConverter.TYPE_GOLD, size = G_Me.userData.gold},
        }

        -- 两种等级框第一项显示的不同，有战力和体力的不同
        if self._style == TopBarWidget.STYLE_POWER then
            table.insert(contents, 1, {
                -- 战力比较特殊
                icon_mini = G_Url:getText_signet("w_img1_signet_battle"),
                size = G_Me.userData.power,
                scale = 0.8,
            })
        else
            table.insert(contents, 1, {
                type = TypeConverter.TYPE_VIT, size = G_Me.userData.vit
            })
        end

        -- 这几个都是基础样式
        for i=1, #contents do
            if contents[i].type == TypeConverter.TYPE_VIT or 
                contents[i].type == TypeConverter.TYPE_SPIRIT then
                self:_updateLimitView(
                    node:getSubNodeByName("Node_top_res"..i),
                    contents[i],
                    withAni
                )
            else
                self:_updateItemView(
                    node:getSubNodeByName("Node_top_res"..i),
                    contents[i],
                    withAni
                )
            end
        end

    -- 等级样式
    elseif self._style == TopBarWidget.STYLE_LEVEL1 or 
        self._style == TopBarWidget.STYLE_LEVEL2 or
        self._style == TopBarWidget.STYLE_LEVEL3 or
        self._style == TopBarWidget.STYLE_LEVEL1_BLOCK or
        self._style == TopBarWidget.STYLE_LEVEL2_BLOCK or
        self._style == TopBarWidget.STYLE_LEVEL3_BLOCK then

        local node = self._barCached[self._style]
        if not node then return end

        -- 内容格式走type, value, size
        local contents = {
            -- 银两，元宝
            {type = TypeConverter.TYPE_MONEY, size = G_Me.userData.money},
            {type = TypeConverter.TYPE_GOLD, size = G_Me.userData.gold},
        }

        -- 两种等级框第一项显示的不同，有战力和体力的不同
        if self._style == TopBarWidget.STYLE_LEVEL2 or self._style == TopBarWidget.STYLE_LEVEL2_BLOCK then
            table.insert(contents, 1, {
                -- 战力比较特殊
                icon_mini = G_Url:getText_signet("w_img1_signet_battle"),
                size = G_Me.userData.power,
                scale = 0.8,
            })
        elseif self._style == TopBarWidget.STYLE_LEVEL1 or self._style == TopBarWidget.STYLE_LEVEL1_BLOCK then
            table.insert(contents, 1, {
                type = TypeConverter.TYPE_VIT, size = G_Me.userData.vit
            })
        elseif self._style == TopBarWidget.STYLE_LEVEL3 or self._style == TopBarWidget.STYLE_LEVEL3_BLOCK then
            table.insert(contents, 1, {
                type = TypeConverter.TYPE_SPIRIT, size = G_Me.userData.spirit
            })
        end

        -- 这几个都是基础样式
        for i=1, #contents do
            if contents[i].type == TypeConverter.TYPE_VIT or
                contents[i].type == TypeConverter.TYPE_SPIRIT then
                self:_updateLimitView(
                    node:getSubNodeByName("Node_top_res"..i),
                    contents[i],
                    withAni
                )
            else
                self:_updateItemView(
                    node:getSubNodeByName("Node_top_res"..i),
                    contents[i],
                    withAni
                )
            end
        end

        -- 当前等级
        self:_updateLevelView(node)

    -- 名字样式
    elseif self._style == TopBarWidget.STYLE_NAME then

        local node = self._barCached[self._style]
        if not node then return end

        -- 更新名字

        -- 获取主角
        local knightData = G_Me.teamData:getKnightDataByPos(1)
        if knightData == nil then return end
        -- 更新名字和颜色
        node:updateLabel("Text_name", {
            text = G_Me.userData.name,
            textColor = G_Colors.qualityColor2Color(G_TypeConverter.quality2Color(knightData.cfgData.quality),true),
            outlineColor = G_Colors.qualityColor2OutlineColor(G_TypeConverter.quality2Color(knightData.cfgData.quality)),
            --outlineColor = cc.c4b(0x42, 0x2e, 0x2f, 0xff),
            --outlineSize = 2,
        })

        -- VIP等级
        node:updateFntLabel("BitmapFontLabel_vip_level", "VIP"..(G_Me.vipData:getVipLevel() or 0))

        -- 内容格式走type, value, size
        local contents = {
            -- 银两，元宝
            {type = TypeConverter.TYPE_MONEY, size = G_Me.userData.money},
            {type = TypeConverter.TYPE_GOLD, size = G_Me.userData.gold},
        }

        -- 这几个都是基础样式
        for i=1, #contents do
            self:_updateItemView(
                node:getSubNodeByName("Node_top_res"..i),
                contents[i],
                withAni
            )
        end

    -- 无等级名字--- 战力 特有资源样式
    elseif self._style == TopBarWidget.STYLE_RES_BLOCK then
        local node = self._barCached[self._style]
        if not node then return end

        local mapRes = {}
        mapRes[TypeConverter.TYPE_ARENA_CURRENCY] = G_Me.userData.prestige --声望，竞技场特有（产出）
        mapRes[TypeConverter.TYPE_COPPER_CASH] = G_Me.userData.copper --铜钱
        mapRes[TypeConverter.TYPE_TOWER_RESOURCE] = G_Me.userData.tower_resource --将心
        mapRes[TypeConverter.TYPE_UNIQUE_COIN] = G_Me.userData.wushuang --无双货币
        mapRes[TypeConverter.TYPE_PET_SOUL] = G_Me.userData.pet_soul --兽魂
        mapRes[TypeConverter.TYPE_SCORE_PRACTICE] = G_Me.userData.score_practice --武魂
        mapRes[TypeConverter.TYPE_EXCLUSIVE_MONEY] = G_Me.userData.qihun --专属货币（器魂）
        mapRes[TypeConverter.TYPE_LING_YU] = G_Me.userData.lingyu --专属货币（器魂）
        mapRes[TypeConverter.TYPE_WEIWANG] = G_Me.userData.weiwang --专属货币（器魂）
        mapRes[TypeConverter.TYPE_SOUL_STONE] = G_Me.userData.hunshi --

        --先更新战力
        --dump(withAni)
        -- local Image_power = node:getSubNodeByName("Image_power")
        -- Image_power:updateLabel("Label_res_amount", {
        --     text = TextHelper.getAmountText(G_Me.userData.power),
        --     textColor = G_Colors.POWER,
        --     outlineColor = G_Colors.POWER_OUTLINE,
        -- })

        -- 内容格式走type, value, size
        local contents = {
            -- 银两，元宝
            {type = TypeConverter.TYPE_MONEY, size = G_Me.userData.money},
            {type = TypeConverter.TYPE_GOLD, size = G_Me.userData.gold},
        }

        --加入特有资源
        -- dump(self._res_type)
        -- dump(mapRes[self._res_type])
        if self._res_type then
            table.insert(contents, 1, {
                type = self._res_type, size = mapRes[self._res_type],
            })
        end
        table.insert(contents, 1, {
            icon_mini = G_Url:getText_signet("w_img1_signet_battle"),
            size = G_Me.userData.power,
            scale = 0.8,
        })
        

        for i=1, #contents do
            self:_updateItemView(
                node:getSubNodeByName("Node_top_res"..i),
                contents[i],
                withAni
            )
        end

    -- 无等级名字--- 战力 特有资源样式
    elseif self._style == TopBarWidget.STYLE_RES_MINE then
        local node = self._barCached[self._style]
        if not node then return end

        local mapRes = {}
        mapRes[TypeConverter.TYPE_ARENA_CURRENCY] = G_Me.userData.prestige --声望，竞技场特有（产出）
        mapRes[TypeConverter.TYPE_COPPER_CASH] = G_Me.userData.copper --铜钱
        mapRes[TypeConverter.TYPE_TOWER_RESOURCE] = G_Me.userData.tower_resource --将心
        mapRes[TypeConverter.TYPE_UNIQUE_COIN] = G_Me.userData.wushuang --无双货币
        mapRes[TypeConverter.TYPE_PET_SOUL] = G_Me.userData.pet_soul --兽魂
        mapRes[TypeConverter.TYPE_SCORE_PRACTICE] = G_Me.userData.score_practice --武魂
        mapRes[TypeConverter.TYPE_EXCLUSIVE_MONEY] = G_Me.userData.qihun --专属货币（器魂）
        mapRes[TypeConverter.TYPE_LING_YU] = G_Me.userData.lingyu --专属货币（器魂）

        --先更新战力
        --dump(withAni)
        -- local Image_power = node:getSubNodeByName("Image_power")
        -- Image_power:updateLabel("Label_res_amount", {
        --     text = TextHelper.getAmountText(G_Me.userData.power),
        --     textColor = G_Colors.POWER,
        --     outlineColor = G_Colors.POWER_OUTLINE,
        -- })

        -- 内容格式走type, value, size
        local contents = {
            -- 银两，元宝
            {type = TypeConverter.TYPE_SPIRIT, size = G_Me.userData.spirit},
            {type = TypeConverter.TYPE_LING_YU, size = G_Me.userData.lingyu},
            {type = TypeConverter.TYPE_MONEY, size = G_Me.userData.money},
            {type = TypeConverter.TYPE_GOLD, size = G_Me.userData.gold},
        }
        

        for i=1, #contents do
            self:_updateItemView(
                node:getSubNodeByName("Node_top_res"..i),
                contents[i],
                withAni
            )
        end
    elseif self._style == TopBarWidget.STYLE_RES_MATCH then
        local node = self._barCached[self._style]
        if not node then return end

        --先更新战力
        --dump(withAni)
        -- local Image_power = node:getSubNodeByName("Image_power")
        -- Image_power:updateLabel("Label_res_amount", {
        --     text = TextHelper.getAmountText(G_Me.userData.power),
        --     textColor = G_Colors.POWER,
        --     outlineColor = G_Colors.POWER_OUTLINE,
        -- })
        -- 内容格式走type, value, size
        local contents = {
            -- 银两，元宝
            {type = TypeConverter.TYPE_WEIWANG, size = G_Me.userData.weiwang},
            {type = TypeConverter.TYPE_MONEY, size = G_Me.userData.money},
            {type = TypeConverter.TYPE_GOLD, size = G_Me.userData.gold},
        }

        table.insert(contents, 1, {
            icon_mini = G_Url:getText_signet("w_img1_signet_battle"),
            size = G_Me.userData.power,
            scale = 0.8,
        })
        

        for i=1, #contents do
            self:_updateItemView(
                node:getSubNodeByName("Node_top_res"..i),
                contents[i],
                withAni
            )
        end
    elseif self._style == TopBarWidget.STYLE_RES_SOUL_STONE then
        local node = self._barCached[self._style]
        if not node then return end

        --先更新战力
        --dump(withAni)
        -- local Image_power = node:getSubNodeByName("Image_power")
        -- Image_power:updateLabel("Label_res_amount", {
        --     text = TextHelper.getAmountText(G_Me.userData.power),
        --     textColor = G_Colors.POWER,
        --     outlineColor = G_Colors.POWER_OUTLINE,
        -- })
        -- 内容格式走type, value, size
        local contents = {
            -- 银两，元宝
            {type = TypeConverter.TYPE_SOUL_STONE, size = G_Me.userData.hunshi},
            {type = TypeConverter.TYPE_MONEY, size = G_Me.userData.money},
            {type = TypeConverter.TYPE_GOLD, size = G_Me.userData.gold},
        }

        table.insert(contents, 1, {
            icon_mini = G_Url:getText_signet("w_img1_signet_battle"),
            size = G_Me.userData.power,
            scale = 0.8,
        })
        

        for i=1, #contents do
            self:_updateItemView(
                node:getSubNodeByName("Node_top_res"..i),
                contents[i],
                withAni
            )
        end
    end
end

-- 更新单项内容
function TopBarWidget:_updateItemView(node, param, withAni)
    --dump(debug.traceback("描述:", 2))
    local itemType = param.type

    print("TopBarWidget:_updateItemView_updateItemView")
    if param.type then
        param = TypeConverter.convert(param)
    end

    -- icon
    if not param.noIcon then
        node:updateImageView("Image_res_icon", {texture = param.icon_mini, scale = param.scale or 1}):setPosition(-41,0)
    end

    -- 数值
    if withAni then

        -- 这里先简单获取某种类型的数据值
        local startValue = 0

        -- 战力特殊
        if not itemType then
            startValue = self._dataCached.power or G_Me.userData:getLastData("power")
        elseif itemType == TypeConverter.TYPE_MONEY then
            startValue = self._dataCached.money or G_Me.userData:getLastData("money")
        elseif itemType == TypeConverter.TYPE_GOLD then
            startValue = self._dataCached.gold or G_Me.userData:getLastData("gold")
        elseif itemType == TypeConverter.TYPE_ARENA_CURRENCY then
            startValue = self._dataCached.prestige or G_Me.userData:getLastData("prestige")
        elseif itemType == TypeConverter.TYPE_COPPER_CASH then
            startValue = self._dataCached.copper or G_Me.userData:getLastData("copper")
        elseif itemType == TypeConverter.TYPE_TOWER_RESOURCE then
            startValue = self._dataCached.tower_resource or G_Me.userData:getLastData("tower_resource")
        elseif itemType == TypeConverter.TYPE_UNIQUE_COIN then
            startValue = self._dataCached.wushuang or G_Me.userData:getLastData("wushuang")
        elseif itemType == TypeConverter.TYPE_PET_SOUL then
            startValue = self._dataCached.pet_soul or G_Me.userData:getLastData("pet_soul")
        elseif itemType == TypeConverter.TYPE_SCORE_PRACTICE then
            startValue = self._dataCached.score_practice or G_Me.userData:getLastData("score_practice")
        elseif itemType == TypeConverter.TYPE_SCORE_PRACTICE then
            startValue = self._dataCached.score_practice or G_Me.userData:getLastData("score_practice")
        elseif itemType == TypeConverter.TYPE_LING_YU then
            startValue = self._dataCached.lingyu or G_Me.userData:getLastData("lingyu")
        elseif itemType == TypeConverter.TYPE_SPIRIT then
            startValue = self._dataCached.spirit or G_Me.userData:getLastData("spirit")
        end
        assert(startValue, "Invalid itemType: "..tostring(itemType))

        local numberChanger = NumberChanger.new(startValue, param.size, function(value)
            node:updateLabel("Label_res_amount", {
                text = TextHelper.getAmountText(value),
                textColor = G_Colors.WHITE,
            })
        end,
        function()
            if(self:getParent() ~= nil and self:isVisible() == true)then
                local pos = node:convertToWorldSpace(cc.p(45,-5))
                local amount = node:getSubNodeByName("Label_res_amount")
                if amount then
                    local amountSize = amount:getContentSize()
                    -- pos = amount:convertToWorldSpace(cc.p(amountSize.width/2, amountSize.height))
                end
                
                require("app.common.TextFly").addNumberChangeEffect(pos,param.size - startValue,nil)
            end
        end)
        numberChanger:play()

        if startValue < param.size then
            node:getSubNodeByName("Label_res_amount"):doScaleAnimation(0.3)
            table.insert(self._numberScales,node:getSubNodeByName("Label_res_amount"))
        end

        table.insert(self._numberChangers, numberChanger)

    else

        -- 数量
        node:updateLabel("Label_res_amount", {
            text = TextHelper.getAmountText(param.size),
            -- enableShadow = cc.c4b(0, 0, 0, 255 * 0.75),
            textColor = G_Colors.WHITE,
        })

    end

end

-- 更新精力体力等这种有上限的

function TopBarWidget:_updateLimitView(node, param, withAni)

    local itemType = param.type

    if itemType then
        param = TypeConverter.convert(param)
    end
    -- icon
    node:updateImageView("Image_res_icon", {texture = param.icon_mini, scale = param.scale or 1}):setPosition(-41,0)

    -- 体力/精力的上限
    local limit = nil

    -- 体力
    if itemType == TypeConverter.TYPE_VIT then

        limit = tonumber(parameter_info.get(262).content)
        assert(limit, "Could not find the parameter_info with id: 262")

    -- 精力
    elseif itemType == TypeConverter.TYPE_SPIRIT then

        limit = tonumber(parameter_info.get(427).content)
        assert(limit, "Could not find the parameter_info with id: 427")
    end

    -- 数值
    if withAni then

        -- 这里先简单获取某种类型的数据值
        local startValue = 0
        if itemType == TypeConverter.TYPE_VIT then
            startValue = self._dataCached.vit or G_Me.userData:getLastData("vit")
        elseif itemType == TypeConverter.TYPE_SPIRIT then
            startValue = self._dataCached.spirit or G_Me.userData:getLastData("spirit")
        end
        local numberChanger = NumberChanger.new(startValue, param.size, function(value)
            node:updateLabel("Label_res_amount", {
                text = G_LangScrap.get("lang_common_top_amount", {cur = value, total = limit}),
                textColor = G_Colors.WHITE
            })
        end,
        function()
            if(self:getParent() ~= nil and self:isVisible() == true)then
                local pos = node:convertToWorldSpace(cc.p(45,-5))
                local amount = node:getSubNodeByName("Label_res_amount")
                if amount then
                    local amountSize = amount:getContentSize()
                    -- pos = amount:convertToWorldSpace(cc.p(amountSize.width/2, amountSize.height))
                end
                require("app.common.TextFly").addNumberChangeEffect(pos,param.size - startValue,nil)
            end
        end)
        numberChanger:play()

        table.insert(self._numberChangers, numberChanger)

    else
        node:updateLabel("Label_res_amount", {
            text = G_LangScrap.get("lang_common_top_amount", {cur = param.size, total = limit}),
            -- enableShadow = cc.c4b(0, 0, 0, 255 * 0.75)
            textColor = G_Colors.WHITE
        })

    end

end

-- 更新等级

function TopBarWidget:_updateLevelView(node)

    -- 等级进度条
    local loadingBar = node:getSubNodeByName("LoadingBar_exp")

    local info = RoleInfo.get(G_Me.userData.level)
    --可能数据被重置了 还不完整
    if not info then
        return
    end
    --assert(info, "Could not find the role info with id: "..tostring(G_Me.userData.level))

    local exp = info.experience
    local curExp = G_Me.userData.exp

    loadingBar:setPercent(curExp / exp * 100)

    -- 等级数字
    node:updateLabel("Text_level", {
        text = G_LangScrap.get("lang_common_top_level", {level = G_Me.userData.level}),
        outlineColor = G_ColorsScrap.COLOR_SCENE_OUTLINE,
        outlineSize = 2,
    })

end


return TopBarWidget