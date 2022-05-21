local mapCnt = require("map.count")

---随机元素
---@param tab table<any,any> @表
---@return any,any @key,val
return function(tab)
    local cnt = mapCnt(tab)
    local who = math.random(1, cnt)
    
    for k, v in pairs(tab) do
        who = who - 1
        
        if who <= 0 then
            return k, v
        end
    end
end

