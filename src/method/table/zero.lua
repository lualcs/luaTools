---置零数据
---@param t table @表
---@return table
return function(t)
    for k, _ in pairs(t) do
        t[k] = 0
    end

    return t
end


