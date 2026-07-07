# Chapter 00 — Quiz

Answer key is in `solutions.md`. Try to answer without looking anything up first — this quiz is meant to reveal what stuck, not to be a lookup exercise.

1. **(Multiple choice)** Who is credited as the primary creator of the C language?
   a) Ken Thompson
   b) Dennis Ritchie
   c) Brian Kernighan
   d) Linus Torvalds

2. **(Fill in the blank)** C was derived from an earlier, typeless language called ______.

3. **(Multiple choice)** What operating system was C originally created to help develop?
   a) Windows
   b) UNIX
   c) MS-DOS
   d) Multics

4. **(Multiple choice)** Which of these is a compiled language?
   a) Classic Python
   b) Shell scripting
   c) C
   d) All of the above

5. **(Fill in the blank)** The three steps of the CPU's basic execution cycle are fetch, ______, and execute.

6. **(Multiple choice)** Which of these is NOT one of the four stages of C compilation?
   a) Preprocessing
   b) Garbage collection
   c) Assembly
   d) Linking

7. **(Output prediction — conceptual)** If a `.c` file has a syntax error on line 10, but the file is 200 lines long, where should you look first when reading the compiler's error output?
   a) The last error message, since it's usually the real cause
   b) The first error message, since later ones may cascade from it
   c) Line 200, since compilers report errors from the bottom
   d) It doesn't matter, all errors are independent

8. **(Multiple choice)** What year was C formally standardized as ANSI C?
   a) 1972
   b) 1983
   c) 1989
   d) 1999

9. **(Fill in the blank)** The C standard published in 1978 by Kernighan and Ritchie is informally known as ______.

10. **(Multiple choice)** Which of the following is true about C's memory management?
    a) C has an automatic garbage collector
    b) C requires the programmer to manually free dynamically allocated memory
    c) C does not allow dynamic memory allocation at all
    d) Memory management in C works identically to Python

11. **(Compiler behavior)** What is the purpose of the **linker** stage specifically?
    a) It converts C syntax into assembly
    b) It expands `#include` and `#define` directives
    c) It resolves references between object files and libraries into one executable
    d) It optimizes your code for speed

12. **(Multiple choice)** Which C standard introduced `//` single-line comments and `stdint.h`?
    a) C89
    b) C99
    c) C11
    d) C23

13. **(True/False)** A CPU can directly execute C source code without any translation step.

14. **(Fill in the blank)** The memory region that holds a running program's compiled instructions is called the ______ segment.

15. **(Multiple choice)** Which memory region grows automatically as a program calls more nested functions?
    a) The heap
    b) The stack
    c) The BSS segment
    d) The text segment

16. **(Debugging)** Your program compiles with no errors, but crashes unpredictably at runtime with no clear message. Based on this chapter, what C-specific concept is most likely responsible?
    a) A syntax error
    b) A missing semicolon
    c) Undefined behavior
    d) A missing `#include`

17. **(Multiple choice)** Why is C still relevant for embedded systems specifically?
    a) It requires a large runtime that provides safety nets
    b) It has minimal runtime overhead and gives direct hardware control
    c) It automatically manages memory for constrained devices
    d) It's the only language that can produce an executable

18. **(Multiple choice)** Which of these compiler flags should you enable from the very beginning of learning C, according to this chapter?
    a) `-O3`
    b) `-Wall -Wextra`
    c) `-shared`
    d) `-fPIC`

19. **(Fill in the blank)** The most recent finalized C standard discussed in this chapter, as of this course, is ______.

20. **(Conceptual)** In one sentence: why does this course teach Pointers (Chapter 09) and Memory Layout (Chapter 10) near the end of the foundational tier, rather than at the very beginning?
