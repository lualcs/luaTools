
local ifPattern = require("ifPattern")

---深比较
---@param a table @表1 
---@param b table @表2
return function(a, b)
    --正向比较
    if not ifPattern(a, b) then
        return false
    end
    
    --反向比较
    if not ifPattern(b, a) then
        return false
    end
	
    return true
end


