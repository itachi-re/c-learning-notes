---
title: "02 — Pointers & Memory"
topic: "C Programming"
tags: [c, pointers, memory, arrays, address]
updated: 2026-06-14
---

# 02 — Pointers & Memory

> "C is not a high-level language. Neither is it a low-level language. It is a right-level language." — Unknown

---

## The Pointer Model

A pointer is a variable that **stores a memory address**.

```
Variable n:                  Pointer p:
┌───────┐                   ┌───────────┐
│  42   │ ← value           │ 0x7fff20  │ ← value (an address)
└───────┘                   └───────────┘
  0x7fff20 ← address          0x7fff28 ← address
  (of n)
```

```c
int n = 42;
int *p = &n;    // p holds the address of n

printf("%d\n",  n);   // 42       (value of n)
printf("%p\n",  p);   // address  (value of p)
printf("%d\n", *p);   // 42       (dereference: value at address p)

*p = 99;              // modify n through p
printf("%d\n", n);    // 99
```

### Declaration Syntax

```c
int   *p;   // pointer to int
char  *s;   // pointer to char
double *d;  // pointer to double
void  *v;   // pointer to void (generic)
int  **pp;  // pointer to pointer to int
```

> `*` binds to the variable name, not the type. `int *a, b;` declares `a` as `int*` and `b` as `int`.

---

## The Address-Of and Dereference Operators

| Operator | Name | What it does |
|----------|------|-------------|
| `&` | address-of | returns the address of a variable |
| `*` | dereference | accesses the value at an address |

```c
int x = 10;
int *p = &x;    // & gives us x's address
int y = *p;     // * follows the address to get the value

*p = 20;        // write through pointer
// now x == 20
```

---

## Pointer Arithmetic

```c
int arr[] = {10, 20, 30, 40, 50};
int *p = arr;   // p points to arr[0]

p++;            // advances by sizeof(int) bytes → points to arr[1]
p += 2;         // advances 2 elements → points to arr[3]
p--;            // one step back → arr[2]

printf("%d\n", *p);         // 30

// Difference between pointers (gives element count, not byte count)
int *start = arr;
int *end   = arr + 5;
ptrdiff_t count = end - start;   // 5
```

**Pointer arithmetic only makes sense within the same array** (or one past the end). Anything else is undefined behavior.

---

## Pointers and Arrays

In most contexts, an array **decays** to a pointer to its first element.

```c
int arr[5] = {1, 2, 3, 4, 5};
int *p = arr;    // same as: int *p = &arr[0];

// These are equivalent:
arr[2]    == *(arr + 2)   == p[2]   == *(p + 2)
```

Key distinctions:

```c
int arr[5];
int *p = arr;

sizeof(arr)  // 20  (5 × 4 bytes — size of the whole array)
sizeof(p)    // 8   (size of a pointer — NOT the array)
```

### Multidimensional Arrays

```c
int matrix[3][4];   // 3 rows, 4 columns

// Access: matrix[row][col]
// In memory: laid out row-by-row (row-major order)
matrix[1][2] == *(*(matrix + 1) + 2)

// Pointer to a row (array of 4 ints):
int (*row_ptr)[4] = matrix;  // pointer to array of 4 ints
row_ptr++;                   // advances by 4 × sizeof(int) = 16 bytes
```

---

## Pointer to Pointer

```c
int  x   = 5;
int *p   = &x;
int **pp = &p;

printf("%d\n", **pp);   // 5 (double dereference)
```

**Classic use case:** modifying a pointer through a function.

```c
void allocate(int **ptr, int size) {
    *ptr = malloc(size * sizeof(int));
}

int *arr = NULL;
allocate(&arr, 10);   // arr now points to heap-allocated memory
```

---

## `void*` — Generic Pointer

```c
void *generic = malloc(sizeof(int));   // malloc returns void*

int *ip = generic;          // implicit cast in C (explicit in C++)
*ip = 42;

// You CANNOT dereference void* directly:
// *generic = 5;  ← compile error
```

---

## `NULL` Pointer

```c
int *p = NULL;    // pointer that points to nothing

// Always check before dereferencing:
if (p != NULL) {
    printf("%d\n", *p);
}

// Dereferencing NULL is undefined behavior (usually segfault)
```

