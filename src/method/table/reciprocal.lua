---倒数读取
---@param t any[] @数组
---@param count count @倒数第几
---@return any
return function(t, count)
    return t[#t - (count or 1) - 1]
end


