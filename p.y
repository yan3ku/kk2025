%{
#include <stdio.h> /* printf() */
#include "common.h" /* MAX_STR_LEN */
int yylex(void);
void yyerror(const char *txt);
%}


/* Declaration of terminal symbols */
%token KW_PROGRAM KW_BEGIN KW_END KW_USES KW_VAR KW_CONST KW_IF KW_THEN KW_ELSE
%token KW_CHAR KW_INTEGER KW_REAL KW_FOR KW_TO KW_DO KW_FUNCTION
%token KW_PROCEDURE KW_DOWNTO KW_ARRAY KW_RECORD KW_OF KW_STRING
%token ASSIGN LE RANGE
%token IDENT STRING_CONST FLOAT_CONST INTEGER_CONST CHARACTER_CONST
 /* added by me */
%token MUL ADD

%union
{ /* Declaration of token types */
    char s[ MAX_STR_LEN + 1 ]; /* text fields for names etc. */
    int i; /* interger field */
    double d; /* floating point field */
}

%%

Grammar: %empty
    | TOKENS
;

TOKENS: TOKEN
    | TOKENS TOKEN
;

TOKEN: KEYWORD { printf("found keyword"); } | OPERATOR | IDENT | CONSTS | CHARS | error
;

KEYWORD: KW_PROGRAM | KW_BEGIN | KW_END | KW_USES | KW_VAR | KW_CONST | KW_IF
    | KW_THEN | KW_ELSE | KW_CHAR | KW_INTEGER | KW_REAL | KW_FOR | KW_TO
        | KW_DO | KW_DOWNTO | KW_ARRAY | KW_RECORD | KW_OF
;

OPERATOR: ASSIGN | LE | RANGE
;

CONSTS: STRING_CONST | FLOAT_CONST | INTEGER_CONST
;

CHARS:	'+' | '-' | '*' | '/' | ';' | ',' | '=' | ':' | '.'
    | '(' | ')' | '{' | '}' | '[' | ']'
;

%%


int main( void )
{
    int ret;
    printf( "Author: Jan Wisniewski\n" );
    printf( "yytext              Token type      Token value as string\n\n" );
    /* invocation of the parser */
    ret = yyparse();
    return ret;
}

void yyerror( const char *txt )
{
    printf( "Syntax error %s", txt );
}
