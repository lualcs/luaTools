---循环执行一个函数
---@param mapf  table<any,fun(...)> @map
return function(map, ...)
    for _, f in pairs(map) do
        f(...)
    end
end
