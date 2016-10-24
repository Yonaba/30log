#Version history#

##1.3.0 (10/24/16)
* Added `class:create`, which allocates a new instance without invoking the class initializer
* Added 30log-commons
* Updated specs

##1.2.0 (03/10/2016)
* Added `class:cast()`, changes the class of an instance

##1.1.0 (09/26/2016)
### New features
* Added `class:subclasses()` returns the list of all classes which extend from `class`
* Added `class:instances()`, returns the list of all instances of `class`
* Added `class:classOf()`, checks if `class` is a superclass of arg
* Added `class:subclassOf()`, checks if `class` is a subclass of arg
* Added `instance:instanceOf()`, checks if `instance` is an instance of arg
* Added `class:without()` to remove a mixin from a class
* Added `class:with()`, includes a mixin to a class

### Breaking changes
* Changed implementation of `class.isClass`, now only checks if arg is a class
* Changed implementation of `class.isInstance`, now only checks if arg is an instance
* Removed `class:include()`
* An instance of `class` is considered to be the instance of any superclass of `class`
* A class is considered to be the subclass of any of its direct superclass's superclasses

##1.0.0 (01/09/2015) 

### New features
* `require "30log"` now returns a callable table
* Added `class.isClass` 
* Added `class.isInstance`
* Adding mixins can be chained
* `subclass.super` returns the `superclass` of `subclass`
* `instance.class` returns the `class` of `instance`

### Breaking changes
* Changed `class` prototype to `class(name, params)`
* Renamed `class:__init()` to `class:init()`
* Renamed `class.__name` to `class.name`
* Renamed `class:extends()` to `class:extend`
* Renamed `class:is()` to `class:extends`
* Renamed `class:has()` to `class:includes`
* Changed `class:extend` prototype to `class:extend(name, params)`
* Changed `tostring(class)` and `tostring(instance)` output.


##0.9.1 (03/02/2014)
* Internal objects/classes registers made tables with weak keys.

##0.9.0 (02/07/2014)
* Added `class.is` and `instance.is` to inspect inheritance relationship between two objects.
* Removed spaces in class/instance tostring output.

##0.8.0 (01/11/2014)
* Mixins are now included with `include`, not `with`
* Objects (instances) cannot call `new`
* Shortened class/instances `__tostring` output (`class (?)` instead of `class (Unnamed)`)
* Bugfixes for `30logclean` (Thanks [zorfmorf](https://github.com/zorfmorf))
* Updated specification tests and README

##0.7.0 (01/05/2014)
* Fix for chained class extension attributes overriding when given a prototype (Thanks [Italo Maia](https://github.com/Yonaba/30log/issues/7))
* Updated specs
* Removed class-commons plugin, moved to [30logclasscommons](http://github.com/Yonaba/30logclasscommons)

##0.6.0 (08/08/2013)
* Added global source
* Made call to class methods available through initializers
* Made class attributes instantly available upon derivation
* Updated clean source
* Updated `Class Commons` compatibility to meet with the its specifications
* Added `Class Commons` test suite
* Updated specs
* Added performance benchmark
* 2 whitespaces as tabs, for indentation

##0.5.0 (06/13/2013)
* Added mixins
* Added clean source
* Updated Readme and specs tests

##0.4.1 (02/14/2013)
* named classes

##0.4.0 (02/13/2013)
* __init can either be a table or a function
* Added the abitlity to turn classes and objects into strings.

##0.3.0 (09/01/13)
* Added Class-Commons support (Thanks to [TsT2005](https://github.com/tst2005))
* Added Tracis-CI validation
* Updated Readme with chained initialization sample
* Updated specs

##0.2.1 (10/31/12)
* Added specs

##0.2.1 (10/04/12)
* Added local shortcuts to global functions internally used
* Typo fix in Readme's snippets

##0.2 (08/28/12)
* Now returns a local function when required. No longer pollutes the global env.
* Some code compression, to meet with the **30lines** rule!
* Added version history.
* Updated Readme

##0.1 (08/25/12)
* Initial Release
