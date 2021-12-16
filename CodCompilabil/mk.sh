#!/bin/bash
echo "compiling $1"
rm -f lex.yy.c
rm -f y.tab.c
rm -f $1
yacc -d $1.y
lex $1.l
gcc -Wno-implicit-function-declaration lex.yy.c y.tab.c -o $1
