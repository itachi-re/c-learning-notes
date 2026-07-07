# Chapter 00 — Cheat Sheet

## History, in one line each

| Year | Event |
|---|---|
| 1969 | Bell Labs withdraws from Multics; Thompson and Ritchie begin UNIX |
| ~1969–1970 | Ken Thompson designs **B**, derived from BCPL |
| 1969–1973 | Dennis Ritchie evolves B into **C**, adding types |
| 1973 | UNIX kernel rewritten in C — proved portability without sacrificing performance |
| 1978 | Kernighan & Ritchie publish *The C Programming Language* ("K&R") |
| 1989 / 1990 | ANSI C / ISO C standardized (**C89** / **C90**) |
| 1999 | **C99**: `//` comments, `stdint.h`, variable-length arrays |
| 2011 | **C11**: atomics, threads, `_Generic` |
| 2018 | **C17**: bug-fix release, no new features |
| 2024 | **C23**: `nullptr`, `typeof`, `#embed` |

## The compilation pipeline

```
Source (.c) → Preprocessor → Compiler → Assembler → Linker → Executable
```

| Stage | Input | Output | What happens |
|---|---|---|---|
| Preprocessing | `.c` | Expanded source | `#include`, `#define` expanded as text |
| Compilation | Expanded source | Assembly | C syntax → CPU-family assembly |
| Assembly | Assembly | Object file (`.o`) | Assembly → binary machine code |
| Linking | `.o` files + libraries | Executable | Resolves references (e.g., `printf`) into one runnable file |

## CPU execution cycle

```
Fetch → Decode → Execute → (repeat)
```

## Memory regions (preview — full detail in Ch. 10)

| Region | Holds | Grows |
|---|---|---|
| Text | Compiled instructions | Fixed |
| Data | Initialized globals/statics | Fixed |
| BSS | Zero-initialized globals/statics | Fixed |
| Heap | Dynamically allocated memory | Upward |
| Stack | Function calls, local variables | Downward |

## Compiled vs. interpreted

| | Compiled (C) | Interpreted (classic Python) |
|---|---|---|
| Translated when | Before running, once | Every time, line by line, at runtime |
| Speed | Generally faster | Generally slower |
| Errors caught | Many, before running | Often only when that line executes |

## Toolchain names you'll meet in Ch. 01

`gcc`, `clang`, `make`, `gdb`, `valgrind`, `clang-format`, `cppcheck`

## First rule of this course

Always compile with `-Wall -Wextra` from Chapter 01 onward. Treat every warning as a bug report.
