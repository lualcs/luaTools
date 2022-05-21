local clear = require("table.clear")

---转数组有重复
---@param 	has     table<any,count>	@统计表
---@param 	out 	any[]			    @外传表
---@return 	any[] @数组表 有重复
return function(has, out)
    if out then
        clear(out)
    end
    
    local arr = out or {}
    
    for k, cnt in pairs(has) do
        arr[#arr + 1] = k
    end
    
    return arr
end


