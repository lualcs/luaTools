
---吐出另一个表的值 at[k] = at[k] - bt[k]
---@param at table<any,count> @表1
---@param bt table<any,count> @表2
return function(at, bt)
    for k, v in pairs(bt) do
        at[k] = (at[k] or 0) - v
    end
end


