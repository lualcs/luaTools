---类似dnf锻造概率
---@param percent number[] @百分比数组[1=100%]
---@return number @理论次数
return function(percent, much)
    local times = 0
    for i = 1, much - 1 do
        times = times + (1 / percent[i])
    end
    return times
end