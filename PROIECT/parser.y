%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdbool.h>

extern FILE* yyin;
extern char* yytext;
extern int yylineno;
int cod=0;

void Print(int valExpr);

void declarare_fara_initializare(char* tip, char* nume, int constanta);
void declarare_vector(char* tip, char* nume, int dimens,int constanta);
void declarare_cu_init_intnumar(char* tip, char* nume, int valoare, int constanta);
void declarare_cu_init_floatnumar(char* tip, char* nume, float valoare, int constanta);
void declarare_cu_init_boolnumar(char* tip, char* nume, _Bool valoare, int constanta);
void declarare_cu_init_variabila(char* tip, char* nume, char* var, int constanta);

void declarare_functie(char* tip, char* nume, char* argum);
void declarare_functie_cu_return(char* tip, char* nume, char* argum, int expresie);
void definire_functie_cu_return(char* nume, char* argum, int expresie);
int verificare_functie(char* nume, char* argum);
int verif_argumente_tip_int(char* argum);
void verificare_apel_functie(char* nume, char* listaparametri);
void declarare_new_datatype(char* nume);
int verificare_datatype(char* nume);

void incrementare_decrementare(char* nume, char* op);
void incr_decr_vector(char* nume, int dimens, char* op);
int return_cu_variabila(char* nume);
void asignare(char* nume, int valoare);
void asignareVector(char* nume, int dimens, int valoare);
int is_declared(char* nume);
void eroareExpresie();

struct variables 
{
    char* data_type;
    int isConst;
    char* name;
    char* scope;
    int ivalue;
    float flvalue;
    int hasValue;

    int dimensiuneMax;
    int* vector;
    int* hasVectorValue;

    int line_no;
};
struct variables symbol_table[100];

struct function
{
    char* return_type;
    char* name;
    char* args;
    int valoareReturn;
    int line_no;
};
struct function symbol_table_functions[100];

int count = 0;
int count_f = 0;


void Print(int valExpr)
{
    printf("\nValoarea Expresiei = %d\n", valExpr);
}


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
    switch(cod) {
    case 1:symbol_table[count].scope="global definition";
           break;
    case 2:symbol_table[count].scope="defined inside a function";
           break;
    case 3:symbol_table[count].scope="defined inside a new type";
           break;
    case 4:symbol_table[count].scope="defined inside the body";     
           break;
    }
    count++;
}

void declarare_vector(char* tip, char* nume, int dimens, int constanta)
{
    if(is_declared(nume) != -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Vectorul \"%s[%d]\" este deja declarat.", nume, dimens);
        yyerror(errmsg);
        exit(0);
    }

    if(constanta == 1)
    {
        char errmsg[300];
        sprintf(errmsg, "Vectorul \"%s\" nu poate fi de tip const.", nume);
        yyerror(errmsg);
        exit(0);
    }

    symbol_table[count].name = strdup(nume);
    symbol_table[count].data_type = strdup(tip);
    symbol_table[count].isConst = 0;
    symbol_table[count].hasValue = 0;
    symbol_table[count].ivalue = 999999;
    symbol_table[count].flvalue = 999999;
    symbol_table[count].dimensiuneMax = dimens;
    symbol_table[count].vector = (int*)malloc(dimens * sizeof(int));
    symbol_table[count].hasVectorValue = (int*)malloc(dimens * sizeof(int));
    symbol_table[count].line_no = yylineno;

    switch(cod) {
    case 1:symbol_table[count].scope="global definition";
           break;
    case 2:symbol_table[count].scope="defined inside a function";
           break;
    case 3:symbol_table[count].scope="defined inside a new type";
           break;
    case 4:symbol_table[count].scope="defined inside the body";     
           break;
    }

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

    if(strcmp(tip,"bool") == 0)
    {
        if(valoare != 0 && valoare != 1)
        {
            char errmsg[300];
            sprintf(errmsg, "Variabila \"%s\" este de tip bool si nu poate fi initializata cu alte valori in afara de 1 sau 0 (TRUE sau FALSE).", nume);
            yyerror(errmsg);
            exit(0);
        }
    }

    symbol_table[count].name = strdup(nume);
    symbol_table[count].data_type = strdup(tip);
    symbol_table[count].isConst = constanta;
    symbol_table[count].hasValue = 1;
    symbol_table[count].ivalue = valoare;
    symbol_table[count].flvalue = 999999;
    symbol_table[count].line_no = yylineno;
    switch(cod) {
    case 1:symbol_table[count].scope="global definition";
           break;
    case 2:symbol_table[count].scope="defined inside a function";
           break;
    case 3:symbol_table[count].scope="defined inside a new type";
           break;
    case 4:symbol_table[count].scope="defined inside the body";     
           break;
    }
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
    switch(cod) {
    case 1:symbol_table[count].scope="global definition";
           break;
    case 2:symbol_table[count].scope="defined inside a function";
           break;
    case 3:symbol_table[count].scope="defined inside a new type";
           break;
    case 4:symbol_table[count].scope="defined inside the body";     
           break;
    }
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

    if(strcmp(symbol_table[decl].data_type,tip) != 0)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabilele \"%s\" si \"%s\" nu sunt de acelasi tip de date.", var, nume);
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
    switch(cod) {
    case 1:symbol_table[count].scope="global definition";
           break;
    case 2:symbol_table[count].scope="defined inside a function";
           break;
    case 3:symbol_table[count].scope="defined inside a new type";
           break;
    case 4:symbol_table[count].scope="defined inside the body";     
           break;
    }
    count++;
}

