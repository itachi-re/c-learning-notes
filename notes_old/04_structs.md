---
title: "04 — Structures & Unions"
topic: "C Programming"
tags: [c, structs, unions, typedef, bitfields]
updated: 2026-06-14
---

# 04 — Structures & Unions

---

## Defining a Struct

A `struct` groups variables of different types under a single name.

```c
struct Point {
    double x;
    double y;
};

// Usage
struct Point p1;
p1.x = 3.5;
p1.y = -1.2;

// Initialization at declaration
struct Point p2 = {1.0, 2.0};

// C99 designated initializers — order-independent
struct Point p3 = { .y = 5.0, .x = -3.0 };
```

---

## `typedef` with Structs

`typedef` creates a type alias, eliminating the need to write `struct` every time:

```c
typedef struct {
    double x;
    double y;
} Point;

Point p = {3.5, -1.2};
```

Or name both the struct tag and the typedef:
```c
typedef struct Node {
    int value;
    struct Node *next;  // must use 'struct Node' here (typedef not yet complete)
} Node;
```

---

## Member Access

```c
typedef struct {
    char name[64];
    int  age;
    float gpa;
} Student;

Student s = { "Itachi", 20, 3.9f };

// Dot operator for struct value
printf("%s, age %d, GPA %.1f\n", s.name, s.age, s.gpa);

// Arrow operator for pointer to struct
Student *sp = &s;
printf("%s\n", sp->name);     // sp->name  ≡  (*sp).name
```

---

## Structs in Functions

```c
// Passing by value (copies the entire struct)
double distance(Point a, Point b) {
    double dx = a.x - b.x;
    double dy = a.y - b.y;
    return sqrt(dx*dx + dy*dy);
}

// Passing by pointer (more efficient for large structs)
void scale(Point *p, double factor) {
    p->x *= factor;
    p->y *= factor;
}

// Returning a struct by value (compiler typically uses RVO)
Point midpoint(Point a, Point b) {
    return (Point){ (a.x + b.x) / 2, (a.y + b.y) / 2 };
}
```

---

## Nested Structures

```c
typedef struct {
    int day;
    int month;
    int year;
} Date;

typedef struct {
    char     name[64];
    Date     dob;          // nested struct
    double   salary;
} Employee;

Employee e = {
    .name   = "Shiki",
    .dob    = { .day = 1, .month = 3, .year = 1992 },
    .salary = 75000.0
};

printf("Born: %02d/%02d/%d\n", e.dob.day, e.dob.month, e.dob.year);
```

---

## Arrays of Structs

```c
#define MAX_STUDENTS 100

typedef struct {
    char name[64];
    int  id;
    float gpa;
} Student;

Student roster[MAX_STUDENTS];
int count = 0;

// Add a student
roster[count++] = (Student){ "Ryougi", 1001, 4.0f };
roster[count++] = (Student){ "Kokutou", 1002, 3.8f };

// Iterate
for (int i = 0; i < count; i++) {
    printf("%d: %s (%.1f)\n", roster[i].id, roster[i].name, roster[i].gpa);
}
```

---

## Struct Padding & Alignment

The compiler may insert **padding bytes** to satisfy alignment requirements:

```c
struct Bad {     // naively: 1 + 4 + 1 + 4 = 10 bytes
    char  a;     // 1 byte + 3 padding
    int   b;     // 4 bytes
    char  c;     // 1 byte + 3 padding
    int   d;     // 4 bytes
};               // actual size: 16 bytes!

struct Good {    // reordered to minimize padding
    int   b;     // 4 bytes
    int   d;     // 4 bytes
    char  a;     // 1 byte
    char  c;     // 1 byte + 2 padding
};               // actual size: 12 bytes

// Check:
printf("%zu\n", sizeof(struct Bad));   // 16
printf("%zu\n", sizeof(struct Good));  // 12
```

**Rule of thumb:** order members largest to smallest to minimize padding.

To eliminate padding (e.g., for network/file protocols):
```c
struct Packed {
    char a;
    int  b;
} __attribute__((packed));   // GCC/Clang extension
```

---

## Self-Referential Structs (Linked List Node)

