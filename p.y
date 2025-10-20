%{

#include <stdio.h> /* printf() */
#include <string.h> /* strcpy() */
#include "common.h" /* MAX_STR_LEN */
int yylex(void);
void yyerror(const char *txt);

void found( const char *nonterminal, const char *value );
%}


%union
{
    char s[ MAX_STR_LEN + 1 ];
    int i;
    double d;
}

%token KW_PROGRAM KW_BEGIN KW_END KW_USES KW_VAR KW_CONST KW_IF KW_THEN KW_ELSE
%token KW_CHAR KW_STRING KW_INTEGER KW_REAL KW_FOR KW_TO KW_DO KW_FUNCTION
%token KW_PROCEDURE KW_ARRAY KW_RECORD KW_OF KW_DOWNTO
%token ASSIGN LE RANGE
%token<s> IDENT STRING_CONST
%token<d> FLOAT_CONST
%token<i> INTEGER_CONST CHARACTER_CONST

%type<s> FUN_HEAD
%type<s> PROGRAM_NAME

 /* precedence of operators */
%left '+' '-'
%left '*' '/'
%right NEG

%%

 /* a program can be empty (semantic error), it may contain syntactic error
    or it may contain:
    program name (PROGRAM_NAME), declaration section
    (SECTION_LIST), and the main block (BLOCK) ending with a dot */
/* Grammar: %empty { yyerror( "Empty input source is not valid!" ); YYERROR; } */
/*     | error */
/*       /\* Start here! *\/ */
/* ; */
Grammar:
    /* other rules */
    | PROGRAM_NAME { found("PROGRAM_NAME", ""); }
    /* other rules */

/* PROGRAM_NAME */
 /* May be empty, or it may contain:
    keyword PROGRAM, program name (IDENT), and a semicolon */
PROGRAM_NAME:
    KW_PROGRAM IDENT ';' {
        found("PROGRAM_NAME", $2);  /* Call found() with the program name */
    }
;

/* SECTION_LIST */
 /* Possibly empty sequence of sections (SECTION) */

/* SECTION */
 /* One of the following:
    section of declaractions of constants (CONST_SECT),
    section of declaractions of variables (VAR_SECT),
    functions (FUNCTION) folloowed by a semicolon,
    procedure (PROCEDURE) followed by a semicolon */

/* CONST_SECT */
 /* keyword CONST, constant declaration list (CONST_LIST)
    followed by a semicolon */

/* CONST_LIST */
 /* list of constant declarations (CONST) separated with semicolons */

/* CONST */
 /* identifier, equal sign ('=') , and a literal value (LITERAL) */

/* LITERAL */
 /* Either an integer constant (INTEGER_CONST), a real constant (FLOAT_CONST),
    or a string constant (STRING_CONST) */

/* VAR_SECT */
 /* keyword VAR, followed by a list of declarations of variables (VAR_LIST),
    ending with a semicolon, eg. "Var i : Integer; c : Char; */

/* VAR_LIST */
 /* list of declarations of variables (VAR) separated with semicolons */

/* VAR */
 /* identifier list (IDENT_LIST), colon, and data type (DATA_TYPE) */

/* IDENT_LIST */
 /* list of identifiers (IDENT) separated with commas */

/* DATA_TYPE */
 /* Either: data type name (DATA_TYPE_NAME),
    array type (ARRAY_TYPE),
    or record type (RECORD_TYPE) */

/* DATA_TYPE_NAME */
 /* One of the lfollowing keywords: Integer, Real, Char, String */

/* ARRAY_TYPE */
 /* keyword ARRAY, left square bracket, dimensions (DIMENSIONS),
   right square bracket, keyword OF, and data type (DATA_TYPE) */

/* DIMENSIONS */
 /* list of dimensions (DIMENSION) separated with commas */

/* DIMESION */
/* literal value (LITERAL), RANGE operator, and literal value */

/* RECORD_TYPE */
 /* keyword RECORD, field list (FIELD_LIST), and keyword END */

/* FIELD_LIST */
 /* list of fields (FIELD) separated with semicolons */

/* FIELD */
 /* identifier list (IDENT_LIST), colon, and data type (DATA_TYPE) */

 /* PROCEDURE AND FUNCTION DECLARATIONS */

