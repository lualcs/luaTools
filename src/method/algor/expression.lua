local function localf(sexpr, ...)
    local f = (load or loadstring)("return " .. sexpr:format(...))
    return f()
end


return localf
