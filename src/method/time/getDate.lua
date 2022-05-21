---获取日期
---@param sec integer|nil @时间
---@return luaDate @毫秒
return function(sec)
    return os.date("*t", sec)
end


