local clear = require("table.opt.clear")
local ifFunction = require("ifFunction")

local o
local meta = {
    __index = function(_, k)
        local v = o[k]
        if ifFunction(v) then
            return function(...)
                return o, v(...)
            end
        end
        return v
    end,
    __newindex = function(t, k, v)
        o[k] = v
    end
}

local bind = {}
return function(obj)
    o = obj
    return setmetatable(clear(bind), meta)
end
