%{
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <vector>
using namespace std;
typedef vector<string> strList;

struct Atributos {
  string c; // token
  int l; // linha
};
#define YYSTYPE Atributos

int yylex();
int yyparse();
void yyerror(const char *);

strList concatena(strList a, strList b);
strList operator+(strList a, strList b);
strList operator+(strList a, string b);

int linha = 1, coluna = 1;
int token(int tk);

%}

%token TK_NUM TK_ID TK_LET TK_IF TK_ELSE TK_WHILE TK_FOR TK_STR TK_ARRAY TK_OBJECT

%start S // simbolo inicial da gramatica

// jump/definir endereço para if

%%

S : CMDs  { cout << $1.c << "." << endl; }
  ;

CMDs : CMD ';' CMDs   { $$.c = $1.c + "\n" + $3.c; }
     |                { $$.c = ""; }
     ;

CMD : A               { $$ = $1; }
    | TK_LET DECLVARS { $$ = $2; }
    ;

DECLVARS : DECLVAR ',' DECLVARS  { $$.c = $1.c + " " + $3.c; }
         | DECLVAR               { $$ = $1; }
         ;

DECLVAR : TK_ID '=' E  { $$.c = $1.c + " & " + $1.c + " "  + $3.c + " = ^"; }
        | TK_ID        { $$.c = $1.c + " &"; }
        ;

A : TK_ID '=' E        { $$.c = $1.c + " " + $3.c + " = ^"; }
  ;

E : E '+' T { $$.c = $1.c + " " + $3.c + " +"; }
  | E '-' T { $$.c = $1.c + " " + $3.c + " -"; }
  | T
  ;

T : T '*' F { $$.c = $1.c + " " + $3.c + " *"; }
  | T '/' F { $$.c = $1.c + " " + $3.c + " /"; }
  | F

F : TK_ID          { $$.c = $1.c + " @"; }
  | TK_NUM         { $$.c = $1.c; }
  | TK_STR         { $$.c = $1.c; }
  | '(' E ')'      { $$ = $2; }
  | TK_OBJECT      { $$.c = $1.c; }
  | TK_ARRAY       { $$.c = $1.c; }
  ;

%%

#include "lex.yy.c"

strList concatena(strList a, strList b) {
  for(int i(0); i < b.size(); i++ ) a.push_back( b[i] );
  return a;
}

strList operator+(strList a, strList b) {
  return concatena(a, b);
}

strList operator+(strList a, string b) {
  a.push_back(b);
  return a;
}

void yyerror( const char* st ) {
   puts( st ); 
   printf( "Proximo a: %s, linha: %d, coluna: %d\n", yytext, linha, coluna);
   exit( 1 );
}

int token(int tk) {
    yylval.c = yytext;
    coluna += strlen(yytext);
    return tk;
}

int main( int argc, char** argv ) {
  yyparse();
  return 0;
}