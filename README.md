30log
=====

[![Build Status](https://travis-ci.org/Yonaba/30log.png)](https://travis-ci.org/Yonaba/30log)

__30log__, in extenso *30 Lines Of Goodness* is a minified framework for [object-orientation](http://lua-users.org/wiki/ObjectOrientedProgramming) in Lua.
It features __class creation__, __object instantiation__, __single inheritance__ and a basic support for __mixins__.<br/>
And, it makes __30 lines__. No less, no more.<br/>
__30log__ was meant for [Lua 5.1.x](http://www.lua.org/versions.html#5.1), yet it is compatible with [Lua 5.2.x.](http://www.lua.org/versions.html#5.2)

##Contents
* [Download](https://github.com/Yonaba/30log/#download)
* [Installation](https://github.com/Yonaba/30log/#installation)
* [Quicktour](https://github.com/Yonaba/30log/#quicktour)
* [Chained initialisation](https://github.com/Yonaba/30log/#chained-initialisation)
* [Mixins](https://github.com/Yonaba/30log/#mixins)
* [Printing classes and objects](https://github.com/Yonaba/30log/#printing-classes-and-objects)
* [Class Commons support](https://github.com/Yonaba/30log/#class-commons)
* [Specification](https://github.com/Yonaba/30log/#specification)
* [Clean source](https://github.com/Yonaba/30log/#clean-source)
* [Contributors](https://github.com/Yonaba/30log/#contributors)

##Download

You can download __30log__ via:

###Bash

```bash
git clone git://github.com/Yonaba/30log.git
````

###Archive

* __Zip__: [0.5.0](https://github.com/Yonaba/30log/archive/30log-0.5.0.zip) ( *latest stable, recommended* ) | [older versions](https://github.com/Yonaba/30log/tags)
* __Tar.gz__: [0.5.0](https://github.com/Yonaba/30log/archive/30log-0.5.0.tar.gz) ( *latest stable, recommended* ) | [older versions](https://github.com/Yonaba/30log/tags)

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
call it using [require](http://pgl.yoyo.org/luai/i/require) function. It will return a single function, 
while keeping safe the global environment.<br/>

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
As of [v0.4.1](https://github.com/Yonaba/30log/blob/master/version_history.md#041-02142013), classes can be named.
<br/>To name a class, you will have to set the desired name as a string value to the reserved key `__name` :

```lua
class = require '30log'
Window = class ()
Window.__name = 'Window'
```

This feature can be quite useful when debugging your code. See the section 
[printing classes](https://github.com/Yonaba/30log/#printing-classes-and-objects) for more details.

###Instances

You can easily create new __instances__ (objects) from a class using the __default instantiation method__ 
named `new()`:

```lua
appFrame = Window:new()
print(appFrame.x,appFrame.y) --> 10, 10
print(appFrame.width,appFrame.height) --> 100, 100
```

There is a shorter version though. You can call new class itself __as a function__ :

```lua
appFrame = Window()
print(appFrame.x,appFrame.y) --> 10, 10
print(appFrame.width,appFrame.height) --> 100, 100
```

From the two examples above, you might have noticed that once an object is created from a class, it 
already implements the properties of his mother class. That's the definition of `inheritance`. 
So, by default, the properties of the new object copy their values from the mother class.<br/>
<br/>
Yet, you can init new objects from a class with custom values for properties. To accomplish that, 
you will have to implement a __class constructor__ into the class. Typically, it is a method that is 
internally called right after an object was derived from a class and that can interact on the so-called 
object to alter the values of its properties.<br/>
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

__Note:__ As of [v0.4.0](https://github.com/Yonaba/30log/blob/master/version_history.md#040-02132013), 
`__init` can also be a __table with named args__. </br>
In that case though, the values of each single object's properties will be taken from the table 
`__init` upon instantiation, no matter what the values passed-in at instantiation would be.

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
A class can __inherit__ from any other class using a reserved method named `extends`.
Similarly to `class`, this method also takes an optional table with named args as argument 
to include __the new properties__ that the derived class will implement.
The new class will inherit his mother class __properties__ as well as __methods__.

```lua
Window = class { width = 100, height = 100, x = 10, y = 10}
Frame = Window:extends { color = 'black' }
print(Frame.x, Frame.y) --> 10, 10

appFrame = Frame()
print(appFrame.x,appFrame.y) --> 10, 10
```

A derived class can __redefine any method__ implemented in its base class (or mother class).
Therefore, the derived class still has access to his mother class methods and properties via a 
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

##Chained initialisation
In a single inheritance tree,  the `__init` constructor can be chained from one class to 
another ( *Initception ?* ).

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
--> c	3
--> b	2
```

##Mixins

As of [v0.5.0](https://github.com/Yonaba/30log/blob/master/version_history.md#050-06132013), __30log__ provides a basic support
for [mixins](http://en.wikipedia.org/wiki/Mixin). This is a powerful concept that can be used to implement
functionnality into different classes without having any special relationship between them, such as 
inheritance.<br/>
__30log__ implements the concept of __mixin__ as an object (actually a *simple lua table*) containing a 
**set of methods**. To include a mixin in a class, use the reserved key named `with`.

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
Window:with(Geometry)
Button:with(Geometry)

-- Let's define objects from those classes
local aWindow = Window()
local aButton = Button()

-- Objects can use functionalities brought by the mixin.
print(aWindow:getArea()) --> 480, 250
print(aButton:getArea()) --> 100, 50

aButton:resize(225,75)
print(aButton.width, aButton.height) --> 255, 75
````

__Note:__ When including a mixin into a class, **only methods** (functions, actually) will be imported into the 
class.

##Printing classes and objects
As of [v0.4.0](https://github.com/Yonaba/30log/blob/master/version_history.md#040-02132013), any attempt to [print](http://pgl.yoyo.org/luai/i/print) or [tostring](http://pgl.yoyo.org/luai/i/tostring) a __class__ or an __instance__ will return a special string, mostly meant for debugging purposes.

```lua
-- Let's illustrate this, with an unnamed __Cat__ class:

-- A Cat Class
local Cat = class()
print(Cat) --> "class (Unnamed): <table: 00550AD0>"

local kitten = Cat()
print(kitten) --> "object (of Unnamed): <table: 00550C10>"
````


```lua
-- Let's define a named __Cat__ class now:

-- A Cat Class
local Cat = class()
Cat.__name = 'Cat'
print(Cat) --> "class (Cat): <table: 00411858>"

local kitten = Cat()
print(kitten) --> "object (of Cat): <table: 00411880>"
````

##Class Commons
[Class-Commons](https://github.com/bartbes/Class-Commons) is an interface that provides a common 
API for a wide range of object orientation libraries in Lua.
The support for Class Commmons was provided by [TsT2005](https://github.com/tst2005). 

```lua
require("30logclasscommons")
common.class(...)
common.instance(...)
```

##Specification

###30log specs

You can run the included specs sing [Telescope](https://github.com/norman/telescope) with the following 
command from the root foolder:

```
tsc -f specs/*
```

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

##Clean source

__30log__ was initially designed for minimalistic purposes. But then commit after commit, I came  with a source code
that was obviously surpassing 30 lines. I opted to stick to the "30-lines" rule. And, as a trade-off, the original source is not 
much elegant, yet 100 % functional.<br/>
For those who might be interested, though, the file [30logclean.lua](https://github.com/Yonaba/30log/blob/master/30logclean.lua) contains the full source code, 
properly formatted and well indented for your perusal.

##Contributors
* [TsT2005](https://github.com/tst2005), for Class-commons support.


##License
This work is under [MIT-LICENSE](http://www.opensource.org/licenses/mit-license.php)<br/>
Copyright (c) 2012-2013 Roland Yonaba

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
