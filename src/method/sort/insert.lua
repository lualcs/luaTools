---插入排序
---@param arr any[] @数组
---@param comp function  @比较函数
---@param val any  @插入值
return function(arr, comp, new)
    for k, val in ipairs(arr) do
        if comp(new, val) then
            table.insert(arr, k, new)
            return 
        end
    end
    
    --到这里直接添加到末尾
    table.insert(arr, new)
end


