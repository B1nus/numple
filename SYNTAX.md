# Functions
Functions are declared with its name, arguments, and return type:
```rust
sub(a, b) -> R
  return a - b
```
You can declare types:
```rust
npr(n, r) N, N -> N
  return n! / (n - r)!
```
You can also add constraints using the keyword `where`:
```rust
npr(n, r) N, N -> N
where r <= n
  return n! / (n - r)!
```
## Entrypoint
A function named after the file acts as the entrypoint to the program. Command line arguments are passed to this function. Let this be the contents of factorial.nm:
```rust
factorial(n) N -> N
  if n <= 1
    return 1
  return n * factorial(n - 1)
```
Running `$ numple factorial 5` will return `factorial(5) = 120`.

# Output
Ask for the value of an expression with `?`
```
$ numple
>>> root(2) + 4 * pi ?
1 | root(2) + 4 * pi ~ 7.69739
```
The leftmost column is for the line number and filename. If there is only one file then it's name is not included. If there is more than one file however the output might look like so:
```
$ numple file
file2:10 | x = 40
file:29 | y = 69 * pi ~ 216.76989
```
## Examples of output:
```
110 | 7/2 = 3.5
117 | pi ~ 3.14159
109 | root(2) * root(2) = 2
112 | sin(pi / 6) = 0.5
108 | phi ~ 1.61803
101 | 2^20 = 1048576
103 | 2^32 ~ 4.29496 * 10^9
97 | 420 * 10^7 = 4.2 * 10^9
110 | (9 + 6 - 7)/3 = 8/3 ~ 2.66667
```
# If statements
Numple only allows boolean expression in if statements in order to keep things simple. Here's an example:
```
if -1 < x < 1
  x?
```
This code only outputs the value for x if its value is between minus one and plus one. As you can see, such a boolean expression is allowed in numple unlike many other programming languages. Now for parenthesis, the expression below can take on two meanings depending on your interpretation.
```
if x = 0 and y = 0 or z = 0
  ...
```
It can be read as `(x = 0 and y = 0) or z = 0` and `x = 0 and (y = 0 or z = 0)` which are not equivalent. When this happens in math you are forced to add parenthesis and numple is no different. The parser will throw an error if it detects an ambiguous statement and prompt the user to add parenthesis as shown [here](https://github.com/B1nus/numple/blob/readme/SYNTAX.md#ambiguous-if-statement).
# Errors and Warnings
## Errors
The general format for errors is the following.
```
Error in factorial.nm
3 | x = hello(5)
        ^^^^^
Function hello() not found.
```
## Functions


GitHub published support for the Markdown below in https://github.com/orgs/community/discussions/16925.

> [!NOTE]
> This language only has the basics needed for numbers. If you want to use strings, booleans, loops or need mutability numple will be super inconvinient.

> [!TIP]
> Try using the syntax `if 5 < x < 10`. It's valid in numple!

> [!IMPORTANT]
> Crucial information necessary for users to succeed.

> [!WARNING]
> Even though you can name functions such as `pi(x) -> R` you probably shouldn't.

> [!CAUTION]
> Negative potential consequences of an action.

Arguments did not meet the `where` constraint.
```carbon
Error:
1 | npr(n, r) N, N -> N
2 | where r <= n
    ^^^^^^^^^^^^

Constraint not met. Found r = 1, n = 3.
```
Arguments did not met type constraints.
```diff
Error:
1 | npr(n, r) N, N -> N

Arguments have the wrong type. Got n = root(2) + pi which is of type R
```
Output did not met type constraint.
```
Error:
1 | npr(n, r) N, N -> N

Returned value does not meet type constraint 'N', got '6/9'
```
Wrong number of arguments.
```
Error:
5 | npr(5)?

Function npr() expected 2 arguments, got 1. Function declaration:
1 | npr(n, r) N, N -> N
```
## Parser
The parser needs to keep track of the file, line and columns of every token. This is needed to give helpful errors with underlining.
### Ambiguous if statement
```
Error in filename.nm
6 | if x = 0 and y = 0 or z = 0

Detected ambiguous if statement. Please add parenthesis.
```
## Compiler
## Runtime
