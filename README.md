# numple
A simple programming language to help me with my math homework.

> [!WARNING]
> To help me get a first version of the language up and running I will remove some features. The following will be temporarily removed:
> - Type declarations.
> - Complex numbers.
> - Natural, Whole and rational numbers.
> - Expression evaluation.
> - Expression simplification.
> - Multiple return.
> - Multiple assign.
> - The `where` keyword.
> - Compiler.
> - Command line tool.
# Command Line Interface
The command line interface tool is called **numple**. Running the command `$ numple` initializes an interactive shell where you can write **numple** code. Read more about **numple's** interactive shell int the [header](#REPL) below.

To run a numple program written in a file, run `$ numple filename.nm`. This will run the numple code and print the output to the terminal.
## Entry Point
A function named the same as the file is considered the entry point of the program. This means that this function is called when running the program with the command `$ numple program.nm`. This is the only way to access command line argument in **numple** programs. Pass arguments to the entry point function with the command `$ numple program.nm 5, 6`. Please note that all expressions are allowed in command line arguments: `$ numple program.nm root(2), 3`.
## REPL
REPL [(Read Evaluate Print Loop)](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop) is a collective term for interactive shells to programming languages. Python has one, Ruby has one, Julia has one and **numple** has one to. Inside of the REPL you can write **numple** code, import code with the `load` keyword and run your code in the interactive shell. Here's an example of an interactive **numple** session:
```
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
You are not allowed to name your functions or numbers the same as **numple's** builtin functions and constants.
> [!NOTE]
> You are however allowed to name a function by a builtin constants name and a number by a builtin functions name. For example naming your number `i = 2` and your function `phi(x) -> R` is allowed.

### Builtin Functions
Below are all of the builtin functions in **numple**:
```
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
### Builtin Constants
**numple's** builtin constants are `e, pi, phi`.
### Keywords
**numple's** keywords are the following:
```diff
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
### Symbols
Here are all symbols recognized by **numple**:
```
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
Implicit multiplication is feature in **numple**. The parser can understand that the expression `5xyz` is meant to represent `5 * x * y * z`. This does however introduce ambiguity into **numple's** syntax since the expression could also be interpreted as `5 * xyz` where `xyz` is the name of a number. In cases of such ambiguity the parser throws an error. Implicit multiplication also works with numeric literals `5x = 5 * x`. However, expressions such as `x5` are not interpreted as implicit multiplication. Implicit multiplication takes precedence over explicit multiplication. This means that `6/5xy` is interpreted as `6 / (5 * x * y)` and not `6 / 5 * x * y`.
## Indentation
Similar to python, **numple** handles indentation with the tokens `INDENT` and `DEDENT`. A code block starts with the `INDENT` token and ends with the `DEDENT` token. The generation of the indentation tokens is done through a similar algorithm to the one described in python's [lexical analysis](https://docs.python.org/3.3/reference/lexical_analysis.html#indentation). Below is my modified version of that algorithm:
1. Push 0 onto the stack.
2. Count the indentation of the current line by iterating through the characters from left to right:
    1. If the character is a space: add `1` to the indentation
    2. If the character is a tab: add anywhere from `1` to `4` to the indentation in order to make the indentation divisible by 4.
    3. Repeat with the next character.
4. If the current indentation is greater than the stack: push the indentation to the stack and add a `INDENT` token.
5. If the current indentation is less than the stack: pop the stack and add `DEDENT` tokens until the indentation is less than or equal to the current indentation. If a matching indentation was not found: log a indentation error and change the indentation on the stack to match the current indentation.
6. Repeat this algorithm with the next line.
## Ambiguous if statements
Parenthesis are sometimes needed in order to avoid ambiguity in boolean expressions. For example the boolean expression `_ and _ or _` is ambiguous. It could be interpreted as either `(_ and _) or _` or `_ and (_ or _)` which are logically distinct boolean statements. The parser will throw an error if such a statement is found. Please note that the precedence rules for boolean expression in **numple** are the same as in math, that is:
1. parenthesis
2. not
3. and/or

This means that the statements such as `not _ and _` are well defined. Also note that statements such as `_ and _ and _` and `_ or _ or _` are well defined.
## Errors
In order to give useful errors, the parser needs to keep track of where the error occurs. The parser errors also need to account for the origin of imported code. In general, try to log errors instead of exiting the program, it is annoying to fix an indentation error only to be met with another when you try to parse it again.

Also, don't forget to format the errors nicely and give good coloring and styling with [ANSI escape codes](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition%29_parameters). For example `bold_red="\x1b[;31m"` to make text red and bold in the terminal.

Please keep in mind that people who use **numple** should not need to understand the interpreter in order to understand **numple's** errors. Keep errors simple and straight to the point. For example: let's say an if statement is missing a code block, then the error should simply say `If statement is missing code`. It should **not** say `Parser expected INDENT token after boolean expression`.
# Interpreter
## Runtime Errors
A few runtime errors can occur in **numple**. Since the parser has checked that the syntax is correct. The only things that can go wrong is regarding invalid expressions and Type mismatches. For example division by zero and invalid function arguments.
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
```
function(x, y) R, R -> R
where x is not Q and y is not Q
```
This is a way to express the input as all *irrational* numbers.
## Staticily Typed
In math, you often declare the type of a number. What if you could do the same in numple? Since all values are immutable, the type should never be able to change anyway.
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
