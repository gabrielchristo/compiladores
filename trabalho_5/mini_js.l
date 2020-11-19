
DIGITO  [0-9]
LETRA   [A-Za-z_]
NUM     {DIGITO}+("."{DIGITO}+)?
ID      {LETRA}({LETRA}|{DIGITO})*
STR     (\"([^\"\n]|(\\\")|\"\")+\")|(\'([^\'\n]|(\\\')|\'\')+\')

%%

"\t"        { coluna += 4; }
"\n"        { linha++; coluna = 1; }
" "         { coluna++; }
{NUM}       { return token(TK_NUM); }
"+"         { return token(TK_PLUS); }
"-"         { return token(TK_MINUS); }
"*"         { return token(TK_MULT); }
"/"         { return token(TK_DIV); }
"%"         { return token(TK_MODULE); }
"=>"        { return token(TK_ARROW); }
"[<=]"      { return token(TK_LEFT_ARROW); }
"<="        { return token(TK_MEIG); }
">="        { return token(TK_MAIG); }
"<"         { return token(TK_MENOR); }
">"         { return token(TK_MAIOR); }
"=="        { return token(TK_IGUAL); }
"!="        { return token(TK_DIFF); }
"&&"        { return token(TK_AND); }
"||"        { return token(TK_OR); }
"if"        { return token(TK_IF); }
"else"      { return token(TK_ELSE); }
"while"     { return token(TK_WHILE); }
"for"       { return token(TK_FOR); }
"let"	    { return token(TK_LET); }
"function"  { return token(TK_FUNCTION); }
"return"    { return token(TK_RETURN); }
"true"      { return token(TK_BOOLEAN); }
"false"     { return token(TK_BOOLEAN); }
"[]"        { return token(TK_ARRAY); }
"{}"        { return token(TK_OBJECT); }
"{"         { return token(TK_OPENBRACE); }
"}"         { return token(TK_CLOSEBRACE); }

"asm{".*"}" {  
			   string lexema = trim(yytext + 3, "{}" );
               yylval.c = tokeniza(lexema);
               coluna += strlen(yytext); 
               return TK_ASM;
			}

{STR}       { return token(TK_STR); }
{ID}        { return token(TK_ID); }
.           { return token(*yytext); }

%%