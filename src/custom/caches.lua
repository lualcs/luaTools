local class = require("class")
local super = require("unknown")
local clear = require("table.clear")
local milli = require("time.millisecond")

---@class cacheUnit 缓存单元
---@field ocutime   integer @缓存时间
---@field elatime   double  @缓存时间
---@field cache     table   @缓存时间
---@class caches:unknown @缓存
local this = class(super)

---构造
function this:ctor(min, max)
    ---@type cacheUnit[]
    self._caches = {}
end

---初始数据
function this:initial()
    clear(self._caches)
end

---缓存
---@param cache data @数据
function this:dataPush(cache)
    local list = self._caches
    table.insert(list, {
        ocutime = milli(),
        cache = cache,
    })
end

return this
