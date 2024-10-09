# numple EBNF grammar declaration
The syntax for indentation is the same as in (pythons grammar)[https://docs.python.org/3/reference/grammar.html]. It is described in detail in their article on [lexical analysis](https://docs.python.org/3.3/reference/lexical_analysis.html#indentation). In short, the token INDENT and DEDENT convey an increase or decrease in indentation. A code block is therefore started by an INDENT token and ended by a DEDENT token.

```
program
  : (statement)+
  ;

newline
  : '\n'
  | '\r\n'
  ; '\r'

comment
  : newline indentation? ['A'-'Z'] [0-255]* '.' newline
  ;

block
  : INDENT statement+ DEDENT
  ;

statement
  : 'if' boolean_expr INDENT statement+
  : 'if' boolean_expr INDENT statement+ DEDENT 'else' INDENT statement+ DEDENT
  : 'if' boolean_expr INDENT statement+ DEDENT ('else' 'if' INDENT statement+ DEDENT)+
  : 'if' boolean_expr INDENT statement+ DEDENT ('else' 'if' INDENT statement+ DEDENT)+ 'else' INDENT statement+ DEDENT
  : identifier '=' expression newline
  : identifier (',' identifier)+ '=' expression (',' expression)+
  : identifier '(' ( identifier (',' identifier)* )? ')'
  : 'return' expression newline
  : 'return' expression (',' expression)*
  : 'load' filename newline
  ;

boolean_expr
  : 'not'? expression boolean_operator expression
  : 'not'? boolean_chain_Expr

boolean_chain_expr

boolean_operator
  : '='
  : '!='
  : ''
```
# Note to self
- Don't forget the 5 < x < 10 syntax
- Don't forget the 5x syntax
- Also, don't forget that function(x) can return more than one value, which is troublesome in expressions. The only allowed functions in expressions are single-valued functions. The parser should throw an error.
