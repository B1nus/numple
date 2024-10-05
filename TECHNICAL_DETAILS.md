# Errors
## Error location
Keep information on which file and line the error occurs. The filename and line should be correct even though it's imported code through the `load` keyword.
## Error Formatting (ANSI excape codes)
Sample program to print in bold, red text using ANSI escape codes.
```
const std = @import("std");

pub fn main() void {
    const stdout = std.io.getStdOut().writer();

    const bold_red = "\x1b[1;31m";
    const reset = "\x1b[0m";

    stdout.print("{s}Error: Something went wrong{s}\n", .{ bold_red, reset }) catch {};
}
```
# Expressions
## Simplifications
All builting operations and functions should have rules for simplification. For example that `2 + 2 = 4`, `root(2) * root(2) = 2`, `sin(pi / 6) = 1/2`, `n! * (n + 1) = (n + 1)!` etc...
# Builtins
`phi = (1 + root(5)) / 2`
# Operations
`a % b = a - b * floor(a / b)`
