# Functions
Functions are declared with its name, arguments, and return type:
```rust
sub(a, b) -> R
  return a - b
```
You can declare the input types:
```rust
npr(n, r) N, N -> N
  return n! / (n - r)!
```
You can also add constraints using the keyword `where`:
```rust
npr(n, r) N, N -> N
where r <= n
  return factorial(n) / factorial(n - r)
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
# Errors and Warnings
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
```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
```

Arguments did not meet the `where` constraint.
```diff
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

Arguments have the wrong type. Got n = root(2) + pi
```
Output did not met type constraint.
```
Error:
1 | npr(n, r) N, N -> N

Returned value does not meet type constraint 'N', got '6/9'
```
## Parser
## Compiler
## Runtime
### Function
```
Error:
1 | npr(n, r) N, N -> N
2 | where r <= n
    ^^^^^^^^^^^^

Constraint not met. Found r = 1, n = 3.
```
```
