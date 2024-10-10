# numple
A simple programming language to help me with my math homework.

# First Version
To help me get a first version of the language up and running I will remove some features. The following will be temporarily removed:
- Type declarations. Functions only take real numbers as arguments and return one real number.
- Complex numbers
- Multiple return
- Multiple assign
- The `where` keyword
- Compiler
# Command Line Interface
The command line interface tool is called **numple**. Running `$ numple` without any arguments initializes an interactive **numple** session, otherwise known as [REPL](#REPL). Read more about the **numple** REPL in the header below.
## REPL
REPL (Read Evaluate Print Loop) is a collective term for interactive shells to programming languages. Python has one, Ruby has one, Julia has one and **numple** has one to. Inside of the REPL you can write **numple** code, import code with the `load` keyword and run your code in the interactive shell. Here's an example of an interactive **numple** session:
```rust
$ numple
Welcome to numple's interactive shell!
>>> x = root(5)
>>> x?
2 | x = root(5) ~ 2.236
>>> if x = root(5)
  |     x = 2
  |
>>> x?
7 | x = 2
>>> 
```
# Parser
## Namespace
**numple** has a few builtin functions and constants. You are not allowed to use these identifiers when defining numbers or functions respectively. You are however allowed to name a function by a builtin constants name and a number by a builtin functions name. For example naming your number `i = 2` is allowed. Or for example naming a function: `phi(x) -> R`. Below are all of the builtin functions in **numple**:
```ocaml
i(C) C -> C
re(c) C -> R
im(c) C -> R
ln(c) C -> C where abs(c) != 0
abs(c) C -> R
arg(c) C -> R where im(c) != 0
sin(c) C -> C
cos(c) C -> C
tan(c) C -> C
min(x, y) R, R -> R
max(x, y) R, R -> R
root(c) C -> C
root(c, n) C, N -> C where n > 0
floor(x) R -> Z
arcsin(c) C -> C
arccos(c) C -> C
arctan(c) C -> C
```

**numples** builtin constants are `e, pi, phi` and **numples** keywords are the following:
```python
or
if
is
not
and
load
loop
else
where
return
```
And here are all recognized symbols in **numple**:
```ocaml
N
Z
Q
R
C
,
(
)
->
?
+
-
*
/
^
%
!
=
!=
<
<=
>
>=
```
## Implicit multiplication
With single letter identifiers, implicit multiplication is allowed: `5xyz = 5 * x * y * z`. In this example the parser throws an error if the identifier `xyz` exists. Implicit multiplication with number literals on the left side of the multiplication is also fine. This means that: `5xy` is fine and that: `xy5` is not. However `(xy)5` is fine. In general the use of an asterix is encouraged. The implicit multiplication is just for convenience.
## Indentation
I used [this python article](https://docs.python.org/3.3/reference/lexical_analysis.html#indentation) as reference, however I have some other ideas on how to implement this. Whitespace is always ignored unless it is after a newline, this whitespace is otherwise known as indentation. The whitespace is counted and an `INDENT` token is output by the lexer. When the indentation is decreased, a `DEDENT` token is returned. Empty lines are ignored and do not generate any tokens.

The amount of indentation for a line is calculated by the following algorithm. Iterate through each character one by one. Each space adds one indentation. Each tab adds 1 to 4 spaces in order to make that total number of spaces until that point a multiple of 4. This is in order to account for code editors performing this same behavious with tabs.

The generation of INDENT and DEDENT tokens is done through the following algorithm described in python's [lexical analysis](https://docs.python.org/3.3/reference/lexical_analysis.html#indentation). This is done after the first pass of the lexer.
1. Push 0 onto the stack.
2. Compare the current lines indentation to the stack. If the current lines indentation is greater: generate a INDENT token, if it is less: generate a DEDENT token.
3. Push the indentation to the stack if it was a INDENT token.
4. Or pop the stack until the indentation is less than or equal if it was a DEDENT token. If the same indentation level is not on the stack, log a indentation error and keep going.
5. Repeat step 2 until the end of the file.
## Ambiguous if statements
Parenthesis are sometimes needed in order to avoid ambiguity in boolean expressions. For example the boolean expression `_ and _ or _` is ambiguous. It could be interpreted as either: `(_ and _) or _` or: `_ and (_ or _)` which are logically distinct boolean statements. The parser will throw an error is such a statement is found. Please note that the precedence rules for boolean expression in **numple** are the same as in math, that is:
1. parenthesis
2. not
3. and/or
This means that the statements such as: `not _ and _` are well defined. Also note that statements such as: `_ and _ and _` or: `_ or _ or _` are well defined.
## Errors
In order to give useful errors, the parser needs to keep track of where the error occurs. The parser errors also need to account for the origin of imported code. In general, try to log errors instead of exiting the program, it is annoying to fix an indentation error only to be met with another when you try to parse it again.

Also, don't forget to format the errors nicely and give good coloring and styling with [ANSI escape codes](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition%29_parameters). For example `bold_red="\x1b[;31m"` to make text red and bold in the terminal.
# Interpreter
## Runtime Errors
A few runtime errors can occur in **numple**. Since the parser has checked that the syntax is correct. The only things that can go wrong is regarding invalid expressions and Type mismatches. I.E. Division by zero and invlalid function arguments.
# Links
- [Zig tokenizer](https://mitchellh.com/zig/tokenizer#from-tokens-to-trees)
- [Zig tokenizer source](https://github.com/ziglang/zig/blob/master/lib/std/zig/tokenizer.zig)
- [Grammar visualiser](https://dundalek.com/GrammKit/)
- [Some EBNF Grammar](https://dzone.com/articles/ebnf-how-to-describe-the-grammar-of-a-language)
- [Python lexer analysis](https://docs.python.org/3.3/reference/lexical_analysis.html#indentation)
- [Python parser internals](https://github.com/python/cpython/blob/main/InternalDocs/parser.md)
- [Arithmetic expresison simplifications](http://www.semdesigns.com/Products/DMS/SimpleDMSDomainExample.html#TransformationRules)
- [Rational number simplification](https://en.wikipedia.org/wiki/Euclidean_algorithm)
- [complex log](https://proofwiki.org/wiki/Definition:Natural_Logarithm/Complex)
- [complex arcsin](https://proofwiki.org/wiki/Definition:Inverse_Sine/Complex)
- [complex arctan](https://proofwiki.org/wiki/Definition:Inverse_Tangent/Complex)
- [complex sin](https://proofwiki.org/wiki/Sine_of_Complex_Number)
# Possible Considerations
## Type Declaration
I have an idea for a more expressive way of declaring the input to a function. It uses the `where` keyword as well as a new `is` keyword. The `is` keyword checks the type of a number at runtime and is used in the following way:
```ocaml
function(x, y) R, R -> R
where x is not Q and y is not Q
```
This is a way to express the input as all *irrational* numbers.
## Staticily Typed
In math, you often declare the type of a number. What of you could do the same in numple? Since all values are immutable, the type should never be able to change anyway.
## Multiple Dispatch
It is sometimes convenient to name two functions by the same name but keep different declarations. I currently have two builtin `root` functions. One which is the squareroot, and the other which takes two arguments, the radicand and the level of the root. I'm still on the fence about this idea, I feel like it could cause confusion.
## Loops
I have an idea for a simple loop syntax. You only have one keyword `loop` and the keyword `break` and `continue`. Writing a for  loop in this syntax would be following:
```
loop 1..10 i
    i?
```
Writing a while loop would be the following:
```
stop = false
loop
    break if stop
```
## One indexed
I think that choosing the 5'th element by typing `list[5]` is intuitive. The same logic would apply to ranges. The range `1..5` would be the number `1, 2, 3, 4, 5`. And the slice `list[1..5]` would be the 5 first elements in the list.
## LLVM
It's either llvm or only letting linux users compile numple programs. Or... Hear me out... just don't make a compiler.
