
--=====
--单个聊天信息显示
local ChatScrollItem = class("ChatScrollItem", function ()
    local layer = display.newLayer()
    layer:setAnchorPoint(0, 0)
	return layer
end)

local KnightInfo = require "app.cfg.knight_info"
local TypeConverter = require "app.common.TypeConverter"
local ChatFaceLayer = require "app.scenes.chat.ChatFaceLayer"
local UpdateNodeHelper = require "app.common.UpdateNodeHelper"
--local SubtitleFormatParser = require "app.subtitle.SubtitleFormatParser"
local FriendLoversPopup = require("app.scenes.friend.FriendLoversPopup")

local offSetX = 3
---===
--@isLeft 是否在左侧显示
--@chatUnit 显示数据
--@listWidth
function ChatScrollItem:ctor(isLeft, chatUnit, listWidth)
    assert(isLeft or type(isLeft) == "boolean", "invalide isLeft " .. tostring(isLeft))
    assert(chatUnit or type(chatUnit) == "table", "invalide chatUnit " .. tostring(chatUnit))
    assert(listWidth or type(listWidth) == "number", "invalide listWidth " .. tostring(listWidth))

	self._isLeft = isLeft
	self._chatUnit = chatUnit --聊天数据
    --dump(self._chatUnit)
	self._needShowTime = self._chatUnit:getNeedShowTimeLabel() --是否需要显示时间。
	self._listWidth = listWidth --列表的宽度。
	self._view = nil
    self._extraHeight = 0 --因表情和多行，多出的显示高度
	self._viewTimeNode = nil
    self:_initUI()
end

function ChatScrollItem:getTotalHeight()
	local viewSize = self._view:getContentSize()
	local viewTimeHeight = self._viewTimeNode == nil and 0 or self._viewTimeNode:getContentSize().height

	return viewSize.height + viewTimeHeight + self._extraHeight
end

function ChatScrollItem:_initUI()
    local channel = self._chatUnit:getChannel()

	self._view = cc.CSLoader:createNode(G_Url:getCSB(self._isLeft and "ChatLeftLayer" or "ChatRightLayer", "chat"))
	self:addChild(self._view)

	local viewSize = self._view:getContentSize()

    local color = G_TypeConverter.quality2Color(self._chatUnit:getSenderQuality())
    dump(self._chatUnit:getSenderSid())
    local server_id = (self._chatUnit:getSenderSid())%1000
    self._view:updateLabel("Text_name",{
    	text = self._chatUnit:getName(),
        textColor = G_Colors.qualityColor2Color(color),
    	--outlineColor = G_Colors.qualityColor2OutlineColor(color),
        --fontSize = 17
    })
    self._view:updateLabel("Text_sid","")

    self._view:updateImageView("Image_content_bg", {
        callback = function ( ... )
            if self._isLeft and self._chatUnit:getChannel() == G_Me.chatData.CHANNEL_PRIVATE then
                local strName = self._chatUnit:getName()
                uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_CHAT_HIT_PRI_MSG, nil, false, strName)
            end
        end
        })

    local common_node = self:getSubNodeByName("Node_common")

    local icon_frame = G_Url:getUI_frame("img_frame_0"..color)
   
    UpdateNodeHelper.updateCommonIconNode(common_node,{
        type = TypeConverter.TYPE_KNIGHT,
        value = self._chatUnit:getSenderHeadIcon(),
        scale = 0.8,
        nameVisible = false,
        icon_bg = icon_frame,
        frame_value = self._chatUnit:getSenderHeadFrame()
        }
    	,function() 
	        if G_Me.userData.id ~= self._chatUnit:getSenderId() and channel ~= G_Me.chatData.CHANNEL_TEAM then
	            G_HandlersManager.commonHandler:sendGetCommonBattleUser(self._chatUnit:getSenderId(), 1)
	        end
    	end
    )

    --私聊处理
    local priNode = self._view:getSubNodeByName("Node_pri")
    local txt_name = priNode:getChildByName("Text_name_pri")
    local txt_tosay = priNode:getChildByName("Text_to_say")
    local nameSize = nil
    local tosaySize = txt_tosay:getContentSize()
    if channel == G_Me.chatData.CHANNEL_PRIVATE then
        self._view:updateLabel("Text_name",{visible = false})
        self._view:updateLabel("Text_sid",{visible = false})

        --私聊名
        dump(color)
        local recColor = G_TypeConverter.quality2Color(self._chatUnit:getRecQuality())
        dump(recColor)
        self._view:updateLabel("Text_name_pri",{
            text = self._isLeft == true and self._chatUnit:getName() or self._chatUnit:getRecName(),
            textColor = self._isLeft == true and G_Colors.qualityColor2Color(color) or G_Colors.qualityColor2Color(recColor),
            --outlineColor = self._isLeft == true and G_Colors.qualityColor2OutlineColor(color) or G_Colors.qualityColor2OutlineColor(recColor),
            --fontSize = 17
        })

        nameSize = txt_name:getContentSize()

        priNode:setVisible(true)
    else
        self._view:updateLabel("Text_name",{visible = true})
        priNode:setVisible(false)

        if channel == G_Me.chatData.CHANNEL_TEAM then
            local server_id = (self._chatUnit:getSenderSid())%1000
            self._view:updateLabel("Text_name",{
                text = self._chatUnit:getName() ,--.. "<S" .. server_id .. ">",
                textColor = G_Colors.qualityColor2Color(color),
                --outlineColor = G_Colors.qualityColor2OutlineColor(color),
                --fontSize = 17
            })
            self._view:updateLabel("Text_sid","<S" .. server_id .. ">")
            self._view:getSubNodeByName("Text_name"):setPosition(self._isLeft and 129.00 or 136.00, self._view:getSubNodeByName("Text_name"):getPositionY())
            if self._isLeft then -- 左边情况比较特效
                local sizeW = self._view:getSubNodeByName("Text_name"):getAutoRenderSize()
                local sizeW2 = self._view:getSubNodeByName("Text_name"):getVirtualRendererSize()
                dump(sizeW)
                dump(sizeW2)
                self._view:getSubNodeByName("Text_sid"):setPositionX(134 + sizeW.width)
            end
        else
            self._view:getSubNodeByName("Text_name"):setPosition(self._isLeft and 132.00 or 166.00, self._view:getSubNodeByName("Text_name"):getPositionY())
        end
    end

    --在内部定位左边和右边
    if self._isLeft then
    	self._view:setAnchorPoint(0, 0)
    	self._view:setPositionX(0)
        if channel == G_Me.chatData.CHANNEL_PRIVATE then
            txt_tosay:setPositionX(txt_name:getPositionX() + nameSize.width + offSetX)
        end
    else
    	self._view:setAnchorPoint(1, 0)
    	self._view:setPositionX(self._listWidth)
        if channel == G_Me.chatData.CHANNEL_PRIVATE then
            txt_tosay:setPositionX(txt_name:getPositionX() - nameSize.width - offSetX)
        end
    end
    self._view:setPositionX(self._isLeft and 0 or self._listWidth)

    if self._needShowTime then
    	self._viewTimeNode = cc.CSLoader:createNode(G_Url:getCSB("ChatTimeTipsLayer", "chat"))
    	self._viewTimeNode:setAnchorPoint(0.5, 0)
    	self._view:addChild(self._viewTimeNode)
    	self._viewTimeNode:setPosition(self._isLeft and viewSize.width or 0, viewSize.height)
    	self._viewTimeNode:updateLabel("Text_time", {
    		text = G_ServerTime:getTimeString(self._chatUnit:getTime())
    	})
    end

    self:_showTxt(self._chatUnit:getContent())
