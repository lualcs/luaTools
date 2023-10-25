--[[
    desc:堆数据 默认父节点<子节点  左节点 < 右节点
]]

local fauto = require("fauto")
local class = require("class")
local super = require("unknown")
local reusable = require("reusable")
local clear = require("table.opt.clear")

local reusable = reusable.new()
---@class vesselheap:unknown @堆数据
local this = class(super)

---@param   aNode heapNode @节点一
---@param   bNdoe heapNode @节点二
---@return  number    @比大小
local function default_compare(aNode, bNdoe)
    local a = aNode.ticks
    local b = bNdoe.ticks

    if a > b then
        return 1
    elseif a < b then
        return -1
    end

    return 0
end

---构造函数
---@param comp fun(aNode:heapNode,bNdoe:heapNode):number @比较函数
function this:ctor(comp)
    ---节点列表
    ---@type heapNode[]
    self._list = {}

    ---节点排序
    ---@type any[] @节点排序
    self._order = {}

    ---比较函数
    ---@type fun(aNode:heapNode,bNdoe:heapNode):number
    self._comp = comp or default_compare

    ---自动增长
    ---@type fun():number
    self._fauto = fauto()

end

--数据清空
function this:clear()
    clear(self._list)
end

---添加节点
---@param   ticks     number      @节点比较
---@param   data      table       @节点数据
---@return  number                @节点位置
function this:append(ticks, data)
    local auto = self._fauto()
    return self:appendBy(ticks, auto, data)
end

---添加节点
---@param   ticks     number      @节点比较
---@param   data      any         @节点数据
---@return  number                @节点位置
function this:appendBy(ticks, auto, data)
    local node = reusable:get()
    node.ticks = ticks
    node.data = data
    node.auto = auto
    return self:insert(node)
end

---插入节点
---@param node heapNode     @节点数据
---@return number           @唯一标识
function this:insert(node)
    local list = self._list
    table.insert(list, node)
    self:upward(#list)
    return node.auto
end

---调整接待你
---@param node  heapNode @节点数据
---@param pos   index    @节点位置
function this:adjust(node, pos)
    self:upward(pos)
    self:downward(pos)
end

---调整节点
---@param node  heapNode @节点数据
function this:adjustByFirst(node)
    self:adjust(node, 1)
end

---调整节点
---@param auto  number   @唯一标识
---@param tick  number   @更新比较
function this:adjustBy(auto, tick)
    local index, node = self:search(auto)
    if node then
        node.ticks = tick
        self:adjust(node, index)
    end
end

---搜索节点
---@param   auto    number      @唯一标识
---@return  index,heapNode      @节点数据
function this:search(auto)
    if auto then
        for i, node in ipairs(self._list) do
            if auto == node.auto then
                return i, node
            end
        end
    end
end

---读取头部
---@return heapNode
function this:reder()
    local list = self._list
    return list[1]
end

---删除头部
---@return heapNode @节点
function this:fetch()
    return self:delete(1)
end

---删除元素
---@return heapNode @删除节点
function this:delete(pos)
    ---删除节点
    local list = self._list
    local node = list[pos]

    if node then
        --获取尾部
        local last = table.remove(list)
        --调整位置
        if list[pos] then
            list[pos] = last
            self:downward(pos)
        end
    end

    reusable:set(node)
    return node
end

---查找删除
---@param auto any  @唯一标识
---@return heapNode @删除节点
function this:deleteBy(auto)
    local index, node = self:search(auto)
    self:delete(index)
    return node
end

---向上调整位置
function this:upward(pos)
    ---@type heapNode[]     @节点列表
    local list = self._list
    ---@type heapNode       @调整节点
    local node = list[pos]
    ---@type function       @比较函数
    local comp = self._comp

    ---@type boolean        @判断位置
    while pos > 1 do
        ---@type index      @父节点位
        local uos = pos // 2

        ---如果是右边节点<左边节点 左右交换
        if 1 == pos % 2 then
            ---如果右边节点<左边节点
            local los = pos - 1

            if -1 == comp(node, list[los]) then
                uos = los
            end
        end

        ---@type boolean    @调整完成
        if -1 ~= comp(node, list[uos]) then
            break
        end

        list[pos] = list[uos]
        pos = uos
    end

    list[pos] = node
end

---向下调整位置
function this:downward(pos)
    ---@type heapNode[]     @节点列表
    local list = self._list
    ---@type heapNode       @调整节点
    local node = list[pos]
    ---@type function       @比较函数
    local comp = self._comp
    ---@type index          @尾部位置
    local last = #list

    ---@type boolea         @底部判断
    while pos < last do
        ---@type index      @左边节点
        local ros = pos * 2
        ---@type index      @右边节点
        local los = ros - 1

        ---@type boolea     @不需调整
        if los > last then
            break
        end

        ---如果有右边节点
        if ros <= last then
            if 1 == comp(node, list[ros]) then
                los = ros
            end
        end

        ---@type boolean    @是否完成
        if 1 ~= comp(node, list[los]) then
            break
        end

        list[pos] = list[los]
        pos = los
    end

    list[pos] = node
end

---左边子节点
---@param pos number @数据下标
---@return number|nil
function this:left(pos)
    local left = pos * 2
    if self._list[left] then
        return left
    end
end

---右边子节点
---@param pos number @数据下标
---@return number|nil
function this:right(pos)
    local right = pos * 2 + 1
    if self._list[right] then
        return right
    end
end

---遍历函数
---@param pos number @节点
function this:order(pos)
    if not self._list[pos] then
        return
    end
    table.insert(self._order, pos)
    self:order(pos * 2)
    self:order(pos * 2 + 1)
end

---迭代函数
function this.next(t, k)
    if nil == k then
        k = 1
    else
        k = k + 1
    end

    local idx = t._order[k]
    if not t._list[idx] then
        k = nil
    end
    return k, t._list[idx]
end

---迭代函数
function this:ipairs()
    clear(self._order)
    self:order(1)
    return self.next, self, nil
end

---迭代函数
function this:pairs()
    return self:ipairs()
end

return this

---@class heapNode @最大堆节点
---@field   ticks   number  @比较数值
---@field   auto    number  @自增长值
---@field   data    table   @数据信息
