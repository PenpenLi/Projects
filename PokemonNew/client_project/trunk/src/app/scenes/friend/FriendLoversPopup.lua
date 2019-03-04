--[====================[
	情侣系统弹出框
]====================]
local FriendLoversPopup = {}

local PopupBase = require "app.popup.common.PopupBase"

local storage = require("app.storage.storage")
local UpdateNodeHelper = require "app.common.UpdateNodeHelper"
local UpdateButtonHelper = require "app.common.UpdateButtonHelper"
local ModuleEntranceHelper = require("app.common.ModuleEntranceHelper")
local TextHelper = require ("app.common.TextHelper")
local FriendLoversInvitePop = require("app.scenes.friend.FriendLoversInvitePop")
local TeamUtils = require ("app.scenes.team.TeamUtils")

---自动匹配弹出框
function FriendLoversPopup.newAutoMatchPopup()
    local view = cc.CSLoader:createNode(G_Url:getCSB("FriendAutoMatchPop", "friend"))
    PopupBase.newPopupWithTouchEnd(function ()
        local isMan = nil
        local timer = nil

        -- 标题
        UpdateNodeHelper.updateCommonNormalPop(view:getSubNodeByName("ProjectNode_bg"),G_Lang.get("lang_lovers_title_auto_match"),function ( ... )
            view:_removeTimer()
            view:removeFromParent()
            uf_eventManager:removeListenerWithTarget(view)
        end,364)

        --按钮状态设置
        UpdateButtonHelper.updateBigButton(view:getSubNodeByName("btn_ok"), {state = UpdateButtonHelper.STATE_ATTENTION, 
            desc = G_Lang.get("common_btn_start_match"), callback = function ( ... )
            if isMan == nil then -- 未选择性别
                G_Popup.tip("请选择对方性别")
                return 
            end
            G_HandlersManager.friendHandler:sendApplyMatch(isMan)
            view:_removeTimer()

            -- 提示
            G_Popup.tip("开始自动匹配")
            --view:removeFromParent() 
        end})

        --checkbox男女选择
        local CheckBox_man = view:getSubNodeByName("CheckBox_man")
        local CheckBox_woman = view:getSubNodeByName("CheckBox_woman")
        CheckBox_man:addEventListener(function (sender,type)
            --dump(type)
            if type == CHECKBOX_STATE_EVENT_SELECTED then
                isMan = true
                CheckBox_woman:setSelected(false)
            elseif type == CHECKBOX_STATE_EVENT_UNSELECTED then
                isMan = false
                CheckBox_woman:setSelected(true)
            end
        end)
        CheckBox_woman:addEventListener(function (sender,type)
            --dump(type)
            if type == CHECKBOX_STATE_EVENT_SELECTED then
                isMan = false
                CheckBox_man:setSelected(false)
            elseif type == CHECKBOX_STATE_EVENT_UNSELECTED then
                isMan = true
                CheckBox_man:setSelected(true)
            end
        end)

         -- 定时器申请排队人数
        if timer == nil then 
            timer = GlobalFunc.addTimer(1, function ( ... )
                G_HandlersManager.friendHandler:sendGetTotalQueueNum(isMan)
            end)
            G_HandlersManager.friendHandler:sendGetTotalQueueNum(isMan)
        end

          -- 移除定时器
        function view:_removeTimer()
            if timer then
                GlobalFunc.removeTimer(timer)
                timer = nil
            end
        end

        -- 添加网络监听,开始匹配 @isSuccess :是否直接匹配成功
        function view:_endPop( isSuccess )
            if not isSuccess then 
                --dump("FriendLoversPopup.newMatchingPopup() !!!!!!!!!!!")
                --dump(debug.traceback("描述:", 2))
                --FriendLoversPopup.newMatchingPopup() 
            end
            uf_eventManager:removeListenerWithTarget(view)
            view:_removeTimer()
            view:removeFromParent()
        end
        function view:_refreshQueue( num )
            view:updateLabel("Text_wait_num",num)
        end
        uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_LOVERS_APPLY_MATCH, view._endPop, view)
        uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_LOVERS_REFRESH_TOTALQUEUE, view._refreshQueue, view)

        -- 初始化选择
        CheckBox_man:setSelected(true)
        isMan = true

        ---添加到当前场景
        view:setPosition(display.cx, display.cy)
        return view
    end, false, false,view,nil,function() 
         view:_removeTimer()
    end)
