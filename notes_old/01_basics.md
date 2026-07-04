---
title: "01 — Basics"
topic: "C Programming"
tags: [c, basics, syntax, data-types, control-flow, operators]
updated: 2026-06-14
---

# 01 — Basics

---

## Program Structure

Every C program has exactly one `main` function — the entry point.

```c
#include <stdio.h>   // include standard I/O header

int main(void) {
    printf("Hello, C.\n");
    return 0;        // 0 = success; non-zero = error
}
```

**Compilation pipeline:**
```
source.c → [preprocessor] → source.i → [compiler] → source.s
         → [assembler] → source.o → [linker] → executable
```

```bash
gcc -std=c11 -Wall -Wextra -o hello hello.c
```

---

## Data Types

### Primitive Types

| Type | Size (typical) | Range |
|------|---------------|-------|
| `char` | 1 byte | -128 to 127 (signed) |
| `unsigned char` | 1 byte | 0 to 255 |
| `short` | 2 bytes | -32,768 to 32,767 |
| `int` | 4 bytes | -2,147,483,648 to 2,147,483,647 |
| `long` | 4 or 8 bytes | platform-dependent |
| `long long` | 8 bytes | ±9.2 × 10¹⁸ |
| `float` | 4 bytes | ~7 significant digits |
| `double` | 8 bytes | ~15 significant digits |
| `_Bool` | 1 byte | 0 or 1 |

> Sizes are not guaranteed by the standard — only minimum ranges are. Use `<stdint.h>` for fixed-width types.

### Fixed-Width Types (`<stdint.h>`)

```c
#include <stdint.h>

int8_t  a = -5;
uint8_t b = 255;
int32_t c = 100000;
int64_t d = 9000000000LL;
```

Use these when exact size matters (networking, file formats, hardware registers).

### Type Limits (`<limits.h>`, `<float.h>`)

```c
#include <limits.h>
#include <float.h>

printf("INT_MAX  = %d\n", INT_MAX);
printf("UINT_MAX = %u\n", UINT_MAX);
printf("DBL_MAX  = %e\n", DBL_MAX);
```

### `sizeof` Operator

```c
printf("%zu\n", sizeof(int));       // typically 4
printf("%zu\n", sizeof(double));    // typically 8
printf("%zu\n", sizeof(char));      // always 1, by definition
```

`sizeof` is evaluated at **compile time** and returns type `size_t` (use `%zu`).

---

## Variables & Constants

```c
int x;          // declaration (uninitialized — undefined value)
int y = 10;     // declaration + initialization

// Constants
const double PI = 3.14159265358979;
#define MAX_SIZE 1024              // preprocessor constant — no type, no scope

// Integer literal suffixes
long  a = 1000L;
unsigned b = 200U;
long long c = 9000000000LL;

// Other bases
int hex = 0xFF;    // 255
int oct = 0777;    // 511
int bin = 0b1010;  // 10 (GCC extension; C23 standard)
```

---

## Operators

### Arithmetic

```c
int a = 17, b = 5;
printf("%d\n", a + b);   // 22
printf("%d\n", a - b);   // 12
printf("%d\n", a * b);   // 85
printf("%d\n", a / b);   // 3  (integer division — truncates)
printf("%d\n", a % b);   // 2  (modulo)
```

> Integer division truncates toward zero. `-7 / 2 == -3`, not -4.

### Relational & Logical

```c
// Relational: return 1 (true) or 0 (false)
a > b   a < b   a >= b   a <= b   a == b   a != b

// Logical: short-circuit evaluation
a && b   // AND: false if left side is 0
a || b   // OR:  true if left side is non-zero
!a       // NOT
```

### Bitwise

```c
a & b    // AND
a | b    // OR
a ^ b    // XOR
~a       // NOT (bitwise complement)
a << 2   // left shift (multiply by 4)
a >> 1   // right shift (divide by 2; arithmetic for signed)
```

### Assignment Shorthands

```c
x += 5;    // x = x + 5
x -= 3;    // x = x - 3
x *= 2;    // x = x * 2
x /= 4;    // x = x / 4
x %= 3;    // x = x % 3
x <<= 1;   // x = x << 1
x &= 0xFF; // x = x & 0xFF
```

### Ternary Operator

```c
int max = (a > b) ? a : b;
// equivalent to:
// int max;
// if (a > b) max = a; else max = b;
```

### Increment / Decrement

```c
int n = 5;
int a = n++;   // a = 5, n = 6  (post-increment: use then increment)
int b = ++n;   // b = 7, n = 7  (pre-increment:  increment then use)
int c = n--;   // c = 7, n = 6  (post-decrement)
```

