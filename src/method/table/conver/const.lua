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
function meta.__index(t, k)
    return tabs[t][k]
end

function meta.__newindex(t, k, v)
    assert(false, "Constants cannot be written！")
end

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

return function(tab)
    local new = {}
    tabs[new] = tab
    return setmetatable(new, meta)
end