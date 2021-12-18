all:
	clear
	rm -f lex.yy.c
	rm -f y.tab.c
	rm -f proiect
	yacc -d proiect.y
	lex proiect.l
	gcc -Wno-implicit-function-declaration lex.yy.c y.tab.c -o proiect
