---
title: "00 — Master Index"
topic: "C Programming"
tags: [c, index, toc]
updated: 2026-06-14
---

# C Programming Notes — Index

Complete table of contents for all note files in this repository.

---

## Notes

| # | File | Topics Covered |
|---|------|----------------|
| 00 | [Index](00_index.md) | This file |
| 01 | [Basics](01_basics.md) | Syntax, data types, operators, control flow, I/O |
| 02 | [Pointers](02_pointers.md) | Pointers, arrays, memory layout, pointer qualifiers |
| 03 | [Functions](03_functions.md) | Declarations, scope, recursion, `argc`/`argv` |
| 04 | [Structs](04_structs.md) | Structures, unions, bit fields, typedef |
| 05 | [File I/O](05_file_io.md) | `FILE*`, text/binary I/O, seeking, error handling |
| 06 | [Preprocessor](06_preprocessor.md) | Macros, conditional compilation, header files |
| 07 | [Dynamic Memory](07_dynamic_memory.md) | `malloc`/`calloc`/`realloc`/`free`, memory errors |
| 08 | [Data Structures](08_data_structures.md) | Linked lists, stacks, queues, trees, hash tables |
| 09 | [Algorithms](09_algorithms.md) | Sorting, searching, complexity analysis |
| 10 | [Advanced](10_advanced.md) | Bitwise ops, function pointers, variadics, multi-file |
| 11 | [Strings](11_strings.md) | `string.h`, safe string handling, conversions |
| 12 | [Error Handling](12_error_handling.md) | `errno`, `perror`, defensive programming |
| 13 | [Debugging](13_debugging.md) | GDB, Valgrind, ASan, profiling |

---

## Programs

| Program | Concepts Demonstrated |
|---------|-----------------------|
| `dynamic_memory_management_demo` | `malloc`, `realloc`, `free`, leak detection |
| `file_operation_utility` | `fopen`/`fread`/`fwrite`, binary vs text, `fseek` |
| `linked_list_implementation` | Heap-allocated nodes, pointer manipulation, CRUD |
| `sorting_algorithm_comparison` | Bubble/insertion/merge/quick sort, timing |
| `student_management_system` | Structs, file persistence, dynamic arrays |

---

## Concept → File Cross-Reference

### Memory
- Stack vs heap → [02_pointers.md](02_pointers.md#memory-layout), [07_dynamic_memory.md](07_dynamic_memory.md)
- Memory errors → [07_dynamic_memory.md](07_dynamic_memory.md#common-errors), [13_debugging.md](13_debugging.md)
- `sizeof` → [01_basics.md](01_basics.md), [02_pointers.md](02_pointers.md)

### Types
- Primitive types → [01_basics.md](01_basics.md)
- Custom types (`struct`, `union`, `typedef`) → [04_structs.md](04_structs.md)
- Strings as `char[]` → [11_strings.md](11_strings.md)

### Control Flow
- Loops and conditionals → [01_basics.md](01_basics.md)
- Recursion → [03_functions.md](03_functions.md)
- Non-local jumps (`setjmp`) → [12_error_handling.md](12_error_handling.md)

### I/O
- Console I/O → [01_basics.md](01_basics.md)
- File I/O → [05_file_io.md](05_file_io.md)
- String I/O → [11_strings.md](11_strings.md)

### Compilation
- Preprocessor → [06_preprocessor.md](06_preprocessor.md)
- Multi-file projects → [10_advanced.md](10_advanced.md)
- Build flags → [13_debugging.md](13_debugging.md)