end

---将文本转换为可以使用的富文本格式。
function ChatScrollItem:_showTxt(strInput)
	---判断当前文本是一行还是两行。以及文本的总高度。
    local maxLineWidth = 342 ---一行的最大宽度。
    local fontSize = 19
    local singleWordWidth = fontSize/2
    local emotionWidth = 55
    local emotionHeight = 35
    local startPos, endPos
    local totalWidth = 0
    local totalHeight = 0--文本的总宽高。
    local emotions = {}
    local lineOne, lineTwo ---第一行，第二行显示的内容。
    repeat
        if startPos then --查找表情
            emotions[#emotions + 1] = {
                startPos = startPos,
                endPos = endPos
            }
        end
        startPos, endPos = string.find(strInput, "#%d+#", endPos and endPos + 1)
    until not startPos

    if #emotions > 0 then ---计算加入表情后的字符串显示长度。
        startPos = 1
        local strOne, strTwo
        local cutStr
        repeat
            if totalWidth >= maxLineWidth then --如果长度已经大于一行，剩余的就是第二行，直接跳出。
                lineOne = string.sub(strInput, 1, startPos - 1)
                lineTwo = string.sub(strInput, startPos)
                lineTwo = lineTwo ~= "" and lineTwo or nil
                startPos = nil
            else
                if not emotions[1] then
                    cutStr = string.sub(strInput, startPos)

                    strOne, strTwo = self:_getCutStr2Length(cutStr, totalWidth, maxLineWidth, singleWordWidth)
                    totalWidth = totalWidth + GlobalFunc.getTextWidth(strOne,19)
                    lineOne = string.sub(strInput, 1, startPos - 1) .. strOne
                    lineTwo = strTwo
                    startPos = nil
                elseif emotions[1].startPos > startPos then
                    cutStr = string.sub(strInput, startPos, emotions[1].startPos - 1)
                    strOne, strTwo = self:_getCutStr2Length(cutStr, totalWidth, maxLineWidth, singleWordWidth)
                    totalWidth = totalWidth +  GlobalFunc.getTextWidth(strOne,19)
                    if strTwo then
                        lineOne = string.sub(strInput, 1, startPos - 1) .. strOne
                        lineTwo = strTwo .. string.sub(strInput, emotions[1].startPos)
                        startPos = nil
                    else
                        startPos = emotions[1].startPos
                    end
                else
                    startPos = emotions[1].endPos + 1
                    table.remove(emotions, 1)
                    totalWidth = totalWidth + emotionWidth
                end
            end
        until not startPos
        if lineOne == nil then --没有记录，说明只有一行需要显示。
            lineOne = strInput
        end
    else --只有文字的情况
       totalWidth = GlobalFunc.getTextWidth(strInput,19)

       if totalWidth > maxLineWidth then
            lineOne, lineTwo = self:_getCutStr2Length(strInput, 0, maxLineWidth, singleWordWidth)
        else
            lineOne = strInput
       end
       print("dddddddddddddddddddgadhahah",lineOne, lineTwo)
    end

    --获得富文本
    local function getLineTxt(str)
        local lineHeight = 0
        local lineTxt = nil
        local hasEmotion = false
        if str ~= nil then 
            local startPos = string.find(str, "#%d+#", 1) --检查每一行是否有表情。
            if startPos then
                lineHeight = emotionHeight
                hasEmotion = true
            else
                lineHeight = fontSize
            end

            local richStr = self:_parse2Rich({
                strInput = str,
                textColor = 0x6b3618, -- 001
                fontSize = fontSize,
            })

            lineTxt = ccui.RichText:create()
            lineTxt:setCascadeOpacityEnabled(true)
            lineTxt:setRichText(richStr)

            -- 情侣喊话
            if self._chatUnit:isLoversWord() then
                lineTxt:setRichText({{type = "text",
                    msg ="点击查看",
                    fontSize = G_CommonUIHelper.FONT_SIZE_NORMAL,
                    color = G_Colors.toColor3B(0xff0000),
                    underline = true,
                    }},true)

                lineTxt:setTouchEnabled(true)
                lineTxt:addClickEventListenerEx(function ( ... ) -- 查看信息
                    if G_Me.userData.id == self._chatUnit:getSenderId() then return end

                    if G_ServerTime:getTime() - self._chatUnit:getTime() >= 86400 then -- 超过24小时提示已失效
                        G_Popup.tip("此消息已失效")
                        return
                    end
                    FriendLoversPopup.newLoversInfoPopup(self._chatUnit:getBaseInfo())
                end)
            end

            -- 这里先格式化字符串否则无法获取尺寸
            lineTxt:formatText()
        end
        
        return lineTxt, lineHeight, hasEmotion
    end

    local lineOneTxt, lineOneHeight, lineOneHasEmotion = getLineTxt(lineOne)
    local lineTwoTxt, lineTwoHeight, lineTwoHasEmotion = getLineTxt(lineTwo)
    totalHeight = lineOneHeight + lineTwoHeight
    ---根据宽高设置背景。
    local imgBg = self._view:getSubNodeByName("Image_content_bg")
    local imgBgSize = imgBg:getContentSize()

    local function placeTxt(richTxt, posX, posY, hasEmotion)
        if not richTxt then return end

        local size = richTxt:getVirtualRendererSize()
        local node = display.newNode()
        node:setCascadeOpacityEnabled(true)

        node:setAnchorPoint(cc.p(0, 0))
        node:setContentSize(size)
        node:addChild(richTxt)
        imgBg:addChild(node)
        richTxt:setPosition(cc.p(size.width/2, size.height/2))
        posY = hasEmotion == true and posY - 5 or posY + 8
        node:setPosition(posX + 10 + (self._isLeft and 5 or 0), posY)

        if not hasEmotion then --最低文本高度
            size.height = 45
        end

        return size
    end

    local lineOneSize = placeTxt(lineOneTxt, 0, lineTwoHeight == 0 and 10 or lineTwoHeight + 22, lineOneHasEmotion)
    local lineTwoSize = placeTxt(lineTwoTxt, 0, 8, lineTwoHasEmotion)
    local newWidth = imgBgSize.width > (lineOneSize.width + 40) and imgBgSize.width or (lineOneSize.width + 40) --40像素为背景不显示区域的宽
    local newHeight = lineOneSize.height + (lineTwoSize ~= nil and lineTwoSize.height or 0)
    newHeight = imgBgSize.height > newHeight and imgBgSize.height or newHeight ---不能低于最小高度
    newHeight = newHeight + (lineOneHasEmotion and 10 or 0) + (lineTwoHasEmotion and 10 or 0) --上下加10像素更好看。

    self._extraHeight = newHeight - imgBgSize.height
    self._view:setPositionY(self._extraHeight)
    imgBg:setContentSize(newWidth, newHeight)
    local arr = imgBg:getChildByName("Image_arrow")

    if not self._isLeft then --不知怎么的 cocos studio 里的固定不起作用了
        arr:setPositionX(newWidth + arr:getContentSize().width/2)
    end
