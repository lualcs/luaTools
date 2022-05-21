local utime = require("usertime")

---纳秒
---@return integer @纳秒
return function()
    return utime.microsecond()
end


