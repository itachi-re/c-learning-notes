# C Programming Notes

> A structured, hands-on reference for learning C — from fundamentals to systems-level programming.

[![Language](https://img.shields.io/badge/Language-C99%2FC11-blue.svg)](https://en.wikipedia.org/wiki/C_(programming_language))
[![Standard](https://img.shields.io/badge/Standard-ISO%2FIEC%209899-orange.svg)](https://www.iso.org/standard/74528.html)
[![Compiler](https://img.shields.io/badge/Compiler-GCC%20%7C%20Clang-brightgreen.svg)](https://gcc.gnu.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Maintained](https://img.shields.io/badge/Maintained-Yes-success.svg)](https://github.com/itachi-re/c-programming-notes)

---

## Overview

This repository is a self-contained learning resource covering C from ground zero to advanced systems programming. Each note file includes concept explanations, annotated code examples, memory diagrams, and practice problems with hidden solutions. The `program/` directory contains fully working demo programs mapped to individual note sections.

---

## Repository Structure

```
c-programming-notes/
├── LICENSE
├── README.md
├── notes/
│   ├── 00_index.md             # Master table of contents
│   ├── 01_basics.md            # Syntax, data types, control flow
│   ├── 02_pointers.md          # Pointers, arrays, memory layout
│   ├── 03_functions.md         # Functions, scope, recursion
│   ├── 04_structs.md           # Structures, unions, typedef
│   ├── 05_file_io.md           # File handling and I/O
│   ├── 06_preprocessor.md      # Macros, conditional compilation
│   ├── 07_dynamic_memory.md    # Heap allocation: malloc/calloc/free
│   ├── 08_data_structures.md   # Linked lists, stacks, queues, trees
│   ├── 09_algorithms.md        # Sorting, searching, complexity
│   ├── 10_advanced.md          # Bitwise ops, function pointers, variadics
│   ├── 11_strings.md           # String handling and string.h deep dive
│   ├── 12_error_handling.md    # errno, defensive programming patterns
│   └── 13_debugging.md         # GDB, Valgrind, AddressSanitizer
├── program/
│   ├── dynamic_memory_management_demo/
│   ├── file_operation_utility/
│   ├── linked_list_implementation/
│   ├── sorting_algorithm_comparison/
│   └── student_management_system/
├── projects/
└── scripts/
    ├── autopush.sh
    └── note_template.md
```

---

## Content Breakdown

### 01 — Basics
- **Program structure** — `#include`, `main()`, compilation unit model
- **Data types** — `int`, `char`, `float`, `double`, `short`, `long`, `unsigned`, `_Bool`
- **Literals & constants** — integer suffixes, `const`, `#define`
- **Operators** — arithmetic, relational, logical, bitwise, assignment, ternary
- **Control flow** — `if/else`, `switch`, `for`, `while`, `do-while`, `break`, `continue`, `goto`
- **Type casting** — implicit promotions, explicit casts, `sizeof`
- **Standard I/O** — `printf`/`scanf` format specifiers

### 02 — Pointers & Memory
- **Pointer fundamentals** — declaration, `&`, `*`, pointer arithmetic
- **Arrays** — decay to pointers, multidimensional arrays, VLAs
- **Memory layout** — text, data, BSS, stack, heap segments
- **Pointer qualifiers** — `const`, `volatile`, `restrict`
- **void\* and NULL** — generic pointers, null safety
- **Pointer to pointer** — double indirection, argv model

### 03 — Functions
- **Anatomy** — return type, name, parameters, prototype declarations
- **Parameter passing** — pass by value, simulated pass by reference
- **Scope & lifetime** — local, global, `static`, `extern`, `register`
- **Recursion** — call stack frames, tail recursion, memoization
- **Inline functions** — `inline` keyword, compiler hints
- **`argc`/`argv`** — command-line argument parsing

### 04 — Structures & Unions
- **Struct basics** — definition, member access (`.` and `->`)
- **Struct padding & alignment** — memory layout, `__attribute__((packed))`
- **Nested structures** — recursive data patterns
- **Arrays of structs** — common data modeling pattern
- **Unions** — overlapping storage, type punning
- **Bit fields** — compact flag storage
- **`typedef`** — aliasing structs and function pointer types

### 05 — File I/O
- **File pointers** — `FILE*`, `fopen` modes, `fclose`, `fflush`
- **Text I/O** — `fgetc`, `fputs`, `fgets`, `fprintf`, `fscanf`
- **Binary I/O** — `fread`, `fwrite`, serialization patterns
- **Seeking** — `fseek`, `ftell`, `rewind`, `SEEK_SET/CUR/END`
- **Error handling** — `ferror`, `feof`, `perror`, `errno`
- **Temp files** — `tmpfile`, `tmpnam`

### 06 — Preprocessor
- **Macros** — object-like, function-like, multi-line with `\`
- **Predefined macros** — `__FILE__`, `__LINE__`, `__DATE__`, `__func__`
- **Conditional compilation** — `#ifdef`, `#ifndef`, `#if`, `#elif`
- **Header files** — include guards, `#pragma once`
- **Token pasting & stringification** — `##` and `#` operators
- **`#pragma`** — compiler-specific directives
- **`X-macros`** — advanced metaprogramming pattern

### 07 — Dynamic Memory
- **Heap allocation** — `malloc`, `calloc`, `realloc`, `free`
- **Ownership model** — who allocates, who frees
- **Memory errors** — leaks, dangling pointers, double free, buffer overflows
- **Debugging** — Valgrind memcheck, AddressSanitizer (`-fsanitize=address`)
- **Best practices** — `free` idioms, always check `NULL`, RAII-like patterns in C

### 08 — Data Structures
- **Singly linked list** — node model, insert/delete/traverse
- **Doubly linked list** — bidirectional traversal, sentinel nodes
- **Stack** — array-based and linked list, LIFO semantics
- **Queue** — circular array and linked list, FIFO semantics
- **Binary tree** — traversal (inorder, preorder, postorder)
- **Binary search tree** — insert, search, delete
- **Hash table** — hash functions, separate chaining, open addressing

### 09 — Algorithms
- **Sorting** — bubble, selection, insertion, merge, quick, heap sort
- **Searching** — linear, binary, interpolation search
- **Complexity analysis** — Big O, Ω, Θ notation
- **Recursion vs iteration** — space/time trade-offs
- **Comparison table** — practical sort selection guide

### 10 — Advanced Topics
- **Bitwise operations** — AND, OR, XOR, NOT, left/right shift
- **Bit manipulation tricks** — flags, masks, power-of-two checks
- **Function pointers** — declaration, callbacks, dispatch tables
- **Variadic functions** — `va_list`, `va_start`, `va_arg`, `va_end`
- **Multi-file projects** — `extern`, static linkage, compilation units
- **`volatile` & `restrict`** — hardware registers, aliasing hints
- **Designated initializers** — C99 struct/array init syntax

### 11 — Strings *(new)*
- **String model** — null-terminated char arrays, no native string type
- **`string.h` functions** — `strlen`, `strcpy`, `strncpy`, `strcat`, `strcmp`, `strstr`, `strtok`
- **Safe alternatives** — `strlcpy`, `strlcat`, `snprintf` over `sprintf`
- **`stdio.h` string ops** — `sprintf`, `sscanf`, `fgets` vs `gets`
- **String to number** — `atoi`, `atol`, `strtol`, `strtod` (and why `atoi` is dangerous)
- **Custom implementations** — building `strlen`, `strcpy`, `strrev` from scratch
- **Unicode/multibyte** — `wchar_t`, `mbstowcs`, locale awareness

### 12 — Error Handling *(new)*
- **`errno` mechanism** — global error indicator, thread safety
- **`perror` / `strerror`** — human-readable error messages
- **Return-code conventions** — negative-on-error, NULL-on-error patterns
- **`assert`** — debug-mode sanity checking, `NDEBUG`
- **`setjmp`/`longjmp`** — non-local jumps for error recovery
- **Defensive programming** — input validation, guard clauses, fail-fast

### 13 — Debugging & Profiling *(new)*
- **GDB workflow** — compile with `-g`, breakpoints, stepping, inspecting memory
- **Valgrind** — memcheck, helgrind (thread errors), massif (heap profiling)
- **AddressSanitizer** — `-fsanitize=address,undefined`, runtime error detection
- **`gprof`** — profiling with `-pg`, reading call graphs
- **`strace`/`ltrace`** — syscall and library call tracing
- **Common bug patterns** — off-by-one, uninitialized reads, signed overflow
- **Makefile debug targets** — `make debug` vs `make release` conventions

---

## Getting Started

### Prerequisites

| Tool | Purpose | Install (openSUSE) |
|------|---------|--------------------|
| `gcc` / `clang` | Compilation | `zypper in gcc clang` |
| `gdb` | Debugger | `zypper in gdb` |
| `valgrind` | Memory analysis | `zypper in valgrind` |
| `make` | Build automation | `zypper in make` |
| `bear` | `compile_commands.json` | `zypper in bear` |

### Compile Flags Reference

```bash
# Development build — all warnings + debug symbols + sanitizers
gcc -std=c11 -Wall -Wextra -Wpedantic -Wshadow -Wformat=2 \
    -g3 -fsanitize=address,undefined -o prog prog.c

# Release build — optimized, no debug
gcc -std=c11 -O2 -DNDEBUG -o prog prog.c

# Check memory issues
valgrind --leak-check=full --track-origins=yes ./prog
```

### Running Examples

```bash
git clone https://github.com/itachi-re/c-programming-notes.git
cd c-programming-notes/program/linked_list_implementation
make        # or: gcc -std=c11 -Wall main.c -o linked_list
./linked_list
```

---

## Learning Roadmap

```
Basics ──► Pointers ──► Functions ──► Structs
                │                        │
                ▼                        ▼
           Dynamic Memory ◄──── Data Structures
                │
                ▼
         Algorithms ──► Advanced ──► Strings
                                        │
                                        ▼
                              Error Handling ──► Debugging
```

---

## Learning Goals

**Foundations**
- [x] Master C syntax and program structure
- [x] Understand memory layout (stack, heap, segments)
- [ ] Write pointer-correct code without UB
- [ ] Work confidently with structs and typedef

**Intermediate**
- [ ] Implement core data structures from scratch
- [ ] Handle files and binary I/O
- [ ] Use the preprocessor effectively
- [ ] Write and debug recursive algorithms

**Advanced**
- [ ] Build multi-file projects with proper header design
- [ ] Use function pointers for callbacks and dispatch
- [ ] Profile and optimize C programs
- [ ] Write memory-safe code validated by Valgrind/ASan

---

## Tools & Workflow

```bash
# Generate compile_commands.json for LSP (clangd/ccls in Neovim)
bear -- gcc -std=c11 -Wall main.c -o main

# Format code
clang-format -i --style="{BasedOnStyle: LLVM, IndentWidth: 4}" *.c *.h

# Static analysis
cppcheck --enable=all --std=c11 .

# Check for UB at compile time
gcc -fsanitize=undefined -fno-omit-frame-pointer -o prog prog.c
```

---

## Resources

| Resource | Type | Notes |
|----------|------|-------|
| [C Reference (en.cppreference.com)](https://en.cppreference.com/w/c) | Reference | Best online C reference |
| [C Standard (N1570)](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf) | Standard | C11 draft (free) |
| *The C Programming Language* — K&R | Book | The original; terse but essential |
| *Modern C* — Jens Gustedt | Book | Free PDF; covers C11/C17 idioms |
| *C Programming: A Modern Approach* — K.N. King | Book | Best for systematic learners |
| [Beej's Guide to C Programming](https://beej.us/guide/bgc/) | Guide | Free, practical, modern |
| [Compiler Explorer (godbolt.org)](https://godbolt.org/) | Tool | See what GCC/Clang emits |
| [cdecl.org](https://cdecl.org/) | Tool | Decode complex C declarations |

---

## Common Pitfalls Quick Reference

| Pitfall | Symptom | Fix |
|---------|---------|-----|
| Off-by-one in arrays | Segfault / garbage | Index: `0` to `n-1` |
| `scanf` string without `&` | UB, likely crash | Use `scanf("%s", str)` not `&str` |
| Forgetting null terminator | String overrun | Allocate `strlen + 1` |
| `int` overflow | Silent wrong result | Use `unsigned` or check bounds |
| Comparing `char` to `EOF` | Infinite loop | `int c = fgetc(f)`, not `char` |
| `strtok` on string literals | Segfault | `strtok` modifies the string; copy first |
| Returning pointer to local | Dangling pointer | Use heap or `static` |
| `sizeof(ptr)` vs `sizeof(*ptr)` | Wrong size | Know what you're measuring |

---

## Contributing

Issues, corrections, and pull requests are welcome. For major additions, open an issue first to discuss scope.

---

## Contact

📬 **Email:** itachi_re@protonmail.com
🐙 **GitHub:** [@itachi-re](https://github.com/itachi-re)

---

## License

MIT License — see [LICENSE](LICENSE) for details.
