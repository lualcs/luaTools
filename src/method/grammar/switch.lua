local ifFunction = require("ifFunction")
return function(expression, body, ...)
    local code = body[expression]
    if not code then
        local def = body.default
        if def then
            return def(...)
        end
    else
        repeat
            if ifFunction(code) then
                return code(...)
            else
                code = body[code]
            end
        until not code
    end
end
