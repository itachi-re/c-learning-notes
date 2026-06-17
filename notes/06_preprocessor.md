---
title: "06 — Preprocessor"
topic: "C Programming"
tags: [c, preprocessor, macros, headers, conditional-compilation]
updated: 2026-06-14
---

# 06 — Preprocessor

The preprocessor runs **before** the compiler, performing textual substitution. It knows nothing about C types, scopes, or syntax — it works on tokens.

```
source.c → [preprocessor] → source.i → [compiler] → ...
```

View preprocessor output: `gcc -E source.c -o source.i`

---

## `#include`

Textually inserts another file at the point of inclusion.

```c
#include <stdio.h>    // searches system include paths
#include "myfile.h"   // searches current directory first, then system paths
```

---

## `#define` — Object-Like Macros

Simple token substitution. No type, no scope, no semicolon.

```c
#define MAX_SIZE  1024
#define PI        3.14159265358979
#define APP_NAME  "C Notes"

int arr[MAX_SIZE];    // expands to: int arr[1024];
```

### Undefining a Macro

```c
#define DEBUG
// ... use DEBUG ...
#undef DEBUG          // remove the macro definition
```

---

## `#define` — Function-Like Macros

```c
#define SQUARE(x)    ((x) * (x))
#define MAX(a, b)    ((a) > (b) ? (a) : (b))
#define ABS(x)       ((x) >= 0 ? (x) : -(x))

int y = SQUARE(3 + 1);   // → ((3+1) * (3+1)) = 16 ✓
// Without inner parens: #define SQUARE(x) x*x → 3+1*3+1 = 7 ✗
```

**Always wrap macro arguments and the entire expansion in parentheses.**

### Multi-Line Macros

```c
#define SWAP(a, b, type) \
    do {                 \
        type _tmp = (a); \
        (a) = (b);       \
        (b) = _tmp;      \
    } while (0)

// Wrap in do-while(0) so it behaves like a statement everywhere:
if (condition)
    SWAP(x, y, int);  // safe — no dangling else problem
```

### Macro Pitfalls

```c
// Double evaluation — side effects applied twice
#define MAX(a, b) ((a) > (b) ? (a) : (b))
int r = MAX(i++, j++);   // i++ evaluated twice if i > j — BUG

// Prefer inline functions for this reason:
static inline int max(int a, int b) { return a > b ? a : b; }
```

---

## Predefined Macros

| Macro | Value |
|-------|-------|
| `__FILE__` | Current source filename (string) |
| `__LINE__` | Current line number (integer) |
| `__DATE__` | Compilation date: `"Jun 14 2026"` |
| `__TIME__` | Compilation time: `"18:44:39"` |
| `__func__` | Current function name (C99, technically not a macro) |
| `__STDC__` | `1` if compiler is C standard-conforming |
| `__STDC_VERSION__` | `201112L` for C11, `201710L` for C17 |

```c
void log_error(const char *msg) {
    fprintf(stderr, "[%s:%d in %s] %s\n", __FILE__, __LINE__, __func__, msg);
}
```

---

## Stringification and Token Pasting

### `#` — Stringification

Converts a macro argument to a string literal:

```c
#define STRINGIFY(x) #x
printf("%s\n", STRINGIFY(hello world));   // hello world
printf("%s\n", STRINGIFY(42));            // 42

// Common use: debug printing
#define DBGINT(x) printf(#x " = %d\n", (x))
DBGINT(2 + 3);    // prints: 2 + 3 = 5
```

### `##` — Token Pasting (Concatenation)

Joins two tokens into one:

```c
#define DECLARE_VAR(type, name) type var_##name

DECLARE_VAR(int, speed);    // expands to: int var_speed;
DECLARE_VAR(char*, label);  // expands to: char* var_label;
```

---

## Conditional Compilation

```c
#define DEBUG 1

#if DEBUG
    printf("debug: x = %d\n", x);
#endif

#ifdef WINDOWS
    // Windows-specific code
#else
    // POSIX code
#endif

#ifndef MAX_SIZE
    #define MAX_SIZE 256    // provide a default if not already defined
#endif
```

### `#if` with Expressions

```c
#if __STDC_VERSION__ >= 201112L
    // C11 features available
    #include <stdnoreturn.h>
#elif __STDC_VERSION__ >= 199901L
    // C99 features
#else
    #error "This code requires C99 or later"
#endif
```

---

## Include Guards

Prevent a header from being included multiple times (causes redefinition errors):

