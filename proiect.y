%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}
%token START FINISH
%token ASSIGN TIP CONST NR IDvar IDclass


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

lista     : IDvar
          | IDvar ASSIGN NR
          | IDvar ASSIGN IDvar
          | lista ',' IDvar
          | lista ',' IDvar ASSIGN NR
          | lista ',' IDvar ASSIGN IDvar
          ;

/* blocul de instructiuni */
bloc : START instructiuni FINISH
     ;

/* instructiuni */
instructiuni   : instructiuni declaratie
               | declaratie
               | instructiuni lista ';'
               | lista ';'
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