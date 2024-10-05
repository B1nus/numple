# numple
A simple programming language made for doing math with numbers.

# Syntax
The syntax is similar to mathematics:
```
sub(a, b) R, R -> R
  return a - b
```
Feel free to skip the type declaration:
```
sub(a, b) -> R
  return a - b
```
## Numbers
The types in numple are the same as in math. We have N, Z, Q, R and C.
```
n = 0
z = -1
q = 1/3
r = pi ^ 2
c = 3 + i(8)
```

Ask for the value of an expression with a question mark.
```
x = 2 * 2
x?
```
```
$ nm filename.nm
at line 2 | x = 2 * 2 = 4
```

## If statements
```
if x = 5
  x?
```
Ambiguous boolean expressions need parenthesis. This statement is ambiguous and the interpreter will throw an error:
```
if x = 5 and y = 6 or z = 7
```
Use parenthesis like so:
```
if (x = 5 and y = 6) or z = 7
```
The priority rules for boolean expres   sions are the same as math.

## Comments.
This is going to ruffle some feather. Comments start with a capital letter and end with a period followed by a newline.
```
Hello, this is a comment. This will keep being
a comment until I type a period and a newline.

x = 2 + 2
```
It follows that functions and numbers only use lowercase letters.

## Import a file.
```
load file
```
The file contents are simply copied into the current file before parsing.

## Command line arguments
Name a function the same as your file to access command line arguments:
```
addition(a, b) R, R -> R
  return a + b
```
```
$ numple addition.nm 5, 2 + root(2)
addition(5, 2 + root(2))
= 7 + root(2)
≈ 8.41421
```

## Builtins.
Functions:
```
i(x) R -> C
re(c) C -> R
im(c) C -> R
ln(x) R -> R where x > 0
abs(c) C -> R
sin(x) R -> R
cos(x) R -> R
tan(x) R -> R where cos(x) != 0
root(x) R -> R
floor(x) R -> Z
arcsin(x) R -> R where -1 <= x <= 1
arccos(x) R -> R where -1 <= x <= 1
arctan(x) R -> R
```
Constants:
```
e
pi
phi
```
These names are reserved and cannot be used. However, you are allowed to for example call a **number** `i = 2` even though there is the **function** `i(x)`.
> [!Note]
> Even though you can name a function `pi() -> R` you should avoid doing so becuase it can cause confusion.

## Keywords (reserved)
```
if
or
not
and
else
where
return
load
```

# Hmm... it seems that we're missing some features?
Do you want mutability? Maybe strings? Or how about loops? Too bad. This language is made for one thing: **Numbers**. Use shadowing to change values:
```
x = 1
x = x + 1
```
Use functions to create loops:
```
loop(10)
loop(n) N -> N
  n?
  if n <= 1
    return 1
  return loop(n - 1)
```
Welcome to functional programming.
# Extra details
## Functions
Sometimes you want to add extra requirements for the input. Use the `where` keyword:
```
sub(a, b) N, N -> N
where b >= a
  return a - b
```
## Numbers
Numbers in muple are interpreted as expressions. Not floats and not integers. This means that the famous:
```
if 0.1 + 0.2 = 0.3
  ...
```
Is actually true in numple. It understands this statement as `if 1/10 + 1/5 = 3/10` which is in fact true.

Also note that this boolean expression works as it would in math:
```
if 1 < x < 5
  x?
```
## Command line arguments
The entry point function works like any other ordinary function. This means that numbers defined before the function declaration can be used as arguments:
```
six = 6
filename(x) N -> N
  ...
```
`$ numple filename.nm six`

Same goes for **all** functions you declared in the file.

# Note to self
### Language symbols
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
=
!=
<
<=
>
>=
```
These should not have to be in the readme. However, consider making the code easy enough to read this from source.
## Shadowing
Warn for shadowing with function args.
Also warn for normal shadowing. But only once.
## Printing
Hmm, how to format? I think formatting as numple is the best, simple and has the benefit of being easy to copy paste into the code. Don't forget to print a decimal representation with the tilde. Output: `at line 3 | x = pi + 2 ~ 5.14159...`. Don't forget to remove the `...` and `~` if the decimal expansion is actually not infinite or shorter than `x` in length.
Should the output of a filename function have the arguments included or no? What if the other print statements bury the commandline arguments so you can't see them anymore? Also what if the argiments are really long? I got it. If there are to many print statements before the output we print the input. And if the einput is to long we split it across more lines.
```
$ num filename.nm root(3) * pi * e * number, hello * 3^5 * root(6) * 8
at line 5 | i = 5
at line 5 | i = 6
at line 5 | i = 7
at line 5 | i = 8
at line 10 | pi = 10
```

Don't forget to make debugging easy. Filenames, lines and columns and sensible errors. Don't find one missing character on one line and ignore the rest, find them all and tell the user.
## Importing
Simply paste the file contents into the new file. Don't forget to keep the right filename and line number in the errors and debug thingies.
## Expression logic
- Polar form `c = 5 * e^i(pi)` or cartesian `c = 5 * (cos(pi) + i(sin(pi)))`
- Find a ratio simplifier algorithm online.
- Don't forget modulo. a % b = a - b * floor(a/b) (N, N -> N)
- Operation priority should be the same as math in both arithmetic and boolean expressions.
## Expression Parser
The parser should always recognize the expression as it's simplest type. That means it should understand that:
- `root(4) = 2` `sin(pi / 6) = 1/2` `floor(6/7) = 0` etc...
- `10/5 = 2`
- `a * ... * a = a^n`
- `i^3 = -i` `i^4 = 1` etc...
- `69/23 = 3` `26/4 = 13/2`
- `0.15 = 3/20`
- `16 + 4 = 20`
- `root(2) * root(2) = root(4) = 2`
- etc...
Here's [a website to help you](http://www.semdesigns.com/Products/DMS/SimpleDMSDomainExample.html#TransformationRules).
[Use these to simplify sin,cos and tan expressions](https://en.wikipedia.org/wiki/Exact_trigonometric_values)
## Compiler and Interpreter
Keep the parser and compiler separate. All errors about syntax should be handled in the parsing stage to avoid code duplication.
Interpreter command:
`$ numple factorial.nm 12`
Compiler command (Only for x86_64 linux):
`$ numple compile factorial.nm`
### Warnings
Shadowing function arguments
## README
Consider removing some stuff from here. The where keyword and the fact that you can omit type for the input should not be something a complete beginner of the language should think about.
