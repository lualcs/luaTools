local class = require("class")
local luacom = require("luacom")

---@class api_luacom @如何使用luacom
local this = class()

function this.FillTypeLib()
end

function this.addConnection()
end

function this.Connect()
end

function this.GetCurrentDirectory()
end

function this.ExportConstants()
end

function this.UnRegisterObject()
end

function this.NewLibrary()
end

function this.ProgIDfromCLSID()
end

function this.RegisterObject()
end

function this.RevokeObject()
end

function this.NewObject()
end

function this.ExposeObject()
end

function this.DetectAutomation()
end

---创建返回一个代表指定com对象的lua对象
---@param keyname string @[ProgID-对象的可读字符串标识符|CLSID-对象的唯一标识符]
function this.CreateObject(keyname)
    return luacom.CreateObject(keyname)
end

function this.ViewTypeLib()
end

function this.CLSIDfromProgID()
end

function this.RoundTrip()
end

function this.NewControl()
end

function this.StartMessageLoop()
end

function this.FillTypeInfo()
end

function this._copyFields()
end

function this.DumpTypeInfo()
end

function this.GetIUnknown()
end

function this.GetType()
end

function this.LoadTypeLibrary()
end

function this.pairs()
end

function this.CreateInprocObject()
end

function this.ImplInterfaceFromTypelib()
end

function this.CreateLuaCOM()
end

function this.EndLog()
end

function this.releaseConnection()
end

function this.ShowHelp()
end

function this.ImplInterface()
end

function this.DumpTypeLib()
end

function this.GetObject()
end

function this.CreateLocalObject()
end

function this.ImportIUnknown()
end

function this.isMember()
end

function this.GetTypeInfo()
end

function this.StartLog()
end

function this.GetEnumerator()
end

return this
