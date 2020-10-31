DELIM   [\t\n ]
DIGITO  [0-9]
LETRA   [A-Za-z_]
DOUBLE  {DIGITO}+("."{DIGITO}+)?
ID      {LETRA}({LETRA}|{DIGITO})*

%%

{DELIM}    { }

             
{DOUBLE}   { yylval.c = yytext; 
             return NUM; }

"let"	   { yylval.c = "x"; 
             return LET; }

{ID}       { yylval.c = yytext; 
             return ID; }

.          { yylval.c = yytext;
	     return yytext[0]; }

%%