---将s合并到t中
---@param t     any[]
---@param s     any[]
---@return t
return function(t, s)
    for _, v in ipairs(s) do
        t[v] = true
    end
    
    return t
end
