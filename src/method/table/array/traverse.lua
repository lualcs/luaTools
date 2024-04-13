---遍历查找
---@param arr any[]  @数组
---@param val any    @查找值
---@param idx index  @起点
---@return any
return function(t, v, idx)
    local len = #t
    for i = (idx or 1) + 1, len do
        if t[i] == v then
            return i
        end
    end
end