# Errors
## Error location
Keep information on which file and line the error occurs. The filename and line should be correct even though it's imported code through the `load` keyword.
## Error Formatting (ANSI excape codes)
Sample program to print in bold, red text using ANSI escape codes.
```zig
const std = @import("std");

pub fn main() void {
    const stdout = std.io.getStdOut().writer();

    const bold_red = "\x1b[1;31m";
    const reset = "\x1b[0m";

    stdout.print("{s}Error: Something went wrong{s}\n", .{ bold_red, reset }) catch {};
}
```
# Shadowing
Shadowing can occur in two situations. If you're making a new number with the same name as before or you're using an argument name with already exists as a number.
```
```
# Scope
There are two scopes in numple, the global scope and the function scope. The function scope "dies" after the function returns. In this example, the global number `x` at line 1 is shadowed by the argument to the function `f()`. This is until the function returns and its scope is over.
```rust
x = 2
f(x) -> R
    x = 3
    return x
x?
```
Outputs `5 | x = 2`. The thing you might not be used to is that the scope of if statements is the same as outside if statements. This means that:
```go
if 1 = 1
    x = 2
x?
```
Outputs `3 | x = 2`. And:
```go
x = 1
if x = 1
    x = 2
x?
```
Outputs `4 | x = 2`.

# Expressions
## Simplifications
All builting operations and functions should have rules for simplification. For example that `2 + 2 = 4`, `root(2) * root(2) = 2`, `sin(pi / 6) = 1/2`, `n! * (n + 1) = (n + 1)!`, `n! / (n - r)! = (n - r + 1) * (n - r + 2) * ... * (n)` etc... There are [resources](http://www.semdesigns.com/Products/DMS/SimpleDMSDomainExample.html#TransformationRules) for achieving this. However, I believe making a perfect expression simplifier is impossible. A good idea is to make adding simplification rules easy so other people can add rules.
# Builtins
`phi = (1 + root(5)) / 2`
# Operations
`a % b = a - b * floor(a / b)`

# TEMPORARY SHIT FOR ME TO REMEMBER RIGHT NOW
Do not stop the program because of a silly syntax error. Remember it, and parse every other line as well. I want good and helpful errors.
Also, make sure to make the lexer understand the simple syntax. Also also, it really shouldn't do any validation, it should be very dumb indeed.
e10 syntax not needed, literaly just write 5.6*10^10, I prefer this.
indentation just needs to be the same. No matter if it's tabs, or spaces.
I'm going to remove the 5x syntax. It's being a bitch.
