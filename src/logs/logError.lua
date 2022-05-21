local logPrint = require("logPrint")
return function(...)
    return logPrint("logError", ...)
end