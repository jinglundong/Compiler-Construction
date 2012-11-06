#Compiler Construction

##Author:
Jinglun Dong

##Dependency:
Lexer using flex
Parser using bison

##How to compile:
$flex lexer.l
$bison -d parser.y
$gcc lex.yy.c parser.tab.c -o parser.out

##How to run:
$./parser.out < inputStream
OR:
$./parser.out inputFile.txt

##Output:
stdout for rules and symbo table goes to rule.out and symtable.out
stderr for rules and symbo table goes to rule.err and symtable.err
