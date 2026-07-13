# quiz.md

Answer key and explanations are in `solutions.md`.

1. **(Multiple choice)** Which command compiles `hello.c` into an executable named `hello`?
   a) `gcc hello.c`
   b) `gcc hello.c -o hello`
   c) `gcc -o hello.c hello`
   d) `gcc run hello.c`

2. **(Fill in the blank)** Without an `-o` flag, GCC names the output executable ______.

3. **(Multiple choice)** Which flag enables debug symbols for use with `gdb`?
   a) `-O0`
   b) `-Wall`
   c) `-g`
   d) `-std=c23`

4. **(Compiler behavior)** What does `-Wextra` do that `-Wall` does not?
   a) Enables all possible warnings with no exceptions
   b) Enables additional warnings `-Wall` deliberately excludes
   c) Disables warnings for cleaner output
   d) Nothing; they are identical

5. **(Fill in the blank)** The four stages of compilation, in order, are preprocessing, ______, assembly, and linking.

6. **(Multiple choice)** Which flag stops GCC immediately after the preprocessing stage?
   a) `-c`
   b) `-S`
   c) `-E`
   d) `-P`

7. **(Output prediction)** What is printed by `echo $?` immediately after a program that executes `return 0;`?
   a) `1`
   b) `0`
   c) Nothing
   d) `true`

8. **(Multiple choice)** Which flag stops GCC immediately after generating an object file, without linking?
   a) `-c`
   b) `-S`
   c) `-E`
   d) `-o`

9. **(Debugging)** A program fails to compile with `expected ';' before '}' token` reported on line 7. Where should you look first?
   a) Line 7 only
   b) Line 8, since errors are always reported one line late
   c) Line 6, the line above the reported error
   d) The last line of the file

10. **(Fill in the blank)** The warning "implicit declaration of function" almost always means you forgot a(n) ______ directive.

11. **(Multiple choice)** Which optimization flag is GCC's default when none is specified?
    a) `-O0`
    b) `-O1`
    c) `-O2`
    d) `-O3`

12. **(Multiple choice)** Why should you avoid combining `-O2`/`-O3` with active `gdb` debugging?
    a) They are not compatible flags and will cause a compile error
    b) Optimized code can reorder or eliminate variables, making debugging confusing
    c) `-O2` and `-O3` disable `gdb` entirely
    d) There is no reason; this is a common and recommended combination

13. **(Memory)** Which compilation stage first produces actual binary machine code, rather than text?
    a) Preprocessing
    b) Compilation proper
    c) Assembly
    d) Linking

14. **(Multiple choice)** What is the purpose of the linker specifically?
    a) Expanding `#include` directives
    b) Translating C into assembly
    c) Resolving references (like `printf`) into a complete executable
    d) Formatting your source code

15. **(Fill in the blank)** `-std=c23` tells the compiler to compile against the ______ language standard specifically.

16. **(Output prediction)** What does this program print?
    ```c
    #include <stdio.h>
    int main(void) {
        printf("A\n");
        printf("B\n");
        return 0;
    }
    ```
    a) `AB` on one line
    b) `A` then `B` on separate lines
    c) `B` then `A`
    d) A compile error

17. **(Multiple choice)** Which of these correctly represents the intent of `int main(void)`?
    a) `main` returns nothing and takes no arguments
    b) `main` returns an `int` and explicitly takes no arguments
    c) `main` returns an `int` and can take any arguments
    d) `void` is a required keyword with no specific meaning

18. **(Debugging)** Running `./hello` produces `Permission denied`. What is the most likely first thing to check?
    a) Whether the file has execute permission (`ls -l hello`)
    b) Whether `printf` was spelled correctly
    c) Whether `-Wall` was used
    d) Whether the file has a `.c` extension

19. **(Multiple choice)** What is the primary purpose of a Makefile, as introduced in this chapter?
    a) To replace the C compiler entirely
    b) To avoid retyping a long, repetitive build command
    c) To add graphical debugging support
    d) To convert C code into another language

20. **(Fill in the blank)** In a Makefile, the indentation before a command must be a literal ______ character, not spaces.

21. **(Compiler behavior)** What happens if you run `gcc -c hello.c -o hello.o` and then try to execute `./hello.o` directly?
    a) It runs normally, printing "Hello, World!"
    b) It fails, because an object file is not yet a complete, linked executable
    c) It automatically links itself before running
    d) `gcc -c` is not a valid flag combination

22. **(Multiple choice)** Which flag would you add specifically to catch use of non-standard, compiler-specific language extensions?
    a) `-Wall`
    b) `-Wextra`
    c) `-Wpedantic`
    d) `-O2`

23. **(Memory)** True or false: `-g` significantly slows down the runtime performance of the resulting executable.

24. **(Output prediction)** Given this program, what does `echo $?` print immediately after running it?
    ```c
    int main(void) {
        return 7;
    }
    ```

25. **(Multiple choice)** Which of the following editors requires installing a separate language server (like `clangd`) to get IDE-like autocompletion for C?
    a) Code::Blocks
    b) VS Code with the C/C++ extension
    c) Neovim
    d) None of the above; all editors include this by default

26. **(Debugging)** A Makefile fails with `Makefile:2: *** missing separator. Stop.` What is the single most likely cause, based on this chapter?
    a) A missing semicolon in the C source file
    b) Spaces used instead of a tab before the build command
    c) The `Makefile` was saved with the wrong file extension
    d) `make` is not installed

27. **(Fill in the blank)** The command `time gcc -O3 file.c -o file` measures the ______ taken to compile the program, not the time taken to run it.
