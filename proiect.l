%{

#include <stdio.h>
#include "y.tab.h"
%}

%option noyywrap

%%

"start" {return START;}
"finish" {return FINISH;}

"int"|"float"|"char"|"string"|"bool" {return TIP;}
"const"                              {return CONST;}

"->" {return ASSIGN;}

"+"     {return PLUS;}
"-"     {return MINUS;}
"="     {return EQUAL;}
"*"     {return PROD;}
"/"     {return DIV;}

"<"     {return LW;}
"<="    {return LEQ;}
">"     {return GE;}
">="    {return GEQ;}

"&&"    {return AND;}
"||"    {return OR;}
"=="    {return EQEQ;}

"IF"        {return IFstatement;}
"ELSIF"     {return ELSEIFstatement;}
"ELSE"      {return ELSEstatement;}
"WHILE"     {return WHILEstatement;}
"FOR"       {return FORstatement;}
"return"    {return RETURN;}

#[_a-zA-Z][_a-zA-Z0-9]*     {return ID;}
[0]|[-]?[1-9][0-9]*       {yylval.num = atoi(yytext); return NUM;}
[ \t]                       ;
[\n]                        {yylineno++;}
.                           {ECHO; yyerror("Unknown character"); printf("%s \n",yytext);}


%%
