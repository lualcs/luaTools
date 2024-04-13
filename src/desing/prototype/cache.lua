local class = require("class")
local super = require("unknown")
---@class cache:unknown @克隆产品
local this = class(super)

---构造函数
function this:ctor()
    ---原型映射
    ---@type prottypeProto[]
    self._list = {}
end

---添加原型
---@param proto prottypeProto @原型
function this:push(proto)
    table.insert(self._list, proto)
end

---获取原型
---@param id number @标识
---@return prottypeProto @原型获取
function this:take(id)
    return self._list[id]
end

return this