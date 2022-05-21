---随机删除
---@param t any[] @集合列表
---@return any
return function(t)
    local count = #t
    local index = math.random(1, count)
    t[count], t[index] = t[index], t[count]
    return table.remove(t)
end
