local class = require("class")
local lfs = require("api_lfs")
local super = require("unknown")
local gsplit = require("string.gsplit")
---@class pbcComment:unknown @pbc解析注解
local this = class(super)

---启动函数
function this:launch()
    local fix = ".proto"
    local nte = ".lua"
    local dir = "./game_protobuff/"
    local emm = "./game_protobuff/emmy/"
    local files = lfs.recursiveFiles(dir, {}, fix)
    for i, fpatch in ipairs(files) do
        local file = io.open(fpatch, "r")
        local read = file:read("*a")
        local note = self:parsing(read)
        file:close()

        local plits = gsplit(fpatch, "/")
        local wpatch = plits[#plits]:sub(1, -7) .. nte
        local wfile = io.open(emm .. wpatch, "w")
        wfile:write(note)
        wfile:close()
    end
end

---解析文件
---@param read string @probuf 原文
---@return string
function this:parsing(read)
    read = read:gsub("message", "---@class")
    read = read:gsub("%d+;", ";")
    read = read:gsub("=", " ")
    read = read:gsub(";//", "@")
    read = read:gsub(";", "@请写注释")
    read = read:gsub("//", "@")
    read = read:gsub("{", "")
    read = read:gsub("}", "")
    read = read:gsub("    required", "---@field")
    read = read:gsub("    repeated", "---@field []")
    read = read:gsub("    optional", "---@field")
    read = read:gsub("int32", "number")
    read = read:gsub("int64", "number")
    read = read:gsub("string", "string")
    read = read:gsub("bool", "boolean")

    local lines = gsplit(read, "\n")
    local link = { nil, " ", nil, " ", nil, " ", nil, "\n" }
    for i, row in ipairs(lines) do
        if row:find("field") then
            local fmts = gsplit(row, "%s")
            if "[]" == fmts[2] then
                fmts[2], fmts[3] = fmts[4], fmts[3] .. fmts[2]
                table.remove(fmts, 4)
            else
                fmts[2], fmts[3] = fmts[3], fmts[2]
            end

            link[1] = fmts[1]
            link[3] = fmts[2]
            link[5] = fmts[3]
            link[7] = fmts[4]
            lines[i] = table.concat(link)
        elseif row:find("syntax") then
            lines[i] = ""
        else
            if row:sub(5, 9) == "class" then
                if i > 1 then
                    local iup = i - 1
                    local cmd = lines[iup]
                    if cmd:sub(1, 1) == "@" then
                        lines[iup] = "\n"
                        lines[i] = lines[i] .. cmd
                    else
                        lines[i] = "\n" .. row .. "\n"
                    end
                else
                    lines[i] = row .. "\n"
                end
            elseif row:find("import") then
                lines[i] = ""
            else
                lines[i] = row .. "\n"
            end
        end
    end

    table.insert(lines, "\n")
    return table.concat(lines)
end

return this
