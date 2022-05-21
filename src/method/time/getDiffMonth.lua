---间隔月
---@param aSec 	sec	@日期表
---@param bSec 	sec	@日期表
---@return integer
return function(aSec, bSec)
    if aSec > bSec then
        aSec, bSec = bSec, aSec
    end
    
    local aYear = os.date("%Y", aSec)
    local bYear = os.date("%Y", bSec)
    
    local aMonth = os.date("%M", aSec)
    local bMonth = os.date("%M", bSec)
    
    return (bYear - aYear) * 12 + (bMonth - aMonth)
end