end

---匹配状态弹出框
function FriendLoversPopup.newMatchingPopup()
    local view = cc.CSLoader:createNode(G_Url:getCSB("FriendMatchingPop", "friend"))
    PopupBase.newPopupWithTouchEnd(function ()
        local timer = nil


        -- 标题
        UpdateNodeHelper.updateCommonNormalPop(view:getSubNodeByName("ProjectNode_bg"),G_Lang.get("lang_lovers_title_matching"),function ( ... )
            dump("close popup")
            view:_removeTimer()
            view:removeFromParent()
        end,344)

        --按钮状态设置
        UpdateButtonHelper.updateNormalButton(view:getSubNodeByName("btn_cancel"), {state = UpdateButtonHelper.STATE_NORMAL, 
            desc = "取消匹配", callback = function ( ... )
            G_HandlersManager.friendHandler:sendCancelMatch()
            view:_removeTimer()
            dump("取消匹配!!")
            view:removeFromParent()
        end})
        UpdateButtonHelper.updateNormalButton(view:getSubNodeByName("btn_ok"), {state = UpdateButtonHelper.STATE_GRAY, 
            desc = G_Lang.get("lovers_btn_matching"), callback = function ( ... )
        end})

        --获取数据
       
        --界面渲染
       -- view:updateLabel("Text_wait_num",rank)

        -- 定时器申请排队人数
        if timer == nil then 
            timer = GlobalFunc.addTimer(1, function ( ... )
                G_HandlersManager.friendHandler:sendGetQueueNum()
            end)
            G_HandlersManager.friendHandler:sendGetQueueNum()
        end

        -- 移除定时器
        function view:_removeTimer()
            if timer then
                GlobalFunc.removeTimer(timer)
                timer = nil
            end
        end

        -- 添加网络监听,前面还有人数刷新
        function view:_refreshQueue( num )
            view:updateLabel("Text_wait_num",num)

            -- if num <= 0 then -- 匹配成功，离开界面
            --     view:_removeTimer()
            --     view:removeFromParent()
            -- end
        end
        -- 成功配对
        function view:_endPop()
            view:_removeTimer()
            view:removeFromParent()

           -- FriendLoversPopup.newBeLoversPopup()
        end
        uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_LOVERS_REFRESH_QUEUE, view._refreshQueue, view)
        uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_LOVERS_MATCH_RESULT, view._endPop, view)

        ---添加到当前场景
        view:setPosition(display.cx, display.cy)
        return view
    end, false, false,view,nil,function ( ... )
         view:_removeTimer()
    end)
end

