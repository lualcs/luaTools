local lfs = require("api_lfs")
local md5 = require("api_md5")
local gsplit = require("string.gsplit")
local t2string = require("t2string")
local t2stringEx = require("t2stringEx")
local excel = require("api_excel")
local clear = require("table.opt.clear")
local default = require("table.default.table")
local logDebug = require("logDebug")
local class = require("class")
local ifString = require("ifString")
local ifTable = require("ifTable")
local super = require("unknown")

local function s2number(s)
    if "nil" == s or nil == s or "" == s then
        return
    end
    return tonumber(s)
end

local function s2string(s)
    if "nil" == s or nil == s then
        return
    end
    return s
end

local function s2boolean(s)
    if true == s or false == s then
        return s
    elseif "nil" == s or nil == s or "" == s then
        return nil
    end
    local n = tonumber(s)
    return (0 ~= n) and true or false
end

local function s2usetype(s)
    if "server" == s then
        return "server"
    elseif "client" == s then
        return "client"
    end
    return "all" ---都需要
end

---lua任意数据类型
local function s2table(s)
    if not s or "" == s then
        return {}
    end

    local f = loadstring("return " .. s)
    if not f then
        if s:find("{") or s:find("}") then
            logDebug(s)
        else
            return s
        end
    end
    return f()
end

local date = {}
---日期转时间戳
local function s2datetime(s)
    if nil == s or false == s or "" == s then
        return 0
    end
    local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
    date.year, date.month, date.day, date.hour, date.min, date.sec = s:match(p)
    return os.time(date)
end

---日期字符串转秒数
local function s2spacer(s)
    if nil == s or false == s or "" == s then
        return 0
    end
    local p = "(%d+) (%d+):(%d+):(%d+)"
    local day, hour, min, sec = s:match(p)
    return day * 86400 + hour * 3600 + min * 60 + sec
end

---基础转换
local baseconver = {
    ["number"] = s2number,
    ["string"] = s2string,
    ["boolean"] = s2boolean,
    ["table"] = s2table,
    ["datetime"] = s2datetime,
    ["spacer"] = s2spacer,
}

---分割字符
local arrayplit = {
    ["number[]"] = ";",
    ["string[]"] = ";",
    ["boolean[]"] = ";",
    ["datetime[]"] = ";",
    ["spacer[]"] = ";",
}

---分割字符
local mapplit = {
    ["table<string,number>"] = ",",
    ["table<string,boolean>"] = ",",
    ["table<string,string>"] = ",",
    ["table<number,number>"] = ",",
    ["table<number,boolean>"] = ",",
    ["table<number,string>"] = ",",
    ["table<boolean,number>"] = ",",
    ["table<boolean,boolean>"] = ",",
    ["table<boolean,string>"] = ",",
}

local mapkfun = {
    ["table<string,number>"] = s2string,
    ["table<string,boolean>"] = s2string,
    ["table<string,string>"] = s2string,
    ["table<number,number>"] = s2number,
    ["table<number,boolean>"] = s2number,
    ["table<number,string>"] = s2number,
    ["table<boolean,number>"] = s2boolean,
    ["table<boolean,boolean>"] = s2boolean,
    ["table<boolean,string>"] = s2boolean,
}

local mapvfun = {
    ["table<string,number>"] = s2number,
    ["table<string,boolean>"] = s2boolean,
    ["table<string,string>"] = s2string,
    ["table<number,number>"] = s2number,
    ["table<number,boolean>"] = s2boolean,
    ["table<number,string>"] = s2string,
    ["table<boolean,number>"] = s2number,
    ["table<boolean,boolean>"] = s2boolean,
    ["table<boolean,string>"] = s2string,
}

---@class excel2luaconfig:unknown @excel转lua配置表
local this = class(super)

---@class ex2luaParam @ex2lua参数
---@field readDir string @excel目录
---@field writeDir string @lua写入目录
---@field md5fpath string @md5Cache路径
---@field structfpath string @lua_struct路径
---@field metablefpath string @lua_metable路径
---@field dirExcelfpath string @dir_excel路径
---@field rffix string @excel 文件后缀
---@field wffix string @lua 文件后缀
---@field fsort table<string,number> @文件序号
---@field fstruct string @结构文件名称
---@field fxstruct string @结构文件名称excel
---@field fglobal table<string,boolean> @全局文件名称
---@field isserver boolean @是否服务端
---@field line boolean @是否换行

