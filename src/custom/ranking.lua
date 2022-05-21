local class = require("class")
local super = require("unknown")
local sortInsert = require("sort.insert")
local traverse = require("search.traverse")


---@class ranking:unknown @排行对象
local this = class(super)

---@class rank  @排行单元
---@field iden  any     @唯一标识
---@field score score   @排行积分

---构造函数
---@param cfg   tp_rankInfos @排行榜配置
function this:ctor(cfg)
    self._cfg = cfg
    ---最大数量
    ---@type count
    self._max = cfg.count;
    ---排行数据
    ---@type rank[]                 
    self._lis = {};
    ---映射数据
    ---@type table<any,rank>
    self._map = {}
    ---最低积分
    ---@type score
    self._min = 0
end

---设置最低限制
---@param score score @最低积分 
function this:setMinScore(score)
    self._min = score
end

---比较函数
---@param a rank
---@param b rank
local function comp(a, b)
    return a.score > b.score
end

---更新分数
---@param iden  any     @唯一标识
---@param score score   @积分
function this:update(iden, score)
    local lis = self._lis
    local map = self._map
    local inf = map[iden]
    --插入数据
    if not inf then
        inf = {
            iden = iden,
            score = score,
        }
        map[iden] = inf
        sortInsert(lis, comp, inf)
    else
        --更新数据
        inf.score = score
        local index = traverse(lis, inf)
        table.remove(lis, index);
        sortInsert(lis, comp, inf)
    end
    return score
end

---增加分数
---@param iden  any     @唯一标识
---@param score score   @积分
function this:append(iden, score)
    local src = self._map[iden] and self._map[iden].score or 0
    self:update(src + score)
end

---删除数据
---@param iden  any     @唯一标识
function this:remove(iden)
    local lis = self._lis
    local map = self._map
    local inf = map[iden]

    if not inf then
        return
    end

    map[iden] = nil
    local index = traverse(lis, inf)
    table.remove(lis, index);
end

return this
