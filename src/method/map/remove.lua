local clear = require("table.opt.clear")
local copy1 = {}

---map移除
---@param map table<any,any>	@数组
---@param val any	  			@移除的值
---@param cnt count 			@移除个数默认值为1
---@return  boolean
return function(map, val, cnt)
    local dels = clear(copy1)
    
    ---记录位置
    for i, v in pairs(map) do
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
        local k = dels[i]
        map[k] = nil
    end
    
    return true
end
