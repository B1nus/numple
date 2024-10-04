# Errors
Sample program to print in bold, red text using ANSI excape codes.
```
const std = @import("std");

pub fn main() void {
    const stdout = std.io.getStdOut().writer();

    const bold_red = "\x1b[1;31m";
    const reset = "\x1b[0m";

    stdout.print("{s}Error: Something went wrong{s}\n", .{ bold_red, reset }) catch {};
}
```
