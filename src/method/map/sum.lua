---哈希总和v
---@param map table<any,number> @map
---@return number @sum(v)
return function(map)
    local sum = 0
    
    for _, v in pairs(map) do
        sum = sum + v
    end

    return sum
end

