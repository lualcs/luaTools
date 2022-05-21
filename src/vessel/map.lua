local class = require("class")
local super = require("unknown")
---@class vesselMap:unknown @map映射
local this = class(super)

---构造函数
---@param cap number @容器大小
function this:ctor(cap)
    self._cap = cap
    self._cnt = 0
    self._map = {}
end

---插入数据
---@param key any @唯一索引
---@param val any @映射数据
---@return boolean
function this:insert(key, val)
    local map = self._map
    local cnt = self._cnt
    if nil == map[key] then
        local cap = self._cap
        if cap and cnt >= cap then
            return false
        end
        self._cnt = cnt + 1
    end
    map[key] = val
    return true
end

---删除数据
---@param key any @唯一标识
function this:erase(key)
    local map = self._map
    local cnt = self._cnt
    if nil ~= map[key] then
        self._cnt = cnt - 1
    end
    map[key] = nil
    return true
end

---获取数据
---@param key any @唯一标识
function this:get(key)
    return self._map[key]
end

---获取大小
function this:size()
    return self._cnt
end

---获取容量
function this:capacity()
    return self._cap
end

---迭代函数
function this:pairs()
    return function(map, k)
        if nil == k then
            return next(map)
        else
            return next(map, k)
        end
    end, self._map, nil
end

return this
