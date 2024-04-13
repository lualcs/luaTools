---添加列表
---@param t     any[]           @数组
---@param map   table<any,any>  @哈希
return function(t, map)
    for _, v in pairs(map) do
        table.insert(t, v)
    end
end
