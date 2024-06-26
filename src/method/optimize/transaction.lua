local caches = require("optimize.cache")

---仿事务
---@param tab     table @数据表
---@param emt     any   @等同空(用于判断视同为nil的数据-忽略数据)
return function(tab, emt)
    local ret = caches[tab] or setmetatable({}, {
        __empty = emt,
        __index = tab,
        __newindex = {},
    })
    caches[tab] = ret
    return ret
end
