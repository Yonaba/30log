#! /bin/bash

# A script for fixing telescope to run with lua 5.2 and 5.3


  if [ "$LUA" == "lua5.2" ]; then
    sed 's/compat_env.setfenv/compat_env.setfenv\nlocal unpack = unpack or table.unpack/' ${TRAVIS_BUILD_DIR}/install/luarocks/share/lua/5.2/telescope.lua
  elif [ "$LUA" == "lua5.3" ]; then
    sed 's/compat_env.setfenv/compat_env.setfenv\nlocal unpack = unpack or table.unpack/' ${TRAVIS_BUILD_DIR}/install/luarocks/share/lua/5.3/telescope.lua
  fi

