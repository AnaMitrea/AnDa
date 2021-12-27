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
void incrementare_decrementare(char* nume, char* op);
int return_cu_variabila(char* nume);
void asignare(char* nume, int valoare);
int is_declared(char* nume);
void eroareFLOAT();

struct variables 
{
    char* data_type;
    int isConst;
    char* name;
    char* scope;
    int ivalue;
	float flvalue;
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

int is_declared(char* nume)
{
    for(int i = 0; i < count; i++)
    {
        if(strcmp(symbol_table[i].name,nume) == 0)
        {
            return i;
        }
    }
    return -1;
}

void declarare_fara_initializare(char* tip, char* nume, int constanta)
{
    if(is_declared(nume) != -1)
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
    symbol_table[count].ivalue = 999999;
    symbol_table[count].flvalue = 999999;
    symbol_table[count].line_no = yylineno;

    count++;
}

void declarare_cu_init_intnumar(char* tip, char* nume, int valoare, int constanta)
{
    if(is_declared(nume) != -1)
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
    symbol_table[count].ivalue = valoare;
    symbol_table[count].flvalue = 999999;
    symbol_table[count].line_no = yylineno;

    count++;
}

void declarare_cu_init_floatnumar(char* tip, char* nume, float valoare, int constanta)
{
    if(is_declared(nume) != -1)
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
    symbol_table[count].ivalue = 999999;
    symbol_table[count].flvalue = valoare;
    symbol_table[count].line_no = yylineno;

    count++;
}


void declarare_cu_init_variabila(char* tip, char* nume, char* var, int constanta)
{
    if(is_declared(nume) != -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabila \"%s\" este deja declarata.", nume);
        yyerror(errmsg);
        exit(0);
    }

    int decl = is_declared(var);
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
    if(strcmp(symbol_table[decl].data_type,"float") == 0)
    {
        symbol_table[count].flvalue = symbol_table[decl].flvalue;
    }
    else 
    if(strcmp(symbol_table[decl].data_type,"int") == 0 || strcmp(symbol_table[decl].data_type,"bool") == 0 )
    {
        symbol_table[count].ivalue = symbol_table[decl].ivalue;
    }
    symbol_table[count].line_no = yylineno;

    count++;
}

void incrementare_decrementare(char* nume, char* op)
{
    int decl = is_declared(nume);
    if(decl == -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabila \"%s\" nu este declarata.", nume);
        yyerror(errmsg);
        exit(0);
    }

    if(strcmp(symbol_table[decl].data_type,"int") != 0)
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
        symbol_table[decl].ivalue = symbol_table[decl].ivalue + 1;
    if(strcmp(op, "--") == 0)
        symbol_table[decl].ivalue = symbol_table[decl].ivalue - 1;
}

int return_cu_variabila(char* nume)
{
    int decl = is_declared(nume);

    if(decl == -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabila \"%s\" nu este declarata.", nume);
        yyerror(errmsg);
        exit(0);
    }

    if(symbol_table[decl].hasValue == 0)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabila \"%s\" nu are valoare.", nume);
        yyerror(errmsg);
        exit(0);
    }
    if(strcmp(symbol_table[decl].data_type,"int") == 0)
        return symbol_table[decl].ivalue;
    else
    {
        return -999999;
    }
}

void eroareFLOAT()
{
    char errmsg[300];
    sprintf(errmsg, "Expresia este float.");
    yyerror(errmsg);
    exit(0);
}

void asignare(char* nume, int valoare)
{
    int decl = is_declared(nume);
    if(decl == -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabila \"%s\" nu este declarata",nume);
        yyerror(errmsg);
        exit(0);
    }

    if(symbol_table[decl].isConst == 1)
    {
        char errmsg[300];
        sprintf(errmsg, "Nu se poate asigna o valoare variabilei de tip const \"%s\" ",nume);
        yyerror(errmsg);
        exit(0);
    }

    symbol_table[decl].hasValue = 1;
    symbol_table[decl].ivalue = valoare;
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
%type <intnum> expresie

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
    : ID UNARY                      { incrementare_decrementare($1,$2); }                
    | UNARY ID                      { incrementare_decrementare($2,$1); }  
    | ID ASSIGN expresie            { asignare($1,$3); }
    | ID ASSIGN '(' expresie ')'    { asignare($1,$4); }
    | ID ASSIGN conditie
    | ID ASSIGN '(' conditie ')'
    ;

expresie
    : expresie PLUS expresie        { $$ = $1 + $3; }
    | expresie MINUS expresie       { $$ = $1 - $3; }
    | expresie PROD expresie        { $$ = $1 * $3; }
    | expresie DIV expresie         { $$ = $1 / $3; }
    | NUMBER                        { $$ = $1; }
    | FLOAT_NUM                     { eroareFLOAT(); }
    | ID                            { if(return_cu_variabila($1) == -999999) {eroareFLOAT();} else { $$ = return_cu_variabila($1);} }
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
        if(strcmp(symbol_table[i].data_type,"float") == 0)
        {
            fprintf(f1,"%s\t\t%s\t\t%f\t\t\t%d\n", symbol_table[i].name, symbol_table[i].data_type, symbol_table[i].flvalue, symbol_table[i].line_no);
        }
        else 
        if(strcmp(symbol_table[i].data_type,"int") == 0)
        {
            fprintf(f1,"%s\t\t%s\t\t%d\t\t\t%d\n", symbol_table[i].name, symbol_table[i].data_type, symbol_table[i].ivalue, symbol_table[i].line_no);
        }
    }
    

    for(int i=0;i<count;i++) 
    {
		free(symbol_table[i].name);
		free(symbol_table[i].data_type);
    }

    fclose(f1);
}
