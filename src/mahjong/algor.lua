---@type cmahjong
local cmahjong = require("cmahjong")
local class = require("class")
local super = require("game.algor")
local clone = require("table.opt.clone")
local clear = require("table.opt.clear")
local arraymap = require("array.map")
local mapSnaps = require("mahjong.cfg.mapSnaps")
local mapNames = require("mahjong.cfg.mapNames")

---@class mahjongAlogor:gameAlgor @麻将算法
local this = class(super)

---构造函数
function this:ctor()
    ---七对-默认支持
    ---@type boolean
    self._support_7pairs = true
    ---四混-默认关闭
    ---@type boolean
    self._support_4laizi = false
    ---七对癞子参与-默认关闭
    ---@type boolean
    self._support_7laizi = false
    ---癞子牌-默认关闭
    ---@type mjCard|nil
    self._support_dinglz = nil
    ---癞子表-默认空表
    ---@type table<mjCard,boolean>
    self._support_laizis = {}
    ---固定将对-默认空表
    ---@type table<mjCard,boolean>
    self._support_jiangs = {}
    ---顺子分组-默认空表
    ---@type table<mjCard,mjUnit>
    self._support_classs = {}
    ---麻将分类-计算属性
    ---@type table<index,mjUnit>
    self._support_mclass = {}
    ---调用信息-默认空表
    ---@type mjUsag
    self._current_usages = {}
end

---初始函数
function this:initial()
    local gameID = plug._competition:getGameInfo().gameID
    ---胡牌算法
    ---@type cmahjong
    self._calgor = cmahjong.new(clone(mapNames), {}, {}, {
        { color = 0, start = 1, close = 9 },
        { color = 1, start = 1, close = 9 },
        { color = 2, start = 1, close = 9 },
    }, clone(mapSnaps), gameID)
end

---七对开关
---@param sport boolean @true:开启 false:关闭
function this:setSupport7pairs(sport)
    self._support_7pairs = sport
end

---四混开关
---@param sport boolean @true:开启 false:关闭
function this:setSupport4laizi(sport)
    self._support_4laizi = sport
end

---七对癞子参与开关
---@param sport boolean @true:开启 false:关闭
function this:setSupport7laizi(sport)
    self._support_7laizi = sport
end

---清空癞子
function this:clrSupportLaizis()
    clear(self._support_laizis)
    self._calgor:clrSupportLaizis()
end

---添加癞子
---@param mj mjCard  @癞子牌
function this:addSupportLaizis(mj)
    self._support_laizis[mj] = true
    self._calgor:addSupportLaizis(mj)
end

---删除癞子
---@param mj mjCard  @癞子牌
function this:delSupportLaizis(mj)
    self._support_laizis[mj] = nil
    self._calgor:delSupportLaizis(mj)
end

---获取癞子映射表
---@return table<mjCard,boolean>
function this:getSupportLaizis()
    return self._support_laizis
end

---清空将对
function this:clrSupportJiangs()
    clear(self._support_jiangs)
    self._calgor:clrSupportJiangs()
end

---添加将对
---@param mj mjCard  @癞子牌
function this:addSupportJiangs(mj)
    self._support_dinglz = mj
    self._support_jiangs[mj] = true
    self._calgor:addSupportJiangs(mj)
end

---删除将对
---@param mj mjCard  @癞子牌
function this:delSupportJiangs(mj)
    local maps = self._support_jiangs
    self._support_jiangs[mj] = nil
    self._support_dinglz = next(maps)
    self._calgor:delSupportJiangs(mj)
end

---麻将
---@param  mj   mjCard      @麻将
---@return index
function this:getSupportClassID(mj)
    local maps = self._support_classs
    return maps[mj].class
end

---麻将
---@param  mj   mjCard      @麻将
---@return index
function this:getSupportClassInfo(mj)
    local maps = self._support_classs
    return maps[mj]
end

---可以成顺
---@param jid   index      @麻将
---@return      boolean
function this:ifJoint(jid)
    local map = self._support_mclass
    return map[jid].joint
end

---是癞子
---@param mj    mjCard      @麻将
---@return      boolean
function this:ifRuffian(mj)
    if self._support_laizis[mj] then
        return true
    end
    return false
end

---使用者
---@param player mahjongPlayer  @玩家
---@param mjFull mjFill         @全副麻将
function this:setUsages(player, mjFull)
    local info = self._current_usages
    info.player = player
    info.mjFull = mjFull or self._logic:getFMahjongMaps()
