---数组总和v
---@param arr number[] @数组
---@return number @sum(v)
return function(arr)
    local sum = 0
    
    for _, v in ipairs(arr) do
        sum = sum + v
    end
	
    return sum
end
