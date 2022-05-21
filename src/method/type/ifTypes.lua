---多个类型判断
---@param fun fun(v:any):boolean 
---@return boolean,number
return function(fun, ...)
    for i = 1, select('#', ...) do
        if not fun(select(i, ...)) then
            return false, i
        end
    end

    return true
end


