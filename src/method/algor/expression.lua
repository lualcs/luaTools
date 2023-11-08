local load = load or loadstring
local function localf(sexpr, ...)
    local f = load("return " .. sexpr:format(...))
    return f()
end


return localf
