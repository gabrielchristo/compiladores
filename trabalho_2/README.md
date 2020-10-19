## Trabalho 2 - Geração de forma intermediária

### Gramática utilizada

atribuição
```
A -> id { Print(id); } = E { Print("="); }
	| print { Print("print #");} E
```

operadores (com precedência)
```
E -> E + T { Print("+"); }
   | E - T { Print("-"); }
   | T
T -> T * F { Print("*"); }
   | T / F { Print("/"); }
   | F
```
   
terminais
```
F -> id { Print(id + "@"); }
   | num { Print(num); }
   | (E)
   | id(E, E)
   | id(E)
```
   
### Eliminando recursividade à esquerda
```
A -> A a | B, Se torna:

A -> B A'
A' -> a A' | e
```

### Gramática sem recursividade à esquerda

```
A -> id { Print( id ); } = E { Print( "="); }
	| print { Print("print #"); } E
	
E -> T E'
E' -> + T { Print( "+"); } E'
    | - T { Print( "-"); } E'
    | e
	
T -> F T'
T' -> * F { Print( "*"); } T'
    | / F { Print( "/"); } T'
    | e
	
F -> id { Print(id + "@"); }
   | num { Print( num ); }
   | (E)
   | id(E, E)
   | id(E)
```

### Rodando o código
```
flex tradutor.l
g++ -std=c++17 -Wall lex.yy.c -lfl -o output
```
