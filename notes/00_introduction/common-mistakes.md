# Chapter 00 — Common Mistakes

These aren't coding mistakes yet (there's no code in this chapter) — they're conceptual misconceptions that shape how beginners approach the rest of this course. Catching them now saves frustration later.

## 1. "C is obsolete; modern languages made it irrelevant."

**Why this happens:** C is over 50 years old, and most beginners' first exposure to programming is through Python, JavaScript, or a mobile app framework — languages that hide memory management and low-level detail entirely. It's natural to assume older means outdated.

**Why it's wrong:** The C standard is still actively maintained (C23 was finalized in 2024). More importantly, the software those "modern" languages themselves run on — operating system kernels, language runtimes, embedded firmware — is written in C. "Foundational" is a more accurate word than "outdated."

**How to avoid it:** Reframe C not as a competitor to Python or JavaScript, but as the layer underneath them. You're not learning a replacement for the tools you already know — you're learning what those tools are quietly doing for you.

## 2. "I should skip straight to the fun/advanced stuff — pointers, projects, algorithms."

**Why this happens:** Chapters like "Data Structures" or "Mini Projects" sound more exciting than "Variables and Types" or "Operators." Beginners often assume the early chapters are filler.

**Why it's wrong:** Nearly every advanced C concept — pointers, structs, dynamic memory — is built directly on the fundamentals of variables, memory, and control flow. Skipping ahead means constantly backtracking to understand terminology and behavior that the earlier chapters would have already explained.

**How to avoid it:** Follow the roadmap in order, at least for your first pass through the material. You can always return to specific chapters later as a reference once you have the full picture.

## 3. "A crash means the language is broken or unreliable."

**Why this happens:** Higher-level languages typically raise a clear, readable exception when something goes wrong (`IndexError`, `NullPointerException`, etc.). Beginners expect the same experience from C.

**Why it's wrong:** C does not perform automatic bounds-checking or null-checking at runtime by default. When something goes wrong — reading past the end of an array, dereferencing an invalid pointer — the result is **undefined behavior**, which can range from an immediate crash, to a delayed crash somewhere unrelated, to silently wrong output with no crash at all. This isn't a flaw in the language; it's a direct consequence of C prioritizing performance and giving you direct memory control (Chapter 26 covers this exhaustively).

**How to avoid it:** From Chapter 01 onward, always compile with `-Wall -Wextra`, and later, `-fsanitize=address,undefined`. These tools surface exactly the kind of mistakes that would otherwise cause silent or delayed failures.

## 4. "I need to memorize the entire standard library before I can write real programs."

**Why this happens:** C reference material (like cppreference) can look intimidatingly exhaustive, listing dozens of functions with precise, formal-sounding descriptions.

**Why it's wrong:** Professional C programmers regularly look up function signatures and behavior — nobody has the standard library memorized. What matters is understanding the *concepts* (how strings work, how memory allocation works, how file I/O works) well enough to know what to look for and to correctly interpret documentation when you do.

**How to avoid it:** Treat `cheatsheet.md` files and reference documentation as tools you'll return to repeatedly, not lists to memorize up front.

## 5. Confusing "I understand the explanation" with "I could reproduce this from scratch."

**Why this happens:** Reading a clear explanation of the compilation pipeline, or the fetch-decode-execute cycle, feels like understanding. Recognition is easier than recall.

**Why it's wrong:** Being able to follow an explanation is a much lower bar than being able to explain it yourself, unaided, or apply it to a new example. Programming skill is built through active recall and application, not passive reading.

**How to avoid it:** Actually do the exercises and quiz in this chapter without looking back at the README first. Struggling to recall something and then checking is far more effective for retention than re-reading until it feels familiar.
