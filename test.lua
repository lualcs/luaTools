package.path = [[/usr/local/share/lua/5.4/?.lua;/usr/local/share/lua/5.4/?/init.lua;/usr/local/lib/lua/5.4/?.lua;/usr/local/lib/lua/5.4/?/init.lua;./?.lua;./?/init.lua]]
package.cpath = [[/usr/local/lib/lua/5.4/?.so;/usr/local/lib/lua/5.4/loadall.so;./?.so]]

local maskword = require("maskword")
local arr2set = require("array.map")


local obj = maskword.new(arr2set {
    "艹你妈",
})



print(obj:conver("艹你妈"))



