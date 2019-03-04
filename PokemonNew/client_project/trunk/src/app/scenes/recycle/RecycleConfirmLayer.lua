--[====================[

    高品质神将装备材料警告面板

]====================]
local RecycleConfirmLayer = class("RecycleConfirmLayer",function()
	return display.newLayer()
end)

--
local PopupBase = require("app.popup.common.PopupBase")
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"

--
function RecycleConfirmLayer.popup(txt, call)
    PopupBase.newPopup(function()
        return RecycleConfirmLayer.new(txt, call)
    end)
end

--
function RecycleConfirmLayer:ctor(txt, call)
    self:enableNodeEvents()
    --
	self._txt = txt
    self._callback = call
    self._content = nil
    self._richText = nil
end

--
function RecycleConfirmLayer:onEnter()
	self:_initWidget()
	self:_updateWidget()
end

--
function RecycleConfirmLayer:onExit()
end

-- 初始化界面
function RecycleConfirmLayer:_initWidget()
	self:setPosition(cc.p(display.cx, display.cy))
	-- csb
	self._content = cc.CSLoader:createNode(G_Url:getCSB("RecycleConfirmLayer", "recycle"))
	self:addChild(self._content)
	
	-- update
	self._content:updateLabel("Text_title", G_LangScrap.get("recycle_confirm_decompose"))
	self._content:updateButton("Button_close", function()
        self:removeFromParent(true)
    end)

    UpdateButtonHelper.updateNormalButton(
        self:getSubNodeByName("Button_next_time"),{
        state = UpdateButtonHelper.STATE_NORMAL,
        desc = G_LangScrap.get("recycle_next_time"),
        callback = function ()
            self:removeFromParent(true)
        end
    })

    UpdateButtonHelper.updateNormalButton(
        self:getSubNodeByName("Button_confirm"),{
        state = UpdateButtonHelper.STATE_ATTENTION,
        desc = G_LangScrap.get("recycle_sure"),
        callback = function ()
            if self._callback then
                self._callback()
            end
            self:removeFromParent(true)
        end
    })
    
    -- create RichText
    self._richText = ccui.RichText:createWithContent(self._txt)
    self._content:addChild(self._richText)
    self._richText:setPosition(cc.p(5, 18))
    self._richText:ignoreContentAdaptWithSize(false)
    self._richText:setContentSize(cc.size(460, 120))
end

-- 更新界面
function RecycleConfirmLayer:_updateWidget()
    
end


return RecycleConfirmLayer