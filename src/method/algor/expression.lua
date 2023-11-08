local load = load or loadstring
local function localf(sexpr, ...)
    return load("return " .. sexpr:format(...))
end


return localf
