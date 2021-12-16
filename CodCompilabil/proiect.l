%{

#include <stdio.h>
#include "y.tab.h"
%}
%option noyywrap
%%

"start"     {return START;}
"finish"    {return FINISH;}
"int"|"float"|"char"|"string"|"bool" {return TIP;}
"const"                              {return CONST;}
"->"    {return ASSIGN;}
#[_a-zA-Z][_a-zA-Z0-9]*     {return ID;}
[0]|[-]?[1-9][0-9]*         {return NR;}
[ \t]                       ;
\n                          {yylineno++;}
.                           {return yytext[0];}
%%
//int yywrap(){return 1;}