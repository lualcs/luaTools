local function localf(sexpr, ...)
    local f = loadstring("return " .. sexpr:format(...))
    return f()
end


return localf
