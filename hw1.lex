%{

/* Declarations section */
#include <stdio.h>
void showToken(char*);
void handleError();
%}

%option yylineno
%option noyywrap

noZero				([1-9])
digit   			([0-9])
letter  			([a-zA-Z])
month 				((0{noZero})|(10)|(11)|(12))
day					((0{noZero})|([1-2]{digit})|(30))
year				((20|19){digit}{digit})
whitespace			([ ])
tag					({letter}({letter}|{digit})*)
exp					(e[-+]?{digit}+)
real				({digit}*\.{digit}+)
all					({digit}*{noZero}{digit}*)
realNoZero			(({all}\.{digit}*)|({digit}*\.{all}))
natural				({noZero}({digit}*))
int					(0|{natural})
withoutA			([^\-])
withoutB			([^\-\>])
word				(({withoutA}|-{withoutA}|\-\-+{withoutB})*\-*)				
comment				(\<!\-\-{word}\-\-\>)
value				(([^\"\n])*)	
punctuation			([\.,\-{whitespace}])				
%%

{comment}													showToken("COMMENT");												
{int}														showToken("INT");
(((0{natural}|{natural}|{realNoZero}){exp}?)|{real})		showToken("FLOAT");
{year}\-{month}\-{day}										showToken("DATE");
{letter}({letter}|\.|,|{whitespace})*						showToken("STRING");
\<{tag}														showToken("SS_TAG");
\>															showToken("SE_TAG");
\<{tag}{whitespace}\/>										showToken("SINGLE_TAG");	
\<\/{tag}\>													showToken("E_TAG");	
{tag}=\"{value}\"											showToken("ATTR");
{punctuation}												showToken("PUNCTUATION");
.															handleError();
%%

void showToken(char* name)
{
        printf("%d %s %s/n" , yylineno, name, yytext);		
}
void handleError() 
{
	printf("Error %s/n",yytext);
	exit(0);
}
