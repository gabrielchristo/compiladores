/* Coloque aqui definições regulares */
D [0-9]
L [A-Za-z_]
S [$]
WS	[ \t\n]
INT {D}+
FLOAT {INT}("."{INT})?([Ee]("+"|"-")?{INT})?
FOR [Ff][Oo][Rr]
IF [Ii][Ff]
ID ({L}|{S})({L}|{D}|{S})*

/* definição de string */
QUOTE [\"]
DOUBLE_QUOTE ({QUOTE}{QUOTE})
STR {QUOTE}({DOUBLE_QUOTE}|\\{QUOTE}|[^\n\"])*{QUOTE}

/* definição de comentário */
TYPE_1 (\/\/)[^\n]*
TYPE_2 (\/\*)[^(\/\/)]*(\*\/)
CMNT {TYPE_1}|{TYPE_2}

%%
    /* Padrões e ações. Nesta seção, comentários devem ter um tab antes */
{WS} { /* ignora espaços, tabs e '\n' */ }
{INT} {return _INT;}
{FLOAT} {return _FLOAT;}

	/* Palavras reservadas devem ser colocadas antes de ID para evitar conflito */
{IF} {return _IF;}
{FOR} {return _FOR;}
{ID} {return _ID;}
{STR} {return _STRING;}
{CMNT} {return _COMENTARIO;}

	/* Relacionais */
">=" {return _MAIG;}
"<=" {return _MEIG;}
"==" {return _IG;}
"!=" {return _DIF;}

.       { return *yytext; 
          /* Essa deve ser a última regra. Dessa forma qualquer caractere isolado será retornado pelo seu código ascii. */ }

%%

/* Não coloque nada aqui - a função main é automaticamente incluída na hora de avaliar e dar a nota. */