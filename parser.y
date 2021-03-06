%{
#include "parser.h"

extern FILE *yyin;
extern int count;
extern char* yytext;

/*Symbol Table*/
extern struct token entity[10000];

/*Function declaration*/
void set_ID_type(int,char*);
void set_Function_type(int,struct ids* idptr);
void set_VarIds_type(struct ids*,char*);
char* toStr(int);
%}

%union {
  struct ids* idtype;
  int num;
  char* strtype;
}

%token 	AND
%token 	ARITH
%token 	ARRAY
%token 	ASSIGN
%token 	_BEGIN
%token 	COLON
%token 	COMMA
%token 	digit
%token 	DIV 	
%token 	DO
%token 	DOT
%token 	DOTDOT
%token 	ELSE
%token 	END
%token 	EQUAL
%token 	FOR
%token 	FORWARD 	
%token 	FUNCTION
%token 	GREATER
%token 	GREATEREQUAL
%token 	<num> 	ID
%token 	IF
%token 	INT
%token 	LBRAC
%token 	LESS
%token 	LESSEQUAL
%token 	letter 	
%token 	LPAR
%token 	MINUS
%token 	MOD
%token 	NEWLINE
%token 	NOT
%token 	NOTEQUAL
%token 	OF
%token 	OR
%token 	PLUS
%token 	PROCEDURE
%token 	PROGRAM
%token 	RBRAC
%token 	RECORD
%token 	RELOP 	
%token 	RPAR
%token 	SEMIC
%token 	STAR
%token 	STR
%token 	SYM
%token 	THEN
%token 	TO
%token 	TYPE
%token 	VAR
%token 	WHILE
%token 	WS
%token 	UNKOWN

%type <idtype> Identifierlist TypeDefinition VariableDeclaration ProcedureDeclaration FunctionDeclaration FormalParameterList FormalParameterListSub
%type <strtype> Type

%%
Program: PROGRAM ID SEMIC CompoundStatement DOT {printf("Program\n");}
       | PROGRAM ID SEMIC TypeDefinitions CompoundStatement DOT {printf("Program\n");}
       | PROGRAM ID SEMIC VariableDeclarations CompoundStatement DOT {printf("Program\n");}
       | PROGRAM ID SEMIC SubprogramDeclarations CompoundStatement DOT {printf("Program\n");}
       | PROGRAM ID SEMIC VariableDeclarations SubprogramDeclarations CompoundStatement DOT {printf("Program\n");}
       | PROGRAM ID SEMIC TypeDefinitions SubprogramDeclarations CompoundStatement DOT {printf("Program\n");}
       | PROGRAM ID SEMIC TypeDefinitions VariableDeclarations CompoundStatement DOT {printf("Program\n");}
       | PROGRAM ID SEMIC TypeDefinitions VariableDeclarations SubprogramDeclarations CompoundStatement DOT {printf("Program\n");}
;

TypeDefinitions: TYPE TypeDefinitionSub {printf("TypeDefinitions\n");} 
;

TypeDefinitionSub: TypeDefinition SEMIC
                 | TypeDefinition SEMIC TypeDefinitionSub
;

VariableDeclarations: VAR VariableDeclarationSub {printf("VariableDeclaration\n");} 
;

VariableDeclarationSub: VariableDeclaration SEMIC 
                      | VariableDeclaration SEMIC VariableDeclarationSub
;

SubprogramDeclarations: ProcedureDeclaration SEMIC
                      | FunctionDeclaration SEMIC
                      | ProcedureDeclaration SEMIC SubprogramDeclarations
                      | FunctionDeclaration SEMIC SubprogramDeclarations
;

TypeDefinition: ID EQUAL Type {printf("TypeDefinition\n");set_ID_type($1,$3);}
;

VariableDeclaration: Identifierlist COLON Type {printf("VariableDeclaration\n");set_VarIds_type($1,$3);}
;

ProcedureDeclaration: PROCEDURE ID LPAR FormalParameterList RPAR SEMIC Block 
                        {printf("ProcedureDeclaration\n");set_Function_type($2, $4);}
                    | PROCEDURE ID LPAR FormalParameterList RPAR SEMIC FORWARD
		                {printf("ProcedureDeclaration\n");set_Function_type($2, $4);}
;

FunctionDeclaration: FUNCTION ID LPAR FormalParameterList RPAR COLON ResultType SEMIC Block 
			{printf("FunctionDeclaration\n");set_Function_type($2, $4);}
                   | FUNCTION ID LPAR FormalParameterList RPAR COLON ResultType SEMIC FORWARD 
			{printf("FunctionDeclaration\n");set_Function_type($2, $4);}
;

FormalParameterList: {printf("FormalParameterList\n");}
                   | FormalParameterListSub {printf("FormalParameterList\n");}
;

FormalParameterListSub: Identifierlist COLON Type { $$->depth = $1->depth; }
                      | Identifierlist COLON Type SEMIC FormalParameterListSub { $$->depth = $1->depth + $5->depth; }
;

Block: VariableDeclarations CompoundStatement {printf("Block\n");}
     | CompoundStatement {printf("Block\n");}
;

CompoundStatement: _BEGIN StatementSequence END {printf("CompoundStatement\n");}
;

StatementSequence: Statement {printf("StatementSequence\n");}
                 | Statement SEMIC StatementSequence {printf("StatementSequence\n");}
;

SimpleStatement: {printf("SimpleStatement\n");}
         | AssignmentStatement {printf("SimpleStatement\n");}
         | ProcedureStatement {printf("SimpleStatement\n");}
;

AssignmentStatement: Variable ASSIGN Expression  {printf("AssignmentStatement\n");}
;

