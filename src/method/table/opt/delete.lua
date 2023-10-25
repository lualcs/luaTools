return function(t,k) 
    local v = t[k]
    t[k] = nil
    return v
end