end

function ChatScrollItem:_getCutStr2Length(strInput, alreadyLength, maxLineWidth, singleWordWidth)
    local utf8 = require("app.common.tools.Utf8")
    ---这里不能直接切割，因为富文本切不正常的话，就会显示不出来。
    ---获取实际语言的输入长度
    local len = utf8.utf8len(strInput)
    local currentWidth = alreadyLength
    local cutPos = 1
    local isTooLong = false

    if len == 0 then
        return "", nil
    end

    repeat
        local c = utf8.utf8sub(strInput,cutPos,cutPos)
        -- local c = string.byte(strInput, cutPos) ---逐个将字符串转换成对应的ascii码
        -- local shift = 1
        -- if c > 0 and c <= 127 then
        --     shift = 1
        -- elseif (c >= 192 and c <= 223) then
        --     shift = 2
        -- elseif (c >= 224 and c <= 239) then
        --     shift = 3
        -- elseif (c >= 240 and c <= 247) then
        --     shift = 4
        -- end

        cutPos = 1 + cutPos
        currentWidth = currentWidth + GlobalFunc.getTextWidth(c,19) + 1.5
    until currentWidth > maxLineWidth or cutPos >= len


    local strOne
    local strTwo

    if currentWidth > maxLineWidth then
        strOne = utf8.utf8sub(strInput, 1, cutPos -1)
        strTwo = utf8.utf8sub(strInput, cutPos)
    else
        strOne = utf8.utf8sub(strInput, 1)
        strTwo = nil
    end

    print("strOne ", strOne)
    print("strTwo", strTwo)
    return strOne, strTwo
