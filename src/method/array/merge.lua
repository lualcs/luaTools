---将s合并到t中
---@param t     any[]
---@param s     any[]
---@return t
return function(t, s)
    for _, v in ipairs(s) do
        table.insert(t, v)
    end
    
    return t
end
