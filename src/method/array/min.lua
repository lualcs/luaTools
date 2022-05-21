---返回数组最小值
---@param arr number[]
---@return number
return function(arr)
    local _, min = next(arr)
    
    for _, val in ipairs(arr) do
        if min > val then
            min = val
        end
    end
    
    return min
end
