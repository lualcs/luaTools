local class = require("class")
--local skynet = require("skynet")
local reusable = require("reusable")
local super = require("unknown")
local heap = require("vessel.heap")
local millisecond = require("time.millisecond")

local reusable = reusable.new()
---@class timer:unknown @定时管理器
local this = class(super)

---构造 
function this:ctor()
    ---单纯执行
    self._maxloops = 100
    ---轮询间隔
    ---@type number                 
    self._interval = 10
    ---清理处理
    self:clear()
end

---启动函数
function this:launch()
    ---启动定时器
    skynet.timeout(1, function()
        self:poling()
    end)
end

---清除数据
function this:clear()
    ---@type integer                @暂停时间
    self._pauset = nil
    ---最大堆
    self._heap = heap.new()
    ---定时器
    ---@type table<string,timeID> 
    self._names = {}
    ---定时器
    ---@type table<timeID,string>   
    self._idens = {}
end

---获取时间
function this:time()
    return millisecond()
end

---定时回调
---@param  elapse   MS          @流逝时间
---@param  count    count       @回调次数
---@param  obj      class       @回调对象
---@param  call     function    @回调函数
---@return timeID @定时ID
function this:append(elapse, count, call, ...)
    ---@type tagTimer @定时数据
    local item = reusable:get()
    item.elapse = elapse
    item.count = count
    item.call = call
    item.args = select("#", ...) > 0 and { ... } or nil
    local ulti = self:time() + elapse
    local head = self._heap
    return head:append(ulti, item)
end

---单次回调
---@param  elapse   MS          @流逝时间
---@param  call     function    @回调函数
---@return timeID @定时ID
function this:appendCall(elapse, call, ...)
    return self:append(elapse, 1, call, ...)
end

---无限回调
---@param  elapse   MS          @流逝时间
---@param  call     function    @回调函数
---@return timeID @定时ID
function this:appendEver(elapse, call, ...)
    return self:append(elapse, nil, call, ...)
end

---定时回调
---@param  name     name        @定时名字
---@param  elapse   MS          @流逝时间
---@param  count    count       @回调次数
---@param  obj      class       @回调对象
---@param  call     function    @回调函数
---@return timeID @定时ID
function this:appendBy(name, elapse, count, call, ...)
    local idens = self._idens
    local names = self._names
    local iden = names[name]
    local indx, node = self._heap:search(iden)
    
    if node then
        self._heap:delete(indx)
        idens[iden] = nil
    end
    
    iden = self:append(elapse, count, call, ...)
    names[name] = iden
    idens[iden] = name
end

---无限回调
---@param  name     name        @定时名字
---@param  elapse   MS          @流逝时间
---@param  call     function    @回调函数
---@return timeID @定时ID
function this:appendEverBy(name, elapse, call, ...)
    return self:appendBy(name, elapse, nil, call, ...)
end

---删除定时
---@param iden    timeID      @定时器ID
function this:remove(iden)
    local heap  = self._heap
    local list  = heap._list
    local idens = self._idens
    local names = self._names
    
    for index, node in ipairs(list) do
        if node.auto == iden then
            --删除数据
            heap:delete(index)
            reusable:set(node.data)
            --删除数据
            local name = idens[iden]
            
            if name then
                names[name] = nil
                idens[iden] = nil
            end

            break
        end
    end
end

---剩余时间
---@param iden timeID
function this:remaining(iden)
    local now = self._pauset or self:time()
    
    for _, item in ipairs(self._heap._list) do
        if item.auto == iden then
            return item.ticks - now
        end
    end

    return 0
end

---剩余时间
---@param name name @定时名字
function this:remainingBy(name)
    local names = self._names
    local iden = names[name]
    return self:remaining(iden)
end

---暂停定时
function this:pause()
    if not self._pauset then
        self._pauset = self:time()
    end
end

---暂停取消
function this:unpause()
    local pause = self._pauset
    
    if pause then
        self._pauset = nil
        local now = self:time()
        local dif = now - pause
        
        for _, item in ipairs(self._heap._list) do
            item.ticks = item.ticks + dif
        end
        
        --启动轮询
        self:poling()
    end
end

---定时轮询
function this:poling()
    ---暂停
    if self._pauset then
        return 
    end
    
    ---定时
    self:timeout()
    
    ---执行
    local count = 0
    repeat
        if self._maxloops then
            count = count + 1
            if count > self._maxloops then
                break
            end
        end
    until not self:execute()
end

---轮询器
function this:timeout()
    skynet.timeout(self._interval, function()
        self:poling()
    end)
end

---设置间隔
---@param interval number @间隔 
function this:interval(interval)
    self._interval = interval or self._interval
end

---最大循环(定时器太多)
---@param interval number @最大循环
function this:maxloops(maxloops)
    self._maxloops = maxloops
end

---检测器
---@param inow number @当前时间
---@param iend number @结束时间
function this:ifExpire(inow, iend)
    if inow < iend then
        return false
    end
    
    return true
end

---执行
---@return boolean
function this:execute()
    ---@type heap       @最大堆
    local heap = self._heap
    ---@type heapNode   @第一个
    local rede = heap:reder()
    
    if not rede then
        return false
    end
    
    ---@type MS         @时间
    local inow = self:time()
    local iend = rede.ticks
    
    ---到期检查
    if not self:ifExpire(inow, iend) then
        return false
    end
    
    ---@type tagTimer   @定时器
    local item = rede.data
    ---@type count      @多少次
    local count = item.count
    
    if count then
        ---扣除次数
        item.count = count - 1
    end
    
    if 0 == item.count then
        ---移除事件
        heap:fetch()
        ---回收数据
        reusable:set(item)
        
        --删除数据
        local names = self._names
        local idens = self._idens
        local iden = rede.auto
        local name = idens[iden]
        
        if name then
            names[name] = nil
            idens[iden] = nil
        end
    else
        ---下次触发
        rede.ticks = iend + item.elapse
        ---调整位置
        heap:adjustByFirst(rede)
    end
    
    ---每次只调用一个定时
    local args = item.args
    item.call(args and table.unpack(args) or nil)
    return true
end

return this

---@class tagTimer              @定时数据
---@field elapse    MS          @间隔时间
---@field count     count       @回调次数
---@field call      function    @回调函数
---@field args      any[]       @回调参数
