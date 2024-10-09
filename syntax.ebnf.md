# numple EBNF grammar declaration
The syntax for indentation is the same as in (pythons grammar)[https://docs.python.org/3/reference/grammar.html]. It is described in detail in their article on [lexical analysis](https://docs.python.org/3.3/reference/lexical_analysis.html#indentation). In short, the token INDENT and DEDENT convey an increase or decrease in indentation. A code block is therefore started by an INDENT token and ended by a DEDENT token.

```bnf
program
    : (statement)+
    ;

newline
    : '\n'
    : '\r\n'
    : '\r'
    ;

comment
    : newline [A-Z] [0-255]* '.' newline
    ;

block
    : newline INDENT statement+ DEDENT
    ;

type
    : 'N'
    : 'Z'
    : 'Q'
    : 'R'
    : 'C'
    ;

statement
    : 'if' boolean block ('else' 'if' boolean block)* ('else' block)? newline
    : identifier, (',' identifier)* '=' expression (',' expression)* newline
    : identifier, '(' function_arguments ')' type? (',' type)* '->' type (',' type)* newline ('where' boolean newline)? block
    : 'return' expression (',' expression)* newline
    : expression '?' newline
    : 'load' identifier newline
    ;

boolean
    : boolean 'or' boolean
    : boolean 'and' boolean
    : 'not' boolean
    : '(' boolean ')'
    : comparison
    ;

comparison
    : expression ('=' | '!=' | '>' | '>=' | '<' | '<=') expression
    : expression ('<' | '<=') expression ('<' | '<=') expression
    : expression ('>' | '>=') expression ('>' | '>=') expression
    ;

identifier
    : [a-z], [a-z0-9_]*
    ;

function_arguments
    : identifier? (',' identifier)*
    ;

expression
    : expression ('+' | '-') term
    : ('+' | '-')? term
    ;

term
    : factor (('*' | '/' | '%') factor)+
    : factor
    ;

factor
    : base '^' base
    : base
    ;

base
    : '(' expression ')'
    : base, '!'
    : identifier
    : number?, [a-z_]+
    : identifier, '(' expression? (',' expression)* ')'
    ;

number
    : [0-9]+
    : [0-9]+, ('.' | ','), [0-9]+
    ;
```
# Note to self
- Don't forget the 5 < x < 10 syntax
- Don't forget the 5x syntax
- Also, don't forget that function(x) can return more than one value, which is troublesome in expressions. The only allowed functions in expressions are single-valued functions. The parser should throw an error.
