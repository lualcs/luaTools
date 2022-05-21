local left = require("table.lcompare")
---table比较
return function(a, b)
    return left(a, b) and left(b, a)
end


