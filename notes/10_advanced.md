---
title: "10 — Advanced Topics"
topic: "C Programming"
tags: [c, bitwise, function-pointers, variadics, multi-file, advanced]
updated: 2026-06-14
---

# 10 — Advanced Topics

---

## Bitwise Operations

```c
unsigned char a = 0b10110101;   // 181
unsigned char b = 0b11001010;   // 202
```

| Op | Syntax | Result | Meaning |
|----|--------|--------|---------|
| AND | `a & b` | bit 1 iff both 1 | masking |
| OR | `a \| b` | bit 1 iff either 1 | setting bits |
| XOR | `a ^ b` | bit 1 iff bits differ | toggling, diff |
| NOT | `~a` | flip all bits | complement |
| Left shift | `a << n` | multiply by 2ⁿ | power-of-two mult |
| Right shift | `a >> n` | divide by 2ⁿ (unsigned) | power-of-two div |

### Common Bit Tricks

```c
// Set bit n
flags |= (1u << n);

// Clear bit n
flags &= ~(1u << n);

// Toggle bit n
flags ^= (1u << n);

// Test bit n
int is_set = (flags >> n) & 1;

// Check if power of two
int is_pow2 = n > 0 && (n & (n - 1)) == 0;

// Round up to next power of two (32-bit)
unsigned next_pow2(unsigned n) {
    n--;
    n |= n >> 1;  n |= n >> 2;
    n |= n >> 4;  n |= n >> 8;
    n |= n >> 16;
    return n + 1;
}

// Swap without temp variable (XOR swap)
a ^= b;  b ^= a;  a ^= b;   // works but avoid in practice (unclear + aliasing UB)

// Isolate lowest set bit
int lsb = n & (-n);

// Clear lowest set bit
n &= n - 1;   // Useful for counting set bits (Kernighan's method)

// Count set bits (Kernighan's algorithm)
int popcount(unsigned n) {
    int count = 0;
    while (n) { n &= n - 1; count++; }
    return count;
    // Or: __builtin_popcount(n) with GCC
}
```

### Flag Enums

```c
typedef enum {
    PERM_READ    = 1u << 0,   // 0001
    PERM_WRITE   = 1u << 1,   // 0010
    PERM_EXECUTE = 1u << 2,   // 0100
} Permission;

unsigned perms = PERM_READ | PERM_WRITE;

if (perms & PERM_EXECUTE) printf("executable\n");
perms |= PERM_EXECUTE;    // grant execute
perms &= ~PERM_WRITE;     // revoke write
```

---

## Function Pointers

A function pointer stores the address of a function with a specific signature.

```c
// Declaration: return_type (*name)(param_types)
int (*fp)(int, int);

int add(int a, int b) { return a + b; }
int mul(int a, int b) { return a * b; }

fp = add;
printf("%d\n", fp(3, 4));    // 7
fp = mul;
printf("%d\n", fp(3, 4));    // 12
```

### `typedef` for Readability

```c
typedef int (*BinaryOp)(int, int);

BinaryOp ops[] = { add, mul };
for (int i = 0; i < 2; i++) {
    printf("%d\n", ops[i](6, 7));
}
```

### Callbacks

```c
void apply_to_array(int *arr, int n, void (*fn)(int *)) {
    for (int i = 0; i < n; i++) fn(&arr[i]);
}

void double_val(int *x) { *x *= 2; }
void negate_val(int *x) { *x = -*x; }

int data[] = {1, 2, 3, 4};
apply_to_array(data, 4, double_val);   // {2, 4, 6, 8}
apply_to_array(data, 4, negate_val);   // {-2, -4, -6, -8}
```

### Dispatch Table (Virtual Function Table in C)

```c
typedef struct {
    void (*open)(const char *path);
    void (*close)(void);
    int  (*read)(void *buf, size_t n);
    int  (*write)(const void *buf, size_t n);
} IODriver;

// Implement two drivers
void file_open(const char *p) { /* ... */ }
void net_open(const char *p)  { /* ... */ }

IODriver file_driver = { file_open, file_close, file_read, file_write };
IODriver net_driver  = { net_open,  net_close,  net_read,  net_write  };

// Polymorphism — call without knowing the underlying driver
IODriver *drv = use_network ? &net_driver : &file_driver;
drv->open("/dev/null");
```

---

## Variadic Functions

Functions that accept a variable number of arguments.

```c
#include <stdarg.h>

// At least one named parameter required before '...'
int sum(int count, ...) {
    va_list args;
    va_start(args, count);   // initialize; count = last named param

    int total = 0;
    for (int i = 0; i < count; i++) {
        total += va_arg(args, int);   // extract next arg (must know type)
    }

    va_end(args);            // cleanup
    return total;
}

printf("%d\n", sum(3, 10, 20, 30));   // 60
```

**Key rules:**
- `va_arg` with the wrong type is UB.
- The function must know how many args there are — either a count parameter or a sentinel (like `printf` uses format string parsing, and `execl` uses `NULL`).

### Forwarding va_list (vprintf pattern)

