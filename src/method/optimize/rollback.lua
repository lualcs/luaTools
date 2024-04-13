local caches = require("optimize.cache")
---事务回滚
return function()
    for t, _ in pairs(caches) do
        caches[t] = nil
    end
end