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
01. Creating a class (100000x): 0.513s 41438 kiB
02. Creating an instance (function call style) (100000x): 0.769s 61369 kiB
03. Creating an instance (using new()) (100000x): 0.654s 60345 kiB
04. Direct access to instance attribute (100000x): 0.007s 0000 kiB
05. Accessing instance attribute through getter (100000x): 0.016s 0000 kiB
06. Accessing instance attribute through setter (100000x): 0.017s 0000 kiB
07. Extending from a class (100000x): 0.711s 60345 kiB
08. Indexing inherited attribute (1-lvl depth) (100000x): 0.008s 0000 kiB
09. Calling inherited method (1-lvl depth) (100000x): 0.015s 0000 kiB
10. Calling inherited setter method (1-lvl depth) (100000x): 0.016s 0000 kiB
````


## Results (LuaJit 2.0.0-b8 / Lua 5.1.4)

````
>> luajit performance\tests.lua 30log
````

````
01. Creating a class (100000x): 0.332s 33844 kiB
02. Creating an instance (function call style) (100000x): 0.402s 47529 kiB
03. Creating an instance (using new()) (100000x): 0.543s 48041 kiB
04. Direct access to instance attribute (100000x): 0.003s 0000 kiB
05. Accessing instance attribute through getter (100000x): 0.006s 0000 kiB
06. Accessing instance attribute through setter (100000x): 0.005s 0000 kiB
07. Extending from a class (100000x): 0.663s 47017 kiB
08. Indexing inherited attribute (1-lvl depth) (100000x): 0.003s 0000 kiB
09. Calling inherited method (1-lvl depth) (100000x): 0.006s 0000 kiB
10. Calling inherited setter method (1-lvl depth) (100000x): 0.005s 0000 kiB
````


## Results (Lua 5.2.1)

````
>> lua performance\tests.lua 30log
````

````
01. Creating a class (100000x): 0.468s 48316 kiB
02. Creating an instance (function call style) (100000x): 0.822s 79580 kiB
03. Creating an instance (using new()) (100000x): 0.748s 80604 kiB
04. Direct access to instance attribute (100000x): 0.006s -001 kiB
05. Accessing instance attribute through getter (100000x): 0.014s -001 kiB
06. Accessing instance attribute through setter (100000x): 0.018s -001 kiB
07. Extending from a class (100000x): 0.768s 78556 kiB
08. Indexing inherited attribute (1-lvl depth) (100000x): 0.006s -001 kiB
09. Calling inherited method (1-lvl depth) (100000x): 0.014s -001 kiB
10. Calling inherited setter method (1-lvl depth) (100000x): 0.018s -001 kiB
````