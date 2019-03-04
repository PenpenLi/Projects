
local TableViewTestLayer = class ("TableViewTestLayer", function (params)
       return cc.TableView:create(params.size)
end)


local function LuaPrint(a)
    local isDebug = false
    if isDebug == true then 
        print(a)
    else

    end
end


function TableViewTestLayer:init()

    self.isNeedExtand = false --是否需要扩展下来栏目
    self.currentIndex = nil --记录当前点击展开的元素
    self.itemStatus = false --当时时候张开元素
    self.tableView = nil -- 滑动列表
    self.oldrecorder = nil --记录以前打开的元素位置
    self.newrecorder = nil --记录时候新打开的位置
    self.isChangeToOther = false  --是否存在展开元素 并且需要展开别的元素
    self.otherorder = nil --存在展开元素 并且需要展开别的元素 记录前一次展开的位置
    self.isDebug = false --是否开启调试打印
    self.changeIndex = nil --用于记录需要关闭的元素的索引 里面的控件做向上移动
    self.TableViewData = nil  --传入的滑动列表的数据
    -- self.isNeedCountCheckBox = false
    self.cellList={}
end
function TableViewTestLayer:ctor(params)

    self:init()
    --初始化一些数据信息
    self:initData(params) 
    --创建列表
    self:createTableView(params)
