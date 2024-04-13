---重复添加
---@param arr any[] @数组
---@param val any   @数据
---@param cnt count @重复
---@param cap count @容量
---@return any[]
return function(arr, val, cnt, cap)
    local len = #arr
    local add = cnt - (cap and len + cnt - cap or 0)
    if add > 0 then
        for i = 1, add do
            table.insert(arr,val)
        end
    else
        for i = 1, cnt do
            table.insert(arr,val)
        end
    end
    return arr
end