local class = require("class")
local super = require("unknown")
---@class decorator:unknown @装饰模型
local this = class(super)

---构造函数
---@param obj any @具体对象
function this:ctor(obj)
    self:concrete(obj)
end

---改变对象
---@param obj any @具体对象
function this:concrete(obj)
    self._obj = obj
end


return this
