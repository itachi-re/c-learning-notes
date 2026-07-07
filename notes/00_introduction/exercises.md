# Chapter 00 — Exercises

This chapter has no code to write yet — that starts in Chapter 01. These exercises instead build the conceptual foundation and research habits you'll rely on for the rest of the course.

## Easy

1. In your own words (2–3 sentences), explain the difference between a compiled language and an interpreted language.
2. Name three pieces of software you use daily that are either written in C or built on top of a C-based runtime.
3. What does "fetch-decode-execute" mean? Describe each step in one sentence.

## Medium

4. Look up the original PDP-7 and PDP-11 computers that Thompson and Ritchie developed UNIX and C on. What were their memory sizes, compared to a modern smartphone? Write down the numbers.
5. Explain why rewriting the UNIX kernel in C (instead of assembly) in 1973 was considered a risky decision at the time.
6. List the four stages of the C compilation pipeline (preprocessing, compilation, assembly, linking) and, for each, describe in one sentence what transformation happens.

## Hard

7. Research one real difference between C89 and C99. Explain what problem the new C99 feature solved.
8. Explain, at a conceptual level, why a language without a garbage collector is well-suited to writing an operating system kernel, while a language with one might be less suited to that task.
9. Find and read the abstract (not the whole paper) of Dennis Ritchie's paper *"The Development of the C Language"* (1993). Summarize its main point in 3–4 sentences.

## Challenge

10. Pick any modern high-level language you've heard of (Python, JavaScript, Go, Rust). Research what language its *own* reference implementation or runtime is written in, and explain why that choice makes sense.

## Real-World

11. Find one open-source C project on GitHub with more than 1,000 stars (e.g., Redis, SQLite, Git, the Linux kernel itself). Skim its `README.md` and note: what problem does it solve, and roughly how large is its codebase (lines of code, if stated)?

## Debugging (Conceptual)

12. A friend tells you: "C must be a bad language, because my program crashed with no error message." Identify what's misleading about this framing, using what you've learned about undefined behavior and compiler warnings in this chapter.

## Refactoring (Conceptual)

13. Rewrite this sentence to be more precise: *"The compiler turns your code into a program."* Use the correct four-stage terminology from this chapter.

## Memory Tracing (Conceptual)

14. Without writing any code, describe in your own words what you'd expect to find in the **stack** versus the **heap** of a running program, based on the diagram in this chapter's README.

---

Answers and discussion for all exercises are in `solutions.md`.
