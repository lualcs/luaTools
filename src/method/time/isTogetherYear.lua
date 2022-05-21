---是否同年
---@param aTime number @时间
---@param bTime number @时间
---@return boolean
return function(aTime, bTime)
    return os.date("%Y", aTime) == os.date("%Y", bTime)
end