void declarare_cu_init_boolnumar(char* tip, char* nume, _Bool valoare, int constanta)
{
    if(is_declared(nume) != -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabila \"%s\" este deja declarata.", nume);
        yyerror(errmsg);
        exit(0);
    }

    if(valoare != 0 && valoare != 1)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabila \"%s\" nu are o valoare specifica de tipul bool.", nume);
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
    switch(cod) {
    case 1:symbol_table[count].scope="global definition";
           break;
    case 2:symbol_table[count].scope="defined inside a function";
           break;
    case 3:symbol_table[count].scope="defined inside a new type";
           break;
    case 4:symbol_table[count].scope="defined inside the body";     
           break;
    }
    count++;
}

void incr_decr_vector(char* nume, int dimens, char* op)
{
    int decl = is_declared(nume);
    if(decl == -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Vectorul \"%s\" nu este declarat.", nume);
        yyerror(errmsg);
        exit(0);
    }

    if(strcmp(symbol_table[decl].data_type,"int") != 0)
    {
        char errmsg[300];
        sprintf(errmsg, "Vectorul \"%s\" nu este de tip int si nu se poate incrementa/decrementa.", nume);
        yyerror(errmsg);
        exit(0);
    }

    if(symbol_table[decl].hasVectorValue[dimens] == 0)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabila \"%s[%d]\" nu are valoare.", nume, dimens);
        yyerror(errmsg);
        exit(0);
    }

    if(strcmp(op, "++") == 0)
        symbol_table[decl].vector[dimens] = symbol_table[decl].vector[dimens] + 1;
    if(strcmp(op, "--") == 0)
        symbol_table[decl].vector[dimens] = symbol_table[decl].vector[dimens] - 1;

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
    
    if(strcmp(symbol_table[decl].data_type,"int") == 0 || strcmp(symbol_table[decl].data_type,"bool") == 0)
        return symbol_table[decl].ivalue;
    else
    {
        return -999999;
    }
}

void eroareExpresie()
{
    char errmsg[300];
    sprintf(errmsg, "Expresia nu este de tip int.");
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

    if(strcmp(symbol_table[decl].data_type,"bool") == 0 )
    {
        if(valoare != 1 && valoare != 0)
        {
            char errmsg[300];
            sprintf(errmsg, "Nu se poate asigna o valoare diferita de 0 sau 1 variabilei de tip bool \"%s\" ",nume);
            yyerror(errmsg);
            exit(0);
        }
    }

    symbol_table[decl].hasValue = 1;
    symbol_table[decl].ivalue = valoare;
}

