local map = {
    ["and"] = true,
    ["or"] = true,
    ["break"] = true,
    ["if"] = true,
    ["elseif"] = true,
    ["else"] = true,
    ["do"] = true,
    ["then"] = true,
    ["end"] = true,
    ["for"] = true,
    ["while"] = true,
    ["until"] = true,
    ["true"] = true,
    ["false"] = true,
    ["function"] = true,
    ["in"] = true,
    ["goto"] = true,
    ["local"] = true,
    ["nil"] = true,
    ["not"] = true,
    ["repeat"] = true,
    ["return"] = true,
}

---是否关键字
---@param s string @字符串 
---@return boolean 
return function(s)
    return map[s]
end


