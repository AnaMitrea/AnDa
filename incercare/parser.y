%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<ctype.h>

    
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
void add(char,char);
void insert_type();
    int search(char *);
    void insert_type();
   
struct dataType {
        char * id_name;
        char * data_type;
        char * type;
        char * scope;
        int line_no;
    } symbol_table[100];
    int q;
    char type[10];
    int count=0;
%}

%token  VOID CHARACTER PRINT SCANFF INT FLOAT CHAR BOOL FOR IF WHILE ELSE TRUE1 FALSE1 NUMBER FLOAT_NUM ID LE GE EQ NE GT LT AND OR STR UNARY RETURN ASSIGN STRING FUNCTION DOUBLE ADD MULTIPLY DIVIDE SUBTRACT
%left ADD SUBTRACT
%left MULTIPLY DIVIDE
%start program
%%

program: global '{' body special '}' {printf("\nProgram corect sintactic!\n\n");}
;

global:datatype ID { add('V','g'); } init ';'
| ID ASSIGN expression ';'
| FUNCTION datatype ID { add('F','g'); } '(' declarp ')' DOUBLE initf ';'
| global datatype ID { add('V','g'); } init ';'
| global ID ASSIGN expression ';'
| global FUNCTION datatype ID { add('F','g'); } '(' declarp ')' DOUBLE initf ';'
| '(' ')'
;

datatype: INT { insert_type(); }
| FLOAT { insert_type(); }
| CHAR { insert_type(); }
| VOID { insert_type(); }
| BOOL { insert_type(); }
| STRING {insert_type(); }
;

bodyf:FOR { add('K','f'); } '(' statement ';' condition ';' statement ')' DOUBLE '{' bodyf '}' 
| bodyf FOR { add('K','f');  } '(' statement ';' condition ';' statement ')' DOUBLE '{' bodyf '}' 
| IF { add('K','f'); } '(' conditionf ')' DOUBLE '{' bodyf '}' elsef 
| bodyf IF { add('K','f');  } '(' conditionf ')' DOUBLE '{' bodyf '}' elsef
| WHILE { add('K','b'); } '(' condition ')' DOUBLE '{' bodyf '}' 
| bodyf WHILE { add('K','b');  } '(' condition ')' DOUBLE '{' bodyf '}' 
| statementf ';' 
| bodyf statementf ';' 
| FUNCTION function ';'
| bodyf  FUNCTION function ';'
| toprint { add('K','f'); }  ';' 
| bodyf toprint { add('K','f');} ';'
| SCANFF '(' STR ',' '&' ID ')' ';' { add('K','f'); } 
| bodyf SCANFF '(' STR ',' '&' ID ')' ';' { add('K','f'); } 
;

elsef: ELSE { add('K','f'); } '{' body '}'
|
;

body:FOR { add('K','b'); } '(' statement ';' condition ';' statement ')' DOUBLE '{' body '}' 
| body FOR { add('K','b');  } '(' statement ';' condition ';' statement ')' DOUBLE '{' body '}' 
| IF { add('K','b'); } '(' condition ')' DOUBLE '{' body '}' else 
| body IF { add('K','b');  } '(' condition ')' DOUBLE '{' body '}' else 
| WHILE { add('K','b'); } '(' condition ')' DOUBLE '{' body '}' 
| body WHILE { add('K','b');  } '(' condition ')' DOUBLE '{' body '}' 
| statement ';' 
| body statement ';' 
| FUNCTION function ';'
| body FUNCTION function ';'
| toprint { add('K','b'); }  ';' 
| body toprint { add('K','b');} ';'
| SCANFF '(' STR ',' '&' ID ')' ';' { add('K','b'); } 
| body SCANFF '(' STR ',' '&' ID ')' ';' { add('K','b'); } 
;
toprint: PRINT '(' INT ',' expression ')' {printf("valoare e %d\n",$5); }
        | PRINT '(' CHAR ',' expression ')' {printf("valoare e %d\n",$5); }
        | PRINT '(' FLOAT ',' expression ')' {printf("valoare e %d\n",$5); }
        | PRINT '(' BOOL ',' expression ')' {printf("valoare e %d\n",$5); }
        ;
else: ELSE { add('K','b'); } '{' body '}'
|
;

condition: value relop value 
| TRUE1 { add('V','b'); }
| FALSE1 { add('V','b');  }
|
;

conditionf: valuef relop valuef 
| TRUE1 { add('V','f'); }
| FALSE1 { add('V','f');  }
|
;

statement: datatype ID { add('V','b'); } init 
| ID ASSIGN expression 
| ID relop expression 
| ID UNARY 
| UNARY ID 
;

statementf: datatype ID { add('V','f'); } initfu 
| ID ASSIGN expression 
| ID relop expression 
| ID UNARY 
| UNARY ID 
;

init: ASSIGN value 
|
;

initfu: ASSIGN valuef
|
;

function: datatype ID { add('F','b'); } '(' declarp ')' DOUBLE initf 
;

declarp: datatype ID { add('P','f'); }
| declarp ',' datatype ID { add('P','f'); }
|
;
initf: '{' bodyf '}' 
| '{' '}'
;


expression: expression ADD value {$$=$1+$3; }
| expression SUBTRACT value {$$=$1-$3; }
| expression MULTIPLY value {$$=$1*$3; }
| expression DIVIDE value {$$=$1/$3; }
| value 
;



