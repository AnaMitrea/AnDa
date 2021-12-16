%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}
%token

%start program
%%

%%
int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}