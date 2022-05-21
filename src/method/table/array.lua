local clear = require("table.clear")

---处理成连续表
---@param t table @表
---@return any[]
return function(t, out)
    local new = clear(out or {})
    for k, v in pairs(t) do
        table.insert(new, v)
    end

    return new
end