/* PROCEDURE */
 /* keyword PROCEDURE, function header (FUN_HEAD), semicolon, section list
    (SECTION_LIST), and block (BLOCK) */

/* FUNCTION */
/* keyword FUNCTION, function head (FUN_HEAD), colon, return data type
    (DATA_TYPE), semicolon, section list (SECTION_LIST), and block (BLOCK) */

/* FUN_HEAD */
/* identifier (IDENT) followed by formal parameters (FORM_PARMS) */

/* FORM_PARAMS */
 /* Either empty, or a list of formal parameters (FORM_PARM_LIST)
    in parentheses */

/* FORM_PARAM_LIST */
 /* list of formal parameters (FORM_PARM) separated with commas */

/* FORM_PARAM */
 /* identifier list (IDENT_LIST), colon, and data type (DATA_TYPE) */

/* BLOCK */
 /* Either keyword BEGIN, and keyword END,
    or keyword BEGIN, instruction list (INSTR_LIST), and keyword END,
    or keyword BEGIN, instruction list, semicolon, and keyword END */


/* INSTR_LIST */
/* Nonempty list of instructions (INSTRUCTION) separated with semicolons */

/* INSTRUCTION */
 /* One of the following:
    function call (FUNCT_CALL),
    for loop (FOR_INSTR),
    assignment (ASSIGN_INSTR),
    conditional instruction (IF_INSTR) */

 /* SIMPLE AND COMPLEX INSTRUCTIONS */

/* FUNCT_CALL */
 /* identifier followed by actual parameters (ACT_PARAMS) */

/* ACT_PARAMS */
/* Either empty, or actual parameter list (ACT_PARM_LIST) in parentheses */

/* ACT_PARAM_LIST */
 /* Nonempty list of actual parameters (ACT_PARAM) separated with commas */

/* ACT_PARAM */
 /* Either: string constant (STRING_CONST),
    number (NUMBER),
    or function call (FUNCT_CALL) */

/* NUMBER */
 /* Either an integer constant (INTEGER_CONST)
    or a real constant (FLOAT_CONST) */

/* ASSIGN_INSTR */
 /* identifier, qualifier (QUALIF), assignment operator (ASSIGN),
    and expression (EXPR) */

/* QUALIF */
/* Either empty,
   or a left square bracket, expression list (EXPR_LIST), right square bracket,
      and qualifier,
   or a dot, identifier, and qualifier
*/

/* EXPR_LIST */
/* Nonempty list of expressions (EXPR) separated with commas */

/* EXPR */
 /* One of the following:
    number,
    identifier with a qualifier,
    two expressions separated with a:
    - plus,
    - minus,
    - star,
    - slash,
    minus sign followed by expression (use NEG precedence),
    or expression in parentheses */

/* FOR_INSTR */
 /* keyword FOR, identifier, assignment operator (ASSIGN),
    constant or variable (CONST_VAR), keyword TO or DOWNTO (TO_DOWNTO),
    constant or variable (CONST_VAR), keyword DO,
    and instruction block (BLOCK_INSTR) */

/* TO_DOWNTO */
 /* Either keyword TO or keyword DOWNTO */

/* CONST_VAR */
 /*Either an integer constant, or identifier */

/* BLOCK_INSTR */
 /* Either a block (BLOCK), or a single instruction (INSTRUCTION) */

/* IF_INSTR */
 /* keyword IF, logical expression LOG_EXPR, keyword THEN,
    instruction block BLOCK_INSTR, and else part (ELSE_PART) */

/* LOG_EXPR */
/* Either two expressions EXPR linked with <, >, LE, =,
   or a logical expression in parentheses */

/* ELSE_PART */
 /* Either empty,
    or keyword ELSE, and instruction block (BLOCK_INSTR) */


%%


int main( void )
{
    int ret;
    printf( "Author: First and last name\n" );
    printf( "yytext              Token type      Token value as string\n\n" );
    ret = yyparse();
    return ret;
}

void yyerror( const char *txt )
{
    printf( "Syntax error %s\n", txt );
}

void found( const char *nonterminal, const char *value )
{ /* info on found syntax structures (nonterminal) */
    printf( "===== FOUND: %s %s%s%s=====\n", nonterminal,
            (*value) ? "'" : "", value, (*value) ? "'" : "" );
}
