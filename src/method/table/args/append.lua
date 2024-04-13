
---添加列表(select(i,...) i~最后的所有参数)
---@param t any[] @数组
---@param ... any[] @变长参数
return function(t, ...)
    local len = select("#", ...)
    for i = 1, len do
        local v = select(i, ...)
        table.insert(t, v)
    end

    return true
end