end
function TableViewTestLayer:createTableView(params )
    --支持横向滑动
    if params.order then 
        self.order = params.order --0 是水平  1是垂直 2是都可以
        --测试只需要把 order是为0  
    else
         self.order = cc.SCROLLVIEW_DIRECTION_VERTICAL
    end 
    self:setDirection(self.order)
    self:setPosition(self.TableViewData["pos"])
    self:setName(self.TableViewData["name"])
    self:setDelegate()
    self:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    --self:setExtendCellHeight(self.TableViewData["changeHeight"])
    if self.isNeedExtand == true  then  --是否需要下拉扩展
        self:registerScriptHandler(self.numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW) 
        self:registerScriptHandler(self.scrollViewDidScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
        self:registerScriptHandler(self.scrollViewDidZoom,cc.SCROLLVIEW_SCRIPT_ZOOM)
        self:registerScriptHandler(self.tableCellTouched,cc.TABLECELL_TOUCHED)
        self:registerScriptHandler(self.cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
        self:registerScriptHandler(self.tableCellAtIndex ,cc.TABLECELL_SIZE_AT_INDEX)
    else
        self:registerScriptHandler(self.numberOfNormalCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW) 
        self:registerScriptHandler(self.normalscrollViewDidScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
        self:registerScriptHandler(self.normalscrollViewDidZoom,cc.SCROLLVIEW_SCRIPT_ZOOM)
        self:registerScriptHandler(self.tableNormalCellTouched,cc.TABLECELL_TOUCHED)
        self:registerScriptHandler(self.normalCellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
        self:registerScriptHandler(self.tableNormalCellAtIndex ,cc.TABLECELL_SIZE_AT_INDEX)
    end
    --是否保持原来位置
  --  self:
    if(self.TableViewData["isKeepOff"]~=nil)then


    end 

    if(self.TableViewData["footerHeight"]~=nil)then
        local layeout =  ccui.Layout:create()
        layeout:setContentSize(self.TableViewData["normalCellHeight"],self.TableViewData["footerHeight"])
        self:setTableViewFooter(layeout)
    else
        self:reloadData()
    end
end


---普通的没有下拉列表的tableview
function TableViewTestLayer:numberOfNormalCellsInTableView()
    return #self.TableViewData["dataInfo"]
end

function TableViewTestLayer:normalscrollViewDidScroll( view )

end

function TableViewTestLayer:runStartActions()
    if(self.cellList~=nil)then
        for i=1,#self.cellList do
            local cell=self.cellList[i]
            if(cell~=nil)then
                cell:setVisible(false)
                local currX=cell:getPositionX()
                local currY=cell:getPositionY()
                cell:setPositionX(currX-100)
                local action=cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(currX,currY)))
                local seq=cc.Sequence:create(cc.DelayTime:create(0.05*i),cc.CallFunc:create(function()
                    cell:setVisible(true) 
                end),action)
                cell:runAction(seq)
            end
        end
        self.cellList=nil
    end
end

function TableViewTestLayer:normalscrollViewDidZoom( )
    -- body
end
-- function TableViewTestLayer:updateCheckBoxs(clickIndex,IsCancel)
--     if #self.selectedTable == 0 then  
--         self.selectedTable[1] = clickIndex

--     else
--         local isInTable = false
--         local tableIndex = nil
--         for index =1,#self.selectedTable do 
--             if self.selectedTable[index] == clickIndex then 
--                 isInTable = true
--                 tableIndex = index
--                 break 
--             end
--         end

--         if isInTable  then 
--             if IsCancel == true then 
--                table.remove(self.selectedTable,tableIndex)
--             end 
   
--         else
--             if IsCancel == false then 
--                 self.selectedTable[#self.selectedTable+1] = clickIndex
--             end 
--         end

--     end
--    -- self:setUpdateSellPanel()
-- end
--------------
-- function TableViewTestLayer:setUpdateSellPanel()
--    --设置最新的数量
--     if self.selectedLabel  then 
--           self.selectedLabel:setString(#self.selectedTable)
--        -- self.selectedTable = {}
--     end 
--     local money = 0  
--     for index = 1,#self.selectedTable do 
--         local cellIndex = tonumber(self.selectedTable[index]) + 1
--         -- money = money + self.TableViewData["dataInfo"][cellIndex]["sellmoney"]
--     end 
--     -- if self.selectedTotalMoney then 
--         -- self.selectedTotalMoney:setString(money)
--     -- end

-- end
-- function TableViewTestLayer:getSelectedTableData()
--     local seletedData = nil 
--     if #self.selectedTable == 0 then 
--         return seletedData
--     else 
--         seletedData = {}
--         local selectedIndex = 1
--         for index = 1,# self.selectedTable do 
--             local cellIndex = tonumber(self.selectedTable[index]) + 1
--             -- seletedData[selectedIndex]   =  self.TableViewData["dataInfo"][cellIndex]["eId"]
--             selectedIndex = selectedIndex + 1
--         end
--         return seletedData
--     end 
--     -- body
-- end
-- function TableViewTestLayer:reSetSellData( )
--     self.selectedTable = {}

-- end

-- function TableViewTestLayer:getSelectedIndexs(  )
--     return self.selectedTable
--     -- body
-- end
-- function TableViewTestLayer:setSelectedIndexs(data  )
--     self.selectedTable = data
--    if self.selectedLabel  then 
--           self.selectedLabel:setString(#self.selectedTable)
--        -- self.selectedTable = {}
--     end 
--     -- body
-- end

function TableViewTestLayer:setKeepOff(isKeepOff)
    if isKeepOff == false then 
        self:setContentOffset(self:minContainerOffset())
    end 
end



function TableViewTestLayer:tableNormalCellTouched(cell)
 --   self.isNeedCountCheckBox = true
    self.oldrecorder = self:getContentOffset()
    --print("老的记录")
    --dump(self.oldrecorder)
    -- if self.isNeedCountCheckBox then
    --     local index = cell:getIdx()
    --     local widget = cell:getChildByName("equipCell")
    --     local checkBox = ccui.Helper:seekWidgetByName(widget,self.checkBoxName)



    --     if checkBox then 
    --         local isSelected = checkBox:isSelected()
          
    --         if isSelected then
    --           --  print("取消选中")
    --             checkBox:setSelected(false)
    --             self:updateCheckBoxs(index,true)
    --         else
    --             if self.maxSelectNum then  --最多选中的装备
    --                 if #self.selectedTable ==tonumber(self.maxSelectNum) then 
    --                     --分解界面最多选择五个装备
    --                     if self.fromPage  then 
    --                         --if self.equipDecompose

    --                         if self.fromPage == "equipDecompose"  then 
    --                          --   print("已经选择了五个装备")
    --                             local tipPop = require "app.popup.Popup"
    --                             local successStr = G_LangScrap.get("equip_error_select_equip_num_over_limit")
    --                             tipPop.tip(successStr)
    --                             return
    --                         end 
                            
    --                     end 
            
    --                 end 
    --             end 
    --           --  print("选中")
    --             checkBox:setSelected(true)
    --             self:updateCheckBoxs(index,false)
              
    --         end

        -- end 

    -- end
end


function TableViewTestLayer:normalCellSizeForTable( )
    return self.TableViewData["normalCellHeight"],self.TableViewData["normalCellWidth"]
    -- body
end

function TableViewTestLayer:tableNormalCellAtIndex(idx)
    local cell = self:dequeueCell()
    if nil == cell then     
        cell =  self.TableViewData["tableCell"].new(self,self.TableViewData["dataInfo"])
        cell:setInfo(self.TableViewData["dataInfo"][idx+1],idx)
        if(self.cellList~=nil)then
            table.insert(self.cellList,cell)
        end
    else
        cell:setInfo(self.TableViewData["dataInfo"][idx+1],idx)
    end

    return cell
end




function TableViewTestLayer:initData(params)
    self.TableViewData = {}
    self.TableViewData["tableCell"] = require (params.tableCell)
    self.TableViewData["width"] = params.size.width --600
    self.TableViewData["height"] = params.size.height --500
    self.TableViewData["pos"] = params.pos
    self.TableViewData["dataInfo"] = params.dataInfo
    self.TableViewData["name"]  = params.name
    self.isNeedExtand  = params.isNeedExtend
    -- if params.isNeedCountCheckBox then 

    --     self.fromPage = params.fromPage
    --     self.checkBoxName = params.checkBoxName
    --     self.isNeedCountCheckBox = params.isNeedCountCheckBox 
    --     self.selectedLabel = params.selectedLabel
    --     self.selectedTable = {}
    --     self.maxSelectNum = params.maxSelectNum
    --     self.selectedTotalMoney = params.selectedTotalMoney
    --     if params.selectTable then 
    --         self:setSelectedIndexs(params.selectTable)
    --     end 
        
       
    -- end 
    if params.otherInfo then 
        self.otherInfo  = params.otherInfo
      --  print("ddddddddddddd")
        --dump(self.otherInfo)
    end 
    self.TableViewData["normalCellHeight"]  = params.normalCell.height --124
    self.TableViewData["normalCellWidth"]  = params.normalCell.width --582
    self.TableViewData["extendCellWidth"]  =params.exendCell.width --582
    self.TableViewData["normalOffset"]  = self.TableViewData["height"] -  self.TableViewData["normalCellHeight"] *(#self.TableViewData["dataInfo"])---740
    self.TableViewData["changeHeight"]  = params.exendCell.height -- 76
    self.TableViewData["extendCellHeight"]  =  self.TableViewData["changeHeight"]  +  self.TableViewData["normalCellHeight"] --200
    self.TableViewData["extendOffset"]  = self.TableViewData["normalOffset"] -self.TableViewData["changeHeight"] -- -816
    self.TableViewData["footerHeight"]  = params.footerHeight
end

function TableViewTestLayer:getOtherInfo()
   -- if self.otherInfo then 
        return  self.otherInfo
    --end 
    
end


function TableViewTestLayer:numberOfCellsInTableView(table)
   return #self.TableViewData["dataInfo"]
end

function TableViewTestLayer:moveToCell(index)
       
        
   if self.itemStatus == true then 
        if self.oldrecorder.y == self.TableViewData["normalOffset"]  then 
            return
        else
            if self.oldrecorder.y == 0 then 
                self:setContentOffset(self.oldrecorder) 
                return
            else

                if self.currentIndex == nil then 
                        LuaPrint("---------4-------")
                        return
                else
                    if self.oldrecorder.y == self.newrecorder.y then -- 点击最上面的元素 然后换到别的条目
                        --LuaPrint("new bug---")
                        LuaPrint("---------5-------")
                        return 
                    else
                        if self.isChangeToOther == true then 
                                LuaPrint("---------6-------")
                                LuaPrint("currentIndex"..self.currentIndex)
                            -- dump()
                            if self.oldrecorder.y == 0 then 
                                LuaPrint("---------6--1-----")
                            elseif self.oldrecorder.y == self.TableViewData["normalOffset"] then 
                                LuaPrint("---------6--2-----")
                            else
                                LuaPrint("otherorder--------")
                                LuaPrint("---------6--3-----")
                                if self.otherorder.y == self.TableViewData["normalOffset"] then
                                    LuaPrint("---------6--4----")
                                    self:setContentOffset(cc.p(0,self.oldrecorder.y-self.TableViewData["changeHeight"]))
                                    return
                                else

                                    self:setContentOffset(cc.p(0,self.oldrecorder.y))
                                    return
                                end

                            end
   
                            return
                        else
                            LuaPrint("---------7-------")
                        end

                    end
           
                end
                   LuaPrint("---------8-------")
               
                local y = self.oldrecorder.y - self.TableViewData["changeHeight"]
                local x = self.oldrecorder.x
                self:setContentOffset(cc.p(x,y)) 
             --   oldrecorder.y =  y 
            end
        end
    else
        if self.oldrecorder.y == 0 then
            self:setContentOffset(cc.p(0,0))
        else
            if self.oldrecorder.y ~= self.TableViewData["extendOffset"] then 
                self:setContentOffset(cc.p(0,self.oldrecorder.y + self.TableViewData["changeHeight"] ))
            end
        end
    end
end

function TableViewTestLayer:scrollViewDidScroll(view)
 -- LuaPrint("scrollViewDidScroll====")
  self.newrecorder = self:getContentOffset()
 --dump(newrecorder)
end

function TableViewTestLayer:scrollViewDidZoom(view)
  --  LuaPrint("scrollViewDidZoom")
end

---TODO实现方式 第一个是插入 删除 第二是更新数据表
function TableViewTestLayer:tableCellTouched(cell)
 
  -- dump(tableview:getContentOffset())
   
     local index = cell:getIdx()
    -- print("tableCellTouched"..index)
    --return
     self.isChangeToOther = false
     self.otherorder = nil

    if self.isNeedExtand == true  then
        if self.currentIndex == nil  then  --第一次点击的时候
            self.oldrecorder = self.newrecorder
            self.itemStatus = true
            self.currentIndex = index
            self:openCellAtIndex(self.currentIndex)
            self:reloadData()
            self.newrecorder = self:getContentOffset()
            self:moveToCell(index)
            self:setIsExpand(false)

        else
            if  self.currentIndex == index then --关闭点击的控件
                self.itemStatus = false
                self.currentIndex = nil
                self.oldrecorder = self.newrecorder
                self:closeCellAtIndex(index)
                self.changeIndex =index 
                self:reloadData()  
                self.newrecorder = self:getContentOffset()    
                self:moveToCell(index)
                self:closeCellAtIndex(-1)
                self.changeIndex = nil
            else
                --已经展开了一个元素后点击另外的元素
                self.isChangeToOther = true
                self.otherorder = self.oldrecorder  
                self.oldrecorder = self.newrecorder
                self.itemStatus = true
                self.currentIndex = index
                self:openCellAtIndex(self.currentIndex)
                self.newrecorder = self:getContentOffset()
                self:reloadData()
                self:moveToCell(index)
                self:setIsExpand(false)
            end
        end
    end
end

--获取每个元素的大小
function TableViewTestLayer:cellSizeForTable(idx) 
    
  -- print("iddx ..."..tableview)
    if  self.currentIndex and (self.currentIndex == idx) then

        return self.TableViewData["extendCellHeight"],self.TableViewData["extendCellWidth"]
    else
        return self.TableViewData["normalCellHeight"],self.TableViewData["normalCellWidth"]
    end

end


function TableViewTestLayer:resetData(list,index)
 --   print("更新-----------")
    self.TableViewData["dataInfo"] = list 
    self:reloadData()
end


function TableViewTestLayer:updateData(list)
    self.TableViewData["dataInfo"] = list 

    self:reloadData()
    if  self.oldrecorder then 
        local newContenOffset = self:minContainerOffset()
        if self.oldrecorder.y  <  newContenOffset.y then 
            self.oldrecorder.y  =  newContenOffset.y
        end 
        self:setContentOffset(self.oldrecorder)
      --  self:reloadData()
    end 

end


--每个元素内容
function TableViewTestLayer:tableCellAtIndex(idx)
   
    local cell = self:dequeueCell()
    local isNeedExtend = false   --是否需要展开
    if  self.currentIndex and (self.currentIndex == idx) then
        isNeedExtend = true
    else
        isNeedExtend = false
    end
    local isCloseExtend = false --是否需要关闭
    if self.changeIndex then 
        if idx == self.changeIndex then
            isCloseExtend = true 
        end       
    end

    if nil == cell then
        
        cell =  self.TableViewData["tableCell"].new({tableviewNode = self })
        cell:setInfo(self.TableViewData["dataInfo"][idx+1],idx)
       
    else
       cell:setInfo(self.TableViewData["dataInfo"][idx+1],idx)
       cell:adaptForAction()  --关闭或者打开滑动的时候需要 重新设置每个cell的位置 因为复用
        --
        if isNeedExtend then 
            cell:runCellOpenAction() --执行展开动作
        end
        if isCloseExtend then  
            cell:runCellCloseAction() --执行滑动动作
        end
    end
     

    return cell
end



return TableViewTestLayer
