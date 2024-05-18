local function s2boolean(s)
    if true == s or false == s then
        return s
    elseif "nil" == s or nil == s or "" == s then
        return nil
    end
    local n = tonumber(s)
    return (0 ~= n) and true or false
end

local function test(svalue, defv)
    local v = s2boolean(svalue)
    if nil == v and defv then
        return s2boolean(defv)
    end
    return v
end

print(test(false, "true"))
