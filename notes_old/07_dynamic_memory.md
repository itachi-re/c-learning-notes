---
title: "07 — Dynamic Memory"
topic: "C Programming"
tags: [c, malloc, calloc, realloc, free, heap, memory-leaks]
updated: 2026-06-14
---

# 07 — Dynamic Memory

---

## Stack vs Heap Recap

| | Stack | Heap |
|---|-------|------|
| Managed by | Compiler/runtime | You (malloc/free) |
| Allocation | Automatic (on function entry) | Manual (`malloc`) |
| Deallocation | Automatic (on function exit) | Manual (`free`) |
| Size limit | ~1–8 MB (typical) | System RAM |
| Speed | Fast (just move `rsp`) | Slower (allocator bookkeeping) |
| Lifetime | Until enclosing scope exits | Until `free()` is called |

```c
void foo(void) {
    int arr[1000];       // stack: 4000 bytes, freed when foo returns
    int *p = malloc(1000 * sizeof(int));  // heap: stays until free(p)
}
```

---

## `malloc` — Memory Allocation

```c
#include <stdlib.h>

void *malloc(size_t size);
```

Allocates `size` **bytes** of uninitialized memory. Returns `NULL` on failure.

```c
int *arr = malloc(10 * sizeof(int));   // 40 bytes for 10 ints
if (arr == NULL) {
    fprintf(stderr, "malloc failed\n");
    exit(EXIT_FAILURE);
}

// Use it
for (int i = 0; i < 10; i++) arr[i] = i * i;

// Free it
free(arr);
arr = NULL;   // prevent dangling pointer use
```

### `sizeof` the Type, Not a Magic Number

```c
// Correct — scales with the type automatically
int    *ip = malloc(n * sizeof(int));
double *dp = malloc(n * sizeof(double));
MyStruct *sp = malloc(n * sizeof(MyStruct));

// Also valid (idiomatic): sizeof *pointer
int *ip = malloc(n * sizeof *ip);   // sizeof *ip == sizeof(int)
```

---

## `calloc` — Zeroed Allocation

```c
void *calloc(size_t count, size_t size);
```

Allocates `count × size` bytes and **zeros them**. Useful when you need a known initial state.

```c
int *arr = calloc(10, sizeof(int));
// arr[0] through arr[9] are all 0

// vs malloc:
int *arr2 = malloc(10 * sizeof(int));
// arr2[0..9] are indeterminate — reading before writing is UB
```

---

## `realloc` — Resize Allocation

```c
void *realloc(void *ptr, size_t new_size);
```

Resizes a previously allocated block. May move it to a new location.

```c
int *arr = malloc(5 * sizeof(int));

// Grow to 10 elements
int *tmp = realloc(arr, 10 * sizeof(int));
if (tmp == NULL) {
    free(arr);           // original block still valid, free it
    return -1;
}
arr = tmp;              // use the (possibly new) pointer
```

> **Never `realloc` directly into the original pointer:**
> ```c
> arr = realloc(arr, 10 * sizeof(int));   // BUG: if realloc returns NULL,
>                                          // arr is NULL and original block is leaked
> ```

### Dynamic Array Pattern

```c
typedef struct {
    int   *data;
    size_t len;
    size_t cap;
} IntVec;

void vec_push(IntVec *v, int val) {
    if (v->len == v->cap) {
        size_t new_cap = v->cap ? v->cap * 2 : 8;
        int *tmp = realloc(v->data, new_cap * sizeof(int));
        if (!tmp) { fprintf(stderr, "OOM\n"); exit(1); }
        v->data = tmp;
        v->cap  = new_cap;
    }
    v->data[v->len++] = val;
}

void vec_free(IntVec *v) {
    free(v->data);
    v->data = NULL;
    v->len = v->cap = 0;
}
```

---

## `free`

```c
void free(void *ptr);
```

Releases heap memory back to the allocator. After `free`:
- The pointer is a **dangling pointer** — set it to `NULL` immediately.
- Reading/writing through it is **undefined behavior**.

```c
free(NULL);   // safe — no-op
free(ptr);
ptr = NULL;   // always do this
```

---

## Common Memory Errors

### 1. Memory Leak

Losing track of allocated memory without freeing it.

```c
void leak(void) {
    int *p = malloc(100 * sizeof(int));
    // ... use p ...
    return;   // forgot to free(p) — leaked 400 bytes
}
```

### 2. Dangling Pointer

