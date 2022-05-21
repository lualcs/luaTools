
---获取日期
---@param sec integer|nil @时间
---@return string @毫秒
return function(sec)
    return os.date("%Y-%m-%d %H:%M:%S", sec)
end


