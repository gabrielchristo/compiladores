%{
	// bloco de declarações
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <map>

using namespace std;

enum TOKEN { _ID = 256, _INT, _FLOAT, _STR, _PRINT};
map<int,string> nome_tokens = {
  { _INT, "int" },
  { _FLOAT, "float" },
  { _ID, "identificador" },
  { _STR, "string" },
  { _PRINT, "metodo print" },
};

	// globais
int token;
string nome_token(int);
void casa(int);

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

// print message on stdout
void showMsg(string str){
	cout << str << " ";
}

int main(){
  
  while((token = yylex()) != 0)
  {
		A();
  }
  
  return 0;
}

// atribuicao inicial
void A(){
    switch(token){
        case _PRINT:
            casa(_PRINT);
            E();
            showMsg("print #");
			break;
        
        case _ID:
            showMsg(yytext);
			casa(_ID);
			casa('=');
			E();
			showMsg("=");
			break;
    }
}

void E(){
    T();
    E_linha();
}

// operadores +-
void E_linha(){
    switch(token){
        case '+':
            casa('+'); T(); showMsg("+"); E_linha();
			break;

        case '-':
            casa('-'); T(); showMsg("-"); E_linha();
			break;
    }
}

void T(){
    F();
    T_linha();
}

// operadores * /
void T_linha(){
    switch(token){
        case '*':
            casa('*'); F(); showMsg("*"); T_linha();
			break;

        case '/':
            casa ('/'); F(); showMsg("/"); T_linha();
			break;
    }
}

// terminais
void F(){
    switch(token){
	
        case _ID:{
			string tempID = (string)yytext;
            casa(_ID);
			// se proximo token for abertura de parenteses eh chamada de funcao
			if(*yytext == '('){
				casa('(');
				E();
				// se achar virgula tem mais parametros
				if(*yytext == ','){
					casa(',');
					E();
				}
				casa(')');
				showMsg(tempID + " #");
			}
			// caso contrario eh identificador
			else showMsg(tempID + " @");
			break;
		}

        case _INT:
            showMsg(yytext);
            casa(_INT);
			break;

        case _FLOAT:
            showMsg(yytext);
            casa(_FLOAT);
			break;

        case _STR:
            showMsg(yytext);
            casa(_STR);
			break;

        case '(':
            casa('(');
            E();
            casa(')');
			break;
    }
}
