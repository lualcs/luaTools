local class = require("class")
local calls = require("array.call")
local super = require("unknown")

---@class tigger:unknown @监听触发器
local this = class(super)

---构造函数
function this:ctor()
    ---事件触发列表
    ---@type table<string,function[]>
    self._events = {}
end

---获取列表
---@param  name string @事件映射
---@return function[]
function this:events(name)
    local list = self._events[name] or {}
    self._events[name] = list
    return list
end

---添加监听
---@param name string   @注册时间
---@param call fun()    @触发函数
---@return name,fun()   @返回凭证
function this:append(name, call)
    local list = self:events(name)
    table.insert(list, call)
    return name, call
end

---移除监听
---@param name string   @注册时间
---@param call fun()    @触发函数
---@return name,fun()   @返回凭证
function this:remove(name, call)
    local list = self:events(name)
    
    for index, event in ipairs(list) do
        if call == event then
            table.remove(list, index)
            break
        end
    end
    
    return name, call
end

---触发事件
---@param   name string @触发事件
---@vararg  any[]       @事件参数
function this:ejector(name, ...)
    local list = self:events(name)
    calls(list, ...)
end

return this
