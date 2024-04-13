local class = require("class")
local super = require("unknown")
---@class dbuilderDirector:unknown @建造者指挥者
local this = class(super)

---构造函数
function this:ctor()
    ---产品容器
    ---@type builderProduct[]
    self._list = {}
end

---添加产品
---@param product builderProduct @构建模式产品
function this:push(product)
    table.insert(self._list, product)
end

return this
