---
title: "03 — Functions"
topic: "C Programming"
tags: [c, functions, scope, recursion, argc, argv]
updated: 2026-06-14
---

# 03 — Functions

---

## Anatomy of a Function

```c
//  return type ┐  name ┐  parameter list ┐
    int          add    (int a, int b)
    {
        return a + b;    // return statement
    }
```

- **Prototype (declaration):** tells the compiler the signature before the definition appears.
- **Definition:** the actual body.
- **Call:** invocation with arguments.

```c
// Prototype (usually in a .h file or top of .c)
int add(int a, int b);

// Definition
int add(int a, int b) {
    return a + b;
}

// Call
int result = add(3, 4);   // result == 7
```

A function that returns nothing uses `void`:
```c
void print_header(void) {   // 'void' parameter list = no parameters
    printf("=== Header ===\n");
}
```

---

## Parameter Passing

### Pass by Value (default)

C is **pass-by-value** — functions receive copies of arguments.

```c
void double_it(int x) {
    x *= 2;             // modifies the local copy
}

int n = 5;
double_it(n);
printf("%d\n", n);     // still 5 — original unchanged
```

### Simulated Pass by Reference (via pointers)

```c
void double_it(int *x) {
    *x *= 2;
}

int n = 5;
double_it(&n);
printf("%d\n", n);     // 10 — original modified
```

### Arrays are Always "By Reference"

When you pass an array, you're passing a pointer to its first element:

```c
void fill_zeros(int *arr, int len) {
    for (int i = 0; i < len; i++) arr[i] = 0;
}

int data[10];
fill_zeros(data, 10);  // data decays to &data[0]
```

> There's no way to pass an array "by value" in C. Wrap it in a struct if you need value semantics.

---

## Return Values

```c
// Multiple values: use output parameters (pointers)
void min_max(const int *arr, int len, int *min, int *max) {
    *min = *max = arr[0];
    for (int i = 1; i < len; i++) {
        if (arr[i] < *min) *min = arr[i];
        if (arr[i] > *max) *max = arr[i];
    }
}

int lo, hi;
int data[] = {3, 1, 4, 1, 5, 9, 2, 6};
min_max(data, 8, &lo, &hi);
// lo == 1, hi == 9
```

---

## Scope & Lifetime

| Scope | Keyword | Lifetime | Where |
|-------|---------|----------|-------|
| Block (local) | (none) | Until block exits | Stack |
| File (global) | `static` | Program lifetime | Data/BSS |
| External (global) | `extern` | Program lifetime | Data/BSS |
| Register hint | `register` | Block | Register (hint only) |

```c
int global = 100;      // file scope, external linkage

void demo(void) {
    int local = 1;          // block scope, automatic storage
    static int count = 0;   // block scope, static storage — persists!
    count++;
    printf("called %d time(s)\n", count);
}
```

### `static` in File Scope

`static` on a global restricts visibility to the current translation unit (`.c` file). This is how you "hide" implementation details:

```c
// In helper.c
static int secret = 0;         // not visible to other .c files
static void internal(void) {}  // same
```

### `extern`

Declares that a variable/function is defined in another translation unit:

```c
// In a.c:
int shared = 42;

// In b.c:
extern int shared;   // declaration, not definition
printf("%d\n", shared);
```

---

## Recursion

A function that calls itself. Needs:
1. A **base case** (termination condition)
2. A **recursive step** that moves toward the base case

```c
// Classic: factorial
unsigned long long factorial(int n) {
    if (n <= 1) return 1;          // base case
    return n * factorial(n - 1);   // recursive step
}

// factorial(5) = 5 * 4 * 3 * 2 * 1 = 120
```

### Call Stack Visualization

```
factorial(4)
├── 4 * factorial(3)
│   ├── 3 * factorial(2)
│   │   ├── 2 * factorial(1)
│   │   │   └── returns 1
│   │   └── returns 2
│   └── returns 6
└── returns 24
```

Each call consumes stack space. Deep recursion → stack overflow.

