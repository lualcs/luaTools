local lfs = require("lfs")

---@class api_lfs @luafilesystem
local this = {}

---目录迭代函数
---@param dir string @指定目录
---@return fun(t:table):fun(t:table,k:any|nil):k,v
function this.dir(dir)
    return lfs.dir(dir)
end

---锁定一个文件或者文件内容
function this.lock(...)
    return lfs.lock(...)
end

---解锁一个文件或者文件内容
function this.unlock(...)
    return lfs.unlock(...)
end

---创建一个目录
---@param dirname string @目录路径
function this.mkdir(dirname)
    if this.ifEmpty(dirname) then
        return lfs.mkdir(dirname)
    end
end

---移除一个目录
---@param dirname string @目录路径
function this.rmdir(dirname)
    return lfs.rmdir(dirname)
end

---获取当前目录
---@return string
function this.currentdir()
    return lfs.currentdir()
end

---设置文件的写入模式
---@param file string @文件
---@param mode string @模式 binary or text
function this.setmode(file, mode)
    return lfs.setmode(file, mode)
end

---文件属性
---@param path string @路径
---@return attributes
function this.attributes(path)
    ---@class attributes @文件属性
    ---@field dev               number @在Unix系统上，它表示inode所在的设备。在Windows系统上，表示包含该文件的磁盘的驱动器号
    ---@field change            number @最近一次文件状态修改时间
    ---@field access            number @最近一次访问时间
    ---@field redev             number @linux系统下rdev表示设备类型，Windows系统下和dev值相同
    ---@field nlink             number @文件上的硬链接数
    ---@field uid               number @目录的user-id(Unix only, always 0 on Windows)
    ---@field gid               number @用户的group-id(Unix only, always 0 on Windows)
    ---@field ino               number @Unix系统下表示inode数目，Windows系统下无意义
    ---@field mode              string @file、directory、link、socket、named pipe、char device、block device or other
    ---@field modification      number @最近一次修改时间
    ---@field size              number @文件大小(以字节为单位)
    return lfs.attributes(path)
end

---是否文件夹
---@param path string @路径
---@return boolean
function this.ifDirectory(path)
    return lfs.attributes(path).mode == "directory"
end

---是否存在
---@param path string @路径
---@return boolean
function this.ifEmpty(path)
    local file = io.open(path, "rb")
    if not file then
        return true
    end

    file:close()
end

---文件属性
---@param file string @文件位置
---@return symlinkattributes
function this.symlinkattributes(file)
    ---@class symlinkattributes:lfsAttributes @文件属性
    return lfs.attributes(file)
end

local filter = {
    ["."] = true,
    [".."] = true,
    ["./vscode"] = true
}

---递归查找文件
---@param dir string   @查找目录
---@param arr string[] @保存数组
---@param fix string   @文件后缀
---@param pat boolean  @不带路径
---@return string[]    @文件列表
function this.recursiveFiles(dir, arr, fix, pat)
    local mix = string.format("%s$", fix)
    for name, _ in this.dir(dir) do
        if not filter[name] then
            local attr = this.attributes(dir .. name)

            if attr.mode ~= "directory" then
                if name:match(mix) then
                    if not pat then
                        table.insert(arr, dir .. name)
                    else
                        table.insert(arr, name)
                    end
                end
            else
                this.recursiveFiles(dir .. name .. "/", arr, fix, pat)
            end
        end
    end

    return arr
end

return this
