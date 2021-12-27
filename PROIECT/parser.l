%{
    #include <stdio.h>
    #include "y.tab.h"
%}
%option noyywrap

alpha [a-zA-Z]
digit [0-9]
incr "++"
decr "--"

%%

"start_global"              { return STARTGLOBAL; }
"end_global"                { return ENDGLOBAL; }
"start_functions"           { return STARTFUNCTIONS; }
"end_functions"             { return ENDFUNCTIONS; }
"start_program"             { return STARTPROGRAM; }
"end_program"               { return ENDPROGRAM; }

"print"                     { return PRINT; }
"function"                  { return FUNCTION; }
"const"                     { return CONST; }
"int"|"float"|"char"|"bool" { yylval.str = strdup(yytext); return DATATYPE; }
"void"                      { return VOID; }
"string"                    { return STRING; }
"return"                    { return RETURN; }
"for"	                    { return FOR; }
"if"	                    { return IF; }
"while"                     { return WHILE; }
"else"	                    { return ELSE; }
"->"                        { return ASSIGN; }

"TRUE"|"FALSE"              { return BOOL_VALUE; }

"<="                        { return LE; }
">="                        { return GE; }
"=="                        { return EQ; }
"!="                        { return NE; }
">"	                        { return GT; }
"<"	                        { return LT; }
"&&"	                    { return AND; }
"||"	                    { return OR; }
"+"                         { return PLUS; }
"-"                         { return MINUS; }
"/"                         { return DIV; }
"*"                         { return PROD; }
"::"                        { return DOUBLE; }

[-]?{digit}+                                { yylval.intnum = atoi(yytext); return NUMBER; }
[-]?{digit}+\.{digit}{1,2}                  { yylval.flnum = atof(yytext); return FLOAT_NUM; }
["].*["]                                    { yylval.str = strdup(yytext); return STR; }
['].[']                                     { return CHARACTER; }
{alpha}({alpha}|{digit})*                   { yylval.str = strdup(yytext); return ID; }
"++"|"--"                                   { yylval.str = strdup(yytext); return UNARY; }

\/\/.*                      { ; }
\/\*(.*\n)*.*\*\/           { ; } 
[ \t]                        ;
\n                          {yylineno++;}
.                           {return yytext[0];}
%%