---构造函数
---@param param ex2luaParam
function this:ctor(param)
    ---用于保存源数据内容
    self.isserver = param.isserver
    self.line = param.line and true or false
    ---目录
    self.readDir = param.readDir             --"./design/Excel/"
    self.writeDir = param.writeDir           --"./design/luacfg/"
    ---后缀
    self.rffix = param.rffix                 -- ".xlsx"
    self.wffix = param.wffix                 --".lua"
    ---变更
    self.md5fpath = param.md5fpath           --"./design/cache/md5Cache.lua"
    ---结构
    self.structfpath = param.structfpath     --"./design/cache/lua_struct.lua"
    ---索引
    self.metablefpath = param.metablefpath   --"./design/cache/lua_metable.lua"
    ---目录
    self.dirExcelfpath = param.dirExcelfpath --"./design/cache/dir_excel.lua"
    ---排序
    self.fsort = param.fsort
    ---缓存
    self.md5cache = {}
    ---注解
    self.semmys = {}
    ---结构
    self.fstruct = param.fstruct or "lua_struct"
    self.fxstruct = param.fxstruct or "struct"
    ---全局
    self.fglobal = param.fglobal or { cfg_global = true }
end

---是否过滤
---@param iuse string @字段类型
function this:isFilter(iuse)
    if self.isserver then
        if "client" == iuse then
            return true
        end
    else
        if "server" == iuse then
            return true
        end
    end
    return false
end

---加载MD5判断excel 是否变化
---@param fpath string @文件路径
---@return table
function this:loadLua(fpath)
    local f = io.open(fpath, "r")
    if not f then
        return {}
    end
    local s = f:read("*a")
    f:close()
    ---@diagnostic disable-next-line: spell
    return loadstring(s)()
end

---文件读取
---@param fpath string @
function this:readf(fpath)
    local f = io.open(fpath, "rb")
    if not f then
        return ""
    end
    local s = f:read("*a")
    f:close()
    return s
end

---保存文件
---@param fpath string @文件路径
---@param data table @配置标识
---@param emmy string|nil @注解
---@param line boolean|nil @是否换行
function this:writef(fpath, data, emmy, line)
    local f = io.open(fpath, "wb")
    if f then
        emmy = emmy or ""
        local sbegin = emmy .. "\n" .. "return "
        local note
        if line then
            note = t2string(data, sbegin, nil, self.rowSort)
        else
            note = t2stringEx(data, sbegin, nil, self.rowSort)
        end
        f:write(note)
        f:close()
    end
    print("write luaCfg:", fpath)
end

---保存文件
---@param fname string @文件名称
---@param data table @配置标识
---@param emmy string|nil @注解
---@param line boolean|nil @是否换行
function this:writeLuaCfg(fname, data, emmy)
    local fpath = self.writeDir .. fname .. self.wffix
    self:writef(fpath, data, emmy, line)
end

---生成md5码
---@param fpath any
function this:genericMD5(fpath)
    local s = self:readf(fpath)
    return md5.lower(s)
end

---启动函数
function this:launch()
    ---创建excel 对象
    self.excel = excel.new()
    ---获取MD5映射
    self.md5cache = self:loadLua(self.md5fpath)
    ---获取struct
    self.struct = self:loadLua(self.structfpath)
    ---获取sort
    self.metable = self:loadLua(self.metablefpath)
    ---获取目录
    local dir = self:loadLua(self.dirExcelfpath or {})
    self.dirExcel = default(dir)
    ---检查创建保存目录
    lfs.mkdir(self.writeDir:sub(1, -2))
    ---遍历配置表格文件
    local files = lfs.recursiveFiles(self.readDir, {}, self.rffix)
    table.sort(files, function(a, b)
        a = self.fsort[a] or 0
        b = self.fsort[b] or 0
        return a < b
    end)
    for _, fpatch in ipairs(files) do
        self:excelMd5(fpatch)
    end
    ---保存md5码
    self:writef(self.md5fpath, self.md5cache, "---@type table<string,string>", true)

    ---构建 struct head
    local semmys = self.semmys
    table.insert(semmys, "---@class struct @结构信息\n")
    table.insert(semmys, "---@field name string @字段名称\n")
    table.insert(semmys, "---@field type string @字段类型\n")
    table.insert(semmys, "---@field desc string @字段描述\n")
    table.insert(semmys, "---@field defv string|nil @默认值\n")
    table.insert(semmys, "\n")

    ---构建strucct field
    table.insert(semmys, "---@class lua_struct @结构信息\n")
    for name, _ in pairs(self.struct) do
        table.insert(semmys, "---@field ")
        table.insert(semmys, name)
        table.insert(semmys, " ")
        table.insert(semmys, "struct[] @结构信息")
        table.insert(semmys, "\n")
    end
    table.insert(semmys, "\n---@type lua_struct ")

    ---保存结构信息
    self:writef(self.structfpath, self.struct, table.concat(semmys), true)
    ---保存结构索引
    self:writef(self.metablefpath, self.metable, nil, true)
    ---保存目录结构
    self:writef(self.dirExcelfpath, self.dirExcel, nil, true)
