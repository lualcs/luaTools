return function(t, v, n, ...)
    for i = 1, n do
        t[i] = v.new(...)
    end
    return t
end