relop: LT
| GT
| LE
| GE
| EQ
| NE
;


value: NUMBER { add('C','b'); $$=atoi(yytext); }
| FLOAT_NUM   { add('C','b'); $$=atof(yytext);}
| CHARACTER  { add('C','b');  $$=yytext[1];}
| STRING { add('C','b'); $$=strdup(yytext);}
| ID 
;

valuef: NUMBER { add('C','f');  }
| FLOAT_NUM   { add('C','f'); }
| CHARACTER  { add('C','f');  }
| STRING { add('C','f');}
| ID 
;

special: RETURN { add('F','s'); } value ';' 
| 
;

%%
int main(int argc, char** argv)
{
     yyin=fopen(argv[1],"r");
     FILE *f1,*f2;
     f1 = fopen("symbol_table.txt", "w");
     f2 = fopen("symbol_table_functions.txt", "w");
     if (f1 == NULL)
{
    printf("Error opening file!\n");
    exit(1);
}
    if (f2 == NULL)
{
    printf("Error opening file!\n");
    exit(1);
}
     yyparse();
	fprintf(f1,"\nSYMBOL   DATATYPE   TYPE   LINE NUMBER \n");
	fprintf(f1,"_______________________________________\n\n");
	int i=0;
	for(i=0; i<count; i++) {
	if((strstr(symbol_table[i].type,"Function"))||(strstr(symbol_table[i].scope,"function")))
		fprintf(f2,"%s\t%s\t%s\t%s\t%d\t\n", symbol_table[i].id_name, symbol_table[i].data_type, symbol_table[i].type,symbol_table[i].scope, symbol_table[i].line_no);
		else
		fprintf(f1,"%s\t%s\t%s\t%s\t%d\t\n", symbol_table[i].id_name, symbol_table[i].data_type, symbol_table[i].type,symbol_table[i].scope, symbol_table[i].line_no);
	}
	for(i=0;i<count;i++) {
		free(symbol_table[i].id_name);
		free(symbol_table[i].type);
		free(symbol_table[i].scope);
}
	fclose(f1);
	fclose(f2);
	
}

int search(char *type) {
	int i;
	for(i=count-1; i>=0; i--) {
		if(strcmp(symbol_table[i].id_name, type)==0) {
			return -1;
			break;
		}
	}
	return 0;
}

void add(char c1,char c2) {
  q=search(yytext);
  if(!q) {
		if(c1 == 'K') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup("N/A");
			symbol_table[count].line_no=yylineno;
			symbol_table[count].type=strdup("Keyword");
			if(c2=='g')
			{symbol_table[count].scope=strdup("global");
			}
			else
			if(c2=='b')
			{symbol_table[count].scope=strdup("body");
			}
			else
			if(c2=='s')
			{symbol_table[count].scope=strdup("special");
			}
			else
			if(c2=='f')
			{symbol_table[count].scope=strdup("function");
			}
			count++;
		}
		else if(c1 == 'V') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup(type);
			symbol_table[count].line_no=yylineno;
			symbol_table[count].type=strdup("Variable");
			if(c2=='g')
			{symbol_table[count].scope=strdup("global");
			}
			else
			if(c2=='b')
			{symbol_table[count].scope=strdup("body");
			}
			else
			if(c2=='s')
			{symbol_table[count].scope=strdup("special");
			}
			else
			if(c2=='f')
			{symbol_table[count].scope=strdup("function");
			}
			count++;
		}
		else if(c1 == 'P') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup(type);
			symbol_table[count].line_no=yylineno;
			symbol_table[count].type=strdup("Parameter");
			if(c2=='g')
			{symbol_table[count].scope=strdup("global");
			}
			else
			if(c2=='b')
			{symbol_table[count].scope=strdup("body");
			}
			else
			if(c2=='s')
			{symbol_table[count].scope=strdup("special");
			}
			else
			if(c2=='f')
			{symbol_table[count].scope=strdup("function");
			}
			count++;
		}
		else if(c1 == 'C') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup("CONST");
			symbol_table[count].line_no=yylineno;
			symbol_table[count].type=strdup("Constant");
			if(c2=='g')
			{symbol_table[count].scope=strdup("global");
			}
			else
			if(c2=='b')
			{symbol_table[count].scope=strdup("body");
			}
			else
			if(c2=='s')
			{symbol_table[count].scope=strdup("special");
			}
			else
			if(c2=='f')
			{symbol_table[count].scope=strdup("function");
			}
			count++;
		}
		else if(c1 == 'F') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup(type);
			symbol_table[count].line_no=yylineno;
			symbol_table[count].type=strdup("Function");
			if(c2=='g')
			{symbol_table[count].scope=strdup("global");
			}
			else
			if(c2=='b')
			{symbol_table[count].scope=strdup("body");
			}
			else
			if(c2=='s')
			{symbol_table[count].scope=strdup("special");
			}
			else
			if(c2=='f')
			{symbol_table[count].scope=strdup("function");
			}
			count++;
		}
	}
}

void insert_type() {
	strcpy(type, yytext);
}

int yyerror(char * s)
{
     printf("eroare: %s la linia:%d\n",s,yylineno);
}
