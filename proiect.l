%{

#include <stdio.h>
#include "y.tab.h"
%}
%option noyywrap
%%

"start_d"     {return STARTD;}
"finish_d"    {return FINISHD;}
"start_i"     {return STARTI;}
"finish_i"    {return FINISHI;}
"int"|"float"|"char"|"string"|"bool" {return TIP;}
"Function"                           {return Function;}
"Class"                              {return Class;}
"const"                              {return CONST;}
"->"    {return ASSIGN;}

"+"     {return PLUS;}
"-"     {return MINUS;}
"*"     {return PROD;}
"/"     {return DIV;}

"<"     {return LS;}
">"     {return GE;}
"<="    {return LEQ;}
">="    {return GEQ;}
"&&"    {return AND;}
"||"    {return OR;}
"=="    {return EQEQ;}
"!="    {return NEQ;}

"FOR"   {return FORstmt;}
"to"    {return to_FOR;}
"with"  {return with_FOR;}

"WHILE"     {return WHILEstmt;}
"IF"        {return IFstmt;}
"ELSEIF"    {return ELSIF;}
"ELSE"      {return ELS;}

#[_a-zA-Z][_a-zA-Z0-9]*                 {return IDvar;}
%[_a-zA-Z][_a-zA-Z0-9]*"["[0-9][0-9]*"]" {return IDarr;}
@[_a-zA-Z][_a-zA-Z0-9]*                 {return IDclass;}
~[_a-zA-Z][_a-zA-Z0-9]*                 {return IDvar_class;}
$[_a-zA-Z][_a-zA-Z0-9]*                 {return IDfun;}


[0]|[-]?[1-9][0-9]*                     {return NR;}
[0]|[-]?[1-9][0-9]*[.][0-9]+            {return NR_decimal;} /*nr cu virgula*/
[ \t]                                   ;
\n                                      {yylineno++;}
.                                       {return yytext[0];}
%%
