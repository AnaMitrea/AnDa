all:
	rm -f lex.yy.c
	rm -f y.tab.c
	rm -f parser
	rm -f symbol_table.txt
	rm -f symbol_table_functions.txt
	yacc -d parser.y
	lex parser.l
	gcc -Wno-implicit-function-declaration lex.yy.c y.tab.c -o parser
