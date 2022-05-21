local class = require("class")

local super = require("unknown")
local clear = require("table.clear")

---@class reusable:unknown @复用仓库
local this = class(super)

---构造
function this:ctor()
    ---@type any[]
    self._list = {}
end

---申请
---@return table
function this:get()
    local list = self._list
    
    if next(list) then
        local data = table.remove(list)
        return clear(data)
    else
        return {}
    end
end

---回收
---@param t table @表
function this:set(t)
    table.insert(self._list, t)
end

return this
