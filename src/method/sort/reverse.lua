---反序排序
---@param list number[]|boolean[]|string[] @数组
---@return any[]
return function(list)
    local leng = #list
    local half = leng // 2
    
    for i = 1, half do
        local j = leng - i + 1
        list[i], list[j] = list[j], list[i]
    end
	
    return list
end


