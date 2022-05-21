
---间隔多少年
---@param aSec 	sec	@日期表
---@param bSec 	sec	@日期表
---@return integer
return function(aSec, bSec)
    return math.abs(os.date("%Y", aSec) - os.date("%Y", bSec))
end


