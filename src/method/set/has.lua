---检查数组值个数
---@param set table<any,true>   @数组
---@param val any               @查值
---@param cnt count             @个数
---@return boolean
return function(set, val, cnt)
    cnt = cnt or 1
    for k, _ in pairs(set) do
        if k == val then
            cnt = cnt - 1
            if cnt <= 0 then
                return true
            end
        end
    end

    return false
end