end

---使用者
---@return mjUsag
function this:getUsages()
    return self._current_usages
end

---统一手牌
---@param hands         mjHands       @手牌
---@return mjUnify
function this:getUnify(hands)
    ---手牌
    ---@type mjHands
    local mjhands = {}
    ---映射
    ---@type mjMapkc
    local mjMpasw = {}
    ---映射
    ---@type mjMapkc
    local mjMpacw = {}
    ---麻将辅助
    ---@type mahjongHelper
    local mjhelp = plug._helper
    ---@type mjClass
    local mjClass = {
        [1] = {}, --万
        [2] = {}, --条
        [3] = {}, --筒
        [4] = {}, --箭
        [5] = {}, --风
        [6] = {}, --花
    }
    local mjGapls = {
        [1] = { min = 9, max = 0, num = 0 }, --万
        [2] = { min = 9, max = 0, num = 0 }, --条
        [3] = { min = 9, max = 0, num = 0 }, --筒
        [4] = { min = 9, max = 0, num = 0 }, --箭
        [5] = { min = 9, max = 0, num = 0 }, --风
        [6] = { min = 9, max = 0, num = 0 }, --花
    }
    ---@type mjUnify
    local ufy = {
        lzCnt = 0,
        spCnt = #hands,
        mjhands = mjhands,
        mjMpasw = mjMpasw,
        mjMpacw = mjMpacw,
        mjClass = mjClass,
        mjGapls = mjGapls,
    }
    for _, mj in ipairs(hands) do
        local cl = mjhelp.getColor(mj)
        local cn = mjMpacw[cl] or 0
        mjMpacw[cl] = cn + 1
        if not self:ifRuffian(mj) then
            table.insert(mjhands, mj)
        else
            ufy.lzCnt = ufy.lzCnt + 1
        end
        --顺子分类
        local ji = self:getSupportClassID(mj)
        ---记录数据
        local ve = mjhelp.getValue(mj)
        local cv = mjClass[ji][ve] or 0
        mjClass[ji][ve] = cv + 1
        ---记录大小
        local vue = math.min(ve, mjGapls[ji].min)
        mjGapls[ji].min = vue
        vue = math.max(ve, mjGapls[ji].max)
        mjGapls[ji].max = vue
        vue = mjGapls[ji].num
        mjGapls[ji].num = vue + 1
    end
    mjMpasw = arraymap(mjhands, mjMpasw)
    table.sort(mjhands)
    return ufy
end

---数据变更
---@param ufy mjUnify @统一数据
---@param cnt mjCount @增加数量
---@param cmj mjCard  @增加数量
---@param kfd string  @记录键值
function this:clamp_unity(ufy, cnt, cmj, kfd)
    --如果是癞子
    if self:ifRuffian(cmj) then
        ufy.lzCnt = ufy.lzCnt + cnt
        return
    end

    ---@type mahjongHelper
    local mjHlp = plug._helper

    ---手牌
    ufy.spCnt = ufy.spCnt + cnt

    ---花色
    local clor = mjHlp.getColor(cmj)
    local ccnt = ufy.mjMpacw[clor] or 0
    ufy.mjMpacw[clor] = ccnt + cnt

    ---牌表
    local jcnt = ufy.mjMpasw[cmj] or 0
    ufy.mjMpasw[cmj] = jcnt + cnt

    ---顺牌
    local ji = self:getSupportClassID(cmj)
    local jv = plug._helper.getValue(cmj)

    ---记录大小
    local vue = math.max(ufy.mjGapls[ji].max, jv)
    ufy.mjGapls[ji].max = vue
    vue = math.min(ufy.mjGapls[ji].min, jv)
    ufy.mjGapls[ji].min = vue
    vue = ufy.mjGapls[ji].num
    ufy.mjGapls[ji].num = vue + cnt

    --设置拿牌
    if 1 == cnt then
        ufy[kfd] = cmj
    elseif -1 == cnt then
        ufy[kfd] = nil
    end
end

local count = 0
---胡检查次数
function this.getHuCardCount()
    return count
end

---胡检查次数
function this.setHuCardCount(c)
    count = c
end

