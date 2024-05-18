local date = {}
local function s2datetime(s)
    if nil == s or false == s or "" == s then
        return 0
    end
    local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
    date.year, date.month, date.day, date.hour, date.min, date.sec = s:match(p)
    return os.time(date)
end
print(s2datetime(""))
