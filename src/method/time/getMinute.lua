---多少分钟
---@param sec integer|nil @时间
---@return integer @毫秒
return function(sec)
    return tonumber(os.date("%M", sec))
end


