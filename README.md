# numple
A simple programming language made for doing math with numbers.

# Syntax
```
subtraction(a, b) R, R -> R
  return a - b
```
Feel free to skip the type declaration.
```
subtraction(a, b) -> R
  return a - b
```
## Numbers
The types in numlang are the same as in math. We have N, Z, Q, R and C.
```
n = 0
z = -1
q = 1/3
r = pi ^ 2
c = 3 + i(8)
```

Ask for the value of an expression with a question mark.
```
x = 2
x?
```
```
$ nm filename.nm
at line 2 | x = 2
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
if ((x = 5) and y = 6) or z = 7
```
The priority rules for boolean expressions are the same as math.

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
$ num addition.nm 5, 2 + root(2)
addition(5, 2 + root(2))
= 7 + root(2)
≈ 8.41421
```

## Builtins.
Functions:
```
root(x) R -> R
floor(x) R -> Z
sin(x) R -> R
cos(x) R -> R
tan(x) R -> R where cos(x) != 0 
arcsin(x) R -> R where -1 <= x <= 1
arccos(x) R -> R where -1 <= x <= 1
arctan(x) R -> R
ln(x) R -> R where x > 0
i(x) R -> C
re(c) C -> R
im(c) C -> R
```
Constants:
```
e
pi
phi
```
These names are reserved and cannot be used. However, you are allowed to for example call a **number** `i = 2` even though there is the **function** `i(x)`.

# Language symbols
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
## Keywords
All keywords are reserved. This means that you cannot name a function or number by any of the below:
```
if
or
not
and
else
return
where
load
```
# Hmm... it seems that we're missing some features?
Do you want mutability? Maybe strings? Or how about loops? Too bad. They do not exist in numlang. This language is made for one thing: **Numbers**. Use shadowing to change values:
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
Numbers in numlang are interpreted as expressions. Not floats and not integers. This means that the famous:
```
if 0.1 + 0.2 = 0.3
  ...
```
Is actually true in numlang. It understands this statement as `if 1/10 + 1/5 = 3/10` which is in fact true.

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
`$ num filename.nm six`

Same goes for **all** functions you declared in the file.

# Note to self
## Shadowing
Warn for shadowing with function args.
Also warn for shadowing with builtins.
Also warn for normal shadowing possibly. But only once.
## Printing
Hmm, how to format? I think formatting as numlang is the best, simple and has the benefit of being easy to copy paste into the code. Don't forget to print a decimal representation with the tilde. Output: `at line 3 | x = pi + 2 ~ 5.14159...`. Don't forget to remove the `...` and `~` if the decimal expansion is actually not infinite or shorter than `x` in length.
Should the output of a filename function have the arguments included or no? What if the other print statements bury the commandline arguments so you can't see them anymore? Also what if the argiments are really long? I got it. If there are to many print statements before the output we print the input. And if the einput is to long we split it across more lines.
```
$ num filename.nm root(3) * pi * e * number, hello * 3^5 * root(6) * 8
at line 5 | i = 5
at line 5 | i = 6
at line 5 | i = 7
at line 5 | i = 8
at line 10 | pi = 10
```
Fk, what is the user reassigns pi to 2 or something and the person using commandline args uses pi expeting it to be 3.14... Okay, shadowing builtins is illegal.
## Importing
Simply paste the file contents into the new file. Don't forget to keep the right filename and line number in the errors and debug thingies.
## Expression logic
[Use these to simplify sin,cos and tan expressions](https://en.wikipedia.org/wiki/Exact_trigonometric_values)

Make some smart code to acess the number type as N, Z, Q, R or C. The hard part is separating Q from R, the rest is mostly trivial.

Hmmm, polar form `c = 5 * e^i(pi)` should be allowed. Make sure to handle this properly.

Find a ratio simplifier algorithm online.

Module %? On real numbers??? Don't forget that the module is always positive. The tiniest positive number is the modulo. Not all values are okay. (division by zero or something)

Operation priority. Don't forget to add mathematically correct priority for */+-^%().
## README
Consider removing some stuff from here. The where keyword and the fact that you can omit type for the input should not be something a complete beginner of the language should think about.
