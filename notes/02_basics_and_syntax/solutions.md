# solutions.md

## Easy Exercise Solutions

**1–2.** `gcc --version` and `clang --version` print version, build, and license information. Exact numbers vary by system and installation date — the goal is confirming a version number prints at all, with no `command not found` error.

**3.**
```c
#include <stdio.h>
int main(void) {
    printf("Rohan\n");
    return 0;
}
```

**4.**
```c
#include <stdio.h>
int main(void) {
    printf("Line one\n");
    printf("Line two\n");
    return 0;
}
```

**5.**
```c
#include <stdio.h>
int main(void) {
    printf("Line one\nLine two\n");
    return 0;
}
```
Both produce identical output — `\n` inside a single string behaves the same as ending one `printf` call and starting another.

**6.** Compiling `gcc hello.c` with no `-o` produces a file named `a.out`, GCC's historical default output name inherited from early UNIX assemblers.

**7.** A successful program (`return 0;`) makes `echo $?` print `0`. A program with `return 1;` makes it print `1`.

**8.** Example warning: `warning: unused variable 'x' [-Wunused-variable]`. Exact wording may vary slightly by GCC version.

**9.**
```makefile
CC = gcc
CFLAGS = -Wall -Wextra -std=c23

greet: greet.c
	$(CC) $(CFLAGS) greet.c -o greet
```

**10.** After `make clean`, `ls` should no longer list the executable file, confirming `rm -f hello` executed successfully.

## Medium Exercise Solutions

**11.**
```bash
gcc -E hello.c -o hello.i   # macro/include expansion, still C-like text
gcc -S hello.i -o hello.s   # translated into CPU assembly instructions
gcc -c hello.s -o hello.o   # assembled into binary machine code (unreadable as text)
gcc hello.o -o hello        # linked into a complete, runnable executable
```
Each stage transforms the program into a form progressively closer to what the CPU directly executes.

**12.** In the generated `.s` file, look for a line containing `call printf` (the exact mnemonic syntax depends on your CPU architecture and assembler dialect, but the call to `printf` is always present as a distinct instruction).

**13.** `-O3` binaries are sometimes slightly larger than `-O2` due to more aggressive inlining and loop unrolling, though the difference is often modest for small programs like `hello.c`. Use `ls -l hello_o0 hello_o2 hello_o3` to compare exact byte sizes on your system.

**14.** Without `-Wextra`, an unused variable still triggers a warning under `-Wall` alone (`-Wunused-variable` is actually part of `-Wall`). This exercise is a good opportunity to discover that some warnings you might expect to require `-Wextra` are already covered by `-Wall` — always check which flag actually enables a given warning using GCC's documentation rather than assuming.

**15.** Linux shells do not search the current directory (`.`) for executables by default, as a security measure preventing a malicious file named, say, `ls` placed in a directory from being run accidentally instead of the real `/bin/ls`. The explicit `./` tells the shell unambiguously: "run the file named `hello` in this exact directory."

**16.**
```makefile
CC = gcc
CFLAGS = -Wall -Wextra -std=c23

build: hello.c
	$(CC) $(CFLAGS) hello.c -o hello

run: build
	./hello

clean:
	rm -f hello
```

**17.** Expected: `warning: implicit declaration of function 'printf'` (older/relaxed conformance modes) or a hard `error: implicit declaration of function 'printf' is invalid in C99` (C99-and-later strict conformance) — the exact phrasing and severity depend on GCC version and `-std=` setting.

**18.** For a simple `hello.c`, there's typically no visible output difference, because `hello.c` doesn't use any feature that changed between C99 and C23. The value of `-std=` becomes visible once your code relies on standard-specific syntax, like C23's `nullptr` or C99's `//` comments in extremely old, strict C89 conformance mode.

**19.** A `#define NAME value` macro is replaced, textually, with `value` everywhere `NAME` appears in the preprocessed output — you should see the literal replacement text in `.i`, not the macro name.

**20.** A warning is the compiler flagging a suspicious pattern while still producing a working executable; an error prevents compilation from completing at all. Example warning: unused variable. Example error: missing semicolon.

## Hard Exercise Solutions

