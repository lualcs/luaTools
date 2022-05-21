local clear = require("table.clear")
local caches = require("optimize.cache")
---数据变更
local change = {}
---事务提交
---@param chgs table|nil @修改
return function(chgs)
    if not chgs then
        chgs = clear(change)
        for t, ret in pairs(caches) do
            local met = getmetatable(ret)
            local chg = met.__newindex
            local ori = met.__index
            local emt = met.__empty
            for k, v in pairs(chg) do
                if v ~= emt then
                    ori[k] = v
                else
                    ori[k] = nil
                end
            end
            caches[t] = nil
            change[t] = chg
        end
    end
    return chgs
end
