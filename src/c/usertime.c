
#include <stdio.h>
#include <sys/time.h>
#include <time.h>
#include "lua.h"
#include "lauxlib.h"

//微秒
static int microsecond(lua_State *L)
{
  struct timeval tv;
  gettimeofday(&tv, NULL);
  lua_pushnumber(L, tv.tv_sec * 1000000 + tv.tv_usec);
  return 1;
}

//毫秒
static int millisecond(lua_State *L)
{
  struct timeval tv;
  gettimeofday(&tv, NULL);
  lua_pushnumber(L, (tv.tv_sec * 1000000 + tv.tv_usec) / 1000);
  return 1;
}

int luaopen_usertime(lua_State *L)
{
  luaL_checkversion(L);

  luaL_Reg l[] = {
      {"millisecond", millisecond},
      {"microsecond", microsecond},
      {NULL, NULL},
  };

  luaL_newlib(L, l);
  return 1;
}