void asignareVector(char* nume, int dimens, int valoare)
{
    int decl = is_declared(nume);
    if(decl == -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Vectorul \"%s\" nu este declarat",nume);
        yyerror(errmsg);
        exit(0);
    }

    if(strcmp(symbol_table[decl].data_type,"bool") == 0 )
    {
        if(valoare != 1 && valoare != 0)
        {
            char errmsg[300];
            sprintf(errmsg, "Nu se poate asigna o valoare diferita de 0 sau 1 vectorului de tip bool \"%s\" ",nume);
            yyerror(errmsg);
            exit(0);
        }
    }

    if(dimens >= symbol_table[decl].dimensiuneMax)
    {
        char errmsg[300];
        sprintf(errmsg, "Dimensiunea maxima a vectorului \"%s[%d]\" a fost depasita.",nume, symbol_table[decl].dimensiuneMax);
        yyerror(errmsg);
        exit(0);
    }

    if(dimens < 0)
    {
        char errmsg[300];
        sprintf(errmsg, "Dimensiunea vectorului \"%s[%d]\" nu poate fi negativa.",nume, symbol_table[decl].dimensiuneMax);
        yyerror(errmsg);
        exit(0);
    }

    symbol_table[decl].vector[dimens] = valoare;
    symbol_table[decl].hasVectorValue[dimens] = 1;
}

int return_Valoare_Vector(char* nume, int dimens)
{
    int decl = is_declared(nume);

    if(decl == -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Vectorul \"%s\" nu este declarat.", nume);
        yyerror(errmsg);
        exit(0);
    }

    if(dimens >= symbol_table[decl].dimensiuneMax)
    {
        char errmsg[300];
        sprintf(errmsg, "Dimensiunea maxima a vectorului \"%s[%d]\" a fost depasita.",nume, symbol_table[decl].dimensiuneMax);
        yyerror(errmsg);
        exit(0);
    }

    if(symbol_table[decl].hasVectorValue[dimens] == 0)
    {
        char errmsg[300];
        sprintf(errmsg, "Variabila \"%s[%d]\" nu are valoare.", nume, dimens);
        yyerror(errmsg);
        exit(0);
    }

    if(strcmp(symbol_table[decl].data_type,"int") == 0 || strcmp(symbol_table[decl].data_type,"bool") == 0)
        return symbol_table[decl].vector[dimens];
    else
    {
        return -999999;
    }

}

int verificare_functie(char* nume, char* argum)
{
    for(int i = 0; i < count_f; i++)
    {
        if(strcmp(symbol_table_functions[i].name,nume) == 0 && strcmp(symbol_table_functions[i].args,argum) == 0)
        {
            return i;
        }
    }
    return -1;
}

int verif_argumente_tip_int(char* argum)
{
    char* ptr = strstr(argum, "bool");
    if(ptr != NULL)
    {
        char errmsg[300];
        sprintf(errmsg, "Functia are argumente de tip bool.");
        yyerror(errmsg);
        return -1;
    }

    ptr = strstr(argum, "char");
    if(ptr != NULL)
    {
        char errmsg[300];
        sprintf(errmsg, "Functia are argumente de tip char.");
        yyerror(errmsg);
        return -1;
    }

    ptr = strstr(argum, "float");
    if(ptr != NULL)
    {
        char errmsg[300];
        sprintf(errmsg, "Functia are argumente de tip float.");
        yyerror(errmsg);
        return -1;
    }

    return 1;
}

void declarare_functie(char* tip, char* nume, char* argum)
{
    if(verificare_functie(nume,argum) != -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Functia \"%s\" are aceeasi signatura.", nume);
        yyerror(errmsg);
        exit(0);
    }

    int verif = verif_argumente_tip_int(argum);
    if(verif == -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Functia \"%s\" nu are toate argumentele de tip int.", nume);
        yyerror(errmsg);
        exit(0);
    }

    symbol_table_functions[count_f].name = nume;
    symbol_table_functions[count_f].return_type = tip;
    symbol_table_functions[count_f].args = argum;
    symbol_table_functions[count_f].valoareReturn = 999999;
    symbol_table_functions[count_f].line_no = yylineno;
    count_f++;
}

