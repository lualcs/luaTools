local clear = require("table.clear")
local copy1 = {}

---map移除
---@param arr table<number,any>	@数组
---@param val any	  			@移除的值
---@param cnt count 			@移除个数默认值为1
---@return  boolean
return function(arr, val, cnt)
    local dels = clear(copy1)
    
    ---记录位置
    for i, v in ipairs(arr) do
        if v == val then
            table.insert(dels, i)
            
            if cnt == #dels then
                break
            end
        end
    end
    
    ---判断数量
    if cnt ~= #dels then
        return false
    end
    
    ---删除元素
    for i = #dels, 1 do
        table.remove(arr, dels[i])
    end
    
    return true
end
