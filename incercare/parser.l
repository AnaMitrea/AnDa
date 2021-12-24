%{
    #include <stdio.h>
    #include "y.tab.h"
%}
%option noyywrap


alpha [a-zA-Z]
digit [0-9]
unary "++"|"--"

%%

"print"                    { return PRINT; }
"scanf"                     { return SCANFF; }
"function"                  { return FUNCTION; }
"int"                       { return INT; }
"float"                     { return FLOAT; }
"char"                      { return CHAR; }
"bool"                      { return BOOL; }
"void"                      { return VOID; }
"string"                    { return STRING; }
"return"                    { return RETURN; }
"for"	                    { return FOR; }
"if"	                    { return IF; }
"while"                     { return WHILE; }
"else"	                    { return ELSE; }
"true"                      { return TRUE1; }
"false"                     { return FALSE1; }
"->"                         { return ASSIGN; }
[-]?{digit}+                 { return NUMBER; }
[-]?{digit}+\.{digit}{1,6}  { return FLOAT_NUM; }
{alpha}({alpha}|{digit})*   { return ID; }
{unary}                     { return UNARY; }
"<="                        { return LE; }
">="                        { return GE; }
"=="                        { return EQ; }
"!="                        { return NE; }
">"	                    { return GT; }
"<"	                    { return LT; }
"&&"	                    { return AND; }
"||"	                    { return OR; }
"+"                         { return PLUS; }
"-"                         { return MINUS; }
"/"                         { return DIV; }
"*"                         { return PROD; }
"::"                        { return DOUBLE; }
\/\/.*                      { ; }
\/\*(.*\n)*.*\*\/           { ; } 
[ \t]                        ;
\n                          {yylineno++;}
.                           {return yytext[0];}
["].*["]                    { return STR; }
['].[']                     { return CHARACTER; }

%%