Using a pointer after the memory it points to has been freed (or gone out of scope).

```c
int *p = malloc(sizeof(int));
*p = 42;
free(p);
printf("%d\n", *p);   // UB: accessing freed memory
```

### 3. Double Free

Calling `free` twice on the same pointer.

```c
int *p = malloc(sizeof(int));
free(p);
free(p);   // UB: usually crashes or corrupts the heap
```

### 4. Buffer Overflow / Underflow

Writing past the allocated bounds.

```c
int *arr = malloc(5 * sizeof(int));
arr[5] = 99;   // UB: one past the end (valid indices: 0–4)
arr[-1] = 0;   // UB: before the allocation
```

### 5. Using `malloc` Return Without Checking

```c
int *p = malloc(1000000000 * sizeof(int));   // may fail!
p[0] = 1;   // crash if p == NULL
```

---

## Memory Debugging

### Valgrind Memcheck

```bash
gcc -g -o prog prog.c
valgrind --leak-check=full --track-origins=yes --show-leak-kinds=all ./prog
```

Reports:
- Invalid reads/writes
- Use of uninitialized values
- Memory leaks (definitely lost, possibly lost)
- Double frees

### AddressSanitizer (faster, recommended for dev)

```bash
gcc -g -fsanitize=address,undefined -o prog prog.c
./prog    # runtime reports any memory errors with stack traces
```

### `MALLOC_PERTURB_` (glibc trick)

```bash
MALLOC_PERTURB_=0xAB ./prog
```

Sets freed/newly allocated memory to `0xAB`, making use-after-free bugs more visible.

---

## Best Practices

```c
// 1. Always check malloc/calloc return value
int *p = malloc(n * sizeof *p);
if (!p) { /* handle error */ }

// 2. Always free — and NULL the pointer
free(p);
p = NULL;

// 3. Use calloc when you need zeroed memory
int *flags = calloc(n, sizeof *flags);   // all zeros, no memset needed

// 4. Use realloc safely (temp pointer)
int *tmp = realloc(old, new_size);
if (!tmp) { free(old); return -1; }
old = tmp;

// 5. Pair allocation and deallocation at the same "level" of abstraction
//    (the same function, or documented ownership transfer)

// 6. Consider a wrapper that exits on failure (for simple programs)
void *xmalloc(size_t size) {
    void *p = malloc(size);
    if (!p) { perror("malloc"); exit(EXIT_FAILURE); }
    return p;
}
```

---

## Memory Layout of a Heap Block

The allocator stores bookkeeping data (size, free/used flag) in a **header** before the block you receive. This is why writing before `ptr` or after `ptr + size` corrupts the heap silently.

```
[allocator header | size | flags] [YOUR DATA | size bytes] [possible padding]
                                   ↑
                              ptr returned by malloc
```

---

## Practice Problems

<details>
<summary>Problem 1: Write a function that duplicates a string on the heap (`my_strdup`).</summary>

```c
#include <stdlib.h>
#include <string.h>

char *my_strdup(const char *s) {
    if (!s) return NULL;
    size_t len = strlen(s) + 1;  // +1 for '\0'
    char *copy = malloc(len);
    if (!copy) return NULL;
    memcpy(copy, s, len);
    return copy;
}

// Usage:
char *dup = my_strdup("hello");
// use dup...
free(dup);
```
</details>

<details>
<summary>Problem 2: What is wrong here? Fix it.</summary>

```c
int *make_array(int n) {
    int arr[n];
    for (int i = 0; i < n; i++) arr[i] = i;
    return arr;
}
```

**Bug:** Returns a pointer to a VLA on the stack. The stack frame is gone after the function returns — dangling pointer.

**Fix:** Allocate on the heap:
```c
int *make_array(int n) {
    int *arr = malloc(n * sizeof(int));
    if (!arr) return NULL;
    for (int i = 0; i < n; i++) arr[i] = i;
    return arr;   // caller must free()
}
```
</details>

<details>
<summary>Problem 3: Why does `realloc` sometimes return the same pointer and sometimes a new one?</summary>

If the heap allocator can **extend the existing block in-place** (enough free space immediately follows it), it does so and returns the same pointer. If not, it:
1. Allocates a new block of the requested size.
2. Copies the data from the old block.
3. Frees the old block.
4. Returns the new pointer.

This is why you must always use a temporary to catch the return value — you can never assume `realloc` returns the same address.
</details>
