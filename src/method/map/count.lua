---统计表元素个数
---@param tab table<any,any> @表
---@return count
return function(tab)
    local cnt = 0
    for k, v in pairs(tab) do
        cnt = cnt + 1
    end

    return cnt
end

