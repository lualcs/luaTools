local class = require("class")
local super = require("unknown")

---@class vessel:unknown @动态容器
local this = class(super)

---构造函数
---@param cap number @容量
function this:ctor(cap)
    self._cap = cap
    self:clear()
end

---清理函数
function this:clear()
    ---映射表
    ---@type table<number,vesselUnit>
    self._map = {}
    ---计数器
    self._cnt = 0
end

---空闲
function this:free()
    if self._cnt ~= self._cap then
        return true
    end
    return false
end

---增长
---@return number
function this:auto()
    self._cnt = self._cnt + 1
    return self._cnt
end

---获取
---@param uuid number @标识
---@return any
function this:get(uuid)
    return self._map[uuid]
end

---添加
---@generic vesselUnit
---@param data vesselUnit @数据
---@return number
function this:append(data)
    if self:free() then
        local uuid = self:auto()
        self._map[uuid] = data
        self._cnt = self._cnt + 1
        data:initial(self, uuid)
        return uuid
    end
end

---删除
---@generic vesselUnit
---@param uuid number @唯一标识
---@return vesselUnit
function this:delete(uuid)
    local data = self._map[uuid]
    if not data then
        return
    end
    self._map[uuid] = nil
    self._cnt = self._cnt - 1
    return data
end

return this
