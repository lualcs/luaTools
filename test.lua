print(package.path)

local transaction = require("optimize.transaction")
local commit = require("optimize.commit")
local rollback = require("optimize.rollback")
local change = require("optimize.change")
local logDebug = require("logDebug")

local ori = {
    lv = 10,
    exp = 0,
    gold = 1000
}

local tran = transaction(ori, 0)


tran.lv = 101
tran.exp = 10
tran.gold = 11000

local cmt = commit()

logDebug(cmt)

local msg = change(cmt, ori, {}, "role")

logDebug(msg)
