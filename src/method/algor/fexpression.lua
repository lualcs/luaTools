local load = load or loadstring
local maps = {}
local function localf(sexpr, ...)
    local f = maps[sexpr] or (load(sexpr)())
    maps[sexpr] = f
    return f(...)
end


return localf
