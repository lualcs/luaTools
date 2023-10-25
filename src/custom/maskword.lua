local class = require("class")
local clear = require("table.opt.clear")
local cutworks = require("cutworks")
local super = require("unknown")

---@class maskword:unknown @屏蔽字处理
local this = class(super)

---构造函数
---@param library table<string,true> @屏蔽字库
function this:ctor(library)
    local tree = {}
    local leng = {}
    for maskwords, _ in pairs(library) do
        local words = { cutworks.utf8_unpack(maskwords) }
        local node = tree
        for i = 1, #words do
            local word = words[i]
            node[word] = node[word] or {}
            node = node[word]
        end
        node[false] = true
        leng[#words] = true
    end

    self._tree = tree
    self._leng = leng
end

local words = {}
---插入函数
function this:insert(...)
    clear(words)
    for i = 1, select("#", ...) do
        words[i] = select(i, ...)
    end
end

local masks = {}
---转换函数
---@param text string @字符内容
---@return string
function this:conver(text)
    ---
    self:insert(cutworks.utf8_unpack(text))
    clear(masks)
    self:exhaustivity(1, 1, #words, words)
    for i, _ in pairs(masks) do
        words[i] = "*"
    end

    return table.concat(words)
end

---穷举检查
---@param c number @数量
---@param b number @开始
---@param e number @结束
---@param s number @字段
function this:exhaustivity(c, b, e, s)
    ---检查参数
    if (not s[e]) or (not s[b]) or (c > (e - b + 1)) then
        return 
    end

    for i = b, e do
        ---数量检查
        if (c > (e - i + 1)) or (not self._leng[c]) then
            break
        end

        local tree = self._tree
        local ok = true
        ---跟踪屏蔽
        for l = i, i + c - 1 do
            local node = tree[s[l]]
            if not node then
                ok = false
                break
            else
                tree = node
            end
        end
        ---记录屏蔽下标
        if ok and tree[false] then
            for l = i, i + c - 1 do
                masks[l] = true
            end
        end
    end

    self:exhaustivity(c + 1, b, e, s)
end

return this
