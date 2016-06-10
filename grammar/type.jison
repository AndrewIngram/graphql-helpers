/* lexical grammar */
%lex

%{
	// Pre-lexer code can go here
%}

%%

[\s\r\n]+               /* skip whitespace */
"type"                return 'type'
"implements"          return 'implements'
"{"                   return '{'
"}"                   return '}'
"("                   return '('
")"                   return ')'
"["                   return '['
"]"                   return ']'
"!"                   return '!'
","                   return ','
":"                   return ':'
'\'\'\''              return 'DOCSTRING_DELIMETER'
[A-Z][a-zA-Z_0-9]*    return 'TYPE_NAME'
[a-z][a-zA-Z_0-9]*    return 'FIELD_NAME'
[a-zA-Z0-9]+          return 'WORD'
(.|\n)								return 'CHAR'
<<EOF>>               return 'EOF'

/lex

%left 'TYPE_NAME' 'WORD'
%left 'FIELD_NAME' 'WORD'
%left 'WORD'
%nonassoc UMINUS

%start expressions

%% /* language grammar */

expressions
    : type_definition 'EOF' { return yy.parser.yy; }
    ;

type_definition
    : type_docstring 'type' 'TYPE_NAME' 'implements' type_list '{' field_list '}'         { return {'name': $3, 'implements': $5, 'fields': $7}; }
    | type_docstring 'type' 'TYPE_NAME' '{' field_list '}'                                { return {'name': $3, 'implements': [], 'fields': $5}; }
    | type_docstring 'type' 'TYPE_NAME' '{' '}'                                           { return {'name': $3, 'implements': [], 'fields': []}; }
    ;

type_docstring
    : 'DOCSTRING_DELIMETER' contents 'DOCSTRING_DELIMETER' %prec UMINUS
    |
    ;

contents
    : content
        {$$ = $1;}
    | contents content
	      {$$ =  $1 + $2;}
    ;

content
	: WORD
		{
			if (!yy.lexer.wordHandler) yy.lexer.wordHandler = function(word) {return word;};
			$$ = yy.lexer.wordHandler(yytext);
		}
	| CHAR
		{
			if (!yy.lexer.charHandler) yy.lexer.charHandler = function(char) {return char;};
			$$ = yy.lexer.charHandler(yytext);
		}
 ;

type_list
    : type_list ',' TYPE_NAME                                              { $$ = $1; $$.push($3); }
    | TYPE_NAME                                                            { $$ = [$1]; }
    ;

field_list
    : field_list field                                                     { $$ = $1; $$.push($2); }
    | field                                                                { $$ = [$1]; }
    ;

field
    : FIELD_NAME field_arguments ':' field_type '!'                        { $$ = {'name': $1, 'args': $2, 'type': $4, 'required': true}; }
    | FIELD_NAME field_arguments ':' field_type                            { $$ = {'name': $1, 'args': $2, 'type': $4, 'required': false}; }
    ;

field_arguments
    : '(' field_argument_list ')'                                          { $$ = $2; }
    |                                                                      { $$ = []; }
    ;

field_argument_list
    : field_argument_list ',' field_argument                               { $$ = $1; $$.push($3); }
    | field_argument                                                       { $$ = [$1]; }
    ;

field_argument
    : FIELD_NAME ':' field_type '!'                                        { $$ = {'name': $1, 'type': $3, 'required': true}; }
    | FIELD_NAME ':' field_type                                            { $$ = {'name': $1, 'type': $3, 'required': false}; }
    ;

field_type
    : '[' TYPE_NAME ']'                                                    { $$ = {'name': $2, 'isList': true}; }
    | TYPE_NAME                                                            { $$ = {'name': $1, 'isList': false}; }
    ;

%%
