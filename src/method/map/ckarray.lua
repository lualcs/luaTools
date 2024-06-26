local clear = require("table.opt.clear")

---转数组有重复
---@param 	map     table<any,count>	@统计表
---@param 	out 	any[]			    @外传表
---@return 	any[] @数组表 有重复
return function(map, out)
    local arr = clear(out) or {}
    local len = 1
    
    for k, cnt in pairs(map) do
        for i = 1, cnt do
            arr[len] = k
            len = len + 1
        end
    end
	
    return arr
end