void declarare_functie_cu_return(char* tip, char* nume, char* argum, int expresie)
{
    if(verificare_functie(nume,argum) != -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Functia \"%s\" are aceeasi signatura.", nume);
        yyerror(errmsg);
        exit(0);
    }

    int verif = verif_argumente_tip_int(argum);
    if(verif == -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Functia \"%s\" nu are toate argumentele de tip int.", nume);
        yyerror(errmsg);
        exit(0);
    }

    symbol_table_functions[count_f].name = nume;
    symbol_table_functions[count_f].return_type = tip;
    symbol_table_functions[count_f].args = argum;
    symbol_table_functions[count_f].valoareReturn = expresie;
    symbol_table_functions[count_f].line_no = yylineno;
    count_f++;
}

void definire_functie_cu_return(char* nume, char* argum, int expresie)
{
    int poz = verificare_functie(nume,argum);
    if(poz == -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Functia \"%s\" definita nu este declarata.", nume);
        yyerror(errmsg);
        exit(0);
    }

    symbol_table_functions[poz].valoareReturn = expresie;
}

void verificare_apel_functie(char* nume, char* listaparametri)
{
    int ok = -1;

    for(int i = 0; i < count_f; i++)
    {
        if(strcmp(symbol_table_functions[i].name,nume) == 0)
        {
            ok = i;
        }
    }

    if(ok == -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Functia \"%s\" apelata nu este declarata.", nume);
        yyerror(errmsg);
        exit(0);
    }

    if(symbol_table_functions[ok].valoareReturn == 999999)
    {
        char errmsg[300];
        sprintf(errmsg, "Functia \"%s\" apelata nu returneaza nicio valoare.", nume);
        yyerror(errmsg);
        exit(0);
    }

    int countVirgule1 = 0;
    for(int i = 0; i < strlen(symbol_table_functions[ok].args); i++)
    {
        if(symbol_table_functions[ok].args[i] == ',')
            countVirgule1++;
    }
    
    int countVirgule2 = 0;
    for(int i = 0; i < strlen(listaparametri); i++)
    {
        if(listaparametri[i] == ',')
            countVirgule2++;
    }

    if(countVirgule1 != countVirgule2)
    {
        char errmsg[300];
        sprintf(errmsg, "Functia \"%s\" apelata nu are acelasi numar de parametri.", nume);
        yyerror(errmsg);
        exit(0);
    }
}

void declarare_new_datatype(char* nume)
{
    if(verificare_datatype(nume) != -1)
    {
        char errmsg[300];
        sprintf(errmsg, "Mai exista datatype cu acelasi nume \"%s\" ", nume);
        yyerror(errmsg);
        exit(0);
    }

    symbol_table_functions[count_f].name = nume;
    char type[] = "newtype";
    symbol_table_functions[count_f].return_type = strdup(type);
    symbol_table_functions[count_f].args = "";
    symbol_table_functions[count_f].valoareReturn = 999999;
    symbol_table_functions[count_f].line_no = yylineno;
    count_f++;
}

int verificare_datatype(char* nume)
{
    for(int i = 0; i < count_f; i++)
    {
        if(strcmp(symbol_table_functions[i].name,nume) == 0 )
        {
            return i;
        }
    }
    return -1;
}
%}

%union
{
    char* str;
    int intnum;
    _Bool boolnum;
    float flnum;
}

%token STARTGLOBAL ENDGLOBAL STARTFUNCTIONS ENDFUNCTIONS STARTPROGRAM ENDPROGRAM CHARACTER PRINT STRING FOR IF WHILE ELSE LE GE EQ NE GT LT AND OR STR ASSIGN FUNCTION DOUBLE PLUS MINUS DIV PROD
%token <str> ID DATATYPE UNARY CONST RETURN TYPE
%token <intnum> NUMBER
%token <flnum> FLOAT_NUM
%token <boolnum> BOOL_VALUE
%type <intnum> expresie conditie dimensiuni
%type <str> decl_functii argumente parametri apelarefunctie listaparametri lista_parametri
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
    : {cod=1;} STARTGLOBAL DOUBLE declarari ENDGLOBAL 
    ;

functii
    : STARTFUNCTIONS DOUBLE declfunctii ENDFUNCTIONS 
    ;

declfunctii
    : decl_functii
    | declfunctii decl_functii
    ;

