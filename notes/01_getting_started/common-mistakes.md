# common-mistakes.md

Twenty mistakes beginners make in their first encounters with the C toolchain, each explained in terms of why it happens, what the compiler actually does in response, and how to fix it.

## 1. Forgetting `./` when running a compiled program

**Why it happens:** Other operating systems and shells sometimes let you run a program by name alone from the current directory. Linux shells deliberately do not search the current directory by default.

**Compiler/shell behavior:** `bash: hello: command not found`, even though the file exists and is executable.

**Fix:** Run `./hello`, explicitly telling the shell to look in the current directory.

## 2. Forgetting `-o` and being confused by `a.out`

**Why it happens:** Beginners assume the compiler names the output after the input file automatically.

**Compiler behavior:** GCC silently produces a file named `a.out` (a historical UNIX convention, "assembler output"), with no error or warning.

**Fix:** Always specify `-o <name>` explicitly, e.g., `gcc hello.c -o hello`.

## 3. Missing semicolon, error reported on the wrong line

**Why it happens:** The compiler doesn't recognize a statement is incomplete until it encounters the *next* token, which is often on a subsequent line.

**Compiler behavior:** `error: expected ';' before '}' token`, reported one or more lines after the actual missing semicolon.

**Fix:** When an error's reported line looks syntactically correct on its own, check the line(s) immediately above it.

## 4. Forgetting `#include <stdio.h>` before using `printf`

**Why it happens:** Beginners don't yet have a mental model that `printf` isn't a language keyword — it's a function declared in a header file you must explicitly include.

**Compiler behavior:** `warning: implicit declaration of function 'printf'` (a warning in relaxed modes, a hard error in strict C99-and-later conformance modes).

**Fix:** Add `#include <stdio.h>` at the top of the file.

## 5. Ignoring warnings entirely

**Why it happens:** A program with warnings still often compiles and runs, so beginners assume warnings are optional noise.

**Compiler behavior:** The compiler produces a working (or seemingly working) executable regardless, since warnings don't halt compilation the way errors do.

**Fix:** Treat every warning under `-Wall -Wextra` as a bug report. Fix warnings as they appear rather than letting them accumulate.

## 6. Not enabling `-Wall -Wextra` from the start

**Why it happens:** The bare `gcc file.c` command works and produces a runnable program, so there's no obvious reason to add more flags.

**Compiler behavior:** Without these flags, GCC stays silent about many legitimate bugs — unused variables, suspicious comparisons, format string mismatches — that it would otherwise flag.

**Fix:** Make `-Wall -Wextra` part of your default compile command permanently, ideally via a Makefile so you never have to remember to type it.

## 7. Confusing a warning with an error

**Why it happens:** Both appear as red or highlighted text in many editors, and both look "scary" to a beginner.

**Compiler behavior:** Errors prevent an executable from being produced at all; warnings do not — the compiler flags a concern but still finishes.

**Fix:** Learn to distinguish the words "error" and "warning" in compiler output — they mean fundamentally different things for whether your program was even built.

## 8. Using spaces instead of a tab in a Makefile

**Why it happens:** Nearly every other context in programming treats tabs and spaces as interchangeable whitespace; Makefiles are a famous, longstanding exception.

**Compiler/make behavior:** `Makefile:2: *** missing separator. Stop.`, an error message that gives no direct hint about whitespace being the cause.

**Fix:** Ensure your editor is configured to insert a literal tab character before Makefile commands, not spaces. Many editors auto-detect Makefiles and handle this correctly, but it's worth checking explicitly if you hit this error.

## 9. Assuming `-O3` is always better than `-O2`

**Why it happens:** A higher number intuitively suggests "more optimized, therefore better."

**Compiler behavior:** `-O3` applies more aggressive transformations, which can occasionally increase binary size or even reduce performance for certain code patterns, compared to the well-tested middle ground of `-O2`.

**Fix:** Default to `-O2` for release builds unless you've specifically measured `-O3` to be faster for your program.

## 10. Debugging an optimized build

**Why it happens:** Beginners don't yet realize optimization and debugging pull in opposite directions.

**Compiler/gdb behavior:** Variables can appear to have the "wrong" value, or seem to not exist at all, inside `gdb`, because the optimizer eliminated or reordered them.

**Fix:** Always use `-O0 -g` for any build you intend to step through with `gdb`.

## 11. Not specifying `-std=` explicitly

