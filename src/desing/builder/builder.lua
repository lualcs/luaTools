local class = require("class")
local super = require("unknown")
---@class builder:unknown @构建者
local this = class(super)

---构造函数
---@param body table @switch 数据
function this:ctor(body)
    self._body = body
end

return this
