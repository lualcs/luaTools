local timer = require("timer")
local class = require("class")
local skynet = require("skynet")

---@class clock:timer @时钟器
local this = class(timer)

---构造
---@param fmt string @格式字符
function this:ctor(fmt)
    self._fmt = fmt
end

---修改
function this:alter(fmt)
    self._fmt = fmt
end

---获取时间
function this:time()
    return os.time()
end

---轮询器
function this:timeout()
    ---定时回调
    skynet.timeout(100, self._callback)
end

---检测器
---@param inow number @当前时间
---@param iend number @结束时间
function this:ifExpire(inow, iend)
    ---剩余时间
    skynet.error(string.format(self._fmt, iend - inow))
    return self:super(this, "ifExpire", inow, iend)
end

return this

---@class tagTimer              @定时数据
---@field elapse    MS          @间隔时间
---@field count     count       @回调次数
---@field call      function    @回调函数
---@field args      any[]       @回调参数
