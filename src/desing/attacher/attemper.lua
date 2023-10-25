local class = require("class")
local super = require("unknown")
---@class attemperAttacher:unknown @多命令调度器
local this = class(super)

---构造函数
function this:ctor()
    self._behavior = {}
end

---注册回调
---@param obj attacherBehavior @多命令行为
function this:regCallback(obj)
   self._behavior[obj] = true
end

---删除回调
---@param obj attacherBehavior @多命令行为
function this:eraCallback(obj)
   self._behavior[obj] = nil
end

---接受回调
---@param whice string @命令符号
function this:revCallback(whice)
    for v, _ in pairs(self._behavior) do
        v:callback(whice)
    end
end

return this
