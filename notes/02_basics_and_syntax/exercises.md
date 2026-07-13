# exercises.md

All solutions and explanations are in `solutions.md`. Try each exercise yourself first — including typing out and running every piece of code — before checking.

## Easy (10)

1. Verify your GCC installation by running `gcc --version` and write down the version number you see.
2. Verify your Clang installation the same way.
3. Write a program that prints your name instead of "Hello, World!".
4. Modify `hello.c` to print two separate lines of text using two separate `printf` calls.
5. Modify `hello.c` to print two lines of text using a single `printf` call and an embedded `\n`.
6. Compile `hello.c` without the `-o` flag. What is the resulting executable named, and why?
7. Run `echo $?` immediately after running a successful program, and again after a program that returns `1`. Record both values.
8. Run `gcc -Wall -Wextra` on a file that declares a variable but never uses it. Record the exact warning text.
9. Create a `Makefile` for a program called `greet.c` that compiles it with `-Wall -Wextra -std=c23`.
10. Run `make clean` on the Makefile from this chapter, then confirm with `ls` that the executable was actually removed.

## Medium (10)

11. Run all four compilation stages manually (`-E`, `-S`, `-c`, then link) on a program of your own, and describe in your own words what changed at each stage.
12. Open the `.s` (assembly) file generated from a simple program and find the line that corresponds to your call to `printf`.
13. Compile the same program with `-O0` and `-O3`, then compare the file sizes of the two resulting executables using `ls -l`.
14. Write a program with an intentional unused variable, then compile it with and without `-Wextra`. Compare the warning output.
15. Explain, using this chapter's material, why running `hello` without `./` typically fails on Linux but `./hello` succeeds.
16. Write a Makefile with three targets: `build`, `run`, and `clean`, where `run` depends on `build`.
17. Deliberately omit `#include <stdio.h>` from a program that calls `printf`, and record the exact compiler warning or error you get.
18. Compile a program using `-std=c99` and then again using `-std=c23`. Are there any differences in the output for a simple `hello.c`? Explain why or why not.
19. Use `gcc -E` on a file with a `#define` macro and observe how the macro is expanded in the preprocessor output.
20. Explain, in your own words, the difference between a compiler warning and a compiler error, using an example of each from this chapter.

## Hard (10)

21. Write a program that intentionally triggers at least three different warnings under `-Wall -Wextra`, then fix each one, explaining the fix.
22. Investigate what `-Wpedantic` catches that `-Wall -Wextra` does not, using a small code sample that relies on a GCC-specific extension (research: statement expressions, `typeof` as a GNU extension pre-C23).
23. Time the compilation of a moderately sized C file (50+ lines) at `-O0`, `-O2`, and `-O3` using the `time` command. Record and compare the results.
24. Explain why `-g` does not meaningfully affect runtime performance, even though it changes the size of the resulting binary file.
25. Modify the Makefile from this chapter to build two separate executables from two separate `.c` files, sharing the same `CFLAGS`.
26. Write a program, compile it to an object file only (`-c`), and attempt to run the `.o` file directly. Explain what happens and why.
27. Use `objdump -d` (if available) on a compiled executable to view its disassembly, and locate the instructions corresponding to `main`.
28. Research and explain one scenario where `-O3` could make a program *slower* than `-O2`, even though it applies "more" optimization.
29. Explain why `int main(void)` is preferred over `int main()` in modern, standards-conformant C, referencing what each syntax technically means about parameters.
30. Write a Makefile that automatically adds `-g` when a variable `DEBUG=1` is passed on the command line (`make DEBUG=1`), and `-O2` otherwise.

## Debugging (5)

31. This program fails to compile. Find and fix the error:
    ```c
    #include <stdio.h>

    int main(void) {
        printf("Hello, World!\n")
        return 0;
    }
    ```

32. This program compiles with a warning under `-Wall`. Find and fix it:
    ```c
    #include <stdio.h>

    int main(void) {
        int x = 5;
        printf("Done\n");
        return 0;
    }
    ```

33. This program produces an "implicit declaration" warning. Find and fix it:
    ```c
    int main(void) {
        printf("Hello\n");
        return 0;
    }
    ```

34. This Makefile fails with a "missing separator" error. Identify the likely cause without seeing whitespace directly, based on what this chapter explained about Makefile syntax:
    ```makefile
    hello: hello.c
        gcc hello.c -o hello
    ```

35. This program compiles and links, but running `./hello` produces `bash: ./hello: Permission denied`. Based on how Linux executables work, what is the most likely cause, and what command would you try first?

## Code Reading (5)

36. Read this command and explain, stage by stage, what it does: `gcc -E hello.c -o hello.i`
37. Read this command and explain what would go wrong if run before `hello.c` even exists: `gcc -S hello.i -o hello.s`
38. Read this Makefile and explain what happens if you run `make` twice in a row without modifying `hello.c`:
    ```makefile
    hello: hello.c
    	gcc -Wall -Wextra hello.c -o hello
    ```
39. Read this compile command and list every flag's purpose from memory: `gcc -std=c23 -Wall -Wextra -Wpedantic -g -O0 hello.c -o hello`
40. Read this code and explain what `return 1;` communicates to the operating system, and how a shell script could detect it:
    ```c
    #include <stdio.h>
    int main(void) {
        printf("Something went wrong\n");
        return 1;
    }
    ```

## Output Prediction (5)

41. Predict the exact output of:
    ```c
    #include <stdio.h>
    int main(void) {
        printf("Line one\n");
        printf("Line two\n");
        return 0;
    }
    ```

42. Predict the exit status printed by `echo $?` after this program runs:
    ```c
    int main(void) {
        return 42;
    }
    ```

43. Predict whether this compiles cleanly under `-Wall -Wextra`, and if not, what the warning says:
    ```c
    #include <stdio.h>
    int main(void) {
        int unused_variable;
        printf("Hi\n");
        return 0;
    }
    ```

44. Predict the output, paying attention to the escape sequence:
    ```c
    #include <stdio.h>
    int main(void) {
        printf("Tab:\tEnd\n");
        return 0;
    }
    ```

45. Predict what happens when you run `make` if no `Makefile` exists in the current directory.

## Mini Projects (2)

46. **Personal toolchain report.** Write a short shell script (`toolchain_check.sh`) that prints the installed versions of `gcc`, `clang`, `make`, and `gdb`, and clearly reports if any are missing. This is a shell scripting exercise, not a C exercise — the goal is to practice checking your own environment programmatically, a skill you'll rely on throughout this course.

47. **Personal Makefile template.** Build a reusable `Makefile` template with `build`, `run`, `clean`, and `debug` (adding `-g -O0` and dropping optimization) targets, designed so you can copy it into any future chapter's folder and only need to change the source filename. Test it against `hello.c`.
