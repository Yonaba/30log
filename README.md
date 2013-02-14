30log
=====

[![Build Status](https://travis-ci.org/Yonaba/30log.png)](https://travis-ci.org/Yonaba/30log)

__30log__, in extenso *30 Lines Of Goodness* is a minified framework for [object-orientation](http://lua-users.org/wiki/ObjectOrientedProgramming) in Lua.
It features __class creation__, __instantiation__, __single inheritance__ .<br/>
And, it makes __30 lines__. No less, no more.

##Contents
* [Download](https://github.com/Yonaba/30log/#download)
* [Installation](https://github.com/Yonaba/30log/#installation)
* [Quicktour](https://github.com/Yonaba/30log/#quicktour)
* [Chained initialisation](https://github.com/Yonaba/30log/#chained-initialisation)
* [Printing classes and objects](https://github.com/Yonaba/30log/#printing-classes-and-objects)
* [Class Commons support](https://github.com/Yonaba/30log/#class-commons-support)
* [Specification](https://github.com/Yonaba/30log/#specification)
* [Contributors](https://github.com/Yonaba/30log/#contributors)

##Download
###Bash

```bash
git clone git://github.com/Yonaba/30log.git
````

###Archive
* __Zip__: [current](https://github.com/Yonaba/30log/archive/master.zip) | [old packages](https://github.com/Yonaba/30log/tags)
* __Tar.gz__: [current](https://github.com/Yonaba/30log/archive/master.tar.gz) | [old packages](https://github.com/Yonaba/30log/tags)

###LuaRocks

```
luarocks install 30log
````

###MoonRocks

```bash
luarocks install --server=http://rocks.moonscript.org/manifests/Yonaba 30log
````

##Installation
Copy the file [30log.lua](https://github.com/Yonaba/30log/blob/master/Lib/30log.lua) inside your project folder, call it using [require](http://pgl.yoyo.org/luai/i/require) function.<br/>
When loaded, __30log__ returns its main function.

##Quicktour
###Creating a class
Making a new class is fairly simple. Just call the returned function, then add some properties to this class :

```lua
class = require '30log'
Window = class ()
Window.x, Window.y = 10, 10
Window.width, Window.height = 100,100
```

You can also shortcut it, passing the default properties as a table to <tt>class</tt> :

```lua
class = require '30log'
Window = class { width = 100, height = 100, x = 10, y = 10}
```
###Named classes
As of [v0.4.1](https://github.com/Yonaba/30log/blob/master/version_history.md), classes can be named, setting manually a string value (corresponding to the name you want to set) to a special key named <tt>**__name**</tt>

```lua
class = require '30log'
Window = class ()
Window.__name = 'Window'
```

This feature can be quite useful when debugging your code. See [printing classes](https://github.com/Yonaba/30log/#printing-classes-and-objects) for more details.
###Instances

Once a class is set, you can easily create new __instances__ from the class.

```lua
appFrame = Window:new()
print(appFrame.x,appFrame.y) --> 10, 10
print(appFrame.width,appFrame.height) --> 100, 100
```

You can also use a shortcut, calling the class __as a function__ :

```lua
appFrame = Window()
print(appFrame.x,appFrame.y) --> 10, 10
print(appFrame.width,appFrame.height) --> 100, 100
```

From the two examples above, you might have noticed that once an instance is created from a class, its properties takes __by default__ the class properties.
But, you can init objects from a class with your own specific properties. To accomplish that, you must have implemented a method named <tt>**__init**</tt> inside the base class.<br/>
In a nutshell, <tt>**__init**</tt> is the __default method__ to be used as a __class constructor__.

```lua
Window = class { width = 100, height = 100, x = 10, y = 10}
function Window:__init(x,y,width,height)
  self.x,self.y = x,y
  self.width,self.height = width,height
end

appFrame = Window:new(50,60,800,600)
   -- or appFrame = Window(50,60,800,600)
print(appFrame.x,appFrame.y) --> 50, 60
print(appFrame.width,appFrame.height) --> 800, 600
```

As of [v0.4.0](https://github.com/Yonaba/30log/blob/master/version_history.md), **<tt>__init**</tt> can also be a __table with named args__. </br>
In that case though, each instances will keep the same values for their properties, no matter what the values passed-in to the <tt>**:new**</tt> method would be.

```lua
Window = class()
Window.__init = { width = 100, height = 100, x = 10, y = 10}

appFrame = Window:new(50,60,800,600)
   -- or appFrame = Window(50,60,800,600)
print(appFrame.x,appFrame.y) --> 10, 10
print(appFrame.width,appFrame.height) --> 100, 100
````

###Methods
__Methods__ are supported. Obviously.

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

###Inheritance
A class can __derive__ from a base class using a default method named <tt>:extends</tt>.
The new class will inherit his mother class default __members__ and __methods__.

```lua
Window = class { width = 100, height = 100, x = 10, y = 10}
Frame = Window:extends { color = 'black' }
print(Frame.x, Frame.y) --> 10, 10

appFrame = Frame()
print(appFrame.x,appFrame.y) --> 10, 10
```

A derived class can __overload any method__ defined in its base class (or mother class). Therefore, the derived class still has access to his mother class methods via a special key named <tt>super</tt>.<br/>
Let's use this feature to build a class constructor for our <tt>Frame</tt> class.

```lua
-- The base class "Window"
Window = class { width = 100, height = 100, x = 10, y = 10}
function Window:__init(x,y,width,height)
  self.x,self.y = x,y
  self.width,self.height = width,height
end

function Window:set(x,y)
  self.x, self.y = x, y
end

-- A derived class named "Frame"
Frame = Window:extends { color = 'black' }
function Frame:__init(x,y,width,height,color)
  -- Calling the superclass constructor
  self.super.__init(self,x,y,width,height)
  -- Setting the extra class member
  self.color = color
end

-- Overloading Window:set()
function Frame:set(x,y)
  self.x = x - self.width/2
  self.y = y - self.height/2
end

-- A appFrame from "Frame" class
appFrame = Frame(100,100,800,600,'red')
print(appFrame.x,appFrame.y) --> 100, 100

appFrame:set(400,400)
print(appFrame.x,appFrame.y) --> 0, 100

appFrame.super.set(appFrame,400,300)
print(appFrame.x,appFrame.y) --> 400, 300
```
##Chained initialisation
In a single inheritance model, <tt>**__init**</tt> constructor can be chained from one class to another.

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
--> a	1
--> d	4
--> c	3
--> b	2
```

##Printing classes and objects
As of [v0.4.0](https://github.com/Yonaba/30log/blob/master/version_history.md), ay attempt to [print](http://pgl.yoyo.org/luai/i/print) or [tostring](http://pgl.yoyo.org/luai/i/tostring) 
a __class__ or an __instance__ will return a special string, mostly useful when debugging.

Let's illustrate this, with an unnamed __Cat__ class:

```lua
-- A Cat Class
local Cat = class()
print(Cat) --> "class (Unnamed): <table: 00550AD0>"

local kitten = Cat()
print(kitten) --> "object (of Unnamed): <table: 00550C10>"
````

Let's define a named __Cat__ class now:

```lua
-- A Cat Class
local Cat = class()
Cat.__name = 'Cat'
print(Cat) --> "class (Cat): <table: 00411858>"

local kitten = Cat()
print(kitten) --> "object (of Cat): <table: 00411880>"
````

##Class Commons support
[Class-Commons](https://github.com/bartbes/Class-Commons) is an interface that provides a common API for lua classes libraries.

```lua
require("30logclasscommons")

common.class(...)
common.instance(...)
```

##Specification

###30log Specs
Specs tests have been included.<br/>
Run them using [Telescope](https://github.com/norman/telescope) with the following command from the root foolder:
```
tsc -f specs/*
```

````
------------------------------------------------------------------------
Class():                                                             
When Class is called with no args passed:                            
  it returns a new class (regular Lua table)                         [P]
Attributes:                                                          
  can be added to classes                                            [P]
  can be passed in a table to Class()                                [P]
Methods:                                                             
  can be added to classes                                            [P]
tostring:                                                            
  classes can be stringified                                         [P]
named classes:                                                       
  classes can be named implementing the special attribute __name     [P]
------------------------------------------------------------------------
Derivation (Inheritance):                                            
Class can be derived from a superclass:                              
  Via "extends()" method                                             [P]
  With extra-arguments passed to method "extends()" as a table       [P]
A derived class still points to its superclass:                      
  Via its "super" key                                                [P]
  Via "getmetatable()" function                                      [P]
A derived class:                                                     
  can instantiate objects                                            [P]
  shares its superclass attributes                                   [P]
  shares its superclass methods                                      [P]
  can reimplement its superclass methods                             [P]
  Yet, it still has access to the original superclass method         [P]
In a single inheritance model:                                       
  __init() class constructor can chain                               [P]
------------------------------------------------------------------------
Instances (Objects):                                                 
When a class is created:                                             
  new objects can be created via Class:new()                         [P]
  new objects can be created calling the class as a function         [P]
  new objects share their class attributes                           [P]
  new objects share their class methods                              [P]
Providing an :__init() method to classes:                            
  Overrides instantiation scheme with Class:new()                    [P]
  Overrides instantiation scheme with Class()                        [P]
.__init can also be a table of named args for static instantiati...: 
  Overrides instantiation scheme with Class:new()                    [P]
  Overrides instantiation scheme with Class()                        [P]
tostring:                                                            
  objects can be stringified                                         [P]
  the output takes into account the mother class name can be stri... [P]
------------------------------------------------------------------------
26 tests 26 passed 41 assertions 0 failed 0 errors 0 unassertive 0 pending
````

###Class-Commons testing implementation
See [Class-Commons-Tests](https://github.com/bartbes/Class-Commons-Tests)

```
$ lua tests.lua 30logclasscommons
Testing implementation: 30logclasscommons
  Summary:
    Failed: 0
    Out of: 10
    Rate: 100%
```

##Contributors
* [TsT2005](https://github.com/tst2005), for Class-commons support.


##License
This work is under [MIT-LICENSE](http://www.opensource.org/licenses/mit-license.php)<br/>
Copyright (c) 2012 Roland Yonaba

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
