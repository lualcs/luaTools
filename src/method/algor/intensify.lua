---类似dnf锻造概率
---@param percent number[] @百分比数组[1=100%]
---@return number @理论次数
return function(percent, much)
    local number = 0
    for i, v in ipairs(percent) do
        if i == much then
            break
        end
        number = number + (1 / v)
    end
    return number
end