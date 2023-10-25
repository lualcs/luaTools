local peak = require("peak")

---@type table<table,table>
local methods = {}

---class 定义
---@generic T
---@param base T
---@return T
return function(base)
    ---@class source @class类型
    local source = {
        __base = base,
        __type = 'class'
    }

    local virtual = {}
    methods[source] = virtual

    if base then
        setmetatable(virtual, {
            __index = methods[base]
        })
    end

    source.new = function(...)
        local obj = {
            __base = source,
            __type = 'object',
        }
        setmetatable(obj, { 
            __index = virtual 
        })
        peak(obj, "ctor", ...)
        return obj
    end

    return setmetatable(source, {
        __newindex = virtual,
        __index = virtual,
    })

end