```c
typedef struct Node {
    int data;
    struct Node *next;   // pointer to same type — must use 'struct Node', not 'Node'
} Node;

// Build a list: 1 → 2 → 3 → NULL
Node n3 = {3, NULL};
Node n2 = {2, &n3};
Node n1 = {1, &n2};

// Traverse
Node *cur = &n1;
while (cur != NULL) {
    printf("%d ", cur->data);
    cur = cur->next;
}
```

---

## Unions

A `union` has the same syntax as `struct` but all members **share the same memory**. Only one member holds a valid value at a time.

```c
union Value {
    int    i;
    float  f;
    double d;
    char   c;
};

union Value v;
v.i = 42;
printf("%d\n", v.i);     // 42
v.f = 3.14f;
printf("%f\n", v.f);     // 3.14 — v.i is now garbage

printf("%zu\n", sizeof(union Value));   // size of largest member (double = 8)
```

### Tagged Union (Discriminated Union)

The idiomatic way to safely use unions:

```c
typedef enum { TYPE_INT, TYPE_FLOAT, TYPE_STRING } ValueType;

typedef struct {
    ValueType type;
    union {
        int    i;
        float  f;
        char  *s;
    } data;
} Variant;

void print_variant(const Variant *v) {
    switch (v->type) {
        case TYPE_INT:    printf("int: %d\n",  v->data.i); break;
        case TYPE_FLOAT:  printf("flt: %f\n",  v->data.f); break;
        case TYPE_STRING: printf("str: %s\n",  v->data.s); break;
    }
}
```

### Type Punning with Unions

```c
// Inspect the IEEE 754 bit representation of a float
union FloatBits {
    float    f;
    uint32_t bits;
};

union FloatBits fb = { .f = 3.14f };
printf("3.14f bits: 0x%08X\n", fb.bits);  // 0x4048F5C3
```

---

## Bit Fields

Specify exact bit widths for struct members — useful for hardware registers and compact flags:

```c
typedef struct {
    unsigned int read    : 1;   // 1 bit
    unsigned int write   : 1;
    unsigned int execute : 1;
    unsigned int _pad    : 5;   // padding to byte boundary
} Permission;

Permission perm = { .read = 1, .write = 1, .execute = 0 };
printf("r=%d w=%d x=%d\n", perm.read, perm.write, perm.execute);
```

> Bit field layout is implementation-defined. For portable flag operations, prefer bitmasks on an integer.

---

## Compound Literals (C99)

Create temporary struct values inline:

```c
typedef struct { int x, y; } Point;

void draw(Point p) { printf("(%d, %d)\n", p.x, p.y); }

draw((Point){3, 4});           // temporary Point value
draw((Point){ .x=1, .y=2 });  // with designated initializers
```

---

## Practice Problems

<details>
<summary>Problem 1: Define a `Stack` struct backed by a fixed array and write push/pop functions.</summary>

```c
#define CAPACITY 256

typedef struct {
    int data[CAPACITY];
    int top;
} Stack;

void stack_init(Stack *s)      { s->top = -1; }
int  stack_empty(const Stack *s) { return s->top == -1; }
int  stack_full(const Stack *s)  { return s->top == CAPACITY - 1; }

int stack_push(Stack *s, int val) {
    if (stack_full(s)) return -1;
    s->data[++s->top] = val;
    return 0;
}

int stack_pop(Stack *s, int *out) {
    if (stack_empty(s)) return -1;
    *out = s->data[s->top--];
    return 0;
}
```
</details>

<details>
<summary>Problem 2: What is the size of this struct? Explain why.</summary>

```c
struct X {
    char  a;
    int   b;
    char  c;
    short d;
};
```

**Answer:** 12 bytes on most platforms.
- `a`: 1 byte + 3 padding (to align `b` to 4-byte boundary)
- `b`: 4 bytes
- `c`: 1 byte + 1 padding (to align `d` to 2-byte boundary)
- `d`: 2 bytes
- Total: 1+3+4+1+1+2 = 12

Reordering to `int b, short d, char a, char c` would give 8 bytes.
</details>

<details>
<summary>Problem 3: When should you use a union vs a struct?</summary>

- Use a **struct** when you need to store multiple values simultaneously (they all coexist in memory).
- Use a **union** when you need to store one of several possible types (only one is valid at a time). Always pair with a discriminant (enum tag) to track which member is active.
- Common use cases for unions: variant types, parsing binary protocols, type punning.
</details>
