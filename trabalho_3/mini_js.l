
DIGITO  [0-9]
LETRA   [A-Za-z_]
INT     {DIGITO}+
DOUBLE  {DIGITO}+("."{DIGITO}+)?
ID      {LETRA}({LETRA}|{DIGITO})*

/* definição de string */
QUOTE [\"\']
DOUBLE_QUOTE ({QUOTE}{QUOTE})
STR {QUOTE}({DOUBLE_QUOTE}|\\{QUOTE}|[^\n\"])*{QUOTE}

%%

"\t"     { coluna += 4; }
"\n"     { linha++; coluna = 1; }
" "      { coluna++; }
{INT}    { return token(TK_NUM); } 
{DOUBLE} { return token(TK_NUM); }
"<"      { return token(TK_MENOR); }
">"      { return token(TK_MAIOR); }
"<="     { return token(TK_MEIG); }
">="     { return token(TK_MAIG); }
"=="     { return token(TK_IGUAL); }
"!="     { return token(TK_DIFF); }
"if"     { return token(TK_IF); }
"else"   { return token(TK_ELSE); }
"while"  { return token(TK_WHILE); }
"for"    { return token(TK_FOR); }
"let"	 { return token(TK_LET); }
"[]"     { return token(TK_ARRAY); }
"{}"     { return token(TK_OBJECT); }
{STR}    { return token(TK_STR); }
{ID}     { return token(TK_ID); }
.        { return token(*yytext); }

%%