---向上执行到顶点
---@param o table       @对象
---@param f string      @名字
return function(o, f, ...)
    local function loop(c, ...)
        if c.__base then
            loop(c.__base, ...)
        end

        local fun = rawget(getmetatable(c).__index, f)
        if fun then
            fun(o, ...)
        end
    end

    loop(o, ...)
end


