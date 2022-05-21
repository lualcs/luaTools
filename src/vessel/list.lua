local class = require("class")
local super = require("unknown")
local reusable = require("reusable")

local reusable = reusable.new()
---@class vessellist:unknown @链表
local this = class(super)

---构造函数
function this:ctor()
    self:clear()
end

---清理函数
function this:clear()
    self._head = nil
    self._tail = nil
    self._size = 0
end

---尾部加入
---@param data any @节点数据
function this:push_back(data)
    local size = self._size
    local node = reusable:get()
    node.data = data
    self._size = size + 1

    if 0 == size then
        self._head = node
        self._tail = node
    else
        self._tail.later = node
        node.front = self._tail
        self._tail = node
    end

    return node
end

---尾部删除
function this:pop_back()
    local tail = self._tail
    if not tail then 
        return 
    end

    local front = tail.front
    self._tail = front
    if front then 
        front.later = nil 
    end
    reusable:set(tail)
end

---插入阶段
---@param node any @数据节点
function this:insert(node, data)
    local new = reusable:get()
    new.data = data
    new.front = node
    new.later = node.later
    node.later = new
    if not new.later then
        self._tail = new
    end
end

---删除阶段
---@param node any @数据节点
function this:erase(node)

    local size = self._size
    if 1 ~= size then
        if node == self._head then
            local later = node.later
            self._head = later
            later.front = nil
        elseif node == self._tail then
            self._tail = node.front
            node.front.later = nil
        else
            node.front.later = node.later
            node.later.front = node.front
        end
    else
        self._head = nil
        self._tail = nil
    end
    --删除尾部
    reusable:set(node)
    self._size = size - 1
    return node
end

---迭代函数
function this:ipairs()
    local node = self._head
    return function(t, k)
        if nil == k then
            k = 1
        else
            k = k + 1
            node = node and node.later
        end
        if node then
            return k, node.data
        else
            return nil, nil
        end
    end, self, nil
end

---迭代函数
function this:pairs()
    return self:ipairs()
end

return this
