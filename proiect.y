%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
%}
%token

%start program
%%

%%
int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}
