%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}
%token START FINISH
%token ASSIGN TIP CONST NR NR_decimal IDvar IDclass IDfun Function
%token MINUS PLUS DIV PROD

%left MINUS PLUS
%left DIV PROD

%start progr
%%
progr: declaratii_globale bloc {printf("\nProgram corect sintactic!\n\n");}
     ;

/* Declaratii globale inainte de blocul de instructiuni */
declaratii_globale  :  declaratii_globale declaratie 
                    |  declaratie 
	               ;

declaratie     : TIP lista ';'
               | CONST TIP lista ';'
               | functie
               ;

functie        : Function IDfun '(' ')' ';'
               | Function IDfun '(' ')' '{' instructiuni '}'
               ;

apelFunctie    : IDfun '(' ')'
               ;

lista     : IDvar
          | IDvar ASSIGN exp
          | lista ',' IDvar
          | lista ',' IDvar ASSIGN NR
          | lista ',' IDvar ASSIGN NR_decimal
          | lista ',' IDvar ASSIGN IDvar
          ;

/* Expresii */
exp       : termen            /*{$$ = $1;}*/
          | exp PLUS termen    /*{$$ = $1 + $3;}*/
          | exp MINUS termen    /*{$$ = $1 - $3;}*/
          | exp PROD termen    /*{$$ = $1 * $3;}*/
          | exp DIV termen    /*{$$ = $1 / $3;}*/
          ;

termen    : IDvar             
          | NR                /*{$$ = $1;}*/
          | NR_decimal        /*{$$ = $1;}*/
          ;

/* Blocul de instructiuni */
bloc : START instructiuni FINISH
     ;

/* instructiuni */
instructiuni   : instructiuni declaratie
               | declaratie
               | instructiuni lista ';'
               | lista ';'
               | instructiuni apelFunctie ';'
               | apelFunctie ';'
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