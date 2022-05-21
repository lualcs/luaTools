local clear = require("table.clear")
local ifTable = require("ifTable")
---过滤字段
---@type table<string,true>
local filter = {
    __type = true,
    __base = true,
}

---深拷贝
---@param t table @要拷贝的表
---@param out table @外带表
---@return table @新表
function localf(t, out)
    local new = clear(out) or {}
    for k, v in pairs(t) do
        if not filter[k] then
            if ifTable(v) then
                new[k] = localf(v)
            else
                new[k] = v
            end
        end
    end

    return new
end

return localf
