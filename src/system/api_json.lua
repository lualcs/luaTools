local cjson = require("cjson")

---@class api_json @json封装
local this = {}

---转json
---@param t any @任意表
---@return json
function this.encode(t)
    return cjson.encode(t)
end

---转table
---@param s json @json数据
---@return any @表格式
function this.decode(s)
    return cjson.decode(s)
end

return this
