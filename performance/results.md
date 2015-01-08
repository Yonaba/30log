Benchmark results
==================

### Configuration

````
Processor: Intel(R) Core(TM) i3-3110M CPU @ 2.40GHz (4 CPUs), ~2.4GHz
Memory: 4096MB RAM
Platform : x64
````

### Results (Lua 5.1.4)

````
>> lua performance\test.lua 30log
````

````
01. Creating a class.................................. (100000 x): 0588 ms
02. Creating an instance (function call style)........ (100000 x): 0298 ms
03. Creating an instance (using new())................ (100000 x): 0317 ms
04. Direct access to instance attribute............... (100000 x): 0010 ms
05. Accessing instance attribute through getter....... (100000 x): 0019 ms
06. Accessing instance attribute through setter....... (100000 x): 0016 ms
07. Extending from a class............................ (100000 x): 0853 ms
08. Indexing inherited attribute (3-lvl depth)........ (100000 x): 0010 ms
09. Calling inherited method (3-lvl depth)............ (100000 x): 0018 ms
10. Calling inherited setter method (3-lvl depth)..... (100000 x): 0018 ms
````