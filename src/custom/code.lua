
local skynet = require("skynet")
local class = require("class")
local super = require("unknown")
local dundryCode = require("sundry.code")
local t2string = require("t2string")


---@class ICode:unknown @错误码辅助
local this = class(super)

local regionCode = 100000000
local moduleCode = 10000

---构造函数
---@param mode integer      @开发模块
---@param mogo service   @服务信息
function this:ctor(mode, mogo)
    ---功能模块
    self._mode = mode * moduleCode
    ---服务信息
    self._mogo = mogo
end

local i = regionCode
local s = { i * 1, i * 2, i * 3, i * 4, i * 5, i * 6, i * 7, i * 8, i * 9 }

---生成编码
---@param code integer @编号
---@return integer
function this:make(type, code)
    return s[type] + self._mode + code
end

---获取类型
---@param code integer @编号
---@return integer
function this:type(code)
    return (code // regionCode)
end

---获取模块
---@param code integer @编号
---@return integer
function this:mode(code)
    return (code % regionCode) // moduleCode
end

---获取代码
---@param code integer @编号
---@return integer
function this:code(code)
    return (code % moduleCode)
end

---错误码
---@param code integer @错误编号
function this:err(code)
    skynet.send(self._mogo, "lua", "writeError", code, debug.traceback())
    ---返回错误码
    return self:make(1, code)
end

---消息号
---@param code integer @消息号
function this:c2s(code)
    return self:make(2, code)
end

---消息号
---@param code integer @消息号
function this:s2c(code)
    return self:make(3, code)
end

---消息号
---@param code integer @消息号
function this:s2s(code)
    return self:make(4, code)
end

---消息号
---@param code integer @消息号
function this:s2w(code)
    return self:make(5, code)
end

---消息号
---@param code integer @消息号
function this:w2s(code)
    return self:make(6, code)
end

---获取代码
---@param code integer @编号
---@return string
function this:desc(code)
    local type = self:type(code)
    local mode = self:mode(code)
    local code = self:code(code)
    
    local stype = dundryCode.types[type]
    local smode = dundryCode.modes[type]
    local scode = dundryCode.types[stype][smode][code]
    
    return t2string({
        type = stype,
        mode = smode,
        code = scode,
    })
end

return this