end

---检查未解析文档
function this:excelMd5(fpatch)
    ---判断变更
    local md5cache = self.md5cache
    local md5 = self:genericMD5(fpatch)

    ---是否更新
    local list = gsplit(fpatch, "/")
    local fname = list[#list]:sub(1, -6)
    if md5cache[fname] == md5 then
        ---结构每次都生成
        if self.fxstruct ~= fname then
            return
        end
    end

    ---文件解析
    self:parsing(fpatch)

    ---记录更新
    md5cache[fname] = md5
end

---文件解析
---@param fpatch any
function this:parsing(fpatch)
    ---替换成绝对路径
    local cur = lfs.currentdir()
    fpatch = cur .. fpatch:sub(2, -1)
    fpatch = fpatch:gsub("\\", "/")
    local excel = self.excel
    excel:open(fpatch)

    local count = excel:sheetsCount()
    for i = 1, count do
        excel:sheets(i)
        local name = excel:sheetName()
        self:sheetPars(name)
        self.dirExcel[fpatch][name] = true
    end
    excel:close()
end

---工作簿解析
---@param name string @工作簿名称
function this:sheetPars(name)
    if name == self.fstruct then
        self:excelForRead(self.structPars, name)
    elseif self.fglobal[name] then
        self:excelForRead(self.gobalsPars, name)
    else
        self:excelForRead(self.configPars, name)
    end
end

---读取回调
---@param callback fun(data:string[][],name:string)
function this:excelForRead(callback, ...)
    local data = default({})
    local e = self.excel
    local rowMax = e:sheetRow()
    local colMax = e:sheetCol()
    for row = 1, rowMax do
        for col = 1, colMax do
            repeat
                local v = e:getGird(row, col)
                data[row][col] = v
            until true
        end
    end
    callback(self, data, ...)
end

local out0 = {}
local out1 = {}
local out2 = {}
---解析数据
---@param stype string @类型
---@param svalue string @配置值
function this:parseValue(stype, svalue, defv)
    local struct = self.struct
    ---基础类型
    local bf = baseconver[stype]
    if bf then
        local v = bf(svalue)
        if nil == v and defv then
            v = bf(defv)
        end
        return v
    end

    ---基础数组
    local as = arrayplit[stype]
    if as then
        bf = baseconver[stype:sub(1, -3)]
        local slist = gsplit(svalue, ";", clear(out1))
        local array = {}
        for i, s in ipairs(slist) do
            array[i] = bf(s)
        end
        return array
    end

    ---map类型
    local ms = mapplit[stype]
    if ms then
        local kf = mapkfun[stype]
        local vf = mapvfun[stype]
        local slist = gsplit(svalue, ",", clear(out1))
        local map = {}
        for _, s in ipairs(slist) do
            local kvs = gsplit(s, "=", clear(out2))
            local k = kf(kvs[1])
            local v = vf(kvs[2])
            map[k] = v
        end
        return map
    end

    ---单个复合结构
    local custom = rawget(struct, stype)
    if custom then
        local slist = gsplit(svalue, ";", clear(out1))
        local cdata = {}
        local vi = 0
        for i, inf in ipairs(custom) do
            local cof = baseconver[inf.type]
            if inf.defv then
                vi = vi + 1 ---增加一个偏移量
                cdata[inf.name] = cof(inf.defv)
            else
                local s = slist[i - vi]
                cdata[inf.name] = cof(s)
            end
        end
        return cdata
    end


    ---数组复合结构
    local csulistInf = rawget(struct, stype:sub(1, -3))
    if csulistInf then
        local cusArray = {}
        local islist = gsplit(svalue, "|", clear(out1))
        for j, is in ipairs(islist) do
            local jslist = gsplit(is, ";", clear(out2))
            local element = {}
            local vi = 0
            for i, kinf in ipairs(csulistInf) do
                local kcof = baseconver[kinf.type]
                if kinf.defv then
                    vi = vi + 1 ---增加一个偏移量
                    element[kinf.name] = kcof(kinf.defv)
                else
                    local s = jslist[i - vi]
                    element[kinf.name] = kcof(s)
                end
            end
            table.insert(cusArray, element)
        end
        return cusArray
    end
end

local out = {}
---解析结构配置
---@param data string[][]
---@param name string @sheetname
function this:structPars(data, name)
    ---@type table<string,string>
    local struct = default({})
    local ssrots = default({})
    local semmys = self.semmys
    for i, row in ipairs(data) do
        local cname = row[1]

        if nil ~= rawget(struct, cname) then
            logDebug({
                error = "this:structPars key repeat"
            })
        end

        ---生成对象名称注解
        local idesc = self.excel:getComment(i, 1)
        table.insert(semmys, "---@class ")
        table.insert(semmys, cname)
        table.insert(semmys, " @")
        table.insert(semmys, idesc and idesc:gsub("\n", " "))
        table.insert(semmys, "\n")

        for j, str in ipairs(row) do
            if 1 ~= j then
                local s = gsplit(str, ":", clear(out))
                local index = j - 1
                local jdesc = self.excel:getComment(i, j)

                struct[cname][index] = {
                    name = s[1],
                    type = s[2],
                    defv = s[3],
                    desc = jdesc and jdesc:gsub("\n", " ")
                }
                ssrots[cname][s[1]] = index

                ---生成field 注解
                table.insert(semmys, "---@field ")
                table.insert(semmys, s[1])
                table.insert(semmys, " ")
                table.insert(semmys, s[2])
                table.insert(semmys, " @")
                table.insert(semmys, jdesc and jdesc:gsub("\n", " "))
                table.insert(semmys, "\n")
            end
        end
        ---换行间隔不同结构
        table.insert(semmys, "\n")
    end

    ---添加读取出来的数据
    for k, v in pairs(self.struct or {}) do
        if not rawget(struct, k) then
            struct[k] = v
        end
    end

    self.semmys = semmys
    self.struct = struct
    self.metable = ssrots
end

---全局配置解析
---@param data string[][]
---@param name string @sheets名称
function this:gobalsPars(data, name)
    ---全局配置
    local cfg = {}
    self.gobalCfg = cfg
    ---全局注解
    local emmy = {}
    self.gobalEmm = emmy

    table.insert(emmy, "---@class ")
    table.insert(emmy, name)
    table.insert(emmy, " @全局配置\n")

    ---遍历表
    local rowSort = {}
    for row, info in ipairs(data) do
        local sdesc = info[1]
        local field = info[2]
        local stype = info[3]
        local svalue = info[4]
        if nil ~= rawget(cfg, field) then
            logDebug({
                error = "this:gobalsPars key repeat"
            })
        end
        cfg[field] = self:parseValue(stype, svalue)
        table.insert(rowSort, field)
        table.insert(emmy, "---@field ")
        table.insert(emmy, field)
        table.insert(emmy, " ")
        table.insert(emmy, stype)
        table.insert(emmy, " @")
        table.insert(emmy, sdesc)
        table.insert(emmy, "\n")
    end

    table.insert(emmy, "\n")
    table.insert(emmy, "---@type ")
    table.insert(emmy, name)
    ---保存解析文件
    self.rowSort = rowSort
    self:writeLuaCfg(name, cfg, table.concat(emmy), true)
    self.rowSort = nil
end

---解析常规配置
---@param data string[][]
---@param name string @sheets名称
function this:configPars(data, name)
    ---行顺序
    local rowSort = {}
    ---读取结构配置
    local struct = self.struct
    if not struct then
        struct = self:loadLua(self.structfpath)
        self.struct = struct
    end

    ---读取原表配置
    local metable = self.metable
    if not metable then
        metable = self:loadLua(self.metablefpath)
    end

    ---解析文件内容[描述-字段-类型-数据...]
    local descrs = data[1]
    local fields = data[2]
    local typels = data[3]

    ---添加类型数据
    local cfgClass = {}
    local cfgSorts = {}
    for index, name in ipairs(fields) do
        local iuse = self.excel:getComment(2, index)
        local stype = typels[index]
        local tpls = gsplit(tostring(stype), ":", out0)
        table.insert(cfgClass, {
            name = name,
            type = tpls[1],
            desc = descrs[index],
            iuse = s2usetype(iuse),
            defv = tpls[2],
        })
        cfgSorts[name] = index
    end
    struct[name] = cfgClass
    metable[name] = cfgSorts

    ---解析数据
    local cfg = {}
    for row, info in pairs(data) do
        repeat
            ---排除前3行数据
            if row <= 3 then
                break
            end
            ---解析当前行数据
            local rowData = self:rowPars(cfgClass, info)
            if not rowData then
                break
            end
            local key = info[1]
            if nil ~= rawget(cfg, key) then
                logDebug({
                    error = "this:configPars key repeat",
                })
            end

            if nil == key then
                logDebug({
                    error = "this:configPars key is nil",
                    name = name,
                    info = info,
                })
            end

            table.insert(rowSort, key)
            cfg[key] = rowData
        until true
    end


    ---有可能没有内容
    local aInfo = cfgClass[1]
    if aInfo and aInfo.name == "nil" then ---kv类型
        ---生成emmylua注解
        local emmy = {
        }

        local bInfo = cfgClass[2]
        table.insert(emmy, "---@type ")
        table.insert(emmy, "table<")
        table.insert(emmy, aInfo.type)
        table.insert(emmy, ",")
        if bInfo then
            table.insert(emmy, bInfo.type)
        else
            table.insert(emmy, "boolean")
        end
        table.insert(emmy, ">")
        ---保存解析文件
        self:writeLuaCfg(name, cfg, table.concat(emmy), self.line)
    elseif next(cfgClass) then ---常规类型
        ---生成emmylua注解
        local emmy = {
            "---@class ",
            name,
            "\n",
        }

        for index, info in ipairs(cfgClass) do
            if not self:isFilter(info.iuse) then
                table.insert(emmy, "---@field ")
                table.insert(emmy, info.name)
                table.insert(emmy, " ")
                ---普通类型
                local stype = info.type
                if stype:find("|") then
                    local slist = gsplit(stype, "|")
                    table.insert(emmy, slist[1])
                else
                    table.insert(emmy, info.type)
                end
                table.insert(emmy, " @")
                table.insert(emmy, descrs[index])
                table.insert(emmy, "\n")
            end
        end
        table.insert(emmy, "\n")
        local first = cfgClass[1]
        table.insert(emmy, "---@type ")
        table.insert(emmy, "table<")
        table.insert(emmy, first.type)
        table.insert(emmy, ",")
        table.insert(emmy, name)
        table.insert(emmy, ">")
        ---保存解析文件
        self.rowSort = rowSort
        self:writeLuaCfg(name, cfg, table.concat(emmy), self.line)
        self.rowSort = nil
    end
end

---解析行数据
---@param info any
function this:rowPars(cfgClass, rowData)
    ---第一行出现#标识注释
    local rowFirst = rowData[1]
    if ifString(rowFirst) and rowFirst:find("#") then
        return
    end

    local struct = self.struct
    ---解析结构数据
    local data = {}
    local mmap = {}
    for index, colInfo in ipairs(cfgClass) do
        ---有可能没有填
        local svalue = rowData[index]
        ---跳过合并类型
        local stype = colInfo.type
        if stype:find("|") then
            mmap[colInfo.name] = colInfo
        elseif (nil == svalue) and (stype ~= "table") and (nil == colInfo.defv) then
            ---过滤空值-或者默认表
        elseif self:isFilter(colInfo.iuse) then
            ---跳过过滤
        else
            local sname = colInfo.name
            local cvalue = self:parseValue(stype, svalue, colInfo.defv)
            data[sname] = cvalue
        end
    end

    ---处理合并字段
    for nmerge, info in pairs(mmap) do
        ---此列为过滤
        if self:isFilter(info.iuse) then
            break
        end
        local slist = gsplit(info.type, "|")
        local merge = {}
        for index, field in ipairs(slist) do
            repeat
                ---第一个代表合并字段数据类型
                if 1 == index then
                    break
                end

                ---内容为nil
                local infos = data[field]
                if not infos then
                    break
                end

                ---合并处理
                data[field] = nil
                for _, info in ipairs(infos) do
                    table.insert(merge, info)
                end
            until true
        end
        data[nmerge] = merge
    end

    ---默认只有1个字段为set or map 类型
    local len = #cfgClass
    local kField = cfgClass[1].name
    if (len <= 2) or ("nil" == kField) then
        if "nil" == kField then
            local vField = cfgClass[2] and cfgClass[2].name
            return data[vField] or true
        end
    end
    return data
end

return this
