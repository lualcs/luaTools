local logPrint = require("logPrint")
return function(...)
    return logPrint("logDebug", ...)
end