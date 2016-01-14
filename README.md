30log
=====

[![Join the chat at https://gitter.im/Yonaba/30log](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/Yonaba/30log?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Build Status](https://travis-ci.org/Yonaba/30log.png)](https://travis-ci.org/Yonaba/30log)
[![Coverage Status](https://coveralls.io/repos/Yonaba/30log/badge.png?branch=master)](https://coveralls.io/r/Yonaba/30log?branch=master)
[![Lua](https://img.shields.io/badge/Lua-5.1%2C%205.2%2C%205.3%2C%20JIT-blue.svg)]()
[![License](http://img.shields.io/badge/Licence-MIT-brightgreen.svg)](LICENSE)

*30log*, in extenso *30 Lines Of Goodness* is a minified framework for [object-orientation](http://lua-users.org/wiki/ObjectOrientedProgramming) in Lua.
It provides  *named* and *unnamed classes*, *single inheritance*, *metamethods* and a basic support for _mixins_.  
In *30 lines*. No less, no more.  
__30log__ was written with [Lua 5.1](http://www.lua.org/versions.html#5.1) in mind, but is compatible with [Lua 5.2](http://www.lua.org/versions.html#5.2), [Lua 5.3](http://www.lua.org/versions.html#5.3) and [LuaJIT](http://luajit.org/luajit.html).


## Download and Installing

#### Bash

```
git clone git://github.com/Yonaba/30log.git
```

#### Archive

* __zip__: [1.0.0](https://github.com/Yonaba/30log/archive/30log-1.0.0.zip) (*latest stable, recommended*) | [older versions](https://github.com/Yonaba/30log/tags)
* __tar.gz__: [1.0.0](https://github.com/Yonaba/30log/archive/30log-1.0.0.tar.gz) (*latest stable, recommended*) | [older versions](https://github.com/Yonaba/30log/tags)


#### LuaRocks

````
luarocks install 30log
````

## Documentation

Find the project page at [yonaba.github.io/30log](gttp://yonaba.github.io/30log).  
A full documentation is available on the [wiki](https://github.com/Yonaba/30log/wiki).

## Class-Commons support

[Class-Commons](https://github.com/bartbes/Class-Commons) is an interface that provides a common API for a wide range of object orientation libraries in Lua. There is a small plugin, originally written by [TsT](https://github.com/tst2005) 
which provides compatibility between *30log* and *Class-commons*. <br/>
See here: [30logclasscommons](http://github.com/Yonaba/30logclasscommons).


##Specification

You can run the included specs with [Telescope](https://github.com/norman/telescope) using the following command from Lua from the root foolder:

```
lua tsc -f specs/*
```

## About the source

####30log-clean.lua

*30log* was initially designed for minimalistic purposes. But then commit after commit, I came up with a source code that was obviously surpassing 30 lines. As I wanted to stick to the "30-lines" rule that defines the name of this library, I had to use an ugly syntax which not much elegant, yet 100 % functional.<br/>
For those who might be interested though, the file [30logclean.lua](http://github.com/Yonaba/30log/blob/master/30logclean.lua) contains the full source code, properly formatted and well indented for your perusal.

####30log-global.lua

The file [30logglobal.lua](http://github.com/Yonaba/30log/blob/master/30logglobal.lua) features the exact same source as the original [30log.lua](http://github.com/Yonaba/30log/blob/master/30log.lua), 
excepts that it sets a global named `class`. This is convenient for Lua-based frameworks such as [Codea](http://twolivesleft.com/Codea/).


## Contributors

* [TsT2005](https://github.com/tst2005), for the original [Class-commons](https://github.com/bartbes/Class-Commons) support.


##License

This work is [MIT-Licensed](https://raw.githubusercontent.com/Yonaba/30log/master/LICENSE).
