local class = require("class")
local super = require("unknown")
---@class vesselUnit:unknown @单元对象
local this = class(super)

---初始函数
---@param pool vessel @自身容器
---@param uuid number @唯一标识
function this:initial(pool, uuid)
    self._pool = pool
    self._uuid = uuid
end

---销毁函数
function this:destory()
    self._pool:delete(self._uuid)
end

return this
