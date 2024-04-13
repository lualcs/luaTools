local class = require("class")
local super = require("unknown")
---@class prottypeProto:unknown @原型对象
local this = class(super)

---构造函数
---@param tp string @类型
function this:ctor(tp)
    --类型
    self._tp = tp
end

---获取类型
function this:tp()
    return self._tp
end

return this