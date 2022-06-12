#include "lua.h"
#include "lauxlib.h"

static inline int strcpy(char *buf, char *str, int len)
{
    for (size_t i = 0; i < len; i++)
    {
        buf[i] = str[i];
    }

    buf[len] = 0;
    return len;
}

//分解
static int utf8_unpack(lua_State *L)
{
    unsigned char *str = lua_tostring(L, 1);
    static char *cbs[7] = {0, 0, 0, 0, 0, 0, 0};
    int count = 0;
    while (*str)
    {
        if (*str >= 252)
            str += strcpy(cbs, str, 6);
        else if (*str >= 248)
            str += strcpy(cbs, str, 5);
        else if (*str >= 240)
            str += strcpy(cbs, str, 4);
        else if (*str >= 224)
            str += strcpy(cbs, str, 3);
        else if (*str >= 128)
            str += strcpy(cbs, str, 2);
        else
            str += strcpy(cbs, str, 1);

        lua_pushstring(L, (const char *)cbs);
        count++;
    }
    return count;
}

int luaopen_cutworks(lua_State *L)
{
    luaL_checkversion(L);

    luaL_Reg l[] = {
        {"utf8_unpack", utf8_unpack},
        {NULL, NULL},
    };

    luaL_newlib(L, l);
    return 1;
}