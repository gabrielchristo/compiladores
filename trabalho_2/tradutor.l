%{
	// bloco de declarações
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <map>

using namespace std;

enum TOKEN { _ID = 256, _INT, _FLOAT, _STR, _PRINT };
map<int,string> nome_tokens = {
  { _INT, "int" },
  { _FLOAT, "float" },
  { _ID, "identificador" },
  { _STR, "string" },
  { _PRINT, "metodo print" }
};

	// globais
int token;
string nome_token(int);
void casa(int);

	// mapeando funcoes
//void print();
//typedef void (*FuncPtr)();
//map<string, FuncPtr> Funcoes = {
//	{"print", &print}
//};

	// metodos da gramatica
	void A();
    void E();
    void E_linha();
    void T();
    void T_linha();
    void F();

%}

	// definições regulares
WS	[ \n\t]
DIGITO	[0-9]
LETRA	[A-Za-z_]
INT	{DIGITO}+
FLOAT {INT}("."{INT})?([Ee]("+"|"-")?{INT})?
ID	{LETRA}({LETRA}|{DIGITO})*
	// definição de string
QUOTE [\"]
DOUBLE_QUOTE ({QUOTE}{QUOTE})
STR {QUOTE}({DOUBLE_QUOTE}|\\{QUOTE}|[^\n\"])*{QUOTE}

%%


	// Ações semanticas
{WS}    {/* ignora espaços, tabs e '\n' */}
{INT}   {return _INT;}
{FLOAT} {return _FLOAT;}
{STR}   {return _STR;}
"print" {return _PRINT;}
{ID}    {return _ID;}
.	    {return yytext[0];}

%%

	// Implementação do analisador sintático

// pega novo token da entrada
int next_token() {
  return yylex();
}

// casa com token esperado
void casa(int esperado){
    if(token == esperado){
        token = yylex();
    } else{
        cout << "Esperado" << nome_token(esperado) << " , encontrado: " << nome_token(token) << endl;
        exit(1);
    }
}

// map com nome dos tokens
string nome_token(int token){
    if(nome_tokens.find(token) != nome_tokens.end()){
        return nome_tokens[token];
    } else{
        string r;
        r = token;
        return r;
    }
}

int main(){

  //token = next_token();  
  // se token é igual a zero é o fim do programa
  //if( token == 0 ) cout << "Sintaxe ok" << endl;
  //else cout << "Caracteres encontrados apos o final do programa" << endl;
  
  while((token = next_token()) != 0)
  {
	//printf( "%d %s\n", token, yytext );
	A();
  }
  
  
  return 0;
}



























void A(){
    switch(token){
        case _PRINT:
            casa(_PRINT);
            F();
            cout << " print #";
			break;
        
        case _ID:
            cout << yytext;
            casa(_ID);
            casa('=');
            E();
            cout << " =";
            casa(';');
			break;
    }
}

void E(){
    T();
    E_linha();
}

void E_linha(){
    switch(token){
        case '+':
            casa('+');
            T();
            cout << " +";
            E_linha();
			break;

        case '-':
            casa('-');
            T();
            cout << " -";
            E_linha();
			break;
    }
}

void T(){
    F();
    T_linha();
}

void T_linha(){
    switch(token){
        case '*':
            casa('*');
            F();
            cout << " *";
            T_linha();
			break;

        case '/':
            casa ('/');
            F();
            cout << " /";
            T_linha();
			break;
    }
}

void F(){
    switch(token){
        case _ID:
            cout << yytext << " @";
            casa(_ID);
			break;

        case _INT:
            cout << yytext;
            casa(_INT);
			break;

        case _FLOAT:
            cout << yytext;
            casa(_FLOAT);
			break;

        case _STR:
            cout << yytext;
            casa(_STR);
			break;

        case '(':
            casa('(');
            E();
            casa(')');
			break;
    }
}