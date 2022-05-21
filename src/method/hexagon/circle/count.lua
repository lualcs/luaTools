---六边形数量
---@param circle  integer  @圈数0~n
---@return count  @数量
return function(circle)
    if 1 == circle then
        return 1
    end
    return (circle - 1) + (5 * (circle - 1)) + 1
end
