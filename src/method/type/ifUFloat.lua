---是否非负数浮点数
---@param v any @参数
return function(v)
    if type(v) ~= "number" then
        return false
    elseif v < 0 then
        return false
    elseif 0 == v % 1 then
        return false
    end
    
    return true
end


