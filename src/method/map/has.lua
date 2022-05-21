---检查数组值个数
---@param arr any[]	    @数组
---@param val any		@查值
---@param cnt count	    @个数
---@return boolean
return function(arr, val, cnt)
    cnt = cnt or 1
    for _, v in pairs(arr) do
        if v == val then
            cnt = cnt - 1
            if cnt <= 0 then
                return true
            end
        end
    end

    return false
end
