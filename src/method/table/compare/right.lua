local left = require("table.compare.left")
return function(lt, rt)
    return left(rt, lt)
end