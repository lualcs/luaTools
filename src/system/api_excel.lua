local class = require("class")
local apicom = require("api_com")

---@class api_excel 如何操作excel表格
local this = class()

function this:ctor()
    self.obj = self:createObject()
end

---创建excel 操作对象
---@return Excel.Application|nil @
function this:createObject()
    ---@type Excel.Application
    local obj = apicom.CreateObject("Ket.Application")
    if not obj then
        obj = apicom.CreateObject("Excel.Application")
    end
    if not obj then
        assert(false)
    end

    ---不显示窗口
    obj.Visible = false
    ---关闭不提示
    obj.DisplayAlerts = false
    return obj
end

function this:create(fpatch) 
    
end

---打开excel文件
---@param fpatch string @excel文件绝对路径
function this:open(fpatch)
    local obj = self.obj
    if not obj then
        return
    end
    if not self.book then
        self.book = obj.WorkBooks:Open(fpatch, 0, 0)
    end
    return self.book
end

---关闭excel 文件
function this:close()
    local book = self.book
    if not book then
        return
    end

    self.obj:Quit()
    self:clear()
end

function this:save()
    local book = self.book
    if not book then
        return
    end
    book:Save()
end

function this:clear()
    self.book = nil
    self.sheet = nil
end

---工作簿数量
---@return integer
function this:sheetsCount()
    local book = self.book
    if not book then
        return 0
    end
    return book.Sheets.Count
end

---切换工作簿
---@param index number @工作簿索引
function this:sheets(index)
    local book = self.book
    if not book then
        return
    end

    ---切换工作簿
    self.sheet = book.Sheets(index)
    return self.sheet
end

---当前excel 名称s
function this:excelNmae()
    if not self.book then
        return
    end
    return self.book.Name
end

---当前工作簿名称
function this:sheetName()
    if not self.sheet then
        return
    end
    return self.sheet.Name
end

---获取工作簿最大列
---@return number
function this:sheetCol()
    local s = self.sheet
    if not s then
        return 0
    end
    return s.UsedRange.Columns.Count
end

---获取工作簿最大行
---@return number
function this:sheetRow()
    local s = self.sheet
    if not s then
        return 0
    end
    return s.UsedRange.Rows.Count
end

---添加工作簿
---@param name string @
function this:addSheet(name)
    ---验证判断
    local book = self.book
    if not book then
        return
    end

    ---添加工作步
    book:Add()
    ---切换新增工作簿
    local count = self:SheetsCount()
    self:sheets(count)
    ---修改名称
    self.sheet.Name = name
end

---获取格子内容
---@param row number @行
---@param col number @列
function this:getGird(row, col)
    local s = self.sheet
    if not s then
        return
    end
    return s.Cells(row, col).Value2
end

---区域读取
---@param are string @"A1:Z100"
function this:range(are)
    local sheet = self.sheet
    if not sheet then
        return
    end
    local range = sheet:Range(are)
end

---获取格子内容
---@param slot string @列 A1
function this:gird(slot)
    local sheet = self.sheet
    if sheet then
        return
    end
    return sheet:Range(slot).Text
end

---设置格子内容
---@param col number @列
---@param row number @行
---@param val string @值
function this:setGird(col, row, val)
    local s = self.sheet
    if not s then
        return
    end
    s.Cells(col, row).Value2 = val
end

---获取批注内容
---@param row number @行
---@param col number @列
---@return string @批注内容
function this:getComment(row, col)
    local s = self.sheet
    if not s then
        return ""
    end
    local cell = s.Cells(row, col)
    if not cell.Comment then 
        return ""
    end
    return cell.Comment:Text()
end

---@class Excel.Comment
---@field Text string @批准

---@class Excel.Gird  @一个格子
---@field Value string @格子内容
---@field Value2 string @格子内容
---@field Comment Excel.Comment

---@class Excel.Range @表格区域
---@field Offset fun(x:number,y:number):Excel.Gird @操作格子

---@class Excel.Sheets @工作簿
---@field Name string @工作簿名称
---@field Count number @工作簿个数
---@field Cells fun(row:number,col:number):Excel.Gird @获取单元格子
---@field Ranges fun(self:Excel.Sheets,gird:string):Excel.Range @区域 a1:b100

---@class Excel.WorkBooks @ 工作簿
---@field Name string @excel名称
---@field Open fun(sef:Excel.WorkBooks,fpath:string,up:number|nil,readonly:number|nil,pass:number|nil,...):Excel.WorkBooks
---@field Sheets Excel.Sheets
---@field Add fun() @添加工作簿
---@field Save fun() @保存打开的表

---@class Excel.Application
---@field Visible boolean @是否显示excel 窗口
---@field DisplayAlerts boolean @关闭时是否提示
---@field WorkBooks Excel.WorkBooks @工作簿
---@field ActiveWorkBook Excel.WorkBooks @当前表
---@field Quit fun() @关闭打开的表

return this
