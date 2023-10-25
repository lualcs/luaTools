local global = {}
return function(path, ...)
    local obj = global[path]
    if not obj then
        obj = require(path):new(...)
        global[path] = obj
    end
    return obj
end
