return function(t, v, n)
    for i = 1, n do
        table.insert(t, v)
    end
    return t
end