local class = require("class")
local super = require("unknown")
---@class proxy:unknown @代理模式
local this = class(super)

---构造函数
---@param target any @目标
function this:ctor(target)
    ---目标
    self._target = target
end


return this
