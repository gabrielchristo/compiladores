%{
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>

using namespace std;

struct Atributos {
  string c;
};

#define YYSTYPE Atributos

int yylex();
int yyparse();
void yyerror(const char *);

%}

%token NUM ID LET

// Start indica o símbolo inicial da gramática
%start S

%%

S : CMDs { cout << $1.c << "." << endl; }
  ;

CMDs : CMD ';' CMDs   { $$.c = $1.c + "\n" + $3.c; }
     | { $$.c = ""; }
     ;

CMD : A
    | LET ID '=' E { $$.c = $2.c + " & " + $2.c + " "  + $4.c + " = ^"; }
    | LET ID       { $$.c = $2.c + " &"; }
    ;

A : ID '=' E { $$.c = $1.c + " " + $3.c + " = ^"; }
  ;

E : E '+' T { $$.c = $1.c + " " + $3.c + " +"; }
  | E '-' T { $$.c = $1.c + " " + $3.c + " -"; }
  | T
  ;

T : T '*' F { $$.c = $1.c + " " + $3.c + " *"; }
  | T '/' F { $$.c = $1.c + " " + $3.c + " /"; }
  | F

F : ID          { $$.c = $1.c + " @"; }
  | NUM         { $$.c = $1.c; }
  | '(' E ')'   { $$ = $2; }
  ;

%%

#include "lex.yy.c"

void yyerror( const char* st ) {
   puts( st ); 
   printf( "Proximo a: %s\n", yytext );
   exit( 1 );
}

int main( int argc, char* argv[] ) {
  yyparse();
  
  return 0;
}