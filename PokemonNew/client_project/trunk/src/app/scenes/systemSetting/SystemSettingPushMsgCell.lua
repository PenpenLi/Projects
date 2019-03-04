--
-- Author: Your Name
-- Date: 2017-07-31 16:38:01

--[===========[

    消息推送列表单元   
    1.用于展示一个消息内容
]===========]

local SystemSettingPushMsgCell = class ("SystemSettingPushMsgCell", function (  )
    return cc.TableViewCell:new()
end)

function SystemSettingPushMsgCell:ctor(view)
    self._index = nil --单元序号
    self._data = nil --数据绑定

    local node = cc.CSLoader:createNode(G_Url:getCSB("SystemSettingPushMsgCell","systemSetting")) --创建CSB
    self:addChild(node)  

end

--数据带入，更新显示 
function SystemSettingPushMsgCell:setInfo(data,index)
	self._data = data
	self._index = index

	-- 名字
	self:updateLabel("Text_name",{text = data.name})

	-- 周期
	self:updateLabel("Text_round",{text = data.day})

	-- 时间
	self:updateLabel("Text_time",{text = data.time})

	-- 提醒
    local chekcBox = self:getSubNodeByName("CheckBox")
    local enabled = G_GameSetting:isPushMsgEnabled(data.id)
    chekcBox:setSelected(enabled)
    chekcBox:addEventListener(function (sender, eventType)
        if eventType == ccui.CheckBoxEventType.selected then 
            G_GameSetting:setPushMsgEnabled(data.id,true)
        elseif eventType == ccui.CheckBoxEventType.unselected then
            G_GameSetting:setPushMsgEnabled(data.id,false)
        end
    end)
end

return SystemSettingPushMsgCell