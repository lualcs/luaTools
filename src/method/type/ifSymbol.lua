local ifKeyword = require("ifKeyword")

---标识符标志
return function(s)
    ---数字字母下划线组成
    if s:find("[^%w_]") then 
        return false 
    end
    
    ---字母或者下划线开头
    if not s:find("^[%a_]") then
        return false
    end
    
    return not ifKeyword(s)
end


