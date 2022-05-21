---返回数组最大值
---@param arr number[]
---@return number
return function(arr)
    local _, max = next(arr)
    
    for _, val in ipairs(arr) do
        if max < val then
            max = val
        end
    end
    
    return max
end
