local ifTable = require("ifTable")
local function localf(lt, rt)
    if not ifTable(lt) or not ifTable(rt) then
        return lt == rt
    end

    for k, lv in pairs(lt) do
        local rv = rt and rt[k]
        if not localf(lv, rv) then
            return false
        end
    end

    return true
end

return localf



