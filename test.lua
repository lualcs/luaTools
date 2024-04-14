local maskword = require("maskword")
local arr2set = require("array.map")


local obj = maskword.new(arr2set {
    "艹你妈",
})



print(obj:conver("艹你妈"))
