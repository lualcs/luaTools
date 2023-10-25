local funs = {
    __metatable = true,
    __newindex = true,
    __tostring = true,
    __assign = true,
    __concat = true,
    __index = true,
    __pairs = true,
    __call = true,
    __mode = true,
    __len = true,
    __add = true,
    __div = true,
    __mod = true,
    __unm = true,
    __pow = true,
    __pow = true,
    __eq = true,
    __lt = true,

}

---弱引用
local tabs = setmetatable({}, { __mode = "k" })
local meta = {}

function meta.__len(t)
    return rawlen(tabs[t])
end

local function _next(t, k)
    local v
    repeat
        k, v = next(tabs[t], k)
        if not funs[k] then
            break
        end
    until false
    return k, v
end

function meta.__pairs(t)
    return _next, t, nil
end

local clone = require("table.opt.clonee")
return function(tab, fread,fwrite)
    local new = {}
    tabs[new] = tab
    return setmetatable(new, clone(meta, {
         __index = function(t, k)
            fread(k)
            return tabs[t][k]
        end,
        __newindex = function(t, k, v)
            fwrite(k,v)
            tabs[t][k] = v
        end
    }))
end