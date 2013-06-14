package = "30log"
version = "0.5.0-1"
source = {
   url = "https://github.com/Yonaba/30log/archive/30log-0.5.0-1.tar.gz",
   dir = "30log-30log-0.5.0-1"
}
description = {
   summary = "30 lines library for object orientation",
   detailed = [[
      30log, in extenso "30 Lines Of Goodness" is a minified framework written in
	  30 lines for object-orientation in Lua. It features class creation, 
		instantiation, single inheritance and mixins.
   ]],
   homepage = "http://yonaba.github.com/30log", -- We don't have one yet
   license = "MIT <http://www.opensource.org/licenses/mit-license.php>" -- or whatever you like
}
dependencies = {
   "lua >= 5.1"
}
build = {
  type = "builtin",
  modules = {
    ["30log"] = "30log.lua",
    ["30logclasscommons"] = "30logclasscommons.lua",
    ["30logclean"] = "30logclean.lua"
  },
  copy_directories = {"specs"}
}