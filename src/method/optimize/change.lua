---统计修改字段数据
---@param mit  table    @修改缓存
---@param tab  table    @原表数据
---@param s2c  table    @通知消息
---@param stp  string   @数据分类
return function(mit, tab, s2c, stp)
    ---当前统计修改
    local chge = mit[tab]
    if chge and next(chge) then
        local msge = {
            type = stp,
            k = {},
            v = {},
        }
        table.insert(s2c, msge)

        for k, v in pairs(chge) do
            table.insert(msge.k, k)
            table.insert(msge.v, v)
        end
    end
    return s2c
end
