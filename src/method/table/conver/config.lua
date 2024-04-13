---配置转换-将结构转成数组
---@param cfgs table[] @配置表
---@param struct table @结构体
return function(cfgs, struct)
    ---迭代函数
    local function lnext(t, rk)
        local k, v = next(t, rk)
        v = t[v]
        return k, v
    end
    ---元表设置
    local meta = {
        ---field 访问
        __index = function(t, k)
            return t[struct[k]]
        end,
        __pairs = function(t)
            return lnext, t, nil
        end,
    }
    for id, cfg in pairs(cfgs) do
        local ncfg = {}
        for field, index in pairs(struct) do
            ncfg[index] = cfg[field]
        end
        cfgs[id] = setmetatable(ncfg, meta)
    end
    return cfgs
end