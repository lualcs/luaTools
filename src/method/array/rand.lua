---随机元素
---@param tab any[] @表
---@return val
return function(tab)
    local who = math.random(1, #tab)
    return tab[who]
end
