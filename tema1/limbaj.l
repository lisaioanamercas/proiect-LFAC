%{
#include <stdio.h>
#include "limbaj.tab.h"

%}
%option noyywrap
%%
"class_section" {return CLASS_SECTION;}
"class" {yylval.stringVal = strdup(yytext); return CLASS; }
"var_section" {return VAR_SECT;}
"fun_section" {return FUN_SECT;}
"init_section" {return INIT_SECT;}

"globalvar_section" {return GLOBALVAR_SECTION;}
"globalfun_section" {return GLOBALFUN_SECTION;}

"int"|"float"|"char"|"string"|"bool"|"void" {yylval.stringVal = strdup(yytext); return TYPE;}

"Print" {return PRINT;}
"TypeOf" {return TYPEOF;}
"if" {return IF;}
"else" {return ELSE;}
"for" {return FOR;}
"while" {return WHILE;}
"do" {return DO;}
"<="|">="|"=="|"!="|"<"|">" {return COMPARE;}
"&&" {return AND;} 
"||" {return OR;}

"{" { return '{'; }
"}" { return '}'; }

"(" { return '('; }
")" { return ')'; }

"+" { return '+'; }


"begin_progr" {return BGIN;}
"end_progr" {return END;}

"true"|"false" {
    if(strcmp(yytext,"true") == 0) { yylval.boolVal = true; }
    else { yylval.boolVal = false; }
    return BOOL;
}

";" { return ';'; }  // Add semicolon token

'[a-zA-Z0-9 -=+()\/?;:'!@#$%^&]' {yylval.charVal = yytext[1]; return CHAR;}

[0-9]+\.[0-9]+ { yylval.floatVal = atof(yytext); return FLOAT; }

[1-9][0-9]|[0] {yylval.intVal = atoi(yytext); return INT;}

\"[^\"]*\" {
    yylval.stringVal = strdup(yytext);  // Copy the string literal
    return STRING;
}

[a-zA-Z][a-zA-Z0-9]* {yylval.stringVal = strdup(yytext); return ID;}

"=" {return ASSIGN;}
[0-9]+ {return NR;}
[ \t] ;
\n {yylineno++;}
.              { fprintf(stderr, "Caracter necunoscut: %s\n", yytext); }
%%