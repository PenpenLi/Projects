--批量使用物品面板

local CommonBatchUsePanel =  class("CommonBatchUsePanel",function()
    return cc.Node:create()
end)

local UpdateNodeHelper = require("app.common.UpdateNodeHelper")
local UpdateButtonHelper = require("app.common.UpdateButtonHelper")
local TypeConverter = require "app.common.TypeConverter"
local ItemInfo = require("app.cfg.item_info")
local ItemConst = require "app.const.ItemConst"

--[======================[
    
    批量使用弹窗：精力、体力、降妖令、免战牌等

    @params表示一个table
    callback表示确认购买后的回调，参数依次为：购买数量，购买价格（总价格），购买物品的id（shop_fixed_info）
    
    local params = {
        itemInfo = "item_info表中记录",
        ownNum = 当前数量
        curResultNum= 当前结果值   --比如使用体力丹会加体力
        maxLimit = 可拥有的上限  --体力和精力都有上限
        tips = 使用描述
    }

]======================]

function CommonBatchUsePanel:ctor(param)
    print("CommonBatchUsePanel",debug.traceback("", 2))
	self._params = param or nil 

	assert(param, "CommonBatchUsePanel param error~~~~~ ")
    self:enableNodeEvents()

end

function CommonBatchUsePanel:_init()

	self:setPosition(display.cx, display.cy)

    -- 创建弹框
    self._csbNode = cc.CSLoader:createNode(G_Url:getCSB("CommonUseNode", "common"))
    self:addChild(self._csbNode)
    ccui.Helper:doLayout(self._csbNode)

    UpdateNodeHelper.updateCommonNormalPop(self,G_Lang.get("common_title_batch_use_item"),function()
        self:removeFromParent(true)
    end,460)

    -- 默认使用数量
    local useCount = 1
    
    local itemInfo = self._params.itemInfo

    local ownNum = rawget(self._params,"ownNum") and self._params.ownNum or 0
    local curResultNum = rawget(self._params,"curResultNum") and self._params.curResultNum or 0
    local maxLimit = rawget(self._params,"maxLimit") and self._params.maxLimit or 0

    local function _updateAmount(num)
      
      	--num = num == 10 and 9 or num

		-- 最少使用1次
		local newUseCount = math.max(useCount + num, 1)
        if num == 10 and newUseCount == 11 then
            newUseCount = 10
        end

		-- 如果使用这么多次最后会有多少个产出物品
		local newResultNum = newUseCount * itemInfo.item_value + curResultNum

		-- 如果最终的产出物品大于玩家可拥有的上限
		if newResultNum > maxLimit then
			newUseCount = math.floor((maxLimit - curResultNum) / itemInfo.item_value)
		end
		
		--print("newUseCount="..newUseCount.." itemInfo.item_value="..itemInfo.item_value.."  curResultNum="..curResultNum
		--	.."  newResultNum="..newResultNum.."  maxLimit="..maxLimit)

		-- 再和当前拥有的数量取最小值
		newUseCount = math.min(ownNum, newUseCount)

		useCount= newUseCount
		
        self._csbNode:updateLabel("Text_amount", {text=useCount})


    end

    _updateAmount(0)

    self._csbNode:updateButton("Button_sub10", function()
        _updateAmount(-10)
    end, 0)
    self._csbNode:updateButton("Button_sub1", function()
        _updateAmount(-1)
    end, 0)
    self._csbNode:updateButton("Button_add10", function()
        _updateAmount(10)
    end, 0)
    self._csbNode:updateButton("Button_add1", function()
        _updateAmount(1)
    end, 0)

    --dump(itemInfo)

    -- 更新icon框
    UpdateNodeHelper.updateCommonIconNode(self._csbNode:getSubNodeByName("Image_icon"), 
        {type=TypeConverter.TYPE_ITEM, value=itemInfo.id, sizeVisible = false,nameVisible = false})

    -- 然后是数量以及描述等
    local color = TypeConverter.quality2Color(itemInfo.quality)
    self._csbNode:updateLabel("Text_name", { 
        text=tostring(itemInfo.name),
        textColor = G_Colors.qualityColor2Color(color,true),
        outlineColor = G_Colors.qualityColor2OutlineColor(color),
        fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL
        })
    --UpdateNodeHelper.updateQualityLabel(self:getSubNodeByName("Text_name"), TypeConverter.quality2Color(itemInfo.quality), itemInfo.name, 24, true)

    -- self._csbNode:updateLabel("Text_tips", {text = rawget(self._params,"tips") and self._params.tips or ""
    --     })

    -- local addCountPanel = self._csbNode:getSubNodeByName("Panel_addCount")
    -- if ownNum > 0 then
    --     addCountPanel:setPositionY(addCountPanel:getPositionY()-13)
    -- end


    --当前拥有数量
    self._csbNode:updateLabel("Text_own_amount", { text=tostring(ownNum)})

    UpdateButtonHelper.updateBigButton(self._csbNode:getSubNodeByName("Node_cancel"), {
        state = UpdateButtonHelper.STATE_NORMAL,
        desc = G_Lang.get("common_btn_cancel"),
        callback = function()
            self:removeFromParent(true)
        end
    })
    UpdateButtonHelper.updateBigButton(self._csbNode:getSubNodeByName("Node_confirm"), {
        state = UpdateButtonHelper.STATE_ATTENTION,
        desc = G_Lang.get("sure"),
        callback = function()
        	--使用道具
        	G_HandlersManager.PropsHandler:sendUseItem(itemInfo.id, useCount)

        end
    })
end


--可能不是背包界面弹出批量使用框，所以使用反馈写在这
function CommonBatchUsePanel:_useOkHandler(msg)
    
    if type(msg) ~= "table" then return end

    local itemInfo = ItemInfo.get(msg.id)

    --非礼包类 礼包在包裹layer已经监听了
    if itemInfo.item_type ~= ItemConst.ITEM_TYPE_GIFTBAG and
    itemInfo.item_type ~= ItemConst.ITEM_TYPE_RANDOM_GIFTBAG then
    	G_Popup.tip(tostring(itemInfo.tips))
    end

    --G_Popup.tip(G_LangScrap.get("common_item_use_success"))

    self:removeFromParent(true)

end



function CommonBatchUsePanel:onEnter()

    self:_init()

    uf_eventManager:addEventListener(G_EVENTMSGID.EVNET_USE_ITEM_SUCCESS, self._useOkHandler,self)
end

function CommonBatchUsePanel:onExit()
    uf_eventManager:removeListenerWithTarget(self)
    if self._csbNode ~= nil then
        self._csbNode:removeFromParent(true)
        self._csbNode = nil
    end
end

return CommonBatchUsePanel