---伴侣请求信息框弹出框
function FriendLoversPopup.newLoversInfoPopup(data)
    PopupBase.newPopupWithTouchEnd(function ()
        local view = cc.CSLoader:createNode(G_Url:getCSB("FriendLoversInfoPop", "friend"))

        -- 标题
        UpdateNodeHelper.updateCommonNormalPop(view:getSubNodeByName("projectNode_common"),"玩家信息",function ( ... )
            view:removeFromParent()
        end,347)

        --按钮状态设置
        UpdateButtonHelper.updateNormalButton(view:getSubNodeByName("FileNode_cancel"), {state = UpdateButtonHelper.STATE_NORMAL, 
            desc = "算了", callback = function ( ... )
            view:removeFromParent()
        end})
        UpdateButtonHelper.updateNormalButton(view:getSubNodeByName("FileNode_ok"), {state = UpdateButtonHelper.STATE_ATTENTION, 
            desc = "在一起", callback = function ( ... )
            G_HandlersManager.friendHandler:sendWantToBeLovers(data.name)
            view:removeFromParent()
        end})

        -- 获取数据
        local iconKnight = view:getSubNodeByName("Node_item_icon")
        local common_node = view:getSubNodeByName("Node_common")
        local myUid = G_Me.userData.id

        local mainRoleName = data.name
        local level = data.level
        local power = data.power
        local headIcon = data.title_pic
        local headFrame = data.pic_frame
        local quality = data.leader_quality
        local guildName = data.guild_name
        if guildName == nil or guildName == "" then
            guildName = G_Lang.get("common_text_no")
        end
        local sex = data.sex

        dump(quality)
        local color = G_TypeConverter.quality2Color(quality)
        local icon_frame = G_Url:getUI_frame("img_frame_0"..color)

        -- 界面渲染
        --头像
        UpdateNodeHelper.updateCommonIconNode(common_node,{
            type=G_TypeConverter.TYPE_KNIGHT,
            value= headIcon,
            nameVisible=false,
            levelVisible=false,
            scale = 0.8,
            icon_bg = icon_frame,
            frame_value = headFrame
        },function( ... )
        end)

        --local color = G_TypeConverter.quality2Color(knightInfo.quality)
        view:updateLabel("Text_user_name", {
            text = mainRoleName,
            textColor = G_Colors.qualityColor2Color(color,true),
            outlineColor = G_Colors.qualityColor2OutlineColor(color),
            })
        view:updateLabel("Label_id_value", {text=tostring(level)})
        view:updateLabel("Label_bang_value", {text=guildName})
        view:updateLabel("Label_power_value", {text=tostring(power)})

        -- 情侣相关
        view:updateImageView("Image_sex", sex == 1 and G_Url:getUI_common_icon("nan") or G_Url:getUI_common_icon("nv"))

        ---添加到当前场景
        view:setPosition(display.cx, display.cy)
        return view
    end, false, false)
end

---确认发送世界弹出框
function FriendLoversPopup.newTellWorldPopup(data)
    PopupBase.newPopupWithTouchEnd(function ()
        local view = cc.CSLoader:createNode(G_Url:getCSB("FriendTellWorldPop", "friend"))

        -- 标题
        UpdateNodeHelper.updateCommonNormalPop(view:getSubNodeByName("ProjectNode_bg"),"提示",function ( ... )
            view:removeFromParent()
        end,344)

        --按钮状态设置
        UpdateButtonHelper.updateNormalButton(view:getSubNodeByName("btn_cancel"), {state = UpdateButtonHelper.STATE_NORMAL, 
            desc = G_Lang.get("common_btn_cancel"), callback = function ( ... )
            view:removeFromParent()
        end})
        UpdateButtonHelper.updateNormalButton(view:getSubNodeByName("btn_ok"), {state = UpdateButtonHelper.STATE_ATTENTION, 
            desc = G_Lang.get("sure"), callback = function ( ... )
            G_HandlersManager.friendHandler:sendTellWorld()
            view:removeFromParent()
        end})

        --获取数据
        local num = G_Me.loversData:getLoversCfg().maxWorldNum - G_Me.loversData:getSendNumWorld()--rawget(data,"num") and data.num or 0  
        local cost = G_Me.loversData:getLoversCfg().worldCostBase * (G_Me.loversData:getSendNumWorld())--rawget(data,"cost") and data.cost or 0  
       
        --界面渲染
        view:getSubNodeByName("Node_tell_cost"):setVisible(cost ~= 0)
        view:updateLabel("Text_left_num",num)
        view:updateLabel("Text_tell_cost_num",G_Lang.get("lovers_cost_desc",{num = cost}))

        ---添加到当前场景
        view:setPosition(display.cx, display.cy)
        return view
    end, false, false)
end

