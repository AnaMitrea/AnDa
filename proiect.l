%{

#include <stdio.h>
#include "y.tab.h"
%}
%option noyywrap
%%

"start"     {return START;}
"finish"    {return FINISH;}
"int"|"float"|"char"|"string"|"bool" {return TIP;}
"Function"                           {return Function;}
"const"                              {return CONST;}
"->"    {return ASSIGN;}

"+"     {return PLUS;}
"-"     {return MINUS;}
"*"     {return PROD;}
"/"     {return DIV;}

#[_a-zA-Z][_a-zA-Z0-9]*         {return IDvar;}
@[_a-zA-Z][_a-zA-Z0-9]*         {return IDclass;}
$[_a-zA-Z][_a-zA-Z0-9]*         {return IDfun;}
[0]|[-]?[1-9][0-9]*             {return NR;}
[0]|[-]?[1-9][0-9]*[.][0-9]+    {return NR_decimal;} /*nr cu virgula*/
[ \t]                           ;
\n                              {yylineno++;}
.                               {return yytext[0];}
%%