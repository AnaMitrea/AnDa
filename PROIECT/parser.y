%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

extern FILE* yyin;
extern char* yytext;
extern int yylineno;

void declarare_fara_initializare(char* tip, char* nume, int constanta);
void declarare_cu_init_intnumar(char* tip, char* nume, int valoare, int constanta);
void declarare_cu_init_floatnumar(char* tip, char* nume, float valoare, int constanta);
void declarare_cu_init_variabila(char* tip, char* nume, char* var, int constanta);
void incrementare_decrementare(char* tip, char* nume, char* op);
int is_declared(char* tip, char* nume);

struct variables 
{
    char* data_type;
    int isConst;
    char* name;
    char* scope;
	float value;
    int hasValue;
    int line_no;
};
struct variables symbol_table[100];

struct function
{
    char* type;
    char* func_name;
    char* args;
};
struct function symbol_table_functions[100];

int count = 0;

int is_declared(char* tip, char* nume)
{
    for(int i = 0; i < count; i++)
    {
        if(strcmp(symbol_table[i].name,nume) == 0)
        {
            if(strcmp(symbol_table[i].data_type,tip) == 0)
            {
                return i;
            }
        }
    }
    return -1;
}

void declarare_fara_initializare(char* tip, char* nume, int constanta)
{
    if(is_declared(tip,nume) != -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabila \"%s\" este deja declarata.", nume);
        yyerror(errmsg);
        exit(0);
    }

    if(constanta == 1)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabila constanta \"%s\" trebuie initializata.", nume);
        yyerror(errmsg);
        exit(0);
    }

    symbol_table[count].name = strdup(nume);
    symbol_table[count].data_type = strdup(tip);
    symbol_table[count].isConst = 0;
    symbol_table[count].hasValue = 0;
    symbol_table[count].value = 999999;
    symbol_table[count].line_no = yylineno;

    count++;
}

void declarare_cu_init_intnumar(char* tip, char* nume, int valoare, int constanta)
{
    if(is_declared(tip,nume) != -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabila \"%s\" este deja declarata.", nume);
        yyerror(errmsg);
        exit(0);
    }

    symbol_table[count].name = strdup(nume);
    symbol_table[count].data_type = strdup(tip);
    symbol_table[count].isConst = constanta;
    symbol_table[count].hasValue = 1;
    symbol_table[count].value = valoare;
    symbol_table[count].line_no = yylineno;

    count++;
}

void declarare_cu_init_floatnumar(char* tip, char* nume, float valoare, int constanta)
{
    if(is_declared(tip,nume) != -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabila \"%s\" este deja declarata.", nume);
        yyerror(errmsg);
        exit(0);
    }

    symbol_table[count].name = strdup(nume);
    symbol_table[count].data_type = strdup(tip);
    symbol_table[count].isConst = constanta;
    symbol_table[count].hasValue = 1;
    symbol_table[count].value = valoare;
    symbol_table[count].line_no = yylineno;

    count++;
}


void declarare_cu_init_variabila(char* tip, char* nume, char* var, int constanta)
{
    if(is_declared(tip,nume) != -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabila \"%s\" este deja declarata.", nume);
        yyerror(errmsg);
        exit(0);
    }

    int decl = is_declared(tip,var);
    if(decl == -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabila \"%s\" nu este declarata si nu se poate asigna la \"%s\" sau nu corespunde tipul de date.", var, nume);
        yyerror(errmsg);
        exit(0);
    }

    if(symbol_table[decl].hasValue == 0)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabila \"%s\" nu are asignata nicio valoare.", var);
        yyerror(errmsg);
        exit(0);
    }

    symbol_table[count].name = strdup(nume);
    symbol_table[count].data_type = strdup(tip);
    symbol_table[count].isConst = constanta;
    symbol_table[count].hasValue = 1;
    symbol_table[count].value = symbol_table[decl].value;
    symbol_table[count].line_no = yylineno;

    count++;
}

void incrementare_decrementare(char* tip, char* nume, char* op)
{
    int decl = is_declared(tip,nume);
    if(decl == -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabila \"%s\" nu este declarata.", nume);
        yyerror(errmsg);
        exit(0);
    }

    if(strcmp(tip,"int") != 0)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabila \"%s\" nu este de tip int si nu se poate incrementa/decrementa.", nume);
        yyerror(errmsg);
        exit(0);
    }

    if(symbol_table[decl].isConst == 1)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabila \"%s\" este de tip const si nu se poate incrementa/decrementa.", nume);
        yyerror(errmsg);
        exit(0);
    }

    if(symbol_table[decl].hasValue == 0)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabila \"%s\" nu are valoare si nu se poate incrementa/decrementa.", nume);
        yyerror(errmsg);
        exit(0);
    }

    if(strcmp(op, "++") == 0)
        symbol_table[decl].value++;
    if(strcmp(op, "--") == 0)
        symbol_table[decl].value--;
}

