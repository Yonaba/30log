Benchmark results
==================

## Configuration

````
Processor: Intel(R) Core(TM) i3-3110M CPU @ 2.40GHz (4 CPUs), ~2.4GHz
Memory: 4096MB RAM
Platform : x64
````

## Results (Lua 5.1.4)

````
>> lua performance\tests.lua 30log
````

````
01. Creating a class (100000x): 0.510s 0006 kiB
02. Creating an instance (function call style) (100000x): 0.610s 0000 kiB
03. Creating an instance (using new()) (100000x): 0.603s 0002 kiB
04. Direct access to instance attribute (100000x): 0.007s 003 kiB
05. Accessing instance attribute through getter (100000x): 0.015s 0000 kiB
06. Accessing instance attribute through setter (100000x): 0.015s 0000 kiB
07. Extending from a class (100000x): 0.653s 0000 kiB
08. Indexing inherited attribute (1-lvl depth) (100000x): 0.008s 002 kiB
09. Calling inherited method (1-lvl depth) (100000x): 0.015s 0000 kiB
10. Calling inherited setter method (1-lvl depth) (100000x): 0.015s 0000 kiB
````


## Results (LuaJit 2.0.0-b8 / Lua 5.1.4)

````
>> luajit performance\tests.lua 30log
````

````
01. Creating a class (100000x): 0.173s 002 kiB
02. Creating an instance (function call style) (100000x): 0.188s 0007 kiB
03. Creating an instance (using new()) (100000x): 0.184s 001 kiB
04. Direct access to instance attribute (100000x): 0.003s 002 kiB
05. Accessing instance attribute through getter (100000x): 0.005s 0000 kiB
06. Accessing instance attribute through setter (100000x): 0.006s 0000 kiB
07. Extending from a class (100000x): 0.209s 0005 kiB
08. Indexing inherited attribute (1-lvl depth) (100000x): 0.003s 005 kiB
09. Calling inherited method (1-lvl depth) (100000x): 0.006s 0000 kiB
10. Calling inherited setter method (1-lvl depth) (100000x): 0.005s 0000 kiB
````


## Results (Lua 5.2.1)

````
>> lua performance\tests.lua 30log
````

````
01. Creating a class (100000x): 0.363s 001 kiB
02. Creating an instance (function call style) (100000x): 0.662s 0009 kiB
03. Creating an instance (using new()) (100000x): 0.670s 001 kiB
04. Direct access to instance attribute (100000x): 0.006s 001 kiB
05. Accessing instance attribute through getter (100000x): 0.014s 001 kiB
06. Accessing instance attribute through setter (100000x): 0.017s 001 kiB
07. Extending from a class (100000x): 0.686s 0000 kiB
08. Indexing inherited attribute (1-lvl depth) (100000x): 0.005s 001 kiB
09. Calling inherited method (1-lvl depth) (100000x): 0.014s 001 kiB
10. Calling inherited setter method (1-lvl depth) (100000x): 0.018s 001 kiB
````