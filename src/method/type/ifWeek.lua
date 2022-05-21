---是否星期几
---@param v any @参数
return function(v)
    if type(v) ~= "number" then 
        return false
    elseif v < 0 then 
        return false
    elseif v % 1 ~= 0 then 
        return false
    end
    return v >= 1 and v <= 7
end


