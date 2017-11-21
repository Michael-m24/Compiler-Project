%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct node{
    char *token;
    struct node *left;
    struct node *middle;
    struct node *right;
} node;

node *mknode (char *token, node *left, node* middle, node *right);
void printtree (node *tree);
#define YYSTYPE struct node *
%}
%token BOOL, CHAR, INT, STRING, INTPTR, CHARPTR, ID
%token IF, ELSE, WHILE, FOR
%token MAIN, PROCEDURE, RETURN
%token BOOLTRUE, BOOLFALSE, CSNULL, INTEGER_POS, INTEGER_NEG, CHAR_CONST, STRING_CONST, HEX_CONST, OCTAL_CONST, BINARY_CONST
%token ASSIGNMENT,AND,DIVISION,EQUAL,GREATER,GREATEREQUAL,LESS,LESSEQUAL,MINUS,NOT,NOTEQUAL,OR,PLUS,MULTI,ADDRESS,DEREFERENCE,ABSUOLUTE,SEMICOLON,COLON,COMMA,LEFTBRACE,RIGHTBRACE,LEFTPAREN,RIGHTPAREN,LEFTBRACKET,RIGHTBRACKET,PERCENT

%right ASSIGNMENT ELSE 
%left LEFTBRACE RIGHTBRACE LEFTPAREN RIGHTPAREN
%left EQUAL GREATER GREATEREQUAL LESSEQUAL LESS NOTEQUAL
%left PLUS MINUS AND OR 
%left MULTI DIVISION
%start s
%%
s: expr     {printf ("ok\n");   printtree ($1); };
expr:       expr PLUS expr    {$$ = mknode ("+", $1, NULL, $3); }
               | expr MINUS expr {$$ = mknode ("-", $1, NULL, $3); }
               | expr MULTI expr {$$ = mknode ("*", $1, NULL, $3); }
               | expr DIVISION expr {$$ = mknode ("/", $1, NULL, $3); }
               | Pexpr
               | numbers                   
               | statements {;};
               
Pexpr:  leftParen expr rightParen {$$ = mknode ("", $1, $2, $3); };
leftParen: LEFTPAREN {$$ = mknode ("(", NULL, NULL, NULL); };
rightParen: RIGHTPAREN {$$ = mknode (")", NULL, NULL, NULL); };
numbers: INTEGER_NEG {printf("yytext neg num=%s\n",yytext); $$ = mknode (yytext, NULL, NULL, NULL); } 
            |      INTEGER_POS  {printf("yytext pos num=%s\n",yytext); $$ = mknode (yytext, NULL, NULL, NULL); };
 statements: IF_statements {;}  
            |   LOOP_statements  {;}
            |  IN.OUT_statements {;} ;
IF_statements: IF | ELSE;
LOOP_statements: WHILE | FOR;
IN.OUT_statements: ;
%%

#include "lex.yy.c"
int main(){
    return yyparse();
}

node *mknode    (char *token, node *left, node* middle, node *right){
    node *newnode = (node*)malloc (sizeof(node));
    char    *newstr = (char*)malloc (sizeof(token)+1);
    strcpy (newstr, token);
    newnode -> left = left;
    newnode -> right = right;
    newnode -> middle = middle;
    newnode -> token = newstr;
    return newnode;
}

void printtree (node *tree){
    if (strlen(tree->token) > 0 )
        printf ("%s\n", tree -> token);
    if (tree -> left)
        printtree (tree-> left);
    if (tree -> middle)
        printtree (tree-> middle);     
    if (tree -> right)
        printtree (tree-> right); 
}
int yyerror(char* s){
    printf ("MY ERROR: %s at line %d with syntax %s\n",  s,counter, yytext);
    return 0;
}
