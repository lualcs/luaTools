
#include "lua.h"
#include "lauxlib.h"

#define PVALUE(v) (v % 16)                  // 计算得出牌值
#define PMERGE(c, v) (c * 16 + v)           // 合并花色牌之
#define ASIZE(s) (sizeof(s) / sizeof(s[0])) // 获取数组容量

// 数组拷贝
#define ACOPY(a, b, n)          \
    for (int i = 0; i < n; i++) \
    {                           \
        a[i] = b[i];            \
    }

// 数组设置
#define MSETS(s, v)                     \
    for (int i = 0; i < sizeof(s); i++) \
    {                                   \
        ((int8_t *)(&s))[i] = v;        \
    }

// 数组查找
#define AFIND(s, v, n, pos)     \
    for (int i = 0; i < n; i++) \
    {                           \
        if (v == s[i])          \
        {                       \
            pos = i;            \
            break;              \
        }                       \
    }

// 数组查找
#define AMOVE(s, pos, len)              \
    for (int i = pos; i < len - 1; i++) \
    {                                   \
        s[i] = s[i + 1];                \
    }

// 数组初始
#define MZERO(s) MSETS(s, 0)

typedef struct ctacits
{
    int8_t count[9];     // 1~9 组合数量
    int8_t cards[16][3]; // 成朴映射16=7顺子+9刻子
    int8_t place[9][4];  // 成扑映射对于位置索引
} ctacits;

// 牌库不重复
typedef struct cpokers
{
    int8_t cnt;          // 牌数量(不重复)
    int8_t pokers[0x49]; // 麻将库(不重复)
} cpokers;

typedef struct claizis
{
    int8_t cnt;          // 癞子数量
    int8_t pokers[0x49]; // 癞子映射{[v]=c}
    int8_t laizis[0x49]; // 癞子牌库(不重复){v1,...}
} claizis;

// 手牌结构
typedef struct chandle
{
    int8_t idx;          // 手牌数量(不重复)
    int8_t cnt;          // 手牌数量
    int8_t lzp;          // 癞子牌数量
    int8_t pokers[0x49]; // 所有牌映射[牌]=数量
    int8_t handle[0x11]; // 手牌数据(不重复)
} chandle;

typedef struct cpairs
{
    int8_t count;
    int8_t place[16]; //
    int8_t cards[10]; // 1~9值-数量 [0]=数量
} cpairs;

typedef struct cpairsls
{
    cpairs cpairs[4]; // 4种花色解析信息
} cpairsls;

// 玩家玩法数据
typedef struct cmahjong
{
    int64_t gameId; // 游戏标识
    cpokers cpoker; // 麻将牌库
    claizis laizis; // 癞子牌库
    claizis jiangs; // 将牌牌库
    cpokers sortls; // 出场牌库
    ctacits ctacit;
} cmahjong;

// 添加牌库(不重复)
static void cpokers_push(cpokers *ptr, int8_t v)
{
    ptr->pokers[ptr->cnt++] = v;
}

// 添加牌库(全部牌)
static void cpokers_save(cpokers *ptr, int8_t v, int8_t i)
{
    ptr->cnt++;
    ptr->pokers[v] = i;
}

// 添加癞子(不重复)
// arg1:this arg2:牌值
static void claizis_push(claizis *ptr, int8_t v)
{
    // 重复判断
    if (!ptr->pokers[v])
    {
        ptr->laizis[ptr->cnt] = v;
        ptr->cnt++;
        ptr->pokers[v] = ptr->cnt;
    }
}

// 删除癞子
static void claizis_dele(claizis *ptr, int8_t v)
{
    int8_t pos = ptr->pokers[v];
    if (pos)
    {
        ptr->cnt--;
        ptr->pokers[v] = 0;
        int8_t len = ptr->laizis[ptr->cnt];
        ptr->laizis[pos] = len;
        ptr->pokers[len] = pos;
    }
}

// 是否癞子
static int claizis_find(claizis *ptr, int8_t v)
{
    return ptr->pokers[v];
}

// 添加手牌arg1:this arg2:手牌 arg3:牌值 arg4:数量
static void chandle_push(cmahjong *pmahjong, chandle *ptr, int8_t v, int8_t c)
{
    if (!c)
    {
        return;
    }

    // 统计癞子牌
    if (claizis_find(&pmahjong->laizis, v))
    {
        ptr->lzp += c;
    }
    else
    {
        // 唯一手牌统计
        if (!ptr->pokers[v])
        {
            ptr->handle[ptr->idx++] = v;
        }
        // 统计手牌数量
        for (int8_t i = 0; i < c; i++)
        {
            ptr->pokers[v]++;
        }
    }
    //
    ptr->cnt += c;
}

