LUA_VERSION =       5.4
PREFIX =            /usr/local
CFLAGS =            -O3 -Wall -pedantic -DNDEBUG -g
LDFLAGS =     		-shared
LUACLIB = 			cmahjong.so usertime.so cutworks.so
CC ?= 				gcc
LUA_CLIB_PATH ?= 	lib
LUA_INCLUDE_DIR ?=   $(PREFIX)/include
LUA_CMODULE_DIR ?=   $(PREFIX)/lib/lua/$(LUA_VERSION)
LUA_MODULE_DIR ?=    $(PREFIX)/share/lua/$(LUA_VERSION)
LUA_BIN_DIR ?=       $(PREFIX)/bin


.PHONY: all clean

all: $(LUACLIB)

$(LUA_CLIB_PATH) :
	mkdir $(LUA_CLIB_PATH)

$(LUA_CLIB_PATH)/cmahjong.so : src/c/cmahjong.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(LDFLAGS) -Isrc/c $^ -o $@

$(LUA_CLIB_PATH)/usertime.so : src/c/usertime.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(LDFLAGS) -Isrc/c $^ -o $@

$(LUA_CLIB_PATH)/cutworks.so : src/c/cutworks.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(LDFLAGS) -Isrc/c $^ -o $@


clean:
	rm -f ./lib/*.so && \
	rm -rf ./src/c/*.o