**21–30** are open-ended, hands-on exercises without single fixed answers; the expected outcomes and reasoning are described in the corresponding sections of this chapter's `README.md` (compiler flags, Makefiles, and the compilation pipeline sections directly support exercises 21–22, 25, 27–30). Exercise 26 in particular should confirm that running a `.o` file directly fails, since it isn't a linked, complete executable — this is the same concept covered in the README's linking stage explanation. Exercise 29 should reference that `int main(void)` explicitly declares zero parameters, while `int main()` in C (unlike C++) technically declares an unspecified number of parameters — a subtle but real difference the C standard preserves for legacy compatibility.

## Debugging Exercise Solutions

**31.** Missing semicolon after the `printf` call:
```c
#include <stdio.h>
int main(void) {
    printf("Hello, World!\n");
    return 0;
}
```

**32.** Unused variable `x`. Either use it or remove it:
```c
#include <stdio.h>
int main(void) {
    printf("Done\n");
    return 0;
}
```

**33.** Missing `#include <stdio.h>`:
```c
#include <stdio.h>
int main(void) {
    printf("Hello\n");
    return 0;
}
```

**34.** The command line is very likely indented with spaces instead of a literal tab character — this is the single most common cause of `missing separator` errors in a Makefile that otherwise looks correct.

**35.** The file most likely lacks execute permission. Check with `ls -l hello` (look for `x` in the permission bits), and fix with `chmod +x hello` if needed. Note: a freshly compiled executable from `gcc` is normally already executable — this scenario is more common when a file was copied or extracted from an archive without preserving its permissions.

## Code Reading Solutions

**36.** Runs the preprocessor only on `hello.c`, expanding all `#include` and `#define` directives, and writes the resulting expanded C source (still text, not compiled) to `hello.i`.

**37.** It would fail with a "no such file or directory" error, since `-S` (compile to assembly) requires `hello.i` to already exist — this command assumes the preprocessing stage (exercise 36) already ran.

**38.** The second `make` run detects that `hello` is already newer than `hello.c` (nothing changed), and prints something like `make: 'hello' is up to date.`, skipping the rebuild entirely — this is `make`'s core efficiency feature, based on file modification timestamps.

**39.** `-std=c23` (target the C23 standard), `-Wall` (common warnings), `-Wextra` (additional warnings), `-Wpedantic` (non-standard extension warnings), `-g` (debug symbols), `-O0` (no optimization).

**40.** `return 1;` signals to the operating system that the program terminated with an error/failure condition (any non-zero value conventionally means failure). A shell script could check this with `if [ $? -ne 0 ]; then echo "failed"; fi` immediately after running the program.

## Output Prediction Solutions

**41.**
```
Line one
Line two
```

**42.** `42`

**43.** It does not compile cleanly — GCC reports `warning: unused variable 'unused_variable' [-Wunused-variable]`, though the program still compiles and runs, printing `Hi`.

**44.**
```
Tab:	End
```
(a literal tab character appears between "Tab:" and "End", followed by a newline)

**45.** `make: *** No targets specified and no makefile found. Stop.`

## Mini Project Notes

**46.** A minimal version of `toolchain_check.sh`:
```bash
#!/usr/bin/env bash
for tool in gcc clang make gdb; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "$tool: $($tool --version | head -n1)"
    else
        echo "$tool: NOT FOUND"
    fi
done
```
Run with `bash toolchain_check.sh` after making it executable with `chmod +x toolchain_check.sh`.

**47.** A reusable template, parameterized by a `TARGET` variable:
```makefile
CC = gcc
TARGET = hello
CFLAGS = -Wall -Wextra -Wpedantic -std=c23

ifeq ($(DEBUG),1)
	CFLAGS += -g -O0
else
	CFLAGS += -O2
endif

build: $(TARGET).c
	$(CC) $(CFLAGS) $(TARGET).c -o $(TARGET)

run: build
	./$(TARGET)

clean:
	rm -f $(TARGET)
```
Running `make DEBUG=1` builds with `-g -O0`; running plain `make` builds with `-O2`. Only `TARGET` needs to change between chapters/exercises.

---

## Quiz Answer Key

1. **b)**
2. `a.out`
3. **c)**
4. **b)**
5. compilation (compilation proper / "compilation")
6. **c)**
7. **b)**
8. **a)**
9. **c)**
10. `#include`
11. **a)**
12. **b)**
13. **c)**
14. **c)**
15. C23
16. **b)**
17. **b)**
18. **a)**
19. **b)**
20. tab
21. **b)**
22. **c)**
23. **False** — `-g` adds debug metadata but does not meaningfully change runtime performance.
24. `7`
25. **c)**
26. **b)**
27. time (compilation time)