// 删除手牌
// arg1:this arg2:手牌 arg3:牌值 arg4:数量
static void chandle_dele(cmahjong *pmahjong, chandle *ptr, int8_t v, int8_t c)
{
    if (!c)
    {
        return;
    }
    // 删除癞子牌
    if (claizis_find(&pmahjong->laizis, v))
    {
        ptr->lzp -= c; // 减少癞子数量
    }
    else
    {
        ptr->cnt -= c;       // 减少手牌数量
        ptr->pokers[v] -= c; // 减少手牌统计

        // 如果这个麻将没有了-就移除
        if (!ptr->pokers[v])
        {
            // 移除数组
            int8_t pos;
            AFIND(ptr->handle, v, ptr->idx, pos);
            AMOVE(ptr->handle, pos, ptr->idx);
            ptr->idx--;
        }
    }
}

// 手牌查找
static int chandle_find(chandle *ptr, int8_t v)
{
    return ptr->pokers[v];
}

// 递归匹配
// arg1:递归 arg2:this arg3:xxx arg4:癞子数量
static int matchWinnCard(int8_t sort, cmahjong *pmahjong, cpairs *pairs, int8_t lzp)
{
    int8_t ori = lzp; // 癞子数量
    int8_t cnt = ASIZE(pairs->cards);
    int8_t lef = 0;
    for (int8_t i = 1; i < cnt; i++)
    {
        int8_t cur = pairs->cards[i];
        if (cur < 0)
        {
            lzp += cur;
        }
        else
        {
            lef += cur;
        }
    }

    if (0 == lef)
    {
        return 1;
    }

    cnt = ASIZE(pmahjong->ctacit.cards);
    for (int8_t i = 0; i < pairs->count; i++)
    {
        int8_t pos = pairs->place[i];
        int8_t *pDeles = pmahjong->ctacit.cards[pos];

        int8_t need = 0;
        for (int8_t j = 0; j < 3; j++)
        {
            int8_t value = pDeles[j];
            pairs->cards[value]--;
            int8_t count = pairs->cards[value];
            if (count < 0)
            {
                need += count;
            }
        }

        if (need >= lzp)
        {
            if (matchWinnCard(sort, pmahjong, pairs, ori))
            {
                return 1;
            }
        }

        for (int8_t j = 0; j < 3; j++)
        {
            int8_t value = pDeles[j];
            pairs->cards[value]++;
        }
    }

    return 0;
}