end

function ChatScrollItem:_parse2Rich(obj)
    local _subtitle = {}

    local strInput = obj.strInput
    local textColor = obj.textColor
    local fontSize = obj.fontSize
    local outlineColor = obj.outlineColor
    local outlineSize = obj.outlineSize

    -- 查找其中的表情
    local _emotions = {}
    local _start, _end

    repeat
        if _start then
            local emotionId = tonumber(string.sub(strInput, _start+1, _end-1))
            -- 先检查是否是合格的emotion
            if emotionId and emotionId > 0 and emotionId <= ChatFaceLayer.FACE_COUNT then
                _emotions[#_emotions+1] = {start=_start, ["end"]=_end}
            end
        end
        _start, _end = string.find(strInput, "#%d+#", _end and _end + 1)
    until not _start

    -- 切割字符串，划分表情和文字
    if #_emotions > 0 then
        _start = 1
        repeat
            if not _emotions[1] then
                if _start < string.len(strInput) then
                    _subtitle[#_subtitle+1] = {type="msg", content=string.sub(strInput, _start)}
                end
                _start = nil
            elseif _emotions[1].start > _start then
                _subtitle[#_subtitle+1] = {type="msg", content=string.sub(strInput, _start, _emotions[1].start - 1)}
                _start = _emotions[1].start
            else
                _subtitle[#_subtitle+1] = {type="image", content=string.sub(strInput, _emotions[1].start, _emotions[1]["end"])}
                _start = _emotions[1]["end"] + 1
                table.remove(_emotions, 1)
            end
        until not _start
    else
        _subtitle[#_subtitle+1] = {type="msg", content=strInput}
    end

    -- 组合成富文本格式
    local _richTextSubtitle = {}
    for i=1, #_subtitle do
        
        local __subtitle = {}
        if _subtitle[i].type == "image" then
            -- emotion
            local faceId = string.sub(_subtitle[i].content, 2, string.len(_subtitle[i].content)-1)
            __subtitle.type = "image"
            __subtitle.filePath = "face/"..((faceId - 1 % 24) + 1)..".png"
            __subtitle.color = 0xffffff
            __subtitle.opacity = 255

            _richTextSubtitle[#_richTextSubtitle + 1] = __subtitle

        elseif _subtitle[i].type == "msg" then
            __subtitle.type = "text"
            __subtitle.msg = GlobalFunc.filterText(_subtitle[i].content)
            
            __subtitle.color = textColor 
            __subtitle.opacity = 255
            __subtitle.fontname = G_Path.getNormalFont()
            __subtitle.outlineColor = outlineColor
            __subtitle.outlineSize = outlineSize
            __subtitle.fontSize = fontSize

            _richTextSubtitle[#_richTextSubtitle + 1] = __subtitle
        end

    end

    return _richTextSubtitle    
end

return ChatScrollItem