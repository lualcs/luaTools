local class = require("class")
local super = require("unknown")
---@class master:unknown @被代理人
local this = class(super)

---构造函数
---@param obj any @代理对象
function this:ctor(obj)
    self:proxy(obj)
end

---更新代理
function this:proxy(obj)
    self._proxy = obj
end

return this
