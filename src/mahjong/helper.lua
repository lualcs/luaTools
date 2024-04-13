local class = require("class")
local clear = require("table.opt.clear")
local super = require("unknown")
---@class mahjongHelper:unknown @麻将辅助
local this = class(super)

---构造函数
---@param mapNames table<mjCard,name>
function this:ctor(mapNames)
    self.mapNames = mapNames
end

---获取名字
---@param mjCard mjCard @扑克牌值
---@return name
function this:getName(mjCard)
    return self.mapNames[mjCard]
end

local names = {}

---获取名字
---@param cards mjCard[] @扑克牌值
---@return name
function this:getNames(cards)
    clear(names)
    
    for _, mjCard in ipairs(cards) do
        local name = self:getName(mjCard)
        table.insert(names, name)
    end
    return table.concat(names)
end

---获取整副牌
---@param infos mjFill[]
---@return mjCard[]
function this.getCards(infos)
    local cards = {}
    
    for _, item in ipairs(infos) do
        for value = item.start, item.close do
            local mj = this.getCard(item.color, value)
            
            for i = 1, item.again do
                table.insert(cards, mj)
            end
        end
    end
    return cards
end

---获取牌值
---@param mjCard mjCard @扑克
---@return mjValue
function this.getValue(mjCard)
    return mjCard % 16
end

---获取花色
---@param mjCard mjCard @扑克
---@return mjColor
function this.getColor(mjCard)
    return mjCard // 16
end

---获取麻将
---@param color mjColor   @花色
---@param value mjValue   @牌值
---@return mjColor
function this.getCard(color, value)
    return color * 16 + value
end

---是否万
---@param mj mjCard
---@return boolean
function this.isWang(mj)
    return mj and mj >= 0x01 and mj <= 0x09
end

---是否条
---@param mj mjCard
---@return boolean
function this.isTiao(mj)
    return mj and mj >= 0x11 and mj <= 0x19
end

---是否筒
---@param mj mjCard
---@return boolean
function this.isTong(mj)
    return mj and mj >= 0x21 and mj <= 0x29
end

---是否风
---@param mj mjCard
---@return boolean
function this.isFeng(mj)
    return mj and mj >= 0x31 and mj <= 0x34
end

---是否箭
---@param mj mjCard
---@return boolean
function this.isJian(mj)
    return mj and mj >= 0x35 and mj <= 0x37
end

---是否字
---@param mj mjCard
---@return boolean
function this.isFont(mj)
    return mj and mj >= 0x31 and mj <= 0x37
end

---是否花
---@param mj mjCard
---@return boolean
function this.isFlower(mj)
    return mj and mj >= 0x41 and mj <= 0x48
end

return this
