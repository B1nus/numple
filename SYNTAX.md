# Functions
Functions are declared with the function name, argument names, and return type:
```
sub(a, b) -> R
  return a - b
```
You can declare the input types:
```
npr(n, r) N, N -> N
  return factorial(n) / factorial(n - r)
```
You can also add constraints using the keyword `where`:
```
npr(n, r) N, N -> N
where r <= n
  return factorial(n) / factorial(n - r)
```
## Entrypoint
A function named after the file acts as the entrypoint to the program. Command line arguments are passed to this function. Let this be the contents of factorial.nm:
```
factorial(n) N -> N
  if n <= 1
    return 1
  return n * factorial(n - 1)
```
Then running `$ numple factorial 5` will return `factorial(5) = 120`.

# Output
Ask for the value of an expression with `?`
```
$ numple
>>> root(2) + 4 * pi?
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
Arguments did not met `where` constraint.
```
Error:
1 | npr(n, r) N, N -> N
2 | where r <= n
    ^^^^^^^^^^^^

Constraint not met. Found r = 1, n = 3.
```
Arguments did not met type constraints.

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
