---
title: "05 — File I/O"
topic: "C Programming"
tags: [c, file-io, fopen, fread, fwrite, fseek]
updated: 2026-06-14
---

# 05 — File I/O

---

## The `FILE*` Abstraction

C wraps OS file handles in a `FILE` struct (defined in `<stdio.h>`). You always work through a `FILE*` pointer.

Three standard streams are available without opening anything:

| Stream | Description | Default |
|--------|-------------|---------|
| `stdin` | Standard input | keyboard |
| `stdout` | Standard output | terminal |
| `stderr` | Standard error | terminal (unbuffered) |

---

## Opening and Closing Files

```c
FILE *fp = fopen("data.txt", "r");
if (fp == NULL) {
    perror("fopen");    // prints: "fopen: No such file or directory"
    return 1;
}
// ... use fp ...
fclose(fp);
```

### Mode Strings

| Mode | Meaning | File must exist? | Truncates? |
|------|---------|-----------------|-----------|
| `"r"` | Read text | Yes | No |
| `"w"` | Write text | No (creates) | Yes |
| `"a"` | Append text | No (creates) | No |
| `"r+"` | Read + write text | Yes | No |
| `"w+"` | Read + write text | No (creates) | Yes |
| `"a+"` | Read + append text | No (creates) | No |
| `"rb"` / `"wb"` | Binary read / write | same as above | same |

> On POSIX systems (Linux), `"r"` and `"rb"` behave identically. The distinction matters on Windows (CRLF conversion).

---

## Text File Operations

### Character by Character

```c
int c;
while ((c = fgetc(fp)) != EOF) {
    putchar(c);
}
```

> Use `int`, not `char`, to hold `fgetc` output — `EOF` is -1 and wouldn't fit in `unsigned char`.

### Line by Line

```c
char buf[256];
while (fgets(buf, sizeof(buf), fp) != NULL) {
    // buf includes the newline '\n' at end (strip if needed)
    buf[strcspn(buf, "\n")] = '\0';   // trim newline
    printf("[%s]\n", buf);
}
```

> Never use `gets()` — removed in C11. Always use `fgets` with a size.

### Formatted Read/Write

```c
// Write
int id = 42;
float score = 98.5f;
fprintf(fp, "%d %.2f\n", id, score);

// Read back
fscanf(fp, "%d %f", &id, &score);
```

---

## Binary File Operations

Binary I/O reads/writes raw bytes — no text encoding, no newline translation.

```c
typedef struct {
    int  id;
    char name[64];
    float score;
} Record;

Record r = { 1, "Ryougi", 99.0f };

// Write binary
FILE *fp = fopen("records.bin", "wb");
fwrite(&r, sizeof(Record), 1, fp);    // 1 record
fclose(fp);

// Read binary
Record loaded;
fp = fopen("records.bin", "rb");
size_t n = fread(&loaded, sizeof(Record), 1, fp);
if (n != 1) { /* handle error */ }
fclose(fp);
printf("%s: %.1f\n", loaded.name, loaded.score);
```

### `fwrite` / `fread` Signatures

```c
size_t fwrite(const void *ptr, size_t size, size_t count, FILE *stream);
size_t fread (      void *ptr, size_t size, size_t count, FILE *stream);
// Returns: number of items successfully written/read (not bytes)
```

---

## Seeking and Telling

Move around within a file without closing and reopening:

```c
fseek(fp, 0, SEEK_SET);    // go to beginning
fseek(fp, 0, SEEK_END);    // go to end
fseek(fp, -10, SEEK_CUR);  // go back 10 bytes from current position

long pos = ftell(fp);      // get current position in bytes

rewind(fp);                // equivalent to fseek(fp, 0, SEEK_SET) + clears error flag
```

### Seek Constants

| Constant | Meaning |
|----------|---------|
| `SEEK_SET` | From the beginning |
| `SEEK_CUR` | From current position |
| `SEEK_END` | From the end |

### Getting File Size

```c
fseek(fp, 0, SEEK_END);
long size = ftell(fp);
rewind(fp);
// size now holds file size in bytes
```

---

## Error Handling

```c
FILE *fp = fopen("missing.txt", "r");
if (fp == NULL) {
    perror("fopen");       // prints error message to stderr
    // errno is set by fopen on failure
    return -1;
}

// During operations:
if (ferror(fp)) {
    fprintf(stderr, "Read error on file\n");
    clearerr(fp);
}

if (feof(fp)) {
    printf("Reached end of file\n");
}
```

### `fflush`

Force buffered data to be written to the OS:

```c
fprintf(fp, "important data\n");
fflush(fp);   // ensure it hits disk (or at least kernel buffer)
```

`fflush(NULL)` flushes all open output streams.

---

## Practical Patterns

### Read Entire File into Buffer

```c
char *read_file(const char *path, size_t *out_size) {
    FILE *fp = fopen(path, "rb");
    if (!fp) return NULL;

    fseek(fp, 0, SEEK_END);
    long size = ftell(fp);
    rewind(fp);

    char *buf = malloc(size + 1);
    if (!buf) { fclose(fp); return NULL; }

    fread(buf, 1, size, fp);
    buf[size] = '\0';

    fclose(fp);
    if (out_size) *out_size = (size_t)size;
    return buf;
}
```

### Copy File

```c
int copy_file(const char *src, const char *dst) {
    FILE *in  = fopen(src, "rb");
    FILE *out = fopen(dst, "wb");
    if (!in || !out) {
        if (in)  fclose(in);
        if (out) fclose(out);
        return -1;
    }

    char buf[4096];
    size_t n;
    while ((n = fread(buf, 1, sizeof(buf), in)) > 0) {
        if (fwrite(buf, 1, n, out) != n) {
            fclose(in); fclose(out);
            return -1;
        }
    }

    fclose(in);
    fclose(out);
    return 0;
}
```

### Count Lines in a File

```c
int count_lines(const char *path) {
    FILE *fp = fopen(path, "r");
    if (!fp) return -1;

    int lines = 0;
    int c;
    while ((c = fgetc(fp)) != EOF) {
        if (c == '\n') lines++;
    }
    fclose(fp);
    return lines;
}
```

---

## Random-Access Binary Records

```c
// Write 3 records
FILE *fp = fopen("db.bin", "w+b");
Record recs[3] = {
    {1, "Alice", 92.5f},
    {2, "Bob",   85.0f},
    {3, "Carol", 97.8f},
};
fwrite(recs, sizeof(Record), 3, fp);

// Update record #2 (0-indexed) in-place
Record update = {3, "Carlos", 98.0f};
fseek(fp, 2 * sizeof(Record), SEEK_SET);
fwrite(&update, sizeof(Record), 1, fp);

// Read record #1 back
Record r;
fseek(fp, 1 * sizeof(Record), SEEK_SET);
fread(&r, sizeof(Record), 1, fp);
printf("%s: %.1f\n", r.name, r.score);  // Bob: 85.0

fclose(fp);
```

---

## Temporary Files

```c
// tmpfile() creates a file deleted when closed or on program exit
FILE *tmp = tmpfile();
fprintf(tmp, "scratch data\n");
rewind(tmp);
// ... use tmp ...
fclose(tmp);   // deleted automatically
```

---

## Practice Problems

<details>
<summary>Problem 1: Write a program that counts word occurrences in a text file given as a command-line argument.</summary>

```c
#include <stdio.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    if (argc < 2) { fprintf(stderr, "Usage: %s <file>\n", argv[0]); return 1; }
    FILE *fp = fopen(argv[1], "r");
    if (!fp) { perror(argv[1]); return 1; }

    int words = 0, in_word = 0;
    int c;
    while ((c = fgetc(fp)) != EOF) {
        if (isspace(c)) in_word = 0;
        else if (!in_word) { in_word = 1; words++; }
    }
    fclose(fp);
    printf("Words: %d\n", words);
    return 0;
}
```
</details>

<details>
<summary>Problem 2: Why should you use `"rb"` instead of `"r"` when copying binary files on all platforms?</summary>

In text mode, the C runtime may translate newline characters:
- On Windows: `\n` is stored as `\r\n` (CRLF) on disk; reading in text mode converts `\r\n` → `\n`.
- On Linux: `\r\n` is left as-is in text mode.

If you open an image, executable, or any non-text file in text mode and it happens to contain the byte `0x0D 0x0A` (CRLF), that sequence will be corrupted or misread. Binary mode (`"rb"`, `"wb"`) bypasses all translation — bytes are passed as-is.
</details>

<details>
<summary>Problem 3: `fread` returns a value less than count. What are the possible reasons?</summary>

1. **EOF reached** — the file had fewer items remaining than requested. Check `feof(fp)`.
2. **Read error** — an I/O error occurred. Check `ferror(fp)` and `errno`.
3. **File shorter than expected** — common when reading records and the file is truncated.

Always check the return value of `fread` and `fwrite`. Never assume they succeeded.
</details>
