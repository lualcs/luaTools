local meta = {
    __index = function(t, k)
        local tb = {}
        t[k] = tb
        return tb
    end
}

local deep = {}
function deep.__index(t, k)
    local tb = setmetatable({}, deep)
    t[k] = tb
    return tb
end

return function(t, recursion)
    if not recursion then
        return setmetatable(t, meta)
    end
    return setmetatable(t, deep)
end
