30log
=====

[![Build Status](https://travis-ci.org/Yonaba/30log.png)](https://travis-ci.org/Yonaba/30log)
[![Coverage Status](https://coveralls.io/repos/Yonaba/30log/badge.png?branch=master)](https://coveralls.io/r/Yonaba/30log?branch=master)
[![License](http://img.shields.io/badge/Licence-MIT-brightgreen.svg)](LICENSE)

__30log__, in extenso *30 Lines Of Goodness* is a minified framework for [object-orientation](http://lua-users.org/wiki/ObjectOrientedProgramming) in Lua.
It features __named (and unnamed) classes__, __single inheritance__ and a basic support for __mixins__.<br/>
It makes __30 lines__. No less, no more.<br/>
__30log__ is [Lua 5.1](http://www.lua.org/versions.html#5.1) and [Lua 5.2](http://www.lua.org/versions.html#5.2) compatible.

##Contents
* [Download](https://github.com/Yonaba/30log/#download)
* [Installation](https://github.com/Yonaba/30log/#installation)
* [Quicktour](https://github.com/Yonaba/30log/#quicktour)
* [Chained initialisation](https://github.com/Yonaba/30log/#chained-initialisation)
* [Mixins](https://github.com/Yonaba/30log/#mixins)
* [Printing classes and objects](https://github.com/Yonaba/30log/#printing-classes-and-objects)
* [Class Commons support](https://github.com/Yonaba/30log/#class-commons)
* [Specification](https://github.com/Yonaba/30log/#specification)
* [Source](https://github.com/Yonaba/30log/#source)
* [Benchmark](https://github.com/Yonaba/30log/#benchmark)
* [Contributors](https://github.com/Yonaba/30log/#contributors)

##Download

You can download __30log__ via:

###Bash

```bash
git clone git://github.com/Yonaba/30log.git
````

###Archive

* __Zip__: [0.9.1](https://github.com/Yonaba/30log/archive/30log-0.9.1.zip) ( *latest stable, recommended* ) | [older versions](https://github.com/Yonaba/30log/tags)
* __Tar.gz__: [0.9.1](https://github.com/Yonaba/30log/archive/30log-0.9.1.tar.gz) ( *latest stable, recommended* ) | [older versions](https://github.com/Yonaba/30log/tags)

###LuaRocks

```
luarocks install 30log
````

###MoonRocks

```bash
luarocks install --server=http://rocks.moonscript.org/manifests/Yonaba 30log
````

##Installation
Copy the file [30log.lua](https://github.com/Yonaba/30log/blob/master/30log.lua) inside your project folder,
call it using [require](http://pgl.yoyo.org/luai/i/require) function. It will return a single local function, 
keeping safe the global environment.<br/>

##Quicktour
###Creating a class
Creating a new class is fairly simple. Just call the returned function, then add some properties to this class :

```lua
class = require '30log'
Window = class ()
Window.x, Window.y = 10, 10
Window.width, Window.height = 100,100
```

You can also make it shorter, packing the default properties and their values within a 
table and then pass it as a single argument to the `class` function :

```lua
class = require '30log'
Window = class { width = 100, height = 100, x = 10, y = 10}
```

###Named classes
Classes can be named.<br/>
To name a class, you will have to set the desired name as a string value to the reserved key `__name` :

```lua
class = require '30log'
Window = class ()
Window.__name = 'Window'
```

This feature can be quite useful when debugging your code. See the section 
[printing classes](https://github.com/Yonaba/30log/#printing-classes-and-objects) for more details.

###Instances

####Creating instances

You can easily create new __instances__ (objects) from a class using the __default instantiation method__ 
named `new()`:

```lua
appFrame = Window:new()
print(appFrame.x,appFrame.y) --> 10, 10
print(appFrame.width,appFrame.height) --> 100, 100
```

There is a shorter version though. You can call new class itself with parens, __just like a function__ :

```lua
appFrame = Window()
print(appFrame.x,appFrame.y) --> 10, 10
print(appFrame.width,appFrame.height) --> 100, 100
```

From the two examples above, you might have noticed that once an object is created from a class, it 
already shares the properties of his mother class. That's the very basis of `inheritance`. 
So, by default, the attributes of the newly created object will copy their values from its mother class.<br/>
<br/>
Yet, you can init new objects from a class with custom values for properties. To accomplish that, 
you will have to implement your own __class constructor__. Typically, it is a method (a function) that will be
called whenever the new() method is used from the class to derive a new object, and then define custom attributes and values for this object.<br/>
By default, __30log__ uses the reserved key `__init` as a __class constructor__.

```lua
Window = class { width = 100, height = 100, x = 10, y = 10}
function Window:__init(x,y,width,height)
  self.x,self.y = x,y
  self.width,self.height = width,height
end

appFrame = Window:new(50,60,800,600)
   -- same as: appFrame = Window(50,60,800,600)
print(appFrame.x,appFrame.y) --> 50, 60
print(appFrame.width,appFrame.height) --> 800, 600
```

`__init` can also be a __table with named keys__. </br>
In that case though, the values of each single object's properties will be taken from this table
upon instantiation, no matter what the values passed-in at instantiation would be. 

```lua
Window = class()
Window.__init = { width = 100, height = 100, x = 10, y = 10}

appFrame = Window:new(50,60,800,600)
   -- or appFrame = Window(50,60,800,600)
print(appFrame.x,appFrame.y) --> 10, 10
print(appFrame.width,appFrame.height) --> 100, 100
````

####Under the hood
*30log* classes are metatables of their own instances. This implies that one can inspect the mother/son 
relationship between a class and its instance via Lua's standard function [getmetatable](http://www.lua.org/manual/5.2/manual.html#pdf-getmetatable).

```lua
local aClass = class()
local someInstance = aClass()
print(getmetatable(someInstance) == aClass) --> true
````

Also, classes are metatables of their derived classes.

```lua
local aClass = class()
local someDerivedClass = aClass:extends()
print(getmetatable(someDerivedClass) == aClass) --> true
````

###Methods and metamethods
Objects can call their class __methods__.

```lua
Window = class { width = 100, height = 100, w = 10, y = 10}
function Window:__init(x,y,width,height)
  self.x,self.y = x,y
  self.width,self.height = width,height
end

function Window:set(x,y)
  self.x, self.y = x, y
end

function Window:resize(width, height)
  self.width, self.height = width, height
end

appFrame = Window()
appFrame:set(50,60)
print(appFrame.x,appFrame.y) --> 50, 60
appFrame:resize(800,600)
print(appFrame.width,appFrame.height) --> 800, 600
```

Objects cannot be used to instantiate new objects though.

```lua
appFrame = Window:new()
aFrame = appFrame:new() -- Creates an error
aFrame = appFrame()     -- Also creates an error
````

Classes supports metamethods as well as methods. Those metamethods can be inherited.
In the following example, we will use the `+` operator to increase the window size.

```lua
Window.__add = function(w, size) 
  w.width = w.width + size
  w.height = w.height + size
  return w
end

window = Window()                                -- creates a new Window instance
window:resize(600,300)                           -- resizes the new window
print(window.width, window.height) --> 600, 300
window = window + 100                            -- increases the window dimensions
print(window.width, window.height) --> 700, 400

Frame = Window:extends()                         -- creates a Frame class deriving from Window class
frame = Frame()                                  -- creates a new Frame instance
frame:resize(400,300)                            -- Resizes the new frame
print(frame.width, frame.height) --> 400, 300
frame = frame + 50                               -- increases the frame dimensions
print(frame.width, frame.height) --> 450, 350
````


###Inheritance

A class can __inherit__ from any other class using a reserved method named `extends`.
Similarly to `class`, this method also takes an optional table with named keys as argument 
to include __new properties__ that the derived class will implement.
The new class will inherit his mother class __properties__ as well as its __methods__.

```lua
Window = class { width = 100, height = 100, x = 10, y = 10}
Frame = Window:extends { color = 'black' }
print(Frame.x, Frame.y) --> 10, 10

appFrame = Frame()
print(appFrame.x,appFrame.y) --> 10, 10
```

A derived class can __redefine any method__ implemented in its base class (or mother class).
Therefore, the derived class *still* has access to his mother class methods and properties via a 
reserved key named `super`.<br/>

```lua
-- Let's use this feature to build a class constructor for our `Frame` class.

-- The base class "Window"
Window = class { width = 100, height = 100, x = 10, y = 10}
function Window:__init(x,y,width,height)
  self.x,self.y = x,y
  self.width,self.height = width,height
end

-- A method
function Window:set(x,y)
  self.x, self.y = x, y
end

-- A derived class named "Frame"
Frame = Window:extends { color = 'black' }
function Frame:__init(x,y,width,height,color)
  -- Calling the superclass constructor
  Frame.super.__init(self,x,y,width,height)
  -- Setting the extra class member
  self.color = color
end

-- Redefining the set() method
function Frame:set(x,y)
  self.x = x - self.width/2
  self.y = y - self.height/2
end

-- An appFrame from "Frame" class
appFrame = Frame(100,100,800,600,'red')
print(appFrame.x,appFrame.y) --> 100, 100

-- Calls the new set() method
appFrame:set(400,400)
print(appFrame.x,appFrame.y) --> 0, 100

-- Calls the old set() method in the mother class "Windows"
appFrame.super.set(appFrame,400,300)
print(appFrame.x,appFrame.y) --> 400, 300
```

###Inspecting inheritance

`class.is` can check if a given class derives from another class.

```lua
local aClass = class()
local aDerivedClass = aClass:extends()
print(aDerivedClass:is(aClass)) --> true
````

It also returns *true* when the given class is not necessarily the immediate ancestor of the calling class.

```lua
local aClass = class()
local aDerivedClass = aClass:extends():extends():extends() -- 3-level depth inheritance
print(aDerivedClass:is(aClass)) --> true
````

Similarly `instance.is` can check if a given instance derives from a given class.

```lua
local aClass = class()
local anObject = aClass()
print(anObject:is(aClass)) --> true
````

It also returns *true* when the given class is not the immediate ancestor.

```lua
local aClass = class()
local aDerivedClass = aClass:extends():extends():extends() -- 3-level depth inheritance
local anObject = aDerivedClass()
print(anObject:is(aDerivedClass)) --> true
print(anObject:is(aClass)) --> true
````

##Chained initialisation
In a single inheritance tree,  the `__init` constructor can be chained from one class to 
another.<br/>

This is called *initception*.<br/>
And, yes, *it is a joke.*

```lua
-- A mother class 'A'
local A = Class()
function A.__init(instance,a)
  instance.a = a
end

-- Class 'B', deriving from class 'A'
local B = A:extends()
function B.__init(instance, a, b)
  B.super.__init(instance, a)
  instance.b = b
end

-- Class 'C', deriving from class 'B'
local C = B:extends()
function C.__init(instance, a, b, c)
  C.super.__init(instance,a, b)
  instance.c = c
end

-- Class 'D', deriving from class 'C'
local D = C:extends()
function D.__init(instance, a, b, c, d)
  D.super.__init(instance,a, b, c)
  instance.d = d
end

-- Creating an instance of class 'D'
local objD = D(1,2,3,4)
for k,v in pairs(objD) do print(k,v) end

-- Output:
--> a  1
--> d  4
--> c  3
--> b  2
```

The previous syntax can also be simplified, as follows:

```lua
local A = Class()
function A:__init(a)
  self.a = a
end

local B = A:extends()
function B:__init(a, b)
  B.super.__init(self, a)
  self.b = b
end

local C = B:extends()
function C:__init(a, b, c)
  C.super.__init(self, a, b)
  self.c = c
end

local D = C:extends()
function D:__init(a, b, c, d)
  D.super.__init(self, a, b, c)
  self.d = d
end
````

##Mixins

__30log__ provides a basic support for [mixins](http://en.wikipedia.org/wiki/Mixin). This is a powerful concept that can 
be used to implement a functionality into different classes, even if they do not have any special relationship.<br/>
__30log__ assumes a `mixin` to be a table containing a **set of methods** (function).<br/>
To include a mixin in a class, use the reserved key named `include`.

```lua
-- A mixin
Geometry = {
  getArea = function(self) return self.width, self.height end,
  resize = function(self, width, height) self.width, self.height = width, height end
}

-- Let's define two unrelated classes
Window = class {width = 480, height = 250}
Button = class {width = 100, height = 50, onClick = false}

-- Include the "Geometry" mixin inside the two classes
Window:include(Geometry)
Button:include(Geometry)

-- Let's define objects from those classes
local aWindow = Window()
local aButton = Button()

-- Objects can use functionalities brought by the mixin.
print(aWindow:getArea()) --> 480, 250
print(aButton:getArea()) --> 100, 50

aWindow:resize(225,75)
print(aWindow.width, aWindow.height) --> 255, 75
````

Note that, when including a mixin into a class, **only methods** (functions, actually) will be imported into the 
class. Also, objects cannot include mixins.

```lua
aWindow = Window()
aWindow:include(Geometry) -- produces an error
````

##Printing classes and objects
Any attempt to [print](http://pgl.yoyo.org/luai/i/print) or [tostring](http://pgl.yoyo.org/luai/i/tostring) a __class__ or an __instance__
will return the name of the class as a string. This feature is mostly meant for debugging purposes.

```lua
-- Let's illustrate this, with an unnamed __Cat__ class:

-- A Cat Class
local Cat = class()
print(Cat) --> "class(?):<table:00550AD0>"

local kitten = Cat()
print(kitten) --> "object(of ?):<table:00550C10>"
````

The question mark symbol `?` means here the printed class is unnamed (or the object derives from an unnamed class).

```lua
-- Let's define a named __Cat__ class now:

-- A Cat Class
local Cat = class()
Cat.__name = 'Cat'
print(Cat) --> "class(Cat):<table:00411858>"

local kitten = Cat()
print(kitten) --> "object(of Cat):<table:00411880>"
````

##Class Commons
[Class-Commons](https://github.com/bartbes/Class-Commons) is an interface that provides a common 
API for a wide range of object orientation libraries in Lua. There is a small plugin, originally written by [TsT](https://github.com/tst2005) 
which provides compatibility between *30log* and *Class-commons*. <br/>
See here: [30logclasscommons](http://github.com/Yonaba/30logclasscommons).

##Specification

You can run the included specs with [Telescope](https://github.com/norman/telescope) using the following 
command from the root foolder:

```
lua tsc -f specs/*
```

###Source

###30logclean
__30log__ was initially designed for minimalistic purposes. But then commit after commit, I came up with a source code
that was obviously surpassing 30 lines. As I wanted to stick to the "30-lines" rule, I had to use an ugly syntax which not much elegant, yet 100 % functional.<br/>
For those who might be interested though, the file [30logclean.lua](https://github.com/Yonaba/30log/blob/master/30logclean.lua) contains the full source code, 
properly formatted and well indented for your perusal.

###30logglobal

The file [30logglobal.lua](https://github.com/Yonaba/30log/blob/master/30logglobal.lua) features the exact same source as the original [30log.lua](https://github.com/Yonaba/30log/blob/master/30log.lua), 
excepts that it sets a global function named `class`. This is convenient for Lua-based frameworks such as [Codea](http://twolivesleft.com/Codea/).

##Benchmark

Performance tests featuring classes creation, instantiation and such have been included.
You can run these tests with the following command with Lua from the root folder, passing to the test script the actual implementation to be tested.

```lua
lua performance/tests.lua 30log
````

Find [here an example of output](https://github.com/Yonaba/30log/tree/master/performance/results.md).

##Contributors
* [TsT2005](https://github.com/tst2005), for the original Class-commons support.


##License
This work is under [MIT-LICENSE](http://www.opensource.org/licenses/mit-license.php)<br/>
Copyright (c) 2012-2014 Roland Yonaba

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/Yonaba/30log/trend.png)](https://bitdeli.com/free "Bitdeli Badge")