---是否数组
---@param v any @数据
---@return boolean
return function(v)
    if "table" ~= type(v) then
        return false
    end
    
    if #v > 0 then
        if not v[1] then
            return false
        elseif next(v, #v) then
            return false
        end
    end
    
    return not next(v)
end


