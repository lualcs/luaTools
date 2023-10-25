local clear = require("table.opt.clear")

---浅拷贝
---@param t table @要拷贝的表
---@param out table @外带表
---@return table @新表
return function(t, out)
    if out then
        clear(out)
    end

    local new = out or {}
    for k, v in pairs(t) do
        new[k] = v
    end

    return new
end