// 解析是否可以胡牌
static int pairsWinnCard(cmahjong *pmahjong, chandle *phandle)
{
    // 癞子牌
    int8_t lzp = phandle->lzp;
    // 解析数组
    cpairsls cpairsls;
    MZERO(cpairsls);

    // 麻将分组
    int8_t map[4][16];
    MZERO(map);

    // 遍历手牌(手牌分类)
    for (int8_t i = 0; i < phandle->idx; i++)
    {
        // 手牌
        int8_t card = phandle->handle[i];
        // 花色
        int8_t sort = pmahjong->sortls.pokers[card];
        // 数量
        int8_t cnts = chandle_find(phandle, card);

        // 没有花色(东南西北中花牌)
        if (!sort)
        {
            // 将牌扣除
            if (cnts < 0)
            {
                // 扣除癞子
                lzp += cnts;
            }
            else
            {
                // 刻子扣癞子
                lzp -= (3 - (cnts % 3));
            }
        }
        else
        {
            // 统计花色牌 万条筒
            int8_t value = PVALUE(card);
            int8_t itype = sort - 1;
            cpairs *pPairs = &cpairsls.cpairs[itype];
            pPairs[itype].cards[value] += cnts;
            pPairs[itype].cards[0] += cnts;
        }

        //预估癞子用完-必定胡不了
        if (lzp < 0)
        {
            return 0;
        }
    }

    ctacits *pTacits = &pmahjong->ctacit;
    for (int8_t i = 0; i < 4; i++)
    {
        cpairs *pPairs = &cpairsls.cpairs[i];
        int8_t hash[16] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
        for (int8_t v = 1; v <= 9; v++)
        {
            if (!pPairs->cards[v])
            {
                continue;
            }

            int8_t idx = v - 1;
            for (int8_t c = 0; c < pTacits->count[idx]; c++)
            {
                int8_t pos = pTacits->place[idx][c];

                int8_t *parr = pTacits->cards[pos];

                int8_t sets[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
                for (int8_t j = 0; j < 3; j++)
                {
                    int8_t value = parr[j];
                    sets[value]++;
                }

                int8_t ok = 1;

                for (int8_t j = 0; j < 3; j++)
                {
                    int8_t value = parr[j];
                    if (sets[value] > pPairs->cards[value] + lzp)
                    {
                        ok = 0;
                        break;
                    }
                }

                if (ok)
                {
                    if (!hash[pos])
                    {
                        pPairs->place[pPairs->count++] = pos;
                        hash[pos] = 1;
                    }
                }
            }
        }
    }

    for (int8_t i = 0; i < ASIZE(cpairsls.cpairs); i++)
    {

        cpairs *pPairs = &cpairsls.cpairs[i];
        if (pPairs->cards[0] > 0)
        {
            if (pPairs->count <= 0)
            {
                return 0;
            }
            else
            {
                if (!matchWinnCard(i + 1, pmahjong, pPairs, lzp))
                {
                    return 0;
                }
            }
        }
    }
    return 1;
}

// 判断是否胡牌
static int setoutWinnCard(cmahjong *pmahjong, chandle *phandle)
{
    int8_t uniq = phandle->idx;
    int8_t outs[0x11];
    ACOPY(outs, phandle->handle, uniq);

    for (int8_t i = 0; i < uniq; i++)
    {
        int8_t card = outs[i];

        if (pmahjong->jiangs.cnt && !pmahjong->jiangs.pokers[card])
        {
            continue;
        }
        // 判断并且取出将牌
        if (2 <= (chandle_find(phandle, card) + phandle->lzp))
        {
            chandle_dele(pmahjong, phandle, card, 2);
            int8_t ok = pairsWinnCard(pmahjong, phandle);
            chandle_push(pmahjong, phandle, card, 2);
            if (ok)
            {
                return 1;
            }
        }
    }

    return 0;
}

// 构造算法 arg1所有牌库 arg2癞子牌库 arg3将对牌库
static int new(lua_State *L)
{
    int8_t top = lua_gettop(L);

    cmahjong *pmahjong = (cmahjong *)lua_newuserdata(L, sizeof(cmahjong));
    MZERO(*pmahjong);

    luaL_getmetatable(L, "mahjong");
    lua_setmetatable(L, -2);

    // 添加牌库
    cpokers *pcpoker = &pmahjong->cpoker;
    lua_pushnil(L);
    while (lua_next(L, 1))
    {
        cpokers_push(pcpoker, lua_tointeger(L, -2));
        lua_pop(L, 1);
    }

    // 添加癞子
    claizis *laizis = &pmahjong->laizis;
    lua_pushnil(L);
    while (lua_next(L, 2))
    {
        claizis_push(laizis, lua_tointeger(L, -2));
        lua_pop(L, 1);
    }

    // 添加将牌
    claizis *jiangs = &pmahjong->jiangs;
    lua_pushnil(L);
    while (lua_next(L, 3))
    {
        claizis_push(jiangs, lua_tointeger(L, -2));
        lua_pop(L, 1);
    }

    // 花色信息(所有牌)
    int8_t iclass = 0;
    cpokers *psortls = &pmahjong->sortls;
    lua_pushnil(L);
    while (lua_next(L, 4))
    {
        lua_getfield(L, -1, "color");
        int8_t color = lua_tointeger(L, -1);
        lua_getfield(L, -2, "start");
        int8_t start = lua_tointeger(L, -1);
        lua_getfield(L, -3, "close");
        int8_t close = lua_tointeger(L, -1);

        iclass++;
        for (int8_t i = start; i <= close; i++)
        {
            int8_t card = PMERGE(color, i);
            cpokers_save(psortls, card, iclass);
        }
        lua_pop(L, 4);
    }

    // 成扑信息
    ctacits *pctacit = &pmahjong->ctacit;
    // 遍历arr
    lua_getfield(L, 5, "arr");
    // 获取长度
    lua_len(L, -1);
    int8_t cnt = lua_tointeger(L, -1);
    lua_pop(L, 1);
    // 开始遍历
    for (int8_t i = 0; i < cnt; i++)
    {
        // 子数组压入堆栈
        lua_rawgeti(L, -1, i + 1);
        // 开始遍历
        lua_pushnil(L);
        int8_t j = 0;
        // 压入kv
        while (lua_next(L, -2))
        {
            // 获取kv
            int8_t card = lua_tointeger(L, -2);
            int8_t cnts = lua_tointeger(L, -1);
            // 重复添加
            for (int8_t k = 0; k < cnts; k++)
            {
                pctacit->cards[i][j++] = card;
            }
            // 弹出kv
            lua_pop(L, 1);
        }
        // 弹出数组
        lua_pop(L, 1);
    }
    // 弹出arr
    lua_pop(L, 1);

    // 遍历pos
    lua_getfield(L, 5, "pos");
    // 获取长度
    lua_len(L, -1);
    cnt = lua_tointeger(L, -1);
    // 弹出长度
    lua_pop(L, 1);
    for (int8_t i = 0; i < cnt; i++)
    {
        // 获取子数组
        lua_rawgeti(L, -1, i + 1);
        // 获取子长度
        lua_len(L, -1);
        pctacit->count[i] = lua_tointeger(L, -1);
        // 开始遍历
        lua_pop(L, 1);
        for (size_t j = 0; j < pctacit->count[i]; j++)
        {
            lua_rawgeti(L, -1, j + 1);
            // 记录索引
            pctacit->place[i][j] = lua_tointeger(L, -1);
            // c是0所以减一
            pctacit->place[i][j]--;
            // 弹出kv
            lua_pop(L, 1);
        }
        // 弹出子数组
        lua_pop(L, 1);
    }
    // 弹出pos
    lua_pop(L, 1);
    // 游戏标识
    pmahjong->gameId = lua_tointeger(L, 6);

    return lua_gettop(L) - top;
}

// 胡牌判断
static int canWinnCard(lua_State *L)
{
    int8_t top = lua_gettop(L);
    cmahjong *pmahjong = lua_touserdata(L, 1);
    // 手牌处理
    chandle handles;
    MZERO(handles);

    // 添加手牌信息
    lua_pushnil(L);
    while (lua_next(L, 2))
    {
        int8_t card = lua_tointeger(L, -2); // 牌值
        int8_t cnts = lua_tointeger(L, -1); // 数量
        chandle_push(pmahjong, &handles, card, cnts);
        lua_pop(L, 1);
    }

    // 返回判断清空
    lua_pushboolean(L, setoutWinnCard(pmahjong, &handles));
    return lua_gettop(L) - top;
}

// 听牌判断
static int tinWinnCard(lua_State *L)
{
}

// 清空癞子
static int clrSupportLaizis(lua_State *L)
{
    int8_t top = lua_gettop(L);
    cmahjong *pmahjong = lua_touserdata(L, 1);
    MZERO(pmahjong->laizis);
    return lua_gettop(L) - top;
}

// 添加癞子
static int addSupportLaizis(lua_State *L)
{
    int8_t top = lua_gettop(L);
    cmahjong *pmahjong = lua_touserdata(L, 1);
    int8_t val = lua_tointeger(L, 2);
    claizis_push(&pmahjong->laizis, val);
    return lua_gettop(L) - top;
}

// 删除癞子
static int delSupportLaizis(lua_State *L)
{
    int8_t top = lua_gettop(L);
    cmahjong *pmahjong = lua_touserdata(L, 1);
    int8_t val = lua_tointeger(L, 2);
    claizis_dele(&pmahjong->laizis, val);
    return lua_gettop(L) - top;
}

// 清空将牌
static int clrSupportJiangs(lua_State *L)
{
    int8_t top = lua_gettop(L);
    cmahjong *pmahjong = lua_touserdata(L, 1);
    MZERO(pmahjong->jiangs);
    return lua_gettop(L) - top;
}

// 增加将牌
static int addSupportJiangs(lua_State *L)
{
    int8_t top = lua_gettop(L);
    cmahjong *pmahjong = lua_touserdata(L, 1);
    int8_t val = lua_tointeger(L, 2);
    claizis_push(&pmahjong->jiangs, val);
    return lua_gettop(L) - top;
}

// 删除将牌(val:number)
static int delSupportJiangs(lua_State *L)
{
    int8_t top = lua_gettop(L);
    cmahjong *pmahjong = lua_touserdata(L, 1);
    int8_t val = lua_tointeger(L, 2);
    claizis_dele(&pmahjong->jiangs, val);
    return lua_gettop(L) - top;
}

int luaopen_cmahjong(lua_State *L)
{
    luaL_checkversion(L);

    int8_t top = lua_gettop(L);
    luaL_Reg l[] = {
        {"new", new},
        {"canWinnCard", canWinnCard},
        {"tinWinnCard", tinWinnCard},
        {"clrSupportLaizis", clrSupportLaizis},
        {"addSupportLaizis", addSupportLaizis},
        {"delSupportLaizis", delSupportLaizis},
        {"clrSupportJiangs", clrSupportJiangs},
        {"addSupportJiangs", addSupportJiangs},
        {"delSupportJiangs", delSupportJiangs},
        {NULL, NULL},
    };

    luaL_newlib(L, l);

    luaL_newmetatable(L, "mahjong");

    lua_pushvalue(L, -2);

    lua_setfield(L, -2, "__index");

    lua_pop(L, 1);

    return lua_gettop(L) - top;
}