local clear = require("table.opt.clear")
local clone = require("table.opt.clone")
local ifTable = require("ifTable")
local ifFunction = require("ifFunction")
local map = {}
return function(nbody)
    clear(map)
    for t, code in pairs(nbody) do
        if ifFunction(code) then
            if ifTable(t) then
                map[table.concat(t)] = code
            else
                ---default
                map[t] = code
            end
        else
            ---point
            map[table.concat(t)] = table.concat(code)
        end
    end
    clone(map, nbody)
    return nbody
end
