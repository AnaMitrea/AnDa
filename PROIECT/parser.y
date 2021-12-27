%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

extern FILE* yyin;
extern char* yytext;
extern int yylineno;

struct variables 
{
    char* data_type;
    int isConst;
    char* id_name;
    char* scope;
	int value;
    int hasValue;
    int line_no;
} symbol_table[100];

struct function
{
    char* type;
    char* func_name;
    char* args;
} symbol_table_functions[100];

int count = 0;
%}

%token STARTGLOBAL ENDGLOBAL STARTFUNCTIONS ENDFUNCTIONS STARTPROGRAM ENDPROGRAM VOID CHARACTER PRINT INT FLOAT CHAR CONST BOOL FOR IF WHILE ELSE NUMBER FLOAT_NUM ID LE GE EQ NE GT LT AND OR STR UNARY RETURN ASSIGN STRING FUNCTION DOUBLE PLUS MINUS DIV PROD BOOL_VALUE
%left PLUS MINUS
%left PROD DIV

%start prog
%%


prog : program { printf("\nProgram corect sintactic!\n\n"); }
;

program 
    : global functii main
    | functii main
    | global main
    | main
    ;

global
    : STARTGLOBAL DOUBLE declarari ENDGLOBAL
    ;

functii
    : STARTFUNCTIONS DOUBLE declarari ENDFUNCTIONS
    ;

main
    : STARTPROGRAM DOUBLE bodymain ENDPROGRAM
    ;

declarari
    : declarari declarare
    | declarare
    ;

declarare
    : datatype ID ';'
    | CONST datatype ID ';'
    | datatype ID ASSIGN NUMBER ';'
    | CONST datatype ID ASSIGN NUMBER ';'
    | datatype ID ASSIGN FLOAT_NUM ';'
    | CONST datatype ID ASSIGN FLOAT_NUM ';'
    | datatype ID ASSIGN ID ';'
    | CONST datatype ID ASSIGN ID ';'
    ;

datatype 
    : INT
    | FLOAT
    | CHAR
    | BOOL
    | STRING
    ;

bodymain
    : body_main
    | bodymain body_main
    ;

body_main
    : declarare
    | IF '(' conditie ')' DOUBLE '{' statement '}' els
    ;

els
    : ELSE DOUBLE '{' statement '}'
    | 
    ;

conditie
    : expresie LT expresie
    | expresie GT expresie
    | expresie LE expresie
    | expresie GE expresie
    | expresie EQ expresie
    | expresie NE expresie
    | '(' conditie AND conditie ')'
    | '(' conditie OR conditie ')'
    ;

statement
    : statement statements
    | statements
    ;

statements
    : ID UNARY ';'
    | UNARY ID ';'
    | ID ASSIGN expresie ';'
    | ID ASSIGN '(' expresie ')' ';'
    | ID ASSIGN conditie ';'
    | ID ASSIGN '(' conditie ')' ';'
    ;

expresie
    : expresie PLUS expresie
    | expresie MINUS expresie
    | expresie PROD expresie
    | expresie DIV expresie
    | NUMBER
    | FLOAT_NUM
    | ID
    ;


%%

int yyerror(char * s)
{
     printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv)
{
     yyin=fopen(argv[1],"r");
     yyparse();
}
