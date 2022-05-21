local peak = require("peak")

---@type table<table,table>
local methods = {}

---class 定义
---@generic T
---@param base T
---@return T
return function(base)
    ---@class source @class类型
    local source = {}
    ---对象类型
    source.__base = base
    source.__type = 'class'
    
    ---虚函数表
    local virtual = {}
    
    methods[source] = virtual
    
    if base then
        setmetatable(virtual, { 
            __index = methods[base] 
        })
    end
    
    source.new = function(...)
        local object = {}
        object.__base = source
        object.__type = 'object'
        setmetatable(object, {
            __index = virtual
        })
        peak(object, "ctor", ...)
        return object
    end
    
    ---设置构造方法
    return setmetatable(source, {
        __newindex = virtual,
        __index = virtual,
    })
end


