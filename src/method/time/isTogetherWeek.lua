---@param t1 number @时间1
---@param t2 number @时间2
return function(t1, t2)
    local t1 = t1 - 1713153600
    local t2 = t2 - 1713153600
    return (t1 // 604800) == (t2 // 604800)
end

