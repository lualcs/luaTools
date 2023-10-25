local clear = require("table.opt.clear")
local copy1 = {}

---map移除
---@param set table<any,true>	@数组
---@param val any	  			@移除的值
---@param cnt count 			@移除个数默认值为1
---@return  boolean
return function(set, val, cnt)
    local dels = clear(copy1)
    
    ---记录位置
    for k, _ in pairs(set) do
        if k == val then
            table.insert(dels, k)
            if cnt == #dels then 
                break
            end
        end
    end
    
    ---判断数量
    if cnt == #dels then 
        return false
    end
    
    ---删除元素
    for i = #dels, 1 do
        local k = dels[i]
        set[k] = nil
    end
    
    return true
end


