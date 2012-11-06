/*Assignment 1. Jinglun DONG*/
%{
#include "parser.tab.h"
#include "parser.h"

/*Symbol Table*/
struct token entity[1000];

int count = 0;     //number of tokens
%}

ID	{letter}({letter}|{digit}|_)*

letter 	[A-Za-z]

digit	[0-9]

INT	{digit}+

STR	\"[^\n"]+\"

WS	[ \t\r\n]+  

%%
and 		{return(AND);}
begin		{return(_BEGIN);}
forward 	{return(FORWARD);}
div       	{return(DIV);}
do  		{return(DO);}
else		{return(ELSE);}
end		{return(END);}
for		{return(FOR);}
function	{return(FUNCTION);}
if    	{return(IF);}
array		{return(ARRAY);}
mod	    {return(MOD);}
not		{return(NOT);}
of		{return(OF);}
or		{return(OR);}
procedure	{return(PROCEDURE);}
program   {return(PROGRAM);}
record	{return(RECORD);}
then		{return(THEN);}
to		{return(TO);}
type		{return(TYPE);}
var		{return(VAR);}
while		{return(WHILE);}
sym		{return(SYM);}

{ID}		{yylval.num = (int)installID(); return(ID);}

{INT}		{yylval.num = (int)installNum(); return(INT);}

{STR}		{yylval.num = (int)installStr(); return(STR);}

"."		    {yylval.num = DOT; return(DOT);}
","     	{yylval.num = COMMA; return(COMMA);}
":" 		{yylval.num = COLON; return(COLON);}
";" 		{yylval.num = SEMIC; return(SEMIC);}
":="    	{yylval.num = ASSIGN; return(ASSIGN);}
".."    	{yylval.num = DOTDOT; return(DOTDOT);}
"(" 		{yylval.num = LPAR; return(LPAR);}
")" 		{yylval.num = RPAR; return(RPAR);}
"["		    {yylval.num = LBRAC; return(LBRAC);}
"]"		    {yylval.num = RBRAC; return(RBRAC);}


"="         {yylval.num = EQUAL; return(EQUAL);}
"<"         {yylval.num = LESS; return(LESS);}
"<="        {yylval.num = LESSEQUAL; return(LESSEQUAL);}
">"         {yylval.num = GREATER; return(GREATER);}
">="        {yylval.num = GREATEREQUAL; return(GREATEREQUAL);}
"<>"        {yylval.num = NOTEQUAL; return(NOTEQUAL);}

"+"         {yylval.num = PLUS; return(PLUS);}
"-"         {yylval.num = MINUS; return(MINUS);}
"*"         {yylval.num = STAR; return(STAR);}

{WS}	    {/* skip blanks and tabs */}

"{"[^{}]*"}" 	{/* ignore comments */}

{digit}{ID}	{return(UNKOWN);}

.           {return(UNKOWN);}

%%
int yywrap(void){return 1;}

int installID(){
char* str = strdup(yytext);
int i;
 for(i=0;i<count;i++){
  if(!strcmp(entity[i].value,str)){
   return i;
  }
 }
 int index = count;
 entity[index].value = str;
 entity[index].property = "ID";
 count++;
 return index;
}

int installNum(){
 return 0;
}

int installStr(){
 return 0;
}

/*
int main( int argc, char **argv ){
    ++argv, --argc;  
    if ( argc > 0 )
         yyin = fopen( argv[0], "r" );
    else
         yyin = stdin;
    int tokenNum;
    while(tokenNum = yylex()){
        printf("%d\n",tokenNum);
    }
}
*/