### Fibonacci (and why naive recursion is slow)

```c
// Naive: O(2^n) — exponential, re-computes subproblems
int fib(int n) {
    if (n <= 1) return n;
    return fib(n - 1) + fib(n - 2);
}

// Iterative: O(n)
int fib_iter(int n) {
    if (n <= 1) return n;
    int a = 0, b = 1, c;
    for (int i = 2; i <= n; i++) {
        c = a + b;
        a = b;
        b = c;
    }
    return b;
}
```

### Tail Recursion

A recursive call where the recursive call is the **last operation** — some compilers optimize this into a loop (no stack growth):

```c
// Not tail-recursive: must multiply after recursive call returns
int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);   // multiply happens AFTER return
}

// Tail-recursive version (accumulator pattern)
int factorial_tail(int n, int acc) {
    if (n <= 1) return acc;
    return factorial_tail(n - 1, n * acc);  // last operation is the call
}
// Call: factorial_tail(5, 1)
```

---

## Inline Functions

`inline` is a **hint** to the compiler to substitute the function body at the call site (avoid call overhead). No guarantee.

```c
static inline int square(int x) { return x * x; }
```

Prefer `inline` functions over `#define` function-like macros — they are type-safe.

---

## Command-Line Arguments

```c
int main(int argc, char *argv[]) {
    // argc: number of arguments (including program name)
    // argv: array of C strings
    // argv[0]: program name
    // argv[argc]: NULL (sentinel)

    printf("Program: %s\n", argv[0]);
    for (int i = 1; i < argc; i++) {
        printf("Arg %d: %s\n", i, argv[i]);
    }
    return 0;
}
```

```bash
$ ./prog hello world 42
Program: ./prog
Arg 1: hello
Arg 2: world
Arg 3: 42
```

### Parsing Numeric Arguments

```c
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <number>\n", argv[0]);
        return 1;
    }
    long n = strtol(argv[1], NULL, 10);
    printf("Got: %ld\n", n);
    return 0;
}
```

---

## Function Pointers (Overview)

Functions have addresses too. See `10_advanced.md` for full coverage.

```c
int add(int a, int b) { return a + b; }
int mul(int a, int b) { return a * b; }

// Pointer to a function taking (int, int) and returning int
int (*op)(int, int) = add;
printf("%d\n", op(3, 4));   // 7

op = mul;
printf("%d\n", op(3, 4));   // 12
```

---

## Best Practices

- Keep functions **short and focused** — one function, one job.
- Use `const` for pointer parameters you won't modify: `void foo(const char *s)`.
- Document preconditions: add `assert` or comments about assumed inputs.
- Return meaningful values — callers should be able to detect failure.
- Declare prototypes in header files; define in `.c` files.

---

## Practice Problems

<details>
<summary>Problem 1: Write a function that reverses an integer array in-place.</summary>

```c
void reverse(int *arr, int len) {
    int lo = 0, hi = len - 1;
    while (lo < hi) {
        int tmp = arr[lo];
        arr[lo++] = arr[hi];
        arr[hi--] = tmp;
    }
}
```
</details>

<details>
<summary>Problem 2: Implement binary search recursively.</summary>

```c
int bsearch_rec(const int *arr, int lo, int hi, int target) {
    if (lo > hi) return -1;
    int mid = lo + (hi - lo) / 2;
    if (arr[mid] == target) return mid;
    if (arr[mid]  < target) return bsearch_rec(arr, mid + 1, hi, target);
    return bsearch_rec(arr, lo, mid - 1, target);
}
```
</details>

<details>
<summary>Problem 3: What is the difference between `static int x` inside a function vs at file scope?</summary>

- **Inside a function:** `x` has block scope (only visible inside the function) but static storage duration (persists between calls; initialized once).
- **At file scope:** `x` has file scope with **internal linkage** — not visible to other translation units (`.c` files). Without `static`, a file-scope variable has external linkage and can be accessed from other files via `extern`.
</details>
