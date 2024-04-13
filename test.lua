---@type cmahjong
local cmahjong = require("cmahjong")
local class = require("class")
local super = require("unknown")
local clone = require("table.opt.clone")
local clear = require("table.opt.clear")
local arraymap = require("array.map")
local mapSnaps = require("mahjong.cfg.mapSnaps")
local mapNames = require("mahjong.cfg.mapNames")
local logDebug = require("logDebug")
local array2map = require("array.map")

---@type cmahjong
local mahjong = cmahjong.new(mapNames, {}, {}, {
    { color = 0, start = 1, close = 9 },
    { color = 1, start = 1, close = 9 },
    { color = 2, start = 1, close = 9 },
}, mapSnaps, 1)

local hand_tiles = array2map { 0x01, 0x01, 0x02, 0x02, 0x03, 0x03, 0x04, 0x04, 0x05, 0x05, 0x06, 0x06,0x01, 0x01, 0x02, 0x02, 0x03, 0x03, 0x04, 0x04, 0x05, 0x05, 0x06, 0x06, 0x07, 0x07 }

local start = os.clock()

for i = 1, 1 do
    mahjong:canWinnCard(hand_tiles)
end


local close = os.clock()

print("耗时:", close - start)