`NULL` is typically `(void*)0` or just `0`, defined in `<stddef.h>`.

---

## Pointer Qualifiers

### `const` with Pointers

```c
int x = 10, y = 20;

// Pointer to const int: cannot modify the value through ptr
const int *p = &x;
// *p = 5;    ← error
p = &y;      // OK — pointer itself can change

// Const pointer to int: pointer cannot change
int * const q = &x;
*q = 5;      // OK — value can change
// q = &y;   ← error

// Const pointer to const int: neither can change
const int * const r = &x;
```

Memory aid:
```
const int * p    → "pointer to const int" → read right-to-left: "p is a pointer to a const int"
int * const p    → "const pointer to int"
const int * const p → both const
```

### `volatile`

Tells the compiler that the value may change outside the program's control (e.g., hardware registers, signal handlers). Prevents optimization that would cache the value in a register.

```c
volatile int *status_reg = (int*)0xDEADBEEF;
while (*status_reg == 0) { /* wait */ }   // re-read every iteration
```

### `restrict`

Hint that a pointer is the **only way** to access the pointed-to memory in its scope. Enables aggressive compiler optimizations (avoids aliasing analysis).

```c
void add(int * restrict a, const int * restrict b, int n) {
    for (int i = 0; i < n; i++) a[i] += b[i];  // compiler can vectorize freely
}
```

---

## Memory Layout of a Process

```
High address
┌─────────────────────┐
│       Stack         │  ← grows downward
│    (local vars,     │
│   function calls)   │
├─────────────────────┤
│         ↓           │
│                     │
│         ↑           │
├─────────────────────┤
│        Heap         │  ← grows upward (malloc/free)
├─────────────────────┤
│     BSS segment     │  ← uninitialized globals/statics (zeroed)
├─────────────────────┤
│     Data segment    │  ← initialized globals/statics
├─────────────────────┤
│     Text segment    │  ← compiled machine code (read-only)
└─────────────────────┘
Low address
```

```c
int global_init = 5;       // data segment
int global_uninit;         // BSS segment (zeroed at startup)

void foo(void) {
    int local = 10;        // stack
    static int s = 0;      // data segment (persists between calls)
    int *heap = malloc(4); // points into heap
}
```

---

## Common Pointer Mistakes

### Uninitialized Pointer
```c
int *p;         // garbage address!
*p = 5;         // undefined behavior — DO NOT do this
```

### Dangling Pointer
```c
int *p = malloc(sizeof(int));
free(p);
*p = 10;   // undefined behavior: memory was freed
p = NULL;  // good habit: null the pointer after freeing
```

### Stack Pointer Escape
```c
int* bad_function(void) {
    int local = 42;
    return &local;  // ← stack frame is gone after return!
}
```

### Off-by-One
```c
int arr[5];
arr[5] = 0;  // undefined behavior: valid indices are 0–4
```

---

## Pointer Size Cheatsheet

On a typical 64-bit Linux system (what you're running):

```c
sizeof(char*)    == 8
sizeof(int*)     == 8
sizeof(void*)    == 8
// All pointer types are the same size on a given platform
```

---

## Practice Problems

<details>
<summary>Problem 1: Write a swap function using pointers.</summary>

```c
void swap(int *a, int *b) {
    int tmp = *a;
    *a = *b;
    *b = tmp;
}

int x = 3, y = 7;
swap(&x, &y);
// x == 7, y == 3
```
</details>

<details>
<summary>Problem 2: What does this print? (No running allowed)</summary>

```c
int arr[] = {5, 10, 15, 20};
int *p = arr + 1;
printf("%d %d %d\n", *p, *(p+1), p[-1]);
```

**Answer:** `10 15 5`
- `*p` → `arr[1]` = 10
- `*(p+1)` → `arr[2]` = 15
- `p[-1]` → `arr[0]` = 5 (negative indexing is valid here)
</details>

<details>
<summary>Problem 3: Write `array_sum` using only pointer arithmetic (no `[]` indexing).</summary>

```c
int array_sum(const int *arr, size_t len) {
    int sum = 0;
    const int *end = arr + len;
    while (arr < end) {
        sum += *arr++;
    }
    return sum;
}
```
</details>