**Why it happens:** The compiler works without it, so beginners don't realize a default is even being chosen.

**Compiler behavior:** GCC uses its own internal default standard, which can differ between GCC versions and doesn't guarantee any specific standard's exact behavior.

**Fix:** Always specify `-std=c23` (or whichever standard the project targets) explicitly, making your build reproducible regardless of which machine or GCC version compiles it.

## 12. Editing the wrong file after copy-pasting examples

**Why it happens:** Beginners sometimes copy an example into a new file but continue editing an old, similarly-named file out of habit.

**Compiler behavior:** None directly — the compiler happily compiles whatever file you actually point it at, which is exactly the problem: no error tells you that you're editing the wrong file.

**Fix:** Use `pwd` and `ls` frequently to confirm which directory and file you're actually working in.

## 13. Confusing compilation success with correctness

**Why it happens:** A program that compiles without errors "feels" finished.

**Compiler behavior:** The compiler only checks that your code is syntactically valid and (with warnings) flags suspicious patterns — it does not verify that your program does what you intended.

**Fix:** Compiling cleanly is necessary, not sufficient. Always run the program and check its actual output against what you expect.

## 14. Trying to run an object file (`.o`) directly

**Why it happens:** Beginners don't yet distinguish between an object file and a complete executable.

**Compiler/shell behavior:** Attempting to execute a `.o` file typically fails outright, since it's not a complete, linked program — it may still contain unresolved references to library functions.

**Fix:** Always complete the linking stage (the default behavior of a plain `gcc file.c -o output` command) before attempting to run a program.

## 15. Not reading error messages top-to-bottom

**Why it happens:** A wall of red error text is intimidating, and it's tempting to jump straight to the last (often most confusing) message.

**Compiler behavior:** A single early mistake (like a missing brace) frequently produces a cascade of confusing, seemingly unrelated errors further down, because the compiler's understanding of the file's structure has already gone wrong.

**Fix:** Always start with the *first* reported error and recompile after fixing just that one — later errors often resolve themselves.

## 16. Forgetting `return 0;` (or any return value) in `main`

**Why it happens:** Beginners don't yet understand that `main`'s return value communicates success or failure to the operating system.

**Compiler behavior:** Under `-Wall`, missing a `return` in a non-`void` function typically produces a `warning: control reaches end of non-void function`. In practice, falling off the end of `main` without a `return` is defined by the C standard to implicitly return `0`, but relying on this is considered poor style.

**Fix:** Always write an explicit `return 0;` (or an appropriate non-zero value) at the end of `main`.

## 17. Confusing `-c` (compile to object file) with `-C` (an entirely different, rarely-used flag)

**Why it happens:** Command-line flags in C are case-sensitive, and it's easy to mistype the case, especially for beginners used to case-insensitive interfaces elsewhere.

**Compiler behavior:** Using the wrong case produces either an unrelated behavior or an "unrecognized command-line option" error, depending on the exact flag.

**Fix:** Pay close attention to flag case; when in doubt, check `man gcc` or `gcc --help`.

## 18. Believing the compiler "translates C into an executable" in one indivisible step

**Why it happens:** From the outside, `gcc hello.c -o hello` looks like a single atomic action.

**Compiler behavior:** GCC is, in fact, orchestrating four distinct stages (preprocessing, compilation, assembly, linking) automatically, unless told to stop early with `-E`, `-S`, or `-c`.

**Fix:** Practice running each stage manually at least once, as shown in this chapter's README, to build an accurate mental model.

## 19. Not realizing that warnings can differ between GCC and Clang

**Why it happens:** Beginners assume all C compilers behave identically, since they're compiling "the same language."

**Compiler behavior:** GCC and Clang implement different (though overlapping) sets of warnings, and their exact wording and detection heuristics differ, meaning code that's clean under one compiler may produce a warning under the other.

**Fix:** Periodically compile important code with both `gcc` and `clang`, using the same flags, and compare their output.

## 20. Expecting `make` to work without a file literally named `Makefile`

**Why it happens:** Beginners sometimes name their build file something else (`makefile.txt`, `build.mk`) without realizing `make`'s default lookup behavior.

**Make behavior:** `make: *** No targets specified and no makefile found. Stop.`

**Fix:** Name the file exactly `Makefile` (capital M is the conventional default) in the same directory where you run `make`, or use `make -f <filename>` to specify a different filename explicitly.
