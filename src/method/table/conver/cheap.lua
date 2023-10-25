local ifTable = require("ifTable")
local clone = require("table.opt.clone")

---代理拷贝
---@generic T:any
---@param src table @默认值表
---@param refuse fun(cmd:string):boolean @拒绝
---@return fun(out:T|nil):T
return function(src, refuse)

    local meta = { __index = src }
    if not (refuse and refuse("pairs")) then
        ---是否支持pairs
        local arr = {}
        local map = {}
        local idx = 0
        for key, val in pairs(src) do
            idx = idx + 1
            arr[idx] = key
            map[key] = idx
        end

        local function rpairs(t, k)
            if nil == k then
                k = arr[1]
            else
                k = arr[map[k] + 1]
            end

            return k, t[k]
        end

        function meta.__pairs(t)
            return rpairs, t, nil
        end
    end

    local new = nil
    return function(out)
        if (not refuse) or not (refuse("single")) then
            if new then
                ---表示只有一份
                return new
            end
        end

        new = out or {}
        if not (refuse and refuse("clone")) then
            ---table数据重新拷贝一份
            for k, v in pairs(src) do
                if ifTable(v) then
                    if not new[k] then
                        new[k] = clone(v)
                    end
                end
            end
        end

        return setmetatable(new, meta)
    end
end


