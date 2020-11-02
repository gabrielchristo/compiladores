%{
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <vector>
#include <map>
#include <algorithm>
using namespace std;
typedef vector<string> strList;

struct Atributos {
  strList c; // token
  int l; // linha
};
#define YYSTYPE Atributos

int yylex();
int yyparse();
void yyerror(const char *);

strList concatena(strList a, strList b);
strList operator+(strList a, strList b);
strList operator+(strList a, string b);

string gera_label(string prefixo);

void print(strList source);
strList resolve_enderecos(strList entrada);

strList novo;
int linha = 1, coluna = 1;
int token(int tk);

void generate_var(Atributos var);
void check_var(Atributos var);
map<string, int> vars;

%}

%token TK_NUM TK_ID TK_LET TK_IF TK_ELSE TK_WHILE TK_FOR TK_STR TK_ARRAY TK_OBJECT
%token TK_MAIOR TK_MENOR TK_MEIG TK_MAIG TK_IGUAL TK_DIFF

%start S // simbolo inicial da gramatica

// nonassoc '<' '>'


// jump/definir endereço para if

/*
if(a>b)
  c=a;
print(c);

a@
b@
> !
:end_if_1 ?
c a@ = ^
:end_if_1:
c@ 1 print $

*/

%%

S : CMDs  { print( resolve_enderecos($1.c) ); }
  ;

CMDs : CMD ';' CMDs   { $$.c = $1.c + $3.c; }
     |                { $$.c = novo; }
     ;

CMD : A                     { $$.c = $1.c + "^"; }
    | TK_LET DECLVARS       { $$ = $2; }
    | TK_IF '(' R ')' CMD   { string endif = gera_label("end_if");
                              $$.c = $3.c + "!" + endif + "?" + $5.c + (":" + endif); }
    ;

DECLVARS : DECLVAR ',' DECLVARS  { $$.c = $1.c + $3.c; }
         | DECLVAR               { $$ = $1; }
         ;

DECLVAR : TK_ID '=' R  { generate_var($1); $$.c = $1.c + "&" + $1.c + $3.c + "=" + "^"; }
        | TK_ID        { generate_var($1); $$.c = $1.c + "&"; }
        ;

A : TK_ID '=' A   { check_var($1); $$.c = $1.c + $3.c + "="; }
  | R             { $$ = $1; }
  ;

R : E TK_MENOR E       { $$.c = $1.c + $3.c + "<"; }
  | E TK_MAIOR E       { $$.c = $1.c + $3.c + ">"; }
  | E TK_IGUAL E       { $$.c = $1.c + $3.c + "=="; }
  | E                  { $$ = $1; }
  ;

E : E '+' T { $$.c = $1.c + $3.c + "+"; }
  | E '-' T { $$.c = $1.c + $3.c + "-"; }
  | T       { $$ = $1; }
  ;

T : T '*' F { $$.c = $1.c + $3.c + "*"; }
  | T '/' F { $$.c = $1.c + $3.c + "/"; }
  | F       { $$ = $1; }

F : TK_ID          { $$.c = $1.c + "@"; }
  | TK_NUM         { $$.c = $1.c; }
  | TK_STR         { $$.c = $1.c; }
  | '(' E ')'      { $$ = $2; }
  | TK_OBJECT      { $$.c = novo + $1.c; }
  | TK_ARRAY       { $$.c = novo + $1.c; }
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

void generate_var(Atributos var){
  if(vars.count(var.c.back()) == 0){
	vars[var.c.back()] = var.l;
  }
  else {
	cout << "Erro: a variável '" << var.c.back() << "' já foi declarada na linha " << vars[var.c.back()] << "." << endl;
	exit(1);
  }
}

void check_var(Atributos var){
  if(vars.count(var.c.back()) == 0){
	cout << "Erro: a variável '" << var.c.back() << "' não foi declarada." << endl;
	exit(1);
  }
}

string gera_label(string prefixo){
  static int n = 0;
  return prefixo + "_" + to_string(++n) + ":";
}

void print(strList source){
  for(int i(0); i < source.size(); i++) cout << source[i] << endl;
  cout << "." << endl;
}

strList resolve_enderecos(strList entrada) {
  map<string,int> label;
  vector<string> saida;
  for( int i = 0; i < entrada.size(); i++ ) 
    if( entrada[i][0] == ':' ) 
        label[entrada[i].substr(1)] = saida.size();
    else
      saida.push_back( entrada[i] );
  
  for( int i = 0; i < saida.size(); i++ ) 
    if( label.count( saida[i] ) > 0 )
        saida[i] = to_string(label[saida[i]]);
    
  return saida;
}

void yyerror( const char* st ) {
   puts( st ); 
   printf( "Proximo a: %s, linha: %d, coluna: %d\n", yytext, linha, coluna);
   exit( 1 );
}

int token(int tk) {
    yylval.c = novo + yytext;
    yylval.l = linha;
    coluna += strlen(yytext);
    return tk;
}

int main( int argc, char** argv ) {
  yyparse();
  return 0;
}