decl_functii
    : FUNCTION DATATYPE ID argumente ';'   { declarare_functie($2,$3,$4); }
    | FUNCTION DATATYPE ID argumente DOUBLE '{' bodyfunction RETURN expresie ';' '}'        { declarare_functie_cu_return($2,$3,$4,$9); }
    | ID argumente DOUBLE '{' bodyfunction RETURN expresie ';' '}'                          { definire_functie_cu_return($1,$2,$7); }
    | {cod=3;} TYPE DOUBLE '{' elemente '}' ID ';'  {declarare_new_datatype($7); }
    ; 

elemente : elemente element
         | element
         ;

element : declarare
        | statements ';'
        ;

argumente
    : '(' parametri ')'     { $$ = $2; }
    | '(' ')'               { $$ = malloc(100); $$[0] = 0; }
    ;

parametri
    : DATATYPE                   { $$ = $1; }
    | parametri ',' DATATYPE     { $$ = $1; strcat($$, ", "); strcat($$, $3); }
    ;

bodyfunction
    : body_function
    | bodyfunction body_function
    ;

body_function
    : {cod=2;} declarare
    | statements ';'
    | IF '(' conditie ')' DOUBLE '{' statement '}' els
    | WHILE '(' conditie ')' DOUBLE '{' statement '}'
    | FOR '(' statements conditie ';' statements ')' DOUBLE '{' statement '}'
    ;

apelarefunctie
    : ID '(' listaparametri ')'             { verificare_apel_functie($1,$3); }          
    ;

listaparametri
    : lista_parametri                       { $$ = $1; }   
    | listaparametri ',' lista_parametri    { $$ = $1; strcat($$, ", "); strcat($$, $3); }
    ;

lista_parametri
    : expresie          { $$ = malloc(100); strcpy($$,"int");}
    | apelarefunctie    { $$ = $1; strcat($$,", ");}
    ;

main
    : {cod=4;} STARTPROGRAM DOUBLE bodymain ENDPROGRAM 
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
    | DATATYPE ID ASSIGN BOOL_VALUE ';'             { declarare_cu_init_boolnumar($1,$2,$4,0); }
    | CONST DATATYPE ID ASSIGN BOOL_VALUE ';'       { declarare_cu_init_boolnumar($2,$3,$5,1); } 
    | DATATYPE ID ASSIGN ID ';'                     { declarare_cu_init_variabila($1,$2,$4,0); }
    | CONST DATATYPE ID ASSIGN ID ';'               { declarare_cu_init_variabila($2,$3,$5,1); }
    | DATATYPE ID dimensiuni ';'                    { declarare_vector($1,$2,$3,0); }
    | CONST DATATYPE ID dimensiuni ';'              { declarare_vector($2,$3,$4,1); }  
    ;

dimensiuni
    : '[' NUMBER ']'        { $$ = $2; }
    ;

bodymain
    : body_main
    | bodymain body_main
    ;

body_main
    : declarare
    | apelarefunctie ';'                                                            
    | statements ';'
    | IF '(' conditie ')' DOUBLE '{' statement '}' els
    | WHILE '(' conditie ')' DOUBLE '{' statement '}'
    | FOR '(' statements conditie ';' statements ')' DOUBLE '{' statement '}'
    | PRINT '(' expresie ')' ';'    { Print($3); }
    | PRINT '(' conditie ')' ';'    { Print($3); }
    ;

els
    : ELSE DOUBLE '{' statement '}'
    | 
    ;

conditie
    : expresie LT expresie          { $$ = ($1 < $3); }
    | expresie GT expresie          { $$ = ($1 > $3); }
    | expresie LE expresie          { $$ = ($1 <= $3); }
    | expresie GE expresie          { $$ = ($1 >= $3); }
    | expresie EQ expresie          { $$ = ($1 == $3); }
    | expresie NE expresie          { $$ = ($1 != $3); }
    | '(' conditie AND conditie ')' { $$ = ($2 && $4); }
    | '(' conditie OR conditie ')'  { $$ = ($2 || $4); }
    ;

statement
    : statement statements ';'
    | statements ';'
    ;