%}

%union
{
    char* str;
    int intnum;
    float flnum;
}

%token STARTGLOBAL ENDGLOBAL STARTFUNCTIONS ENDFUNCTIONS STARTPROGRAM ENDPROGRAM VOID CHARACTER PRINT CONST STRING FOR IF WHILE ELSE LE GE EQ NE GT LT AND OR STR RETURN ASSIGN FUNCTION DOUBLE PLUS MINUS DIV PROD BOOL_VALUE
%token <str> ID DATATYPE UNARY
%token <intnum> NUMBER
%token <flnum> FLOAT_NUM

%left PLUS MINUS
%left PROD DIV
%left UNARY

%start prog

%%


prog : program { printf("\nProgram corect sintactic!\n\n"); }
;

program 
    : global functii main
    | functii main
    | global main
    | main
    ;

global
    : STARTGLOBAL DOUBLE declarari ENDGLOBAL
    ;

functii
    : STARTFUNCTIONS DOUBLE declarari ENDFUNCTIONS
    ;

main
    : STARTPROGRAM DOUBLE bodymain ENDPROGRAM
    ;

declarari
    : declarari declarare
    | declarare
    ;

declarare
    : DATATYPE ID ';'                               { declarare_fara_initializare($1,$2,0); }
    | CONST DATATYPE ID ';'                         { declarare_fara_initializare($2,$3,1); }
    | DATATYPE ID ASSIGN NUMBER ';'                 { declarare_cu_init_intnumar($1,$2,$4,0); }
    | CONST DATATYPE ID ASSIGN NUMBER ';'           { declarare_cu_init_intnumar($2,$3,$5,1); }
    | DATATYPE ID ASSIGN FLOAT_NUM ';'              { declarare_cu_init_floatnumar($1,$2,$4,0); }
    | CONST DATATYPE ID ASSIGN FLOAT_NUM ';'        { declarare_cu_init_floatnumar($2,$3,$5,1); }
    | DATATYPE ID ASSIGN ID ';'                     { declarare_cu_init_variabila($1,$2,$4,0); }
    | CONST DATATYPE ID ASSIGN ID ';'               { declarare_cu_init_variabila($2,$3,$5,1); }
    ;

bodymain
    : body_main
    | bodymain body_main
    ;

body_main
    : declarare
    | statements ';'
    | IF '(' conditie ')' DOUBLE '{' statement '}' els
    | WHILE '(' conditie ')' DOUBLE '{' statement '}'
    | FOR '(' statements conditie ';' statements ')' DOUBLE '{' statement '}'
    ;

els
    : ELSE DOUBLE '{' statement '}'
    | 
    ;

conditie
    : expresie LT expresie
    | expresie GT expresie
    | expresie LE expresie
    | expresie GE expresie
    | expresie EQ expresie
    | expresie NE expresie
    | '(' conditie AND conditie ')'
    | '(' conditie OR conditie ')'
    ;

statement
    : statement statements ';'
    | statements ';'
    ;

statements
    : ID UNARY                  
    | UNARY ID
    | ID ASSIGN expresie
    | ID ASSIGN '(' expresie ')'
    | ID ASSIGN conditie
    | ID ASSIGN '(' conditie ')'
    ;

expresie
    : expresie PLUS expresie
    | expresie MINUS expresie
    | expresie PROD expresie
    | expresie DIV expresie
    | NUMBER
    | FLOAT_NUM
    | ID
    ;


%%

int yyerror(char * s)
{
    printf("Eroare: %s Linia:%d\n",s,yylineno);
}


int main(int argc, char** argv)
{
    yyin=fopen(argv[1],"r");

    FILE *f1;
    f1 = fopen("symbol_table.txt", "w");

    if (f1 == NULL)
    {
        printf("Error opening file!\n");
        exit(1);
    }

    yyparse();

    fprintf(f1,"\nSYMBOL   DATATYPE   VALUE   LINENUMBER \n");
	fprintf(f1,"_______________________________________\n\n");

    for(int i = 0; i < count; i++)
    {
        fprintf(f1,"%s\t\t%s\t\t%f\t\t\t%d\n", symbol_table[i].name, symbol_table[i].data_type, symbol_table[i].value, symbol_table[i].line_no);
    }
    

    for(int i=0;i<count;i++) 
    {
		free(symbol_table[i].name);
		free(symbol_table[i].data_type);
    }

    fclose(f1);
} 
