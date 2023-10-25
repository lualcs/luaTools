local class = require("class")
local switch = require("switch")
local super = require("unknown")
---@class strategy:unknown @策略模式
local this = class(super)

---构造函数
---@param body table @switch数据
---@param expr any   @默认的策略
function this:ctor(body, expr)
    ---构建对象
    self._body = body
    ---策略变化
    self._expr = expr
end

---更改策略
---@param expr any   @最新的策略
function this:change(expr)
    ---策略变化
    self._expr = expr
end

---策略逻辑(推荐使用default:实现一个反射方法)
---@param name string @方法名字
function this:logic(name, ...)
    local algor = switch(self._expr,self._body)
    return algor[name](algor, ...)
end

return this
