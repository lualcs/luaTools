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

local handle = { 0x08, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x02 }

local hand_tiles = array2map(handle)

local start = os.clock()

print("手牌数量:", #handle)
local out = {}
-- logDebug(mahjong:tinWinnCard(hand_tiles, clear(out)))

for i = 1, 10000 do
    mahjong:xuaWinnCard(hand_tiles)
end



local close = os.clock()

print("耗时:", close - start)
