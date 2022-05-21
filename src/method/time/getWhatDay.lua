local upday = {
    ["0"] = 7,
    ["1"] = 1,
    ["2"] = 2,
    ["3"] = 3,
    ["4"] = 4,
    ["5"] = 5,
    ["6"] = 6,
}

---星期几
---@param sec integer|nil @时间
---@return integer @毫秒
return function(sec)
    local wday = os.date("%w", sec)
    return upday[wday]
end


