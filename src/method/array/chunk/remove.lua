---移除数组
---@overload fun<V>(t:table<nmber,V> | V[]):V
---@generic V
---@param t  table<nmber,V> | V[]       @只有这个参数 等同 table.remove
---@param i1 number|nil @开始位置
---@param i2 number|nil @结束位置
---@return V|nil
return function(t, i1, i2)
    if not i2 then
        return table.remove(t, i1)
    end

    local len = #t
    --删除数据
    for i = i1, i2 do
        t[i] = nil
    end

    --数据移位
    local num = len - i2
    table.move(t, i2 + 1, len, i1, t)

    --清除残留数据
    for i = len, len - num, -1 do
        t[i] = nil
    end
end