statements
    : ID UNARY                                  { incrementare_decrementare($1,$2); }                
    | UNARY ID                                  { incrementare_decrementare($2,$1); }  
    | ID ASSIGN expresie                        { asignare($1,$3); }
    | ID ASSIGN '(' expresie ')'                { asignare($1,$4); }
    | ID ASSIGN conditie                        { asignare($1,$3); }
    | ID ASSIGN '(' conditie ')'                { asignare($1,$4); }
    | ID dimensiuni ASSIGN expresie             { asignareVector($1,$2,$4); }
    | ID dimensiuni ASSIGN '(' expresie ')'     { asignareVector($1,$2,$5); }
    | ID dimensiuni ASSIGN '(' conditie ')'     { asignareVector($1,$2,$5); }
    | ID dimensiuni UNARY                       { incr_decr_vector($1,$2,$3); }
    | UNARY ID dimensiuni                       { incr_decr_vector($2,$3,$1); }
    ;

expresie
    : expresie PLUS expresie        { $$ = $1 + $3; }
    | expresie MINUS expresie       { $$ = $1 - $3; }
    | expresie PROD expresie        { $$ = $1 * $3; }
    | expresie DIV expresie         { if($3 == 0) {yyerror("Impartire la zero!");}  $$ = $1 / $3; }
    | NUMBER                        { $$ = $1; }
    | FLOAT_NUM                     { eroareExpresie(); }
    | BOOL_VALUE                    { $$ = $1; }
    | ID                            { if(return_cu_variabila($1) == -999999) {eroareExpresie();} else {$$ = return_cu_variabila($1);} }
    | ID dimensiuni                 { if(return_Valoare_Vector($1,$2) == -999999) { eroareExpresie(); } else {$$ = return_Valoare_Vector($1,$2);}  }
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
    FILE *f2;
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

    fprintf(f1,"\nSYMBOL       MAX_DIMENSION        DATATYPE        SCOPE        VALUE        LINENUMBER \n");
	fprintf(f1,"______________________________________________________________________________________________________\n\n");

    for(int i = 0; i < count; i++)
    {
        if(strcmp(symbol_table[i].data_type,"float") == 0)
        {
            fprintf(f1,"%s\t|\t%d\t|%s\t|%s\t|%f\t|%d\n", symbol_table[i].name, symbol_table[i].dimensiuneMax, symbol_table[i].data_type, symbol_table[i].scope, symbol_table[i].flvalue, symbol_table[i].line_no);
        }
        else 
        if(strcmp(symbol_table[i].data_type,"int") == 0 || strcmp(symbol_table[i].data_type,"bool") == 0 || strcmp(symbol_table[i].data_type,"char") == 0)
        {
            fprintf(f1,"%s\t|\t%d\t|%s\t|%s\t|%d\t|%d\n", symbol_table[i].name, symbol_table[i].dimensiuneMax,symbol_table[i].data_type, symbol_table[i].scope, symbol_table[i].ivalue, symbol_table[i].line_no);
            if(symbol_table[i].dimensiuneMax > 0)
            {
                for(int k=0; k < symbol_table[i].dimensiuneMax; k++)
                {
                    fprintf(f1, "%s[%d]\t\t|\t val=%d\n", symbol_table[i].name, k, symbol_table[i].vector[k]);
                }
                fprintf(f1, "................................................................................................\n");
            }
        }
    }

    fprintf(f2,"\nSYMBOL   RETURN_TYPE           PARAMETERS                      VAL_RETURN       LINENUMBER \n");
	fprintf(f2,"______________________________________________________________________________________________________\n\n");

    for(int j = 0; j < count_f; j++)
    {
        fprintf(f2,"%s\t\t|\t%s\t\t|\t%s\t\t\t|\t%d\t\t\t|\t%d\n", symbol_table_functions[j].name, symbol_table_functions[j].return_type, symbol_table_functions[j].args, symbol_table_functions[j].valoareReturn, symbol_table_functions[j].line_no);
    }
    

    for(int i=0;i<count;i++) 
    {
		free(symbol_table[i].name);
		free(symbol_table[i].data_type);
    }

    for(int i=0; i < count_f; i++)
    {
        free(symbol_table_functions[i].name);
		free(symbol_table_functions[i].return_type);
    }

    fclose(f1);
    fclose(f2);
}
