---z=x*(2^y) 规则拆解
---@return x,y @x < 1
return function(z)
    for i = 0, 32 do
        local x = z / (2 ^ i)
        
        if x < 1 then
            return x, i
        end
    end
end