ProcedureStatement: ID LPAR ActualParameterList RPAR {printf("ProcedureStatement\n");}
;

Statement: OpenStatement
         | ClosedStatement
;

OpenStatement: IF Expression THEN Statement {printf("StructuredStatement\n");}
             | IF Expression ClosedStatement ELSE OpenStatement {printf("StructuredStatement\n");}
             | WHILE Expression DO OpenStatement {printf("StructuredStatement\n");}
             | FOR ID ASSIGN Expression TO Expression DO OpenStatement {printf("StructuredStatement\n");}
;

ClosedStatement: SimpleStatement {printf("Statement\n");}
               | CompoundStatement {printf("StructuredStatement\n");}
               | IF Expression THEN ClosedStatement ELSE ClosedStatement {printf("StructuredStatement\n");}
               | WHILE Expression DO ClosedStatement {printf("StructuredStatement\n");}
               | FOR ID ASSIGN Expression TO Expression DO ClosedStatement {printf("StructuredStatement\n");}
;

Type: ID {printf("Type\n"); $$ = toStr($1);}
    | ARRAY LBRAC Constant DOTDOT Constant RBRAC OF Type {printf("Type\n"); $$ = "array";}
    | RECORD Fieldlist END {printf("Type\n"); $$ ="record";}
;

ResultType: ID {printf("ResultType\n");}
;

Fieldlist: {printf("Fieldlist\n");}
          | FieldlistSub {printf("Fieldlist\n");}
;

FieldlistSub: Identifierlist COLON Type {set_VarIds_type($1,$3);}
            | Identifierlist COLON Type SEMIC FieldlistSub {set_VarIds_type($1,$3);}
;

Constant: Sign INT {printf("Constant\n");}
        | INT {printf("Constant\n");}
;

Expression: SimpleExpression {printf("Expression\n");}
          | SimpleExpression RelationalOp SimpleExpression {printf("Expression\n");}
;

RelationalOp: LESS {printf("RelationalOp\n");}
             |LESSEQUAL {printf("RelationalOp\n");}
             |GREATER {printf("RelationalOp\n");}
             |GREATEREQUAL {printf("RelationalOp\n");}
             |NOTEQUAL {printf("RelationalOp\n");}
             |EQUAL {printf("RelationalOp\n");}
;

SimpleExpression: Sign SimpleExpressionSub {printf("SimpleExpression\n");}
                | SimpleExpressionSub {printf("SimpleExpression\n");}
;

SimpleExpressionSub: Term
                   | Term AddOp SimpleExpressionSub
;

AddOp: PLUS {printf("AddOp\n");}
     | MINUS {printf("AddOp\n");}
     | OR {printf("AddOp\n");}
;

Term: Factor {printf("Factor\n");}
    | Factor MulOp Term {printf("Factor\n");}
;

MulOp: STAR {printf("MulOp\n");}
     | DIV {printf("MulOp\n");}
     | MOD {printf("MulOp\n");}
     | AND {printf("MulOp\n");}
;

Factor: INT {printf("Factor\n");}
      | STR {printf("Factor\n");}
      | Variable  {printf("Factor\n");}
      | FunctionReference {printf("Factor\n");}
      | NOT Factor {printf("Factor\n");}
      | LPAR Expression RPAR  {printf("Factor\n");}
;

FunctionReference: ID LPAR ActualParameterList RPAR  {printf("FunctionReference\n");}
;

Variable: ID ComponentSelection {printf("Variable\n");}
;

ComponentSelection: {printf("ComponentSelection\n");}
                  | DOT ID ComponentSelection {printf("ComponentSelection\n");}
                  | LBRAC Expression RBRAC ComponentSelection {printf("ComponentSelection\n");}
;

ActualParameterList: {printf("ActualParameterList\n");}
                  | ActualParameterListSub {printf("ActualParameterList\n");}
;

ActualParameterListSub: Expression
                      | Expression COMMA ActualParameterListSub
;

Identifierlist: ID { $$ = newid($1,NULL); printf("Identifierlist\n");}
              | ID COMMA Identifierlist { $$ = newid($1,$3); printf("Identifierlist\n");}
;

Sign: PLUS {printf("Sign\n");}
    | MINUS {printf("Sign\n");}
;
%%
int main(int argc, char *argv[])
{
    ++argv, --argc;    /* skip argv[0] */
    if (argc > 0) {
        yyin = fopen(argv[0], "r");
    } else {
        yyin = stdin;
    }
    freopen("rule.out","w",stdout);
    freopen("rule.err", "w", stderr);
    yyparse();

    freopen("symtable.out","w",stdout);
    freopen("symtable.err", "w", stderr);
    int i;
    for(i=0;i<count;i++){
      printf("entry: %3d, symbol: %12s, property: %3s, type: %4s \n",i,entity[i].value,entity[i].property,entity[i].type);
    }
    return 0;
};

yyerror(char *s)
{
  fprintf(stderr, "error: %s\n", s);
};

void set_ID_type(int id, char* type){ 
  entity[id].type = strdup(type);
}

void set_Function_type(int id, struct ids* idptr){
  char buffer[30];
  sprintf(buffer,"%d",idptr->depth);
  entity[id].type = strdup(buffer);
}

void set_VarIds_type(struct ids* ids,char* type){
  while(ids != NULL){
    entity[ids->index].type = strdup(type);
    ids = ids->next;
  }
}

struct ids* newid(int id,struct ids* next){
  struct ids* i = malloc(sizeof(struct ids));  
  i->index = id;
  i->next = next;
  if(next == NULL){
    i->depth = 1;
  }else{
    i->depth = 1 + (next->depth);
  }
  return i;
}

char* toStr(int id){
  return entity[id].value;
}
