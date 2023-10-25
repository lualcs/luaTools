---重复添加
---@param arr any[] @数组
---@param val any   @数据
---@param cnt count @重复
---@param cap count @容量
---@return any[]
return function(arr, val, cnt, cap)
    for i = 1, cnt do
        table.insert(arr, val)
    end
    while cap and cap > #arr do
        table.remove(arr, 1)
    end
    return arr
end