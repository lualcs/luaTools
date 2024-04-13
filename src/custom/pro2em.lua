local lfs = require("api_lfs")
local class = require("class")
local gsplit = require("string.gsplit")

local this = class()
---启动函数
function this:launch()
    local fix = ".proto"
    local nte = ".lua"
    local dir = "./proto/"
    --local dir = "C:/code/Server/support/Protobuf/proto/"
    local emm = "./design/emmy/"
    --local emm = "C:/code/Server/mmlua/"

    ---检查创建emmy目录
    lfs.mkdir(emm:sub(1, -2))

    ---遍历修改协议文件
    local files = lfs.recursiveFiles(dir, {}, fix)
    for _, fpatch in ipairs(files) do
        local note = self:parsing(fpatch)
        local plits = gsplit(fpatch, "/")
        local fname = plits[#plits]:sub(1, -7)
        local wpatch = fname .. "_proto" .. nte
        local wfile = io.open(emm .. wpatch, "w")
        wfile:write(note)
        wfile:close()
    end
end

---处理注释头
function this.noteHead(s)
    s = s:gsub("/+", function(match)
        if #match > 3 then
            return string.rep("-", #match)
        else
            return match
        end
    end)
    return s
end

---注解可能被分开了
function this.notepush(t, list, start)
    for i = start, #list do
        table.insert(t, list[i])
    end
end

local itf = function(match)
    return "<" .. match:gsub("%s", "") .. ">"
end

---比较找到位置
local function fsc(s, a, b)
    local ai = s:find(a)
    local bi = s:find(b)
    if not ai or not bi then
        return false
    end
    return ai < bi
end

---比较找到位置{左右括号再一起}
local function startclose(s)
    local ai = s:find("{")
    local bi = s:find("}")
    return ai and bi
end

---删除间隙
function this.delinterval(str)
    return str:gsub("<%s*(.-)%s*>", itf)
end

---文件解析
function this:parsing(fpatch)
    ---读取文件内容
    local f = io.open(fpatch)
    local s = f:read("*a")
    f:close()

    s = s:gsub("int8", "number")
    s = s:gsub("int16", "number")
    s = s:gsub("int32", "number")
    s = s:gsub("int64", "number")
    s = s:gsub("uint8", "number")
    s = s:gsub("uint16", "number")
    s = s:gsub("uint32", "number")
    s = s:gsub("uint64", "number")
    s = s:gsub("string", "string")
    s = s:gsub("bool", "boolean")

    local lines = gsplit(s, "\n")

    local t = {}
    local tt = {}
    local dep
    local bclass = false
    local benums = false
    local bStart = false
    local curmsgrow = ""
    local lenght = #lines
    local i = 1
    while i <= lenght do
        local row = lines[i]
        -- if i == 2122 then 
        --     print("error",row,lines[i-1],lines[i-2])
        -- end
        ---结构解析
        if row:find("syntax") then
        elseif row:match("^//") then
            local gs = row:gsub("/", "-")
            table.insert(t, gs)
            table.insert(t, "\n")
        elseif fsc(row, "//", "=") then
            ---跳过被注释的成员
        elseif not bStart and row:match("message") and (not row:find("=")) then
            ---自己这一层
            curmsgrow = row
            bclass = true
            if row:find("{") then
                bStart = true
            end

            table.insert(t, "---@class ")
            local list = gsplit(row, "%s")
            table.insert(t, list[2])
            table.insert(t, " @")
            table.insert(t, list[4])
            table.insert(t, "\n")
        elseif bStart and (row:find("message") or row:find("enum")) and (not row:find("=")) then
            print("嵌套two：", row)
            dep, i = this.NestingMsg(lines, i)
            for _, v in ipairs(dep) do
                table.insert(tt, v)
            end
        elseif row:find("{") and (not startclose(row)) then
            bStart = true
        elseif row:find("}") and (not startclose(row)) then
            table.insert(t, "\n")
            curmsgrow = ""
            bStart = false
            bclass = false
            benums = false
        elseif row:match("enum") and (not row:find("=")) then
            if row:find("{") then
                bStart = true
            end
            benums = true
            table.insert(t, "---@alias ")
            local list = gsplit(row, "%s")
            table.insert(t, list[2])
            table.insert(t, " number @")
            table.insert(t, list[4])
            table.insert(t, "\n")
        elseif (not bStart) and row:find("///") then
            table.insert(t, this.noteHead(row))
            table.insert(t, "\n")
        elseif bStart and benums and row:find("=") then
            local grow = row:gsub("//", "---")
            grow = grow:gsub(";", "")
            local list = gsplit(grow, "%s")
            table.insert(t, list[1])  ---名称
            table.insert(t, " ")
            table.insert(t, list[2])  ---等号
            table.insert(t, " ")
            table.insert(t, list[3])  ---数值
            table.insert(t, " ")
            self.notepush(t, list, 4) ---注解
            table.insert(t, "\n")
        elseif bStart and bclass and row:find("map<") then
            local grow = row:gsub("//", "@")
            grow = grow:gsub("%d+;", "")
            grow = grow:gsub("map<", "table<")
            grow = this.delinterval(grow)
            local list = gsplit(grow, "%s")
            table.insert(t, "---@field ")
            table.insert(t, list[2])  ---名称
            table.insert(t, " ")
            table.insert(t, list[1])  ---类型
            table.insert(t, " ")
            self.notepush(t, list, 4) ---注解
            table.insert(t, "\n")
        elseif bStart and bclass and row:find("repeated") then
            local grow = row:gsub("//", "@")
            grow = grow:gsub("%d+;", "")
            local list = gsplit(grow, "%s")
            table.insert(t, "---@field ")
            table.insert(t, list[3])  ---名称
            table.insert(t, " ")
            table.insert(t, list[2])  ---类型
            table.insert(t, "[]")     --数组
            table.insert(t, " ")
            self.notepush(t, list, 5) ---注解
            table.insert(t, "\n")
        elseif bStart and bclass and row:find("required") then
            local grow = row:gsub("//", "@")
            grow = grow:gsub("%d+;", "")
            local list = gsplit(grow, "%s")
            table.insert(t, "---@field ")
            table.insert(t, list[3])  ---名称
            table.insert(t, " ")
            table.insert(t, list[2])  ---类型
            table.insert(t, " ")
            self.notepush(t, list, 6) ---注解
            table.insert(t, "\n")
        elseif bStart and bclass and row:find("optional") then
            local grow = row:gsub("//", "@")
            grow = grow:gsub("%d+;", "")
            local list = gsplit(grow, "%s")
            table.insert(t, "---@field ")
            table.insert(t, list[3])  ---名称
            table.insert(t, " ")
            table.insert(t, list[2])  ---类型
            table.insert(t, " ")
            self.notepush(t, list, 6) ---注解
            table.insert(t, "\n")
        elseif bStart and bclass and row:find("=") then
            local grow = row:gsub("//", "@")
            grow = grow:gsub("%d+;", "") ---这里替换直接少一个
            local list = gsplit(grow, "%s")
            table.insert(t, "---@field ")
            table.insert(t, list[2])  ---名称
            table.insert(t, " ")
            table.insert(t, list[1])  ---类型
            table.insert(t, " ")
            self.notepush(t, list, 4) ---注解
            table.insert(t, "\n")
        else
            print("bStart,bclass,bename,row,i", bStart, bclass, benums, row, i)
        end

        if row:find("}") and row:find("=") and row:find(";") and (not startclose(row)) then
            table.insert(t, "\n")
            curmsgrow = ""
            bStart = false
            bclass = false
            benums = false
        end

        i = i + 1
    end

    ---嵌套放前面
    for _, v in ipairs(t) do
        table.insert(tt, v)
    end
    return table.concat(tt)
end

---嵌套处理
---@param lines string[] @行数据
---@param index number @当前索引
function this.NestingMsg(lines, index)
    local t = {}
    local tt = {}
    local dep
    local bclass = false
    local benums = false
    local bStart = false
    local curmsgrow = ""
    local lenght = #lines
    local i = index
    while i <= lenght do
        local row = lines[i]
        ---结构解析
        if fsc(row, "//", "=") then
            ---跳过被注释的成员
        elseif bStart and (row:find("message") or row:find("enum")) and bStart and (not row:find("=")) then
            print("嵌套dep：", row)

            dep, i = this.NestingMsg(lines, i)
            for _, v in ipairs(dep) do
                table.insert(tt, v)
            end
        elseif row:find("message") then
            if row:find("{") then
                bStart = true
            end
            curmsgrow = row
            bclass = true
            table.insert(t, "---@class ")
            local list = gsplit(row, "%s")
            table.insert(t, list[2])
            table.insert(t, " @")
            table.insert(t, list[4])
            table.insert(t, "\n")
        elseif row:find("enum") then
            if row:find("{") then
                bStart = true
            end
            benums = true
            table.insert(t, "---@alias ")
            local list = gsplit(row, "%s")
            table.insert(t, list[2])
            table.insert(t, " number @")
            table.insert(t, list[4])
            table.insert(t, "\n")
        elseif row:find("{") and (not startclose(row)) then
            bStart = true
        elseif row:find("}") and (not startclose(row)) then
            table.insert(t, "\n")
            curmsgrow = ""
            bStart = false
            bclass = false
            benums = false
            index = i
            break
        elseif (not bStart) and row:find("///") then
            ---分区注释保留
            table.insert(t, this.noteHead(row))
            table.insert(t, "\n")
        elseif bStart and bclass and row:find("map<") then
            ---map结构
            local grow = row:gsub("//", "@")
            grow = grow:gsub("%d+;", "")
            grow = grow:gsub("map<", "table<")
            grow = this.delinterval(grow)
            local list = gsplit(grow, "%s")
            table.insert(t, "---@field ")
            table.insert(t, list[2])  ---名称
            table.insert(t, " ")
            table.insert(t, list[1])  ---类型
            table.insert(t, " ")
            this.notepush(t, list, 4) ---注解
            table.insert(t, "\n")
        elseif bStart and bclass and row:find("repeated") then
            local grow = row:gsub("//", "@")
            grow = grow:gsub("%d+;", "")
            local list = gsplit(grow, "%s")
            table.insert(t, "---@field ")
            table.insert(t, list[3])  ---名称
            table.insert(t, " ")
            table.insert(t, list[2])  ---类型
            table.insert(t, "[]")     --数组
            table.insert(t, " ")
            this.notepush(t, list, 5) ---注解
            table.insert(t, "\n")
        elseif bStart and bclass and row:find("required") then
            local grow = row:gsub("//", "@")
            grow = grow:gsub("%d+;", "")
            local list = gsplit(grow, "%s")
            table.insert(t, "---@field ")
            table.insert(t, list[3])  ---名称
            table.insert(t, " ")
            table.insert(t, list[2])  ---类型
            table.insert(t, " ")
            this.notepush(t, list, 6) ---注解
            table.insert(t, "\n")
        elseif bStart and bclass and row:find("optional") then
            local grow = row:gsub("//", "@")
            grow = grow:gsub("%d+;", "")
            local list = gsplit(grow, "%s")
            table.insert(t, "---@field ")
            table.insert(t, list[3])  ---名称
            table.insert(t, " ")
            table.insert(t, list[2])  ---类型
            table.insert(t, " ")
            this.notepush(t, list, 6) ---注解
            table.insert(t, "\n")
        elseif bStart and bclass and row:find("=") then
            local grow = row:gsub("//", "@")
            grow = grow:gsub("%d+;", "") ---这里替换直接少一个
            local list = gsplit(grow, "%s")
            table.insert(t, "---@field ")
            table.insert(t, list[2])  ---名称
            table.insert(t, " ")
            table.insert(t, list[1])  ---类型
            table.insert(t, " ")
            this.notepush(t, list, 4) ---注解
            table.insert(t, "\n")
        elseif bStart and benums and row:find("=") then
            ---枚举处理
            local grow = row:gsub("//", "---")
            grow = grow:gsub(";", "")
            local list = gsplit(grow, "%s")
            table.insert(t, list[1])  ---名称
            table.insert(t, " ")
            table.insert(t, list[2])  ---等号
            table.insert(t, " ")
            table.insert(t, list[3])  ---数值
            table.insert(t, " ")
            this.notepush(t, list, 4) ---注解
            table.insert(t, "\n")
        else
            print("bStart,bclass,bename,row,i", bStart, bclass, benums, row, i)
        end

        if row:find("}") and row:find("=") and row:find(";") then
            if (not startclose(row)) then
                curmsgrow = ""
                bStart = false
                bclass = false
                benums = false
                index = i
                break
            end
        end

        i = i + 1
    end
    ---嵌套放前面
    for _, v in ipairs(t) do
        table.insert(tt, v)
    end
    return tt, index
end

return this
