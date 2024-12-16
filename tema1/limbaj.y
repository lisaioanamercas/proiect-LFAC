%{
#include <iostream>
#include <vector>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
extern int yylex();
void yyerror(const char * s);

%}

%union {
    char* stringVal;
    bool boolVal;
    char charVal;
    int intVal;
    float floatVal;
    struct array* arrayVal;
    class AST_value* astVal;
}

%token BGIN END ASSIGN NR 
%token<stringVal> ID ID_CLASS TYPE
%token<boolVal> BOOL
%token<charVal> CHAR
%token<intVal> INT
%token<floatVal> FLOAT
%token<stringVal> STRING
%token<stringVal> CONST 
%token ELSE WHILE FOR DO IF
%token<stringVal> COMPARE
%token AND OR
%token<stringVal> CLASS
%token CLASS_SECTION
%token VAR_SECT
%token FUN_SECT
%token INIT_SECT
%token GLOBALVAR_SECTION
%token GLOBALFUN_SECTION
%token<stringVal> PRINT
%token<stringVal> TYPEOF
%token '+'


%start progr

%left AND 
%left OR
%left COMPARE
%left '+'
%left '-'
%left '*' 
%left '/'
%left IF
%left ELSE

%%

progr: classSect globalvarSect globalfunSect main_block { 
    printf("The programme is correct!\n");
};

classSect: /* Optional class section */
            | CLASS_SECTION classDecl
            ;

classDecl: CLASS ID '{' block_class '}'
            ;

block_class: varSect funSect initSect
            ;

varSect: /* Optional variable section */
          | VAR_SECT declarations
          ;

funSect: /* Optional function section */
         | FUN_SECT fun_decl
         ;

fun_decl: TYPE ID '(' declaration_function ')' '{' block '}'
        | TYPE ID '(' ')' '{' block '}'
        ;


declaration_function: decl
                     | decl ',' declaration_function
                     ;

declarations: decl ';'
             | declarations decl ';'
             ;

decl: TYPE ID
    | TYPE ID ASSIGN expression
    | TYPE ID '[' INT ']'
    | CONST TYPE ID ASSIGN expression
    ;

expression: expression '+' expression
          | expression '-' expression
          | expression '*' expression
          | expression '/' expression
          | INT
          | ID
          | FLOAT
          | CHAR
          | BOOL
          | STRING
          ;


initSect: /* Optional initializer section */
          | INIT_SECT init
          ;

init: ID '(' ')' ';'
    ;

globalvarSect: /* Optional global variable section */
                | GLOBALVAR_SECTION declarations
                ;

globalfunSect: /* Optional global function section */
                | GLOBALFUN_SECTION fun_decl
                ;

main_block: BGIN block_list END
           ;

block_list: block_list list_element
          | list_element
          ;

list_element: statement ';'
            | control_statement ';'
            | decl ';'
            ;

statement: ID ASSIGN expression
          | function_call
          ;

function_call: ID '(' call_list ')'
            | PRINT '(' STRING ')' {
               printf("Printez: %s\n", $3);
            }
            | TYPEOF '(' expression ')'{
                printf("Typeof a fost apelat!");
            }
             ;

call_list: expression ',' call_list
         | expression
         | /* Empty */
         ;

control_statement: if_statement
                  | while_statement
                  | dowhile_statement
                  | for_statement
                  ;

if_statement: IF '(' boolean_expr ')' '{' block_list '}' else_statement
            ;

else_statement: /* Optional else block */
                | ELSE '{' block_list '}'
                ;

while_statement: WHILE '(' boolean_expr ')' '{' block_list '}'
                ;

dowhile_statement: DO '{' block_list '}' WHILE '(' boolean_expr ')'
                  ;

for_statement: FOR '(' for_assignment ')' '{' block_list '}'
              ;

for_assignment: ID ASSIGN INT ';' ID COMPARE INT ';' ID 
               ;

boolean_expr : '(' boolean_expr ')'
               | BOOL
             | boolean_expr AND boolean_expr
             | boolean_expr OR boolean_expr
             ;
block: block_list
     ;

%%
void yyerror(const char * s) {
    printf("Syntax error: %s at line %d\n", s, yylineno);
    printf("Last token: %s\n", yytext);  // Print the last token to help identify the issue
}

#include <fcntl.h>
#include <unistd.h>

int main(int argc, char** argv) {
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Error opening file");
        return 1;
    }

    yyparse();
    printf("Parsing completed successfully.\n");
    return 0;
}