### Operator Precedence (high → low, simplified)

```
() [] . ->           (postfix)
! ~ ++ -- + - * &   (unary)
* / %
+ -
<< >>
< <= > >=
== !=
&
^
|
&&
||
?:
= += -= ...
,
```

When in doubt, use parentheses.

---

## Type Casting

### Implicit Conversion (Promotion)

```c
int  i = 5;
double d = i;        // int promoted to double: d = 5.0
int result = 5 / 2; // both int: result = 2 (not 2.5)
double r = 5.0 / 2; // 5.0 is double → 2 promoted → result 2.5
```

### Explicit Cast

```c
int a = 7, b = 2;
double result = (double)a / b;   // 3.5
int truncated = (int)3.99;       // 3 (truncates, doesn't round)
char c = (char)65;               // 'A'
```

---

## Standard I/O

### `printf` Format Specifiers

| Specifier | Type |
|-----------|------|
| `%d`, `%i` | `int` (signed decimal) |
| `%u` | `unsigned int` |
| `%ld` | `long` |
| `%lld` | `long long` |
| `%f` | `double` (decimal notation) |
| `%e` | `double` (scientific notation) |
| `%g` | `double` (shorter of `%f`/`%e`) |
| `%c` | `char` |
| `%s` | `char*` (null-terminated string) |
| `%p` | pointer (hex address) |
| `%x` | unsigned hex |
| `%o` | unsigned octal |
| `%zu` | `size_t` |
| `%%` | literal `%` |

```c
printf("%-10s | %6.2f\n", "item", 3.14159);
// left-align string in 10 chars, float with width 6 and 2 decimal places
```

### `scanf`

```c
int n;
double x;
char buf[64];

scanf("%d", &n);         // & required for non-pointer types
scanf("%lf", &x);        // double uses %lf in scanf (not %f)
scanf("%63s", buf);      // limit input to avoid overflow; no & for arrays
scanf("%d %lf", &n, &x); // multiple values
```

> **Never use `gets()`** — it has no bounds checking and was removed in C11. Use `fgets(buf, sizeof(buf), stdin)` instead.

---

## Control Flow

### `if` / `else`

```c
if (x > 0) {
    printf("positive\n");
} else if (x < 0) {
    printf("negative\n");
} else {
    printf("zero\n");
}
```

### `switch`

```c
int day = 3;
switch (day) {
    case 1:  printf("Mon\n"); break;
    case 2:  printf("Tue\n"); break;
    case 3:  printf("Wed\n"); break;
    default: printf("Other\n"); break;
}
```

Without `break`, execution **falls through** to the next case.

`switch` only works with integer types (`int`, `char`, `enum`).

### `for` Loop

```c
for (int i = 0; i < 10; i++) {
    printf("%d ", i);
}

// All parts optional — infinite loop:
for (;;) { /* ... */ }
```

### `while` Loop

```c
int n = 10;
while (n > 0) {
    printf("%d\n", n);
    n--;
}
```

### `do-while` Loop

```c
int n;
do {
    printf("Enter a positive number: ");
    scanf("%d", &n);
} while (n <= 0);  // body always executes at least once
```

### `break` and `continue`

```c
for (int i = 0; i < 10; i++) {
    if (i == 5) break;      // exit loop entirely
    if (i % 2 == 0) continue; // skip even numbers
    printf("%d\n", i);      // prints: 1 3
}
```

### `goto` (use sparingly)

```c
// Legitimate use: cleanup in error paths
int result = do_something();
if (result < 0) goto cleanup;

// ... more code ...

cleanup:
    free(ptr);
    fclose(fp);
    return -1;
```

---

## Practice Problems

<details>
<summary>Problem 1: Write a program that reads three integers and prints the largest.</summary>

```c
#include <stdio.h>

int main(void) {
    int a, b, c;
    scanf("%d %d %d", &a, &b, &c);
    int max = a;
    if (b > max) max = b;
    if (c > max) max = c;
    printf("Largest: %d\n", max);
    return 0;
}
```
</details>

<details>
<summary>Problem 2: Print a multiplication table (1–10) using nested loops.</summary>

```c
#include <stdio.h>

int main(void) {
    for (int i = 1; i <= 10; i++) {
        for (int j = 1; j <= 10; j++) {
            printf("%4d", i * j);
        }
        printf("\n");
    }
    return 0;
}
```
</details>

<details>
<summary>Problem 3: Without using division or modulo, determine if a number is even using bitwise ops.</summary>

```c
// The LSB of an even number is always 0.
int is_even = (n & 1) == 0;
```
</details>
