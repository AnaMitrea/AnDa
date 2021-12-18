%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}
%token START FINISH
%token ASSIGN TIP ID NR CONST


%start progr
%%
progr: declaratii_globale bloc {printf("Program corect sintactic!\n");}
     ;

/* declaratii globale inainte de blocul de instructiuni */
declaratii_globale  :  declaratii_globale declaratie 
                    |  declaratie 
	               ;

declaratie     : TIP lista ';'
               | CONST TIP lista ';'
               ;

lista     : ID
          | ID ASSIGN NR
          | lista ',' ID
          | lista ',' ID ASSIGN NR
          | lista ',' ID ASSIGN ID
          ;

/* blocul de instructiuni */
bloc : START instructiuni FINISH
     ;

/* instructiuni */
instructiuni   : statement ';'
               | instructiuni statement ';'
               ;

statement      : ID ASSIGN NR
               | ID ASSIGN ID
               ; 

%%
int yyerror(char * s){
     printf("eroare: %s la linia:%d\n",s,yylineno);
}
int main(int argc, char** argv){
     yyin=fopen(argv[1],"r");
     yyparse();
} 