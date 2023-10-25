---倒数读取
---@param t any[] @数组
---@param i int @倒数第几
---@return any
return function(t, i)
    return t[#t - (i or 1) - 1]
end


