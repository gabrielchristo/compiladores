## Trabalho 3 - Compilador de mini javascript ##

```
flex mini_js.l
bison mini_js.y
g++ -Wall y.tab.c -lfl -o mini
```