```c
// A wrapper around printf for prefixed logging
void log_msg(const char *level, const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    fprintf(stderr, "[%s] ", level);
    vfprintf(stderr, fmt, args);   // v* functions accept va_list
    va_end(args);
}

log_msg("ERROR", "file not found: %s (errno=%d)\n", path, errno);
```

---

## Multi-File Projects

### Project Layout

```
myproject/
├── include/
│   ├── vec3.h
│   └── utils.h
├── src/
│   ├── vec3.c
│   ├── utils.c
│   └── main.c
└── Makefile
```

### Header / Source Split

```c
// include/vec3.h
#ifndef VEC3_H
#define VEC3_H

typedef struct { double x, y, z; } Vec3;

Vec3   vec3_add(Vec3 a, Vec3 b);
double vec3_dot(Vec3 a, Vec3 b);
double vec3_len(Vec3 v);

#endif
```

```c
// src/vec3.c
#include "vec3.h"
#include <math.h>

Vec3 vec3_add(Vec3 a, Vec3 b) {
    return (Vec3){ a.x+b.x, a.y+b.y, a.z+b.z };
}
double vec3_dot(Vec3 a, Vec3 b) { return a.x*b.x + a.y*b.y + a.z*b.z; }
double vec3_len(Vec3 v) { return sqrt(vec3_dot(v, v)); }
```

```c
// src/main.c
#include <stdio.h>
#include "vec3.h"

int main(void) {
    Vec3 a = {1, 0, 0}, b = {0, 1, 0};
    Vec3 c = vec3_add(a, b);
    printf("len = %.3f\n", vec3_len(c));  // 1.414
    return 0;
}
```

### Makefile

```makefile
CC      = gcc
CFLAGS  = -std=c11 -Wall -Wextra -Iinclude
SRCS    = src/main.c src/vec3.c src/utils.c
OBJS    = $(SRCS:.c=.o)
TARGET  = myproject

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: clean
```

---

## `volatile` — Revisited

Prevents the compiler from caching reads of a variable in a register:

```c
volatile int done = 0;   // modified by signal handler or another thread

// Without volatile, compiler may hoist the read out of the loop:
while (!done) { /* spin-wait */ }
```

---

## `restrict`

Tells the compiler that a pointer is the **only alias** for the object it points to in the current scope, enabling better optimization (e.g., SIMD vectorization):

```c
// memcpy: src and dst must not overlap — restrict says so
void *memcpy(void * restrict dst, const void * restrict src, size_t n);

// vs memmove: allows overlap, can't use restrict
void *memmove(void *dst, const void *src, size_t n);
```

---

## Designated Initializers (C99)

```c
// Array: initialize specific indices
int arr[10] = { [0] = 1, [5] = 42, [9] = -1 };
// Others are zero

// Struct
typedef struct { int x, y, z; } Point3;
Point3 p = { .z = 10, .x = 3 };  // .y defaults to 0
```

---

## Flexible Array Members (C99)

A struct with a zero-length array at the end — useful for variable-length data:

```c
typedef struct {
    size_t len;
    int    data[];    // flexible array member (must be last)
} IntArray;

// Allocate for 10 elements
IntArray *arr = malloc(sizeof(IntArray) + 10 * sizeof(int));
arr->len = 10;
for (size_t i = 0; i < arr->len; i++) arr->data[i] = i;

free(arr);
```

---

## `_Generic` (C11)

Type-generic expressions — compile-time type dispatch:

```c
#define ABS(x) _Generic((x), \
    int:    abs(x),  \
    long:   labs(x), \
    float:  fabsf(x),\
    double: fabs(x)  \
)
```

---

## Practice Problems

<details>
<summary>Problem 1: Write a function that counts the number of 1-bits in a 32-bit integer (three approaches).</summary>

```c
// 1. Naive O(32)
int popcount_naive(uint32_t n) {
    int c = 0;
    for (int i = 0; i < 32; i++) c += (n >> i) & 1;
    return c;
}

// 2. Kernighan's method O(k) where k = set bits
int popcount_k(uint32_t n) {
    int c = 0;
    while (n) { n &= n - 1; c++; }
    return c;
}

// 3. GCC builtin
int popcount_builtin(uint32_t n) {
    return __builtin_popcount(n);
}
```
</details>

<details>
<summary>Problem 2: Implement a generic `min` using function pointers for any comparable type.</summary>

```c
typedef int (*Comparator)(const void *, const void *);

const void *generic_min(const void *a, const void *b, Comparator cmp) {
    return cmp(a, b) <= 0 ? a : b;
}

int cmp_int(const void *a, const void *b) {
    return *(int*)a - *(int*)b;
}

int x = 3, y = 7;
const int *m = generic_min(&x, &y, cmp_int);
printf("min = %d\n", *m);  // 3
```
</details>

<details>
<summary>Problem 3: What happens if you pass `float` to `va_arg` as `float` instead of `double`?</summary>

**Undefined behavior.** Variadic function arguments undergo **default argument promotions**: `float` is promoted to `double`, `char`/`short` are promoted to `int`. So you must use `va_arg(args, double)`, not `va_arg(args, float)`. Similarly, calling `va_arg(args, short)` is wrong — use `int` and cast.
</details>
