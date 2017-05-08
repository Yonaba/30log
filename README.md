![30log logo](https://github.com/Yonaba/30log/raw/master/30log-logo.png)

[![Join the chat at https://gitter.im/Yonaba/30log](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/Yonaba/30log?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Build Status](https://travis-ci.org/Yonaba/30log.png)](https://travis-ci.org/Yonaba/30log)
[![Lua](https://img.shields.io/badge/Lua-5.1%2C%205.2%2C%205.3%2C%20JIT-blue.svg)]()
[![License](http://img.shields.io/badge/Licence-MIT-brightgreen.svg)](LICENSE)
[![Coverage Status](https://coveralls.io/repos/Yonaba/30log/badge.png?branch=master)](https://coveralls.io/r/Yonaba/30log?branch=master)

*30log*, in extenso *30 Lines Of Goodness* is a minified framework for [object-orientation](http://lua-users.org/wiki/ObjectOrientedProgramming) in Lua.
It provides  *named* and *unnamed classes*, *single inheritance*, *metamethods* and a basic support for _mixins_. In *30 lines*.<br/>
Well, [somehow](http://github.com/Yonaba/30log#30log-cleanlua).


## Download

#### Archive

Current release is [1.3.0](https://github.com/Yonaba/30log/releases/tag/30log-1.3.0-1). See other [releases](https://github.com/Yonaba/30log/releases).

#### Bash

This will clone the repository, as-is, and deliver the cutting edge release. Might be unstable.

```
git clone git://github.com/Yonaba/30log.git
```

#### LuaRocks

This will download and install the latest stable release from [Luarocks](https://luarocks.org/) servers.

````
luarocks install 30log
````

## Wiki

A full documentation is available on the [wiki](https://github.com/Yonaba/30log/wiki). Find the project page at [yonaba.github.io/30log](gttp://yonaba.github.io/30log). 


## Class-Commons support

[Class-Commons](https://github.com/bartbes/Class-Commons) is an interface which provides a common API for a wide range of Object Orientation libraries in Lua. There is a small plugin, originally written by [TsT](https://github.com/tst2005) 
which provides compatibility between *30log* and *Class-commons*. <br/>
See the module [30log-commons.lua](https://github.com/Yonaba/30log/blob/master/30log-commons.lua).


## Specs

You can run the included specs with [Telescope](https://github.com/norman/telescope) using the following command from Lua from the root foolder:

```
lua tsc -f specs/*
```

## About the source

#### 30log-clean.lua

*30log* was initially designed for minimalistic purposes. But then commit after commit, I came up with a source code that was obviously surpassing 30 lines. As I wanted to stick to the "30-lines" rule that defines the name of this library, I had to use an ugly syntax which not much elegant, yet 100 % functional.<br/>
For those who might be interested though, the file [30log-clean.lua](http://github.com/Yonaba/30log/blob/master/30log-clean.lua) contains the full source code, properly formatted and well indented for your perusal.

#### 30log-global.lua

The file [30log-global.lua](http://github.com/Yonaba/30log/blob/master/30log-global.lua) features the exact same source as the original [30log.lua](http://github.com/Yonaba/30log/blob/master/30log.lua), 
excepts that it sets a global named `class`. This is convenient for Lua-based frameworks such as [Codea](http://twolivesleft.com/Codea/).


#### 30log-singleton.lua

The file [30log-singleton.lua](http://github.com/Yonaba/30log/blob/master/30log-global.lua) is a [singleton pattern](http://en.wikipedia.org/wiki/Singleton_pattern) implementation for use with *30log*.

## Contributors

* [TsT2005](https://github.com/tst2005), for the original [Class-commons](https://github.com/bartbes/Class-Commons) implementation.
* [Srdjan Marković](https://github.com/Yonaba/30log/blob/master/LICENSE#L22-L31) for the awesome graphic logo design.


## License

This work is [MIT-Licensed](https://raw.githubusercontent.com/Yonaba/30log/master/LICENSE).
