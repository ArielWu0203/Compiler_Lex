/* Definition section */
%{
	#include <stdio.h>
	#include <stdlib.h>
    int yylineno;
%}

/* Define regular expression label */

letter [a-zA-Z]
digit [0-9]
ws [ \t]+
nextline \n
id {letter}+({letter}|{digit})*
number {digit}+
string_const \"[^"]+\"

/* Rules section */
%%

"+" 	{ printf("%s \t ADD\n", yytext); }
"-"		{ printf("%s \t SUB\n", yytext); }
"*"     { printf("%s \t MUL\n", yytext); }
"/"     { printf("%s \t DIV\n", yytext); }
"%"     { printf("%s \t MOD\n", yytext); }
"++"     { printf("%s \t INC\n", yytext); }
"--"     { printf("%s \t DEC\n", yytext); }
">"     { printf("%s \t MT\n", yytext); }
"<"     { printf("%s \t LT\n", yytext); }
">="     { printf("%s \t MTE\n", yytext); }
"<="     { printf("%s \t LTE\n", yytext); }
"=="     { printf("%s \t EQ\n", yytext); }
"!="     { printf("%s \t NE\n", yytext); }
"["     { printf("%s \t LSB\n", yytext); }
"]"     { printf("%s \t RSB\n", yytext); }
","     { printf("%s \t COMMA\n", yytext); }
";"     { printf("%s \t SEMICOLON\n", yytext); }
"("     { printf("%s \t LB\n", yytext); }
")"     { printf("%s \t RB\n", yytext); }
\"      { printf("%s \t QUOTA\n", yytext);}
{string_const}    { 
                    int len =(int) strlen(yytext);
                    printf("%c \t QUOTA\n", *yytext);
                    for (int i=0;i<len-2;i++) printf("%c",*(yytext+1+i));
                    printf(" \t STR_CONST\n");
                    printf("%c \t QUOTA\n",*(yytext+len-1));
                  }
"print"     { printf("%s \t PRINT\n", yytext); }
{id}	{ printf("%s \t ID\n", yytext); }
\n			{;}
{ws}    {;}

%%

/*	C Code section */
int yywrap(void)
{
    return 1;
}

int main(int argc,char *argv[])
{
	yyin = fopen(argv[1],"r");
	yylex();
	printf("\nParse over, the line number is %d.\n\n",yylineno);
	printf("comment: 1 lines\n\n");

	return 0;
}
