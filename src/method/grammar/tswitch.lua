local tconcat = require("tconcat")
local clear = require("table.opt.clear")
local ifFunction = require("ifFunction")
local arg = {}
local map = {}
return function(param, nargs, nbody, ...)
    ---构建数组
    clear(arg)
    for _, k in ipairs(nargs) do
        local v = param[k]
        assert(nil ~= v)
        table.insert(arg, v)
    end

    local argv = table.concat(arg)
    local code = nbody[argv]

    if not code then
        ---调用函数
        local def = nbody.default
        if def then
            return def(...)
        end
    end

    ---语法缓存
    if not map[nbody] then
        map[tconcat(nbody)] = true
    end

    ---找到分支
    repeat
        if ifFunction(code) then
            return code(...)
        end
        code = nbody[code]
    until not code
end
