---反序排序
---@param array any[] @数组
---@return any[]
return function(array)
    local leng = #array
    local half = leng // 2
    
    for i = 1, half do
        local j = leng - i + 1
        array[i], array[j] = array[j], array[i]
    end
	
    return array
end


