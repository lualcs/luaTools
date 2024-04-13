local cache = require("random.cache")

local gather = {}

---不重复随机-缓存版本-集合
---@param  list any[] 				    @随机数组
---@param  map  table<any,true>|nil	    @排除数据
---@return fun(index:index|nil):index   @随机闭包
return function(list, map)
    local tab = gather[list] or {
        cache(list, map)
    }
    gather[list] = tab
    return tab[1],tab[2]
end