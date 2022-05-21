package = "luatools"
version = "1.0.0-6"
source = {
   url = "git://github.com/lualcs/luaTools",
}
description = {
   summary = "An extra mocking layer for OpenResty in busted testing environment.",
   detailed = [[
      This module mocks the following OpenResty APIs:

   ]],
   homepage = "git://github.com/lualcs/luaTools",
   license = "MIT"
}
dependencies = {
   'lua >= 5.1',
}
build = {
   type = "builtin",
   modules = {
      ifBoolean = "src/method/type/ifBoolean.lua",
      ifExist = "src/method/type/ifExist.lua",
      ifFloat = "src/method/type/ifFloat.lua",
      ifFunction = "src/method/type/ifFunction.lua",
      ifInt = "src/method/type/ifInt.lua",
      ifNil = "src/method/type/ifNil.lua",
      ifNumber = "src/method/type/ifNumber.lua",
      ifPattern = "src/method/type/ifPattern.lua",
      ifSame = "src/method/type/ifSame.lua",
      ifString = "src/method/type/ifString.lua",
      ifTable = "src/method/type/ifTable.lua",
      ifThread = "src/method/type/ifThread.lua",
      ifTypes = "src/method/type/ifTypes.lua",
      ifUFloat = "src/method/type/ifUFloat.lua",
      ifUserData = "src/method/type/ifUserData.lua",
      ifWeek = "src/method/type/ifWeek.lua",
      ifKeyword = "src/method/type/ifKeyword.lua",
      ifLetter = "src/method/type/ifLetter.lua",
      tvoid = "src/method/tools/tvoid.lua",
      toguess = "src/method/tools/toguess.lua",
      class = "src/method/tools/class.lua",
      fauto = "src/method/tools/fauto.lua",
      peak = "src/method/tools/peak.lua",
      t2string = "src/method/tools/t2string.lua",
      fvoid = "src/method/tools/fvoid.lua",
      fvoid = "src/method/tools/fvoid.lua",
      enumerate = "src/custom/enumerate.lua",
      occupy = "src/custom/occupy.lua",
      power = "src/custom/power.lua",
      ranking = "src/custom/ranking.lua",
      reusable = "src/custom/reusable.lua",
      tigger = "src/custom/tigger.lua",
      logDebug = "src/logs/logDebug.lua",
      logError = "src/logs/logError.lua",
      logPrint = "src/logs/logPrint.lua",
      ["vessel.heap"] = "src/vessel/heap.lua",
      ["vessel.list"] = "src/vessel/list.lua",
      ["vessel.map"] = "src/vessel/map.lua",
      ["vessel.queue"] = "src/vessel/queue.lua",
      ["table.array"] = "src/method/table/array.lua",
      ["table.absorb"] = "src/method/table/absorb.lua",
      ["table.cheap"] = "src/method/table/cheap.lua",
      ["table.clear"] = "src/method/table/clear.lua",
      ["table.clean"] = "src/method/table/clean.lua",
      ["table.clone"] = "src/method/table/clone.lua",
      ["table.copy"] = "src/method/table/copy.lua",
      ["table.copyFilter"] = "src/method/table/copyFilter.lua",
      ["table.defaultZero"] = "src/method/table/defaultZero.lua",
      ["table.delete"] = "src/method/table/delete.lua",
      ["table.emptyDir"] = "src/method/table/emptyDir.lua",
      ["table.exist_list"] = "src/method/table/exist_list.lua",
      ["table.push_args"] = "src/method/table/push_args.lua",
      ["table.push_map"] = "src/method/table/push_map.lua",
      ["table.push"] = "src/method/table/push.lua",
      ["table.readonly"] = "src/method/table/readonly.lua",
      ["table.reciprocal"] = "src/method/table/reciprocal.lua",
      ["table.remove_args"] = "src/method/table/remove_args.lua",
      ["table.remove"] = "src/method/table/remove.lua",
      ["table.ventgas"] = "src/method/table/ventgas.lua",
      ["table.zero"] = "src/method/table/zero.lua",
      ["table.zeroSetting"] = "src/method/table/zeroSetting.lua",
      ["string.gsplit"] = "src/method/string/gsplit.lua",
      ["array.append"] = "src/method/array/append.lua",
      ["array.merge"] = "src/method/array/merge.lua",
      ["array.call"] = "src/method/array/call.lua",
      ["array.map"] = "src/method/array/map.lua",
      ["array.max"] = "src/method/array/max.lua",
      ["array.minmax"] = "src/method/array/minmax.lua",
      ["array.min"] = "src/method/array/min.lua",
      ["array.rand"] = "src/method/array/rand.lua",
      ["array.sum"] = "src/method/array/sum.lua",
      ["array.wgtSum"] = "src/method/array/wgtSum.lua",
      ["map.call"] = "src/method/map/call.lua",
      ["map.ckarray"] = "src/method/map/ckarray.lua",
      ["map.count"] = "src/method/map/count.lua",
      ["map.keys"] = "src/method/map/keys.lua",
      ["map.rand"] = "src/method/map/rand.lua",
      ["map.sum"] = "src/method/map/sum.lua",
      ["math.frexp"] = "src/method/math/frexp.lua",
      ["math.ldexp"] = "src/method/math/ldexp.lua",
      ["math.getCompound"] = "src/method/math/getCompound.lua",
      ["math.getDecimal"] = "src/method/math/getDecimal.lua",
      ["math.setDecimal"] = "src/method/math/setDecimal.lua",
      ["math.toDisplay"] = "src/method/math/toDisplay.lua",
      ["random.cache"] = "src/method/random/cache.lua",
      ["random.erase"] = "src/method/random/erase.lua",
      ["random.multi"] = "src/method/random/multi.lua",
      ["random.range"] = "src/method/random/range.lua",
      ["random.weight"] = "src/method/random/weight.lua",
      ["search.astart"] = "src/method/search/astart.lua",
      ["search.binary"] = "src/method/search/binary.lua",
      ["search.traverse"] = "src/method/search/traverse.lua",
      ["set.setToarr"] = "src/method/set/setToarr.lua",
      ["set.setTosum"] = "src/method/set/setTosum.lua",
      ["sort.bubble"] = "src/method/sort/bubble.lua",
      ["sort.bucket"] = "src/method/sort/bucket.lua",
      ["sort.count"] = "src/method/sort/count.lua",
      ["sort.hill"] = "src/method/sort/hill.lua",
      ["sort.insert"] = "src/method/sort/insert.lua",
      ["sort.merge"] = "src/method/sort/merge.lua",
      ["sort.quick"] = "src/method/sort/quick.lua",
      ["sort.reverse"] = "src/method/sort/reverse.lua",
      ["sort.select"] = "src/method/sort/select.lua",
      ["sort.shuffle"] = "src/method/sort/shuffle.lua",
      ["time.fmtDate"] = "src/method/time/fmtDate.lua",
      ["time.getDate"] = "src/method/time/getDate.lua",
      ["time.getDay"] = "src/method/time/getDay.lua",
      ["time.getDiffDay"] = "src/method/time/getDiffDay.lua",
      ["time.getDiffMonth"] = "src/method/time/getDiffMonth.lua",
      ["time.getDiffSec"] = "src/method/time/getDiffSec.lua",
      ["time.getDiffYear"] = "src/method/time/getDiffYear.lua",
      ["time.getHour"] = "src/method/time/getHour.lua",
      ["time.microsecond"] = "src/method/time/microsecond.lua",
      ["time.millisecond"] = "src/method/time/millisecond.lua",
      ["time.getMinute"] = "src/method/time/getMinute.lua",
      ["time.getMonth"] = "src/method/time/getMonth.lua",
      ["time.getSecond"] = "src/method/time/getSecond.lua",
      ["time.getWhatDay"] = "src/method/time/getWhatDay.lua",
      ["time.getYear"] = "src/method/time/getYear.lua",
      ["time.getYearDay"] = "src/method/time/getYearDay.lua",
      ["time.getZero"] = "src/method/time/getZero.lua",
      ["time.getZone"] = "src/method/time/getZone.lua",
      ["time.isTogetherDay"] = "src/method/time/isTogetherDay.lua",
      ["time.isTogetherHour"] = "src/method/time/isTogetherHour.lua",
      ["time.isTogetherMinute"] = "src/method/time/isTogetherMinute.lua",
      ["time.isTogetherMonth"] = "src/method/time/isTogetherMonth.lua",
      ["time.isTogetherYear"] = "src/method/time/isTogetherYear.lua",
      ["optimize.cache"] = "src/method/optimize/cache.lua",
      ["optimize.change"] = "src/method/optimize/change.lua",
      ["optimize.commit"] = "src/method/optimize/commit.lua",
      ["optimize.rollback"] = "src/method/optimize/rollback.lua",
      ["optimize.transaction"] = "src/method/optimize/transaction.lua",
      ["api_json"] = "src/system/api_json.lua",
      ["api_lfs"] = "src/system/api_lfs.lua",
      ["api_lpeg"] = "src/system/api_lpeg.lua",
      ["api_md5"] = "src/system/api_md5.lua",
      
   }
}