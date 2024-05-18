local logDebug = require("logDebug")
local gsplit = require("string.gsplit")


logDebug(gsplit("number:0", ":", {}))
logDebug(gsplit("number", ":", {}))