---寻找情侣弹出框
function FriendLoversPopup.newFindLoversPopup()
    local view = cc.CSLoader:createNode(G_Url:getCSB("FriendFindLoversPop", "friend"))
    PopupBase.newPopupWithTouchEnd(function ()
        --local view = cc.CSLoader:createNode(G_Url:getCSB("FriendFindLoversPop", "friend"))

          -- 标题
        UpdateNodeHelper.updateCommonNormalPop(view:getSubNodeByName("ProjectNode_bg"),"寻找情侣",function ( ... )
            uf_eventManager:removeListenerWithTarget(view)
            view:removeFromParent()
        end,385)

          --获取数据
        local leftWorld = G_Me.loversData:getLoversCfg().maxWorldNum - G_Me.loversData:getSendNumWorld()--rawget(data,"num") and data.num or 0  
        local leftFriend = G_Me.loversData:getLoversCfg().maxFriendNum - G_Me.loversData:getSendNumFriend()--rawget(data,"num") and data.num or 0  
        local cost = G_Me.loversData:getLoversCfg().worldCostBase * (G_Me.loversData:getSendNumWorld())--rawget(data,"cost") and data.cost or 0  
       

        ---创建editbox来代替当前的输入框
        local imageTextBg = view:getSubNodeByName("Image_text_bg")
        local editBox = ccui.EditBox:create(cc.size(349, 42), G_Url:getUI_createRole("create_role_input_bg"))
        editBox:setFontName(G_Path.getNormalFont())
        editBox:setFontSize(19)
        editBox:setFontColor(cc.c4b(0xff, 0xff, 0xff, 0xff))
        editBox:setPlaceHolder("")
        editBox:setPlaceholderFontColor(cc.c4b(0xff, 0xff, 0xff, 0xff))
        editBox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
        editBox:setAnchorPoint(0, 0)
        editBox:setPosition(18, 0)
        editBox:registerScriptEditBoxHandler(function(strEventName, pSender)
            local edit = pSender
            local strFmt 
            if strEventName == "began" then
            elseif strEventName == "ended" then
                    
            elseif strEventName == "return" then
                local text = edit:getText()

                if text ~= "" then
                    G_HandlersManager.friendHandler:sendAlterDeclaration(text)
                end

                editBox:setText(G_Me.loversData:getDeclaration())
                --dump(text)
                -- if self:_hasSpecial(text) then
                --     self._nameText:setText("")
                -- end
            elseif strEventName == "changed" then
                
            end
        end)

        imageTextBg:addChild(editBox, 0)
        local nameText = editBox

        --渲染
        --view:updateLabel("Text_declaration",G_Me.loversData:getDeclaration())
        editBox:setText(G_Me.loversData:getDeclaration())
        view:updateLabel("Text_left_world",leftWorld)
        view:updateLabel("Text_left_friend",leftFriend)
        view:updateLabel("Text_world_cost",cost)

          --按钮状态设置
        UpdateButtonHelper.updateBigButton(view:getSubNodeByName("FileNode_find_world"), {state = UpdateButtonHelper.STATE_NORMAL, 
            desc = "世界寻找", callback = function ( ... )
                if G_Me.loversData:getLoversCfg().maxWorldNum <= G_Me.loversData:getSendNumWorld() then
                    G_Popup.tip("今日世界喊话次数已用完")
                    return
                end

            --G_HandlersManager.friendHandler:sendTellWorldCount()
            G_HandlersManager.friendHandler:sendTellWorld()
            view:removeFromParent()
            --FriendLoversPopup.newTellWorldPopup()
        end})
        UpdateButtonHelper.updateBigButton(view:getSubNodeByName("FileNode_find_friend"), {state = UpdateButtonHelper.STATE_ATTENTION, 
            desc = "好友寻找", callback = function ( ... )
            G_Popup.newPopup(function ()
                local popLayer = FriendLoversInvitePop.new()
                return popLayer
            end)
            view:removeFromParent()
        end})
        view:updateButton("Button_save_word",function ( ... ) -- 修改宣言
            editBox:touchDownAction(editBox,ccui.TouchEventType.ended)
            --FriendLoversPopup.newAlterWordPopup()
        end )

        -- 添加网络监听
        function view:_refreshDeclaration() -- 刷新宣言内容
            --view:updateLabel("Text_declaration",G_Me.loversData:getDeclaration())
            editBox:setText(G_Me.loversData:getDeclaration())
        end
        uf_eventManager:addEventListener(G_EVENTMSGID.EVENT_LOVERS_ALTER_DECLARATION, view._refreshDeclaration, view)

          ---添加到当前场景
        view:setPosition(display.cx, display.cy)
        return view
    end, false, false,view)
