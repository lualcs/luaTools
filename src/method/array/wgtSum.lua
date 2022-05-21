---统计总权重
return function(arr, key)
    local sum = 0
    
    for i, data in ipairs(arr) do
        sum = sum + data[key]
    end
    
    return sum
end
