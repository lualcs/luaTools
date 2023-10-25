local class = require("class")
local switch = require("switch")
local super = require("unknown")
---@class factory:unknown @工程模式
local this = class(super)

---构造函数
---@param body          table @switch 数据
function this:ctor(body)
    self._body = body
end

---工程生产
---@param expression any @表达式
function this:product(expression)
    return switch(expression, self._body)
end

return this
