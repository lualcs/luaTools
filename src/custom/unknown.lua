local class = require("class")
local ifFunction = require("ifFunction")
local clone = require("table.opt.clone")
local source = require("table.opt.source")
local default = require("table.default.table")

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
    ---信号表信息<函数名字,对象列表>
    ---@type table<string,any[]>
    self._signals = default({}, true)
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

---关联列表
local uv_os
---关联方法
local uv_ok
---调用对象
local uv_oi
local function signal_call(...)
    for _, v in pairs(uv_os) do
        v[uv_ok](v, ...)
    end
    return uv_oi.__virtual[uv_ok](uv_oi, ...)
end

---信号元方法
---@param o     any     @调用方法
---@param key   string  @函数名字
local function signal_index(o, key)
    local from = getmetatable(o)
    local value = from.__index
    if ifFunction(value) then
        uv_os = rawget(o._signals, key)
        if uv_os then
            uv_ok = key
            uv_oi = o
            return signal_call
        end
    end
    return o.__virtual[key]
end

---连接方法
---@param other any    @被连对象
---@param fname string @函数名字
function this:connect(other, fname)
    local meta = getmetatable(other)
    local from = meta.__index
    if not ifFunction(from) then
        meta.__index = signal_index
        other.__virtual = from
    end
    table.insert(other._signals[fname], self)
end

return this