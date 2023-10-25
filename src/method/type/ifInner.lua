local clear = require("table.cleaer")


local map = {}
---是否存在某个值
---@param t1    any[]   @表数据
---@param t2    any[]   @值数据
---@return boolean
return function(t1, t2)
    ---填充数据
    clear(map)
    for k, v in pairs(t1) do
        map[v] = true
    end

    ---检查数据
    for k, v in pairs(t2) do
        if map[v] then
            return true
        end
    end
    return false
end


