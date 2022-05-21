---类型转换
---@param v any @数据类型
return function(v)
    if "true" == v then 
        return true
    elseif "false" == v then 
        return false
    end
    return tonumber(v) or tostring(v) or v
end


