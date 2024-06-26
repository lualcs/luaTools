---过滤拷贝
---@param t         any[] @要拷贝的表
---@param out       table @外带表
---@param filter    function|nil @过滤函数
return function(t, filter, out)
    if out then
        table.opt.clear(out)
    end

    local new = out or {}
    for k, v in ipairs(t) do
        if not filter or filter(k, v) then
            table.insert(new, v)
        end
    end

    return new
end
