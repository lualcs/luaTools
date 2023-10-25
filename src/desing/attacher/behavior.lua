local class = require("class")
local super = require("unknown")
local timer = require("singleClass.timer")
---@class attacherBehavior:unknown @多命令行为
local this = class(super)

---构造函数
---@param timerout number @执行超时
---@param attemper attemperAttacher @调度对象
---@param behavior T[] @固定行为
function this:ctor(timerout,attemper, behavior)
    ---执行超时
    self._timerout = timerout
    ---调度对象
    self._attemper = attemper
    ---固定行为
    self._behavior = behavior
    ---注册调度
    attemper:regCallback(self)
    self:clear()
end

---清理函数
function this:clear()
    self._icursor = 1
end

---启动函数
function this:launch()
    ---启动执行下命令
    self:execute()

    ---定时器唯一标识
    ---@type number
    self._timerID = timer:appendEver(self._timerout, function()
        self:execute()
    end)
end

function this:execute()
    local behavior = self._behavior[self._icursor]
    behavior.closure()
end

---回调函数
---@param whice string @回调命令
function this:callback(whice)
    local icursor = self._icursor
    local container = self._behavior
    local behavior = container[icursor]
    if behavior.validation(whice) then
        icursor = icursor + 1
        ---删除定时器
        if not container[icursor] then
            timer:removeByID(self._timerID)
            self._timerID = nil
        else
            self._icursor = icursor
            ---执行一下新的命令
            self:execute()
            ---重置一下超时时间
            timer:resetTimer(self._timerID)
        end
        return true
    end
    return false
end

return this