end

---修改喊话弹出框
function FriendLoversPopup.newAlterWordPopup()
    PopupBase.newPopupWithTouchEnd(function ()
        local view = cc.CSLoader:createNode(G_Url:getCSB("FriendAlterWordPop", "friend"))
        local strWord = ""

        -- 标题
        UpdateNodeHelper.updateCommonNormalPop(view:getSubNodeByName("ProjectNode_bg"),"修改宣言",function ( ... )
            view:removeFromParent()
        end,344)

         ---创建editbox来代替当前的输入框
        local imageTextBg = view:getSubNodeByName("Image_text_bg")
        local editBox = ccui.EditBox:create(cc.size(460, 42), G_Url:getUI_createRole("create_role_input_bg"))
        editBox:setFontName(G_Path.getNormalFont())
        editBox:setFontSize(19)
        editBox:setFontColor(cc.c4b(0xff, 0xff, 0xff, 0xff))
        editBox:setPlaceHolder("请输入宣言内容")
        editBox:setPlaceholderFontColor(cc.c4b(0xff, 0xff, 0xff, 0xff))
        editBox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
        editBox:setAnchorPoint(0, 0)
        editBox:setPosition(18, 0)

        imageTextBg:addChild(editBox, 0)
        local nameText = editBox

        -- 按钮监听
        UpdateButtonHelper.updateBigButton(view:getSubNodeByName("FileNode_ok"), {state = UpdateButtonHelper.STATE_NORMAL, 
            desc = "确认", callback = function ( ... )
            local nameTxt = nameText:getText()
            nameTxt = string.trim(nameTxt)
            G_HandlersManager.friendHandler:sendAlterDeclaration(nameTxt)
            view:removeFromParent()
        end})

        ---添加到当前场景
        view:setPosition(display.cx, display.cy)
        return view
    end, false, false)
end


---成功配对弹出框
function FriendLoversPopup.newBeLoversPopup()
    PopupBase.newPopupWithTouchEnd(function ()
        local view = cc.CSLoader:createNode(G_Url:getCSB("FriendLoversMatchResultLayer", "friend"))
        view:setContentSize(display.width,display.height)
        ccui.Helper:doLayout(view)

        --获取数据
        local knightData = G_Me.teamData:getKnightDataByPos(1)
        if knightData == nil then
            return view
        end
        dump(knightData.serverData)
        local name = G_Me.loversData:getLoversInfo():getName()  
        local sex = G_Me.loversData:getLoversInfo():getSex() 
        local _,star = TeamUtils.level2starName(G_Me.loversData:getLoversInfo():getStar())  
        local _,starMe = TeamUtils.level2starName(knightData.serverData.starLevel)

        dump(star)
        dump(knightData.serverData.base_id)
        dump(knightData.serverData.starLevel)

        --界面渲染
        view:updateLabel("Text_success_desc",G_Lang.get("lovers_to_be_lovers2",{name = name}))
        local knightMe = require("app.common.KnightImg").new(knightData.serverData.knightId,starMe,0)
        local knightLovers = require("app.common.KnightImg").new(sex == 1 and 1 or 11,star,0)
        view:getSubNodeByName("Node_spine_me"):addChild(knightMe)
        view:getSubNodeByName("Node_spine_lovers"):addChild(knightLovers)

        -- 发送确认收到信息
        view:performWithDelay(function()
            G_HandlersManager.friendHandler:sendSureMatchResult()
        end, 0.3)

        -- 飘雪特效
        local EffectNode = require("app.effect.EffectNode")
        local backGroundEffect = EffectNode.createEffect("effect_misson_2",{x=0,y=0},view)
        backGroundEffect:setPosition(display.cx, display.cy + 300)

        ---添加到当前场景
        --view:setPosition(display.cx, display.cy)
        return view
    end, false, false)
