---修改结构
---@param mit  table @修改数据
---@param tab  table @原表数据
---@param s2c  table @保存数据
---@param type any   @分类标记
return function(mit, tab, s2c, type)
    local chge = mit[tab]
    
    if chge and next(chge) then
        local msge = {
            type = type,
            k = {},
            v = {},
        }
        table.insert(s2c, msge)
        
        for k, v in pairs(chge) do
            table.insert(msge.k, k)
            table.insert(msge.v, v)
        end
    end
end
