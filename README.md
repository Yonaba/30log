![30log-plus-logo](https://github.com/cpeosphoros/30log-plus/raw/master/30log-plus-logo.png)

[![Build Status](https://travis-ci.org/cpeosphoros/30log-plus.png)](https://travis-ci.org/cpeosphoros/30log-plus)
[![Lua](https://img.shields.io/badge/Lua-5.1%2C%205.2%2C%205.3%2C%20JIT-blue.svg)]()
[![License](http://img.shields.io/badge/Licence-MIT-brightgreen.svg)](LICENSE)
[![Coverage Status](https://coveralls.io/repos/cpeosphoros/30log-plus/badge.png?branch=master)](https://coveralls.io/r/cpeosphoros/30log-plus?branch=master)

*30log*, in extenso *30 Lines Of Goodness* is a minified framework for [object-orientation](http://lua-users.org/wiki/ObjectOrientedProgramming) in Lua.
It provides  *named* and *unnamed classes*, *single inheritance*, *metamethods* and a basic support for _mixins_. In *30 lines*.<br/>
Well, [somehow](http://github.com/Yonaba/30log#30log-cleanlua).

*30log-plus* is both a fork from and an extension to 30log, with a focus on
stronger support for class initialization and mixins support. We have decided to
keep our changes only to the equivalent of 30log-clean. Those changes will also
*not* be pull requested into Yonaba's repository, as they slightly deviate from
his minimalist approach.

## Installation

*30log-plus* is available only from https://github.com/cpeosphoros/30log-plus.
To install it, just clone or download the repository then place it somewhere Lua
will look for it.

Then add 30log-plus to your code:

```
local class = require '30log-plus'
```

## Wiki

A full documentation is available on the [wiki](https://github.com/cpeosphoros/30log-plus/wiki).

## Class-Commons support

[Class-Commons](https://github.com/bartbes/Class-Commons) is an interface which provides a common API for a wide range of Object Orientation libraries in Lua. There is a small plugin, originally written by [TsT](https://github.com/tst2005)
which provides compatibility between *30log* and *Class-commons*. <br/>
See the module [30log-commons.lua](https://github.com/Yonaba/30log/blob/master/30log-commons.lua).


## Specs

You can run the included specs with [Telescope](https://github.com/norman/telescope) using the following command from Lua from the root foolder:

```
lua tsc -f specs/*
```

## License

This work is [MIT-Licensed](https://raw.githubusercontent.com/cpeosphoros/30log-plus/master/LICENSE).
