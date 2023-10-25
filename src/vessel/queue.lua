local class = require("class")
local super = require("unknown")
---@class vesselqueue:unknown @队列
local this = class(super)

---构造函数
function this:ctor()
    ---数据列表
    ---@type any[]
    self._list = {}

    ---下标起点
    self._begin = 1
    ---有效元素
    self._count = 0
end

---元素个数
---@return integer
function this:size()
    return self._count
end

---尾部添加
---@param value any @添加值
function this:push_back(value)
    if nil ~= value then
        local index = self._count + self._begin
        self._list[index] = value
        self._count = self._count + 1
    end
end

---头部添加
---@param value any @添加值
function this:push_fron(value)
    if value then
        local index = self._begin

        if 1 ~= self._begin then
            index = index - 1
        end

        self._list[index] = value
        self._count = self._count + 1
    end
end

---尾部删除
---@return T|nil
function this:pop_back()
    local index = self._count + self._begin - 1
    local value = self._list[index]

    if value then
        self._list[index] = nil
        self._count = self._count - 1
        return value
    end
end

---头部删除
---@return T|nil
function this:pop_fron()
    local value = self._list[self._begin]

    if value then
        self._list[self._begin] = nil
        self._begin = self._begin + 1
        self._count = self._count - 1
        return value
    end
end

---数据访问
---@generic t:any
---@param index index @下标
---@return T|nil
function this:get_data(index)
    index = index + self._begin - 1
    return self._list[index]
end

---迭代函数
function this.next(t, k)
    if nil == k then
        k = 1
    end
    local pos = t._begin + k - 1
    if not t._list[pos] then
        k = nil
    end
    return k, t._list[pos]
end

---迭代函数
function this:ipairs()
    return self.next, self, nil
end

---迭代函数
function this:pairs()
    return self:ipairs()
end

return this
