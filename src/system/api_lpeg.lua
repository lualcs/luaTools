local lpeg = require("lpeg")
local class = require("class")
local super = require("unknown")



---@class api_lpeg:unknown @api_lpeg
local api_lpeg = class(super)
local this = api_lpeg

function this.B(...)
    return lpeg.B(...)
end

function this.C(...)
    return lpeg.C(...)
end

function this.Carg(...)
    return lpeg.Carg(...)
end

function this.type(...)
    return lpeg.type(...)
end

function this.setmaxstack(...)
    return lpeg.setmaxstack(...)
end

function this.version(...)
    return lpeg.version(...)
end

function this.V(...)
    return lpeg.V(...)
end

function this.locale(...)
    return lpeg.locale(...)
end

function this.pcode(...)
    return lpeg.pcode(...)
end

function this.S(...)
    return lpeg.S(...)
end

function this.R(...)
    return lpeg.R(...)
end

function this.Cp(...)
    return lpeg.Cp(...)
end

function this.Cg(...)
    return lpeg.Cg(...)
end

function this.match(...)
    return lpeg.match(...)
end

function this.Cc(...)
    return lpeg.Cc(...)
end

function this.Cf(...)
    return lpeg.Cf(...)
end

---P
---@param value string|number|boolean|table|function
function this.P(value)
    return lpeg.P(value)
end

function this.Cb(...)
    return lpeg.Cb(...)
end

function this.Cs(...)
    return lpeg.Cs(...)
end

function this.Ct(...)
    return lpeg.Ct(...)
end

function this.ptree(...)
    return lpeg.ptree(...)
end

function this.Cmt(...)
    return lpeg.Cmt(...)
end

return this
