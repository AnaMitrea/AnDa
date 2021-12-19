%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}
%token STARTD FINISHD
%token STARTI FINISHI
%token ASSIGN TIP CONST NR NR_decimal IDvar IDclass IDvar_class IDarr IDfun Function 
%token FORstmt to_FOR with_FOR
%token WHILEstmt IFstmt ELSIF ELS
%token MINUS PLUS DIV PROD
%token LS GE LEQ GEQ AND OR EQEQ NEQ

%left MINUS PLUS
%left DIV PROD

%start progr
%%
progr: bloc_d bloc_i {printf("\nProgram corect sintactic!\n\n");}
     ;
/* Blocul de declaratii */
bloc_d : STARTD declaratie FINISHD
       | STARTD FINISHD
       ;


declaratie     : TIP lista_arr ';' 
               | lista_arr ';'
               | TIP lista ';' 
               | CONST TIP lista ';'
               | functie 
               | declaratie TIP lista ';'
               | declaratie CONST TIP lista ';'
               | declaratie TIP lista_arr ';'
               | declaratie lista_arr ';'
               | declaratie functie
               ;

functie        : Function IDfun '(' ')' '{' instructiuni '}' 
               ;

apelFunctie    : IDfun '(' ')'
               ;

lista     : IDvar
          | IDvar ASSIGN exp
          | lista ',' IDvar
          | lista ',' IDvar ASSIGN termen
          ;

lista_arr : IDarr
          | IDarr ASSIGN termen
          ;

/* Expresii */
exp       : termen            /*{$$ = $1;}*/
          | exp PLUS termen    /*{$$ = $1 + $3;}*/
          | exp MINUS termen    /*{$$ = $1 - $3;}*/
          | exp PROD termen    /*{$$ = $1 * $3;}*/
          | exp DIV termen    /*{$$ = $1 / $3;}*/
          | exp ASSIGN termen
          ;

termen    : IDvar             
          | NR                /*{$$ = $1;}*/
          | NR_decimal        /*{$$ = $1;}*/
          | IDarr
          ;

/* Blocul de instructiuni */
bloc_i : STARTI instructiuni FINISHI
     ;

/* instructiuni */
instructiuni   : instructiuni ';'
               | instructiuni lista ';'
               | lista ';'
               | instructiuni lista_arr ';'
               | lista_arr ';'
               | instructiuni apelFunctie ';'
               | apelFunctie ';'
               | instructiuni FORstatement 
               | FORstatement
               | instructiuni WHILEstatement
               | WHILEstatement
               | instructiuni IFstatement
               | IFstatement
               ;

FORstatement   : FORstmt '(' exp to_FOR termen with_FOR termen ')' ':' ':' '{' instructiuni '}'
               ;

WHILEstatement : WHILEstmt '(' conditie ')' ':' ':' '{' instructiuni '}'
               ;

IFstatement    : IFstmt '(' conditie ')' ':' ':' '{' instructiuni '}'
               | IFstmt '(' conditie ')' ':' ':' '{' instructiuni '}' ELSIF '(' conditie ')' ':' ':' '{' instructiuni '}'
               | IFstmt '(' conditie ')' ':' ':' '{' instructiuni '}' ELSIF '(' conditie ')' ':' ':' '{' instructiuni '}' ELS ':' ':' '{' instructiuni '}'
               | IFstmt '(' conditie ')' ':' ':' '{' instructiuni '}' ELS ':' ':' '{' instructiuni '}'
               ;

conditie       : termen
               | conditie LS termen
               | conditie GE termen
               | conditie LEQ termen
               | conditie GEQ termen
               | conditie AND termen
               | conditie OR termen
               | conditie EQEQ termen
               | conditie NEQ termen
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