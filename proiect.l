%{

#include <stdio.h>

%}

%option noyywrap

%%

"int"|"float"|"char"|"string"|"bool" {return TIP;}
"const"                              {return CONST;}

"start" {return START;}
"finish" {return FINISH;}

#[_a-zA-Z][_a-zA-Z0-9]* {return ID;}

"->" {return ASSIGN;}

"+"   {return PLUS;}
"-"   {return MINUS;}
"="   {return EQUAL;}
"*"   {return PROD;}
"/"   {return DIV;}
"<"   {return LS;}
">"   {return GE;}
"<="  {return LEQ;}
">="  {return GEQ;}
"&&"  {return AND;}
"||"  {return OR;}
"=="  {return EQEQ;}

"IF"        {return IFstatement;}
"ELSIF"     {return ELSEIFstatement;}
"ELSE"      {return ELSEstatement;}
"WHILE"     {return WHILEstatement;}
"FOR"       {return FORstatement;}
"return"    {return RETURN;}

[ \t]   ;
[\n]    {yylineno++;}

%%

int yywrap()
{
    return 1;
}