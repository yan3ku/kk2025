%{
#include <stdio.h> /* printf() */
#include <string.h> /* strcpy */
#include <stdlib.h> /* atoi(), atof() */
#include "common.h" /* MAX_STR_LEN */
#include "p.tab.h" /* declaration of terminal symbols */

int process_token(const char *text, const char *TokenType,
                  const char *TokenVal, const int TokenID);

int comm_beg = 0; /* starting line of a comment */
int text_beg = 0; /* starting line of a string */
int yylineno;
%}


/* declaraction of additional start conditions */
/* (INITIAL start condition does not need to be declared) */
/* ..................... */
%x COMMENT
%x COMMENTB
%x STRING

%option yylineno case-insensitive
%%


 /* removal of multiline comments (*..*) */
 /* using start conditions */
 /* ..................... */
"(*" comm_beg = yylineno; BEGIN COMMENT ;
<COMMENT>{
    "*)" BEGIN INITIAL;
    \* ;
    [^*]+ ;
 }

 /* removal of multiline comments {..} */
 /* z using start conditions */
 /* ..................... */
"{" comm_beg = yylineno; BEGIN COMMENTB;
<COMMENTB>{
    "}" BEGIN INITIAL;
    [^}]+ ;
 }

 /* detecting an error: Unexpected closing of comment in the line */
 /* ..................... */
"}" fprintf(stderr, "ERROR: unexpected closing of comment in line %d\n", yylineno);
"*)" fprintf(stderr, "ERROR: unexpected closing of comment in line %d\n", yylineno);
<COMMENTB,COMMENT><<EOF>> {
    fprintf(stderr,  "ERROR: unterminated comment opened in line %d\n", comm_beg);
    yyterminate();
}

 /* detecting strings '..' */
 /* using start conditions */
 /* ..................... */

' { yymore(); BEGIN STRING; }
<STRING>{
    [^']+' { BEGIN INITIAL; return process_token(yytext, "STRING", yytext, STRING_CONST); }
}

 /* detection of directives in form of {$I name.ext} */
 /* (without start conditions) */
 /* ..................... */
"{$I"[ \t]+.*"}" printf("Processing INCLUDE directive\n");

 /* Detection of keywords (case-insensitive)! */
 /* ..................... */
PROGRAM  process_token(yytext, "KW_PROGRAM",  "", KW_PROGRAM) ;
BEGIN    process_token(yytext, "KW_BEGIN",    "", KW_BEGIN) ;
END      process_token(yytext, "KW_END",      "", KW_END) ;
USES     process_token(yytext, "KW_USES",     "", KW_USES) ;
VAR      process_token(yytext, "KW_VAR",      "", KW_VAR) ;
CONST    process_token(yytext, "KW_CONST",    "", KW_CONST) ;
IF       process_token(yytext, "KW_CONST",    "", KW_IF) ;
THEN     process_token(yytext, "KW_THEN",     "", KW_THEN) ;
ELSE     process_token(yytext, "KW_ELSE",     "", KW_ELSE) ;

CHAR     process_token(yytext, "KW_CHAR",     "", KW_CHAR) ;
INTEGER  process_token(yytext, "KW_INTEGER",  "", KW_INTEGER) ;
REAL     process_token(yytext, "KW_REAL",     "", KW_REAL) ;
FOR      process_token(yytext, "KW_FOR",      "", KW_FOR) ;
TO       process_token(yytext, "KW_TO",       "", KW_TO) ;
DO       process_token(yytext, "KW_DO",       "", KW_DO) ;
FUNCTION process_token(yytext, "KW_FUNCTION", "", KW_FUNCTION) ;

PROCEDURE process_token(yytext, "KW_PROCEDURE", "", KW_PROCEDURE) ;
DOWNTO    process_token(yytext, "KW_DOWNTO", "", KW_DOWNTO) ;
ARRAY     process_token(yytext, "KW_ARRAY", "", KW_ARRAY) ;
RECORD    process_token(yytext, "KW_RECORD", "", KW_RECORD) ;
OF        process_token(yytext, "KW_OF", "", KW_OF) ;
STRING    process_token(yytext, "KW_STRING", "", KW_STRING) ;

 /* detecting terminal symbols specified with regular expressions */
 /* identifiers */
[a-zA-Z][a-zA-Z0-9_]*  process_token(yytext, "IDENT", yytext, IDENT);

 /* intergers */
[0-9]+        process_token(yytext, "INTEGER_CONST", yytext, INTEGER_CONST) ;

 /* real numbers */
[0-9]+\.[0-9]+(e[+-]?[0-9]+)? process_token(yytext, "FLOAT_CONST", yytext, FLOAT_CONST) ;


 /* cutting out whitespace */
[ \t\n\r]+  ;

 /* multicharacter expressions, e.g.: :=, <= */
:=	  return process_token(yytext, "ASSIGN", "", ASSIGN);
\<=	  return process_token(yytext, "LE", "", LE);
".."  return process_token(yytext, "RANGE", "", RANGE);

 /* one character operators and punctuation */
. return process_token(yytext, "", yytext, yytext[0]);

%%

/* Name:	strnncpy
 * Purpose:	Copies given number of characters from a stream appending
 *		character with code 0.
 * Parameters:	dst		- (o) string to be copied from;
 *		src		- (i) string to be copied to;
 *		n		- (i) max number of characters to copy.
 * Returns:	dst.
 * Remarks:	strncpy does not append character 0 to the copied string.
 *		Destination string must have room for additional n+1 character.
 */
char *
strnncpy(char *dst, const char *src, const int n)
{
  if (n > 0) {
    strncpy(dst, src, n);
  }
  dst[n] = '\0';
  return dst;
}/*strnncpy*/

/* Name:	process_token
 * Purpose:	Print information about detected token and pass it up
 *              with its value if present.
 * Parameters:	text            - (i) matched text;
 *              TokenType       - (i) string representing token name;
 *              TokenVal        - (i) token value if present;
 *              TokenID         - (i) token type identifier declared
 *                                      using %token directive
 *                                      in c.y file single character code
 *					(in the parser put into single quotes).
 * Returns:	Token type identifier (TokenID).
 * Remarks:	Info about detected token is printed in 3 columns.
 *		The first one contains matched text, the second - token type,
 *		the third - token value, if it exists.
 */
int process_token(const char *text, const char *TokenType,
                  const char *TokenVal, const int TokenID)
{
  int l;
  printf("%-20.20s%-15s %s\n", text, TokenType, TokenVal);
  switch (TokenID) {

  case INTEGER_CONST:
    yylval.i = atoi(TokenVal); break;

  case FLOAT_CONST:
    yylval.d = atof(TokenVal); break;

  case IDENT:
    strncpy(yylval.s, TokenVal, MAX_STR_LEN); break;

  case STRING_CONST:		/* rozpoznany napis zawiera cudzysłowy */
    l = strlen(TokenVal);
    strnncpy(yylval.s, TokenVal+1, l - 2 <= MAX_STR_LEN ? l - 1 : MAX_STR_LEN);
    break;

  case CHARACTER_CONST:
    yylval.i = TokenVal[1]; break;

  }
  return(TokenID);
}/*process_token*/


int yywrap( void )
{ /* function called at the end of input stream */

  /* Checking whether the current start condition YY_START */
    /* is different from INITIAL. If so, */
    /* it means unclosed comment or string - */
    /* print error message.*/
    /* ..................... */
    /* if (yy_start != INITIAL) { */
    /*     fputs("wrong state", stderr); */
    /*     return 1; */
    /* } */

  return( 1 ); /* neede to prevent restart of the analysis */
}