end

---解除情侣弹出框
function FriendLoversPopup.newRelieveLoversPopup(callBack)
    PopupBase.newPopupWithTouchEnd(function ()
        local view = cc.CSLoader:createNode(G_Url:getCSB("FriendRelieveLoversPop", "friend"))

        -- 标题
        UpdateNodeHelper.updateCommonNormalPop(view:getSubNodeByName("ProjectNode_bg"),G_Lang.get("lang_lovers_title_relieve_lovers"),function ( ... )
            view:removeFromParent()
        end,366)

        --按钮状态设置
        UpdateButtonHelper.updateBigButton(view:getSubNodeByName("btn_ok"), {state = UpdateButtonHelper.STATE_ATTENTION, 
        desc = "确定", callback = function ( ... )
            G_HandlersManager.friendHandler:sendRelieveLovers(G_Me.loversData:getLoversInfo():getId())
            if callBack then callBack() end
            view:removeFromParent()
        end})
        UpdateButtonHelper.updateBigButton(view:getSubNodeByName("btn_cancel"), {state = UpdateButtonHelper.STATE_NORMAL, 
        desc = "取消", callback = function ( ... )
            view:removeFromParent()
        end})

        --获取数据
        local leftTime = G_Me.loversData:getLoversInfo():getOffLineSeconeds() 
        local name = G_Me.loversData:getLoversInfo():getName()
        local isCharge = leftTime == 0 or (G_ServerTime:getTime() - leftTime < 172800)
        --dump(leftTime)

        --界面渲染
        view:getSubNodeByName("Node_relieve_cost"):setVisible(isCharge)
        view:updateLabel("Text_relieve_desc",isCharge and G_Lang.get("lovers_tell_world_cost") or G_Lang.get("lovers_tell_world_free"))
        view:updateLabel("Text_relieve_name",G_Lang.get("lovers_to_be_lovers3",{name = name}))

        ---添加到当前场景
        view:setPosition(display.cx, display.cy)
        return view
    end, false, true)
end

---确认成为情侣弹出框
function FriendLoversPopup.newSureBeLoversPopup(data)
    PopupBase.newPopupWithTouchEnd(function ()
        local view = cc.CSLoader:createNode(G_Url:getCSB("FriendSureBeLoversPop", "friend"))

        -- 标题
        UpdateNodeHelper.updateCommonNormalPop(view:getSubNodeByName("ProjectNode_bg"),"提示",function ( ... )
            view:removeFromParent()
        end,344)

        --按钮状态设置
        UpdateButtonHelper.updateNormalButton(view:getSubNodeByName("btn_ok"), {state = UpdateButtonHelper.STATE_ATTENTION, 
        desc = "确定", callback = function ( ... )
            G_HandlersManager.friendHandler:sendAcceptRespond(data.id)
            view:removeFromParent()
        end})
        UpdateButtonHelper.updateNormalButton(view:getSubNodeByName("btn_cancel"), {state = UpdateButtonHelper.STATE_NORMAL, 
        desc = "取消", callback = function ( ... )
            view:removeFromParent()
        end})

        --获取数据
       
        --界面渲染
        view:updateLabel("Text_be_lovers",G_Lang.get("lovers_to_be_lovers1",{name = data.name}))

        ---添加到当前场景
        view:setPosition(display.cx, display.cy)
        return view
    end, false, false)
end


return FriendLoversPopup