---胡牌判断
---@param ufy   mjUnify @信息
function this:isHu7Pairs(ufy)
    --数量检查
    if 14 ~= ufy.spCnt then
        return false
    end

    if self._support_7laizi then
        --癞子允许参与
        local lzcnt = ufy.lzCnt
        for _, ct in ipairs(ufy.mjMpasr) do
            if 0 ~= ct % 2 then
                lzcnt = lzcnt - 1
                if lzcnt < 0 then
                    return false
                end
            end
        end
    else
        --癞子不能参与
        for _, ct in pairs(ufy.mjMpasr) do
            if 0 ~= ct % 2 then
                return false
            end
        end
    end

    return true
end

---胡牌判断
---@param ufy     mjUnify  @信息
---@return boolean
function this:canWinnCard(ufy)
    --数量检查
    if 2 ~= ufy.spCnt % 3 then
        return false
    end

    --支持四混
    if self._support_4laizi then
        if ufy.lzCnt >= 4 then
            return true
        end
    end

    --支持七对
    if self._support_7pairs then
        if self:isHu7Pairs(ufy) then
            return true
        end
    end

    return self._calgor:canWinnCard(ufy.mjMpasw)
end

---听哪些
---@param   hands mjHands        @手牌
---@return  table<mjCard,mjPeg>  @提示
function this:getTingCard(hands)
    ---@type mjTings        @胡牌映射
    local rtings = {}
    ---@type mjUsag         @使用信息
    local mjUsag = self:getUsages()
    ---@type mjUnify        @统一手牌
    local ufy = self:getUnify(hands)
    local mjMpacw = ufy.mjMpacw
    ---@type mjCount        @癞子数量
    local lzcount = ufy.lzCnt
    ---@type mahjongHelper  @麻将辅助
    local mjhelp = plug._helper
    ---@type mahjongType  @麻将类型
    local mjPeg = self._type
    ---遍历牌库
    for deal, _ in pairs(mjUsag.mjFull) do
        local ok = true
        local clor = mjhelp.getColor(deal)
        ---没有癞子
        if lzcount <= 0 then
            --不是癞子
            if not self:ifRuffian(deal) then
                local ccnt = mjMpacw[clor] or 0
                local mnum = (ccnt + 1) % 3
                if 2 ~= mnum and 0 ~= mnum then
                    --要么取将-要么成扑
                    ok = false
                end
            end
        end

        if ok then
            ---数据变更
            self:clamp_unity(ufy, 1, deal, "getCard")
            --检查胡牌
            if self:canWinnCard(ufy) then
                rtings[deal] = mjPeg:getPegItem(ufy)
            end
            ---数据变更
            self:clamp_unity(ufy, -1, deal, "getCard")
        end
    end

    ---添加癞子
    if next(rtings) then
        local lzs = self:getSupportLaizis()
        for lzmj, _ in pairs(lzs) do
            if not rtings[lzs] then
                ufy.getCard = lzmj
                rtings[lzmj] = mjPeg:getPegItem(ufy)
                ufy.getCard = nil
            end
        end
    end

    return rtings
end

---选那些
---@param   hands mjHands        @手牌
---@return  mjXuaks              @提示
function this:getXuanCard(hands)
    ---@type mjXuaks        @选牌映射
    local rXuaks = {}
    ---@type mjUsag         @使用信息
    local mjUsag = self:getUsages()
    ---@type mjUnify        @统一手牌
    local ufy = self:getUnify(hands)
    local mjMpasw = ufy.mjMpasw
    ---@type mahjongType  @麻将类型
    local mjPeg = self._type
    ---遍历牌库
    for cast, _ in pairs(mjMpasw) do
        ---数据变更
        self:clamp_unity(ufy, -1, cast, "casCard")
        for deal, _ in pairs(mjUsag.mjFull) do
            self:clamp_unity(ufy, 1, cast, "getCard")
            if self:canWinnCard(ufy) then
                ---@type mjTings    @胡牌信息
                local tings = rXuaks[cast] or {}
                rXuaks[cast] = tings
                tings[deal] = mjPeg:getPegItem(ufy)
            end
            self:clamp_unity(ufy, -1, cast, "getCard")
        end
        self:clamp_unity(ufy, 1, cast, "casCard")
    end
    ---添加癞子
    local lzs = self:getSupportLaizis()
    for _, tings in pairs(rXuaks) do
        if next(tings) then
            for lzmj, _ in pairs(lzs) do
                if not tings[lzs] then
                    ufy.getCard = lzmj
                    tings[lzmj] = mjPeg:getPegItem(ufy)
                    ufy.getCard = nil
                end
            end
        end
    end
    return rXuaks
end

return this