local ifTable = require("ifTable")

---数据还原
---@param obj table @对象
---@param inf table @数据
local function localf(obj, inf)
    if inf then
        for k, v in pairs(inf) do
            if ifTable(v) then
                if obj[k] then
                    localf(obj[k], v)
                else
                    obj[k] = v
                end
            else
                obj[k] = v
            end
        end
    end
end

return localf


