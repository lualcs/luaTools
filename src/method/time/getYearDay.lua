---一年多少天
---@param sec integer|nil @时间
---@return integer @毫秒
return function(sec)
    ---@type luaDate
    local date = os.date("*t", sec)
    date.month = 12
    date.day = 31
    return tonumber(os.date("%j", os.time(date)))
end


