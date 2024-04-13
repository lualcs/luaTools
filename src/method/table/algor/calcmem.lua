local ifTable = require("ifTable")

---计算table 内存大小
local function sizeof(v)
    return 16 --默认都是16字节
end

---迭代计算lua表有多大
---@param t table @ 
---@param notfirst nil|true @释放第一层
local function calc(t, notfirst)
    local size = 0
    for k, v in pairs(t) do
        if notfirst then
            size = size + sizeof(k)
        end

        if ifTable(v) then
            size = size + calc(v, true)
        else
            size = size + sizeof(v)
        end
    end
    return size
end

return calc