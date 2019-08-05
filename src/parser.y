%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include "library.h"
    // int yyerror(const char *s);
    int yylex(void);
    extern FILE* yyin;
    extern short shouldPrintDebugInfo;
    extern char *getTypeName(int type);
%}

%union {
  struct ast *a;
  int i;
  double d;
  struct symbol *s;		/* which symbol */
  struct symlist *sl;
  int fn;			/* which function */
}

%error-verbose
%token IF ELSE FOR IN TO BY ARROW
%token DEF
%token RETURN EXTERN
%token <s> ID
%token OP_EQ OP_GT OP_GTE OP_LT OP_LTE OP_NE
%token <i> INT DOUBLE
%token <i> INT_VAL 
%token <d> DOUBLE_VAL
%token COMMA
%token <fn> FUNC


%left <fn> OP_EQ OP_NE
%left <fn> OP_GTE OP_LTE
%left <fn> OP_GT OP_LT
%right '='
%left '+' '-'
%left '*' '/'
%left '%'
%right '(' ')'

%type <a> stmt expr program stmts if_stmt for_stmt block numeric multi_purpose_exp comparison_exp boolean_result_exp function_call_exp call_args mathematical_exp variable_exp assignment_exp func_decl
%type <sl> func_decl_args
%type <s> var_decl
%type <fn> comparison
%type <i> type

%%
// Program

program:  stmts {
                    if (shouldPrintDebugInfo) dumpast($1,5);
                    eval($1);
                    treefree($1);
                };
stmts:    stmt 
        | stmts stmt { $$ = newast('L', $1, $2); };
stmt:     var_decl 
        | func_decl 
        | extern_decl  
        | if_stmt
        | for_stmt
        | expr
        | RETURN expr { $$ = $2;} ;





if_stmt:  IF '(' expr ')' block                 { 
                    $$ = newflow('I', $3, $5, NULL); 
                  }
        | IF '(' expr ')' block ELSE block      { 
                    $$ = newflow('I', $3, $5, $7); 
                  };
for_stmt: FOR '('  ID ':'  type IN expr TO expr ')' block {
                    struct symbol *t = lookup($3->name);
                    setReturnType(t, $5);
                    $$ = newforflow(t,$7, $9, $11, newnum_int(1)); 
                }
        | FOR '('  ID ':'  type IN expr TO expr BY expr ')' block  {
                    struct symbol *t = lookup($3->name);
                    setReturnType(t, $5);
                    $$ = newforflow(t,$7, $9, $13, $11); 
                };




block:    '{' stmts '}' { $$ = newast('L', NULL, $2);}
        | '{'  '}' { $$ = newast('L', NULL, NULL);};
comparison: OP_EQ | OP_NE | OP_GT | OP_GTE | OP_LT | OP_LTE;





// Declarations
var_decl:  ID ':'  type { 
                          if (shouldPrintDebugInfo) printf("TYPE_TOKEN: %d\n", $3);
                          struct symbol *t = lookup($1->name);
                          int type = getType(t);
                          // if (type == 'Z' || type== 'K'){
                          //   printf("ERROR: can't declare already declared variable %s(%s).\n", t->name, getTypeName(t->return_type));
                          //   exit(1);
                          // }
                          setReturnType(t, $3);
                          $$ = newref($1);
                       }
          | ID ':'  type  '=' expr {
                          if (shouldPrintDebugInfo) printf("TYPE_TOKEN: %d\n", $3);
                          struct symbol *t = lookup($1->name);
                          setReturnType(t, $3);
                          $$ = newasgn(t, $5);
                      };  
extern_decl: EXTERN  ID '(' func_decl_args ')' ':'  type 
        | EXTERN ID '(' ')' ':' type
        | EXTERN ID ':' type;
func_decl: DEF  ID '(' func_decl_args ')' ':'  type ARROW block   {
        dodef($2, $4, $9);
        struct symbol *t = lookup($2->name);
        setReturnType(t, $7);
        // dumpast(lookup($2->name)->func, 0);
        if (shouldPrintDebugInfo) printf("DEFINED FUNCTION: %s\n", $2->name);
        $$ = newnum_int(-1);
} 
        | '(' func_decl_args ')' ':'  type ARROW block {
        struct symbol *t = lookup("anonymous");
        setReturnType(t, $5);
        dodef(t, $2, $7);
        if (shouldPrintDebugInfo) printf("DEFINED FUNCTION: %s\n", t->name);
        $$ = newnum_int(-1);
}
        | DEF ID '(' ')' ':' type ARROW block {
        struct symbol *t = lookup($2->name);
        setReturnType(t, $6);
        dodef(t, NULL, $8);
        if (shouldPrintDebugInfo) printf("DEFINED FUNCTION: %s\n", t->name);
        $$ = newnum_int(-1);
};
func_decl_args:  var_decl    { $$ = newsymlist(((struct symref *)$1)->s, NULL);}
              | var_decl COMMA func_decl_args  { $$ = newsymlist(((struct symref *)$1)->s, $3); };





// Expressions
expr: multi_purpose_exp
    | boolean_result_exp;

multi_purpose_exp: mathematical_exp
    | variable_exp
    | function_call_exp
    | FUNC '(' call_args ')' { $$ = newfunc($1, $3); }
    | '(' expr ')' { $$ = $2; }
    | assignment_exp
    | numeric;

mathematical_exp: multi_purpose_exp '%' multi_purpose_exp  { $$ = newast('%', $1,$3); }
    | multi_purpose_exp '*' multi_purpose_exp  { $$ = newast('*', $1,$3); }
    | multi_purpose_exp '/' multi_purpose_exp  { $$ = newast('/', $1,$3); }
    | multi_purpose_exp '+' multi_purpose_exp  { $$ = newast('+', $1,$3); }
    | multi_purpose_exp '-' multi_purpose_exp  { $$ = newast('-', $1,$3);};

variable_exp: ID { $$ = newref($1); };
assignment_exp: ID '=' expr { $$ = newasgn($1, $3); };

function_call_exp: ID '(' call_args ')' {
          $$ = newcall($1, $3);
          if (shouldPrintDebugInfo) printf("CALLING FUNCTION: %s\n", $1->name);
        }
    |  ID '(' ')' {$$ = newcall($1, NULL);}
    | '(' call_args ')' {$$ = newcall(lookup("anonymous"), $2);}
    ;

boolean_result_exp: comparison_exp;
comparison_exp: multi_purpose_exp comparison multi_purpose_exp { $$ = newcmp($2, $1, $3); };

type: INT {/*printf("FOUND TOKEN_TYPE: K\n");*/ $$ = 'K';}
      | DOUBLE {/*printf("FOUND TOKEN_TYPE: Z\n");*/ $$ = 'Z';} ;

numeric: INT_VAL { $$ = newnum_int($1); }
		| DOUBLE_VAL { $$ = newnum_double($1); };
	  
call_args: expr
        | expr COMMA call_args    {$$ = newast('L', $1, $3);}   ;


%%