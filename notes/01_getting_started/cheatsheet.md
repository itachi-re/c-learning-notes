# cheatsheet.md

## Installing the toolchain

| Distro | Command |
|---|---|
| Debian/Ubuntu | `sudo apt install build-essential clang make gdb valgrind` |
| Fedora | `sudo dnf install gcc clang make gdb valgrind` |
| Arch | `sudo pacman -S base-devel clang` |
| openSUSE | `sudo zypper install -t pattern devel_C_C++` |

Verify: `gcc --version`, `clang --version`

## The essential compile command

```bash
gcc -std=c23 -Wall -Wextra -Wpedantic -g -O0 hello.c -o hello
```

## Running and checking exit status

```bash
./hello
echo $?
```

## The four compilation stages

| Flag | Stops after | Output file convention |
|---|---|---|
| `-E` | Preprocessing | `.i` |
| `-S` | Compilation (to assembly) | `.s` |
| `-c` | Assembly (to object file) | `.o` |
| *(none)* | Linking (complete executable) | no extension |

```bash
gcc -E hello.c -o hello.i    # preprocess only
gcc -S hello.i -o hello.s    # compile to assembly
gcc -c hello.s -o hello.o    # assemble to object file
gcc hello.o -o hello         # link to executable
```

## Flags reference

| Flag | Meaning |
|---|---|
| `-o <name>` | Name the output executable |
| `-Wall` | Enable common useful warnings |
| `-Wextra` | Enable additional warnings beyond `-Wall` |
| `-Wpedantic` | Warn on non-standard extensions |
| `-g` | Include debug symbols for `gdb` |
| `-O0` | No optimization (debugging) |
| `-O2` | Standard optimization (release builds) |
| `-O3` | Aggressive optimization (measure before using) |
| `-std=c23` | Compile against the C23 standard explicitly |

## Minimal Makefile

```makefile
CC = gcc
CFLAGS = -std=c23 -Wall -Wextra -Wpedantic -g -O0

hello: hello.c
	$(CC) $(CFLAGS) hello.c -o hello

clean:
	rm -f hello
```

> Indentation before commands must be a literal **tab**, not spaces.

```bash
make          # builds using the first target
make clean    # removes build output
```

## Quick diagnosis table

| Symptom | Likely cause |
|---|---|
| `command not found` running `hello` | Missing `./` prefix |
| `expected ';' before '}'` | Missing semicolon on the line above |
| `implicit declaration of function 'printf'` | Missing `#include <stdio.h>` |
| `missing separator. Stop.` | Spaces instead of a tab in Makefile |
| `Permission denied` running `./hello` | File isn't marked executable |
