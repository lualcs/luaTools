--[[
    desc:成扑映射
]]

local kz111 = { [1] = 3 }
local kz222 = { [2] = 3 }
local kz333 = { [3] = 3 }
local kz444 = { [4] = 3 }
local kz555 = { [5] = 3 }
local kz666 = { [6] = 3 }
local kz777 = { [7] = 3 }
local kz888 = { [8] = 3 }
local kz999 = { [9] = 3 }

local sz123 = { [1] = 1, [2] = 1, [3] = 1 }
local sz234 = { [2] = 1, [3] = 1, [4] = 1 }
local sz345 = { [3] = 1, [4] = 1, [5] = 1 }
local sz456 = { [4] = 1, [5] = 1, [6] = 1 }
local sz567 = { [5] = 1, [6] = 1, [7] = 1 }
local sz678 = { [6] = 1, [7] = 1, [8] = 1 }
local sz789 = { [7] = 1, [8] = 1, [9] = 1 }

---成扑信息(牌值-参与的刻子或者顺子)
---@type table<number,number>[][]
local data = {
    [1] = { sz123, kz111 },
    [2] = { sz123, sz234, kz222 },
    [3] = { sz123, sz234, sz345, kz333 },
    [4] = { sz234, sz345, sz456, kz444 },
    [5] = { sz345, sz456, sz567, kz555 },
    [6] = { sz456, sz567, sz678, kz666 },
    [7] = { sz567, sz678, sz789, kz777 },
    [8] = { sz678, sz789, kz888 },
    [9] = { sz789, kz999 },
}

---@type number[][]
local pos = {
    [1] = {},
    [2] = {},
    [3] = {},
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
}

---数值可以参与的类型
---@type table<number,number>[]
local arr = {}
---数组映射对于类型
---@type table<number,number>
local map = {}
for i, list in ipairs(data) do
    for j, v in ipairs(list) do
        if not map[v] then
            table.insert(arr, v)
            map[v] = #arr
        end
        pos[i][j] = map[v]
    end
end

return {
    arr = arr,
    pos = pos,
}