```c
// mylib.h
#ifndef MYLIB_H
#define MYLIB_H

typedef struct {
    int x, y;
} Point;

double distance(Point a, Point b);

#endif  // MYLIB_H
```

### `#pragma once` (Non-standard, widely supported)

```c
#pragma once

// rest of header — simpler but not ISO C
```

Both approaches work. `#pragma once` is simpler but technically implementation-defined; include guards are portable.

---

## Creating Header Files

**Rule:** Headers should contain only **declarations**, never **definitions** (except `static inline` functions and `typedef`s).

```c
// vector.h — public interface
#ifndef VECTOR_H
#define VECTOR_H

#include <stddef.h>   // for size_t

typedef struct {
    double x, y, z;
} Vec3;

// Function declarations
Vec3   vec3_add(Vec3 a, Vec3 b);
Vec3   vec3_scale(Vec3 v, double s);
double vec3_dot(Vec3 a, Vec3 b);
double vec3_length(Vec3 v);

#endif
```

```c
// vector.c — implementation
#include "vector.h"
#include <math.h>

Vec3 vec3_add(Vec3 a, Vec3 b) {
    return (Vec3){ a.x+b.x, a.y+b.y, a.z+b.z };
}
double vec3_length(Vec3 v) {
    return sqrt(v.x*v.x + v.y*v.y + v.z*v.z);
}
// ... etc ...
```

---

## X-Macros Pattern

A powerful metaprogramming technique for generating repetitive code from a single source of truth:

```c
// Define the data table once
#define COLOR_TABLE \
    X(RED,   "red",   0xFF0000) \
    X(GREEN, "green", 0x00FF00) \
    X(BLUE,  "blue",  0x0000FF)

// Generate an enum
typedef enum {
#define X(name, str, hex) COLOR_##name,
    COLOR_TABLE
#undef X
    COLOR_COUNT
} Color;

// Generate a name array
const char *color_names[] = {
#define X(name, str, hex) str,
    COLOR_TABLE
#undef X
};

// Generate a hex value array
const int color_hex[] = {
#define X(name, str, hex) hex,
    COLOR_TABLE
#undef X
};

// Usage
Color c = COLOR_BLUE;
printf("%s: #%06X\n", color_names[c], color_hex[c]);
```

---

## `#pragma`

Compiler-specific directives. Common ones:

```c
#pragma once                          // header guard (non-standard but universal)
#pragma GCC optimize("O3")           // per-function optimization level
#pragma pack(1)                      // disable struct padding
#pragma pack(pop)                    // restore previous packing
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-variable"
// ... code without the warning ...
#pragma GCC diagnostic pop
```

---

## `#error` and `#warning`

```c
#ifndef __linux__
    #error "This code only compiles on Linux"
#endif

#if BUFFER_SIZE < 64
    #warning "BUFFER_SIZE is very small, consider increasing it"
#endif
```

---

## Practice Problems

<details>
<summary>Problem 1: Write a `CLAMP(val, lo, hi)` macro that limits val to [lo, hi].</summary>

```c
#define CLAMP(val, lo, hi) \
    (((val) < (lo)) ? (lo) : ((val) > (hi)) ? (hi) : (val))

// Caveat: evaluates val up to twice. For side-effect safety, use an inline function.
static inline int clamp(int val, int lo, int hi) {
    if (val < lo) return lo;
    if (val > hi) return hi;
    return val;
}
```
</details>

<details>
<summary>Problem 2: What's wrong with this macro? Fix it.</summary>

```c
#define DOUBLE(x) x + x
int result = DOUBLE(3) * 4;
```

**Bug:** Expands to `3 + 3 * 4 = 3 + 12 = 15` (expected 24).

**Fix:** Always wrap the whole expression:
```c
#define DOUBLE(x) ((x) + (x))
// Expands to: ((3) + (3)) * 4 = 6 * 4 = 24
```
</details>

<details>
<summary>Problem 3: Why is `do { ... } while (0)` the standard wrapper for multi-statement macros?</summary>

It makes the macro a single statement that must end with `;`, behaving correctly in all contexts:

```c
// Without do-while(0):
#define LOG(x) fprintf(stderr, x); fflush(stderr)

if (error)
    LOG("bad");    // expands to: fprintf(...); fflush(...);
// Only the fprintf is in the if body — fflush always runs.

// With do-while(0):
#define LOG(x) do { fprintf(stderr, x); fflush(stderr); } while (0)

if (error)
    LOG("bad");   // correct — both statements are in the block
// The trailing ; after LOG() terminates the do-while, not dangling.
```
</details>
