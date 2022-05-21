local class = require("class")
local clone = require("table.clone")
local source = require("table.source")
---@class unknown @空class
local this = class()

---调用基类
---@generic T
---@param this T        @原class
---@param f    string   @接口名字
---@return ...
function this:super(this, f, ...)
    return this.__base[f](self, ...)
end

---构造函数
function this:ctor()
end

---初始数据
function this:initial()
end

---启动对象
function this:launch()
end

--数据清空
function this:clear()
end

---数据拷贝
function this:clone()
    return clone(self)
end

---数据还原
---@param data table @还原数据
function this:source(data)
    return source(self, data)
end

return this
