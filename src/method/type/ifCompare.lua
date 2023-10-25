local left = require("table.compare.left")
---table比较
return function(lt, rt)
    return left(lt, rt) and left(rt, lt)
end


