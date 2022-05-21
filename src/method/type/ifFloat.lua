---是否小数 
---@param v any @数据 
---@return boolean 
return function(v)
    if "number" ~= type(v) then
        return false
    elseif 0 == v % 1 then
        return false
    end
    
    return true
end


