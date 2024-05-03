local clear = require("table.opt.clear")
local caches = require("optimize.cache")
---数据变更
local change = {}
---事务提交
---@param chgs table|nil @修改
---@return table @返回修改记录
return function(chgs)
    if not chgs then
        chgs = clear(change)
        for t, ret in pairs(caches) do
            local met = getmetatable(ret)
            local chg = met.__newindex ---记录修改
            local ori = met.__index    ---原始数据
            local emt = met.__empty    ---忽略数据
            for k, v in pairs(chg) do

                ---值一样删除记录
                if ori[k] == v then
                    chg[k] = nil
                end

                if v ~= emt then
                    ori[k] = v
                else
                    ---删除视同nil的子弹
                    ori[k] = nil
                end
            end
            caches[t] = nil
            change[t] = chg
        end
    end
    return chgs
end
