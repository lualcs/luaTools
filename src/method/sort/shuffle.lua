---乱序排序
---@param list any[] @排序数组
return function(list)
    local len = #list
    
    for i = 1, len do
        local pos = math.random(i, len)
        list[i], list[pos] = list[pos], list[i]
    end
end


