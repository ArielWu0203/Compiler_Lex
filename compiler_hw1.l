/* Definition section */
%{
	#include <stdio.h>
	#include <stdlib.h>
    int yylineno;
    int comment_line = 0;
%}

%x COMMENT

/* Define regular expression label */

letter [a-zA-Z]
digit [0-9]
ws [ \t]+
nextline \n
id {letter}+({letter}|{digit})*
number {digit}+
string_const \"[^\n]+\"
int_number {digit}+
float_number {int_number}\.{int_number}
comment "//"[^\n]+\n

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
{string_const}    { 
                    int len =(int) strlen(yytext);
                    printf("%c \t QUOTA\n", *yytext);
                    for (int i=0;i<len-2;i++) printf("%c",*(yytext+1+i));
                    printf(" \t STR_CONST\n");
                    printf("%c \t QUOTA\n",*(yytext+len-1));
                  }
{comment}   { char tmp[(int)strlen(yytext)];memset(tmp,'\0',sizeof(tmp));strncpy(tmp,yytext,(int)strlen(yytext)-1);printf("%s \t C++ Comment\n",tmp);yylineno++;comment_line++;}
"/*"    {printf("%s",yytext);BEGIN COMMENT;}
<COMMENT>\n     {printf("%s",yytext); yylineno++;comment_line++;}
<COMMENT>.     {printf("%s",yytext); }
<COMMENT>"*/"   {
                  comment_line++;
                  printf("%s \t C Comment\n",yytext);
                  BEGIN 0;
                }
"print"     { printf("%s \t PRINT\n", yytext); }
"if"     { printf("%s \t IF\n", yytext); }
"else"     { printf("%s \t ELSE\n", yytext); }
"for"     { printf("%s \t FOR\n", yytext); }
"while"     { printf("%s \t WHILE\n", yytext); }
"string"     { printf("%s \t STRING\n", yytext); }
"int"     { printf("%s \t INT\n", yytext); }
"float"     { printf("%s \t FLOAT\n", yytext); }
"="     { printf("%s \t ASGN\n", yytext); }
"+="     { printf("%s \t ADDASGN\n", yytext); }
"-="     { printf("%s \t SUBASGN\n", yytext); }
"*="     { printf("%s \t MULASGN\n", yytext); }
"/="     { printf("%s \t DIVASGN\n", yytext); }
"%="     { printf("%s \t MODASGN\n", yytext); }
"&&"     { printf("%s \t AND\n", yytext); }
"||"     { printf("%s \t OR\n", yytext); }
"!"     { printf("%s \t NOT\n", yytext); }
"{"     { printf("%s \t LCB\n", yytext); }
"}"     { printf("%s \t RCB\n", yytext); }
"void"     { printf("%s \t VOID\n", yytext); }
"bool"     { printf("%s \t BOOL\n", yytext); }
"true"     { printf("%s \t TRUE\n", yytext); }
"false"     { printf("%s \t FALSE\n", yytext); }
"return"     { printf("%s \t RET\n", yytext); }
"continue"     { printf("%s \t CONT\n", yytext); }
"break"     { printf("%s \t BREAK\n", yytext); }
{int_number}    { printf("%s \t I_CONST\n",yytext); }
{float_number}    { printf("%s \t F_CONST\n",yytext); }

{id}	{ printf("%s \t ID\n", yytext); }
\n			{yylineno++; }
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
	printf("\nParse over, the line number is %d.\n\n",yylineno-1);
	printf("comment: %d lines\n\n",comment_line);

	return 0;
}
