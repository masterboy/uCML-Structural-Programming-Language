%{
    #include<stdlib.h>
    #include "library.h"
    #include "parser.tab.h"
    // int yyerror(const char *s);
    short shouldPrintDebugInfo = 0;
%}

alpha       [a-zA-Z]
digit       [0-9]
alnum       {alpha}|{digit}
alnumus		{alpha}|{digit}|_
print       [ -~]

ID          {alpha}+{alnumus}*
ICONST      "0"|[0-9]{digit}*
FCONST      "0"|{digit}*"."{digit}+

%option noyywrap yylineno

%%

"//".* {/*ignore comments*/}
"\"mode\ debug\"" {shouldPrintDebugInfo = 1;printf("DEBUG MODE ENABLED\n");}
"int" {return INT;}
"double" {return DOUBLE;}
"return" {return RETURN;}
"extern" {return EXTERN;}
"if" {return IF;}
"else" {return ELSE;}
"for" {return FOR;}
"in" {return IN;}
"to" {return TO;}
"by" {return BY;}
"def" {return DEF;}
"=>" {return ARROW;}
"=="    { yylval.fn = 4; return OP_EQ; }
"!="    { yylval.fn = 3; return OP_NE;}
"<"     { yylval.fn = 2; return OP_LT;}
"<="    { yylval.fn = 6; return OP_LTE;}
">"     { yylval.fn = 1; return OP_GT;}
">="    { yylval.fn = 5; return OP_GTE;}
"," {return COMMA;}

 /* built in functions */
"sqrt"  { yylval.fn = B_sqrt; return FUNC; }
"exp"   { yylval.fn = B_exp; return FUNC; }
"log"   { yylval.fn = B_log; return FUNC; }
"print" { yylval.fn = B_print; return FUNC; }
"echo" { yylval.fn = B_print; return FUNC; }
"printi" { yylval.fn = B_print; return FUNC; }
"newline" { yylval.fn = B_newline; return FUNC; }


{ID} {yylval.s = lookup(yytext);return ID;}
{ICONST} {yylval.i = atoi(yytext); return INT_VAL;}
{FCONST} {yylval.d = atof(yytext); return DOUBLE_VAL;}
[\(\)\{\}\:\+\-\*\/\=\<\>\%\!] return yytext[0];
[ \t] {};
[\r\n] {};
.		{ 
			yyerror("Unknown Character"); 
			// printf("%c - %d\n", yytext[0]);
			exit(1);	
		}

%%