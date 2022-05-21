---数字转展示
---@param value number @实数
return function(value)
    if value < 10000 then
        return tostring(value)
    elseif value < 100000000 then
        return string.format("%.f万", value / 10000)
    end
    
    return string.format("%.f亿", value / 100000000)
end


