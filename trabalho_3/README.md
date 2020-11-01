## Trabalho 3 - Compilador de mini javascript ##

```
flex mini_js.l
bison mini_js.y
g++ -Wall mini_js.tab.c -lfl -o mini
```

Note: using [modified version of bison](http://marin.jb.free.fr/bison/) due to a bug