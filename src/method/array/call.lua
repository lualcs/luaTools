---循环执行一个函数
---@param arr  fun(...)[] @arr
return function (arr, ...)
    for _, f in ipairs(arr) do
        f(...)
    end
end
