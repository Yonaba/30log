package = "30log"
version = "1.0.0-1"
source = {
   url = "https://github.com/Yonaba/30log/archive/30log-1.0.0-1.tar.gz",
   dir = "30log-30log-1.0.0-1"
}
description = {
  summary = "30 lines library for object orientation",
  detailed = [[
    30log, in extenso "30 Lines Of Goodness" is a minified library
    for object-orientation in Lua. It features named (and unnamed) classes,
    single inheritance and provides basic support for mixins in 30 lines of code.]],
  homepage = "http://yonaba.github.io/30log",
  license = "MIT <http://www.opensource.org/licenses/mit-license.php>"
}
dependencies = {"lua >= 5.1, <5.3"}
build = {
  type = "builtin",
  modules = {
    ["30log"] = "30log.lua",
    ["30logclean"] = "30logclean.lua",
    ["30logglobal"] = "30logglobal.lua",
    ["singleton"] = "singleton.lua"
  }
}