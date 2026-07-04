<!--
Thanks for contributing to c-learning-notes! Please fill this out completely —
incomplete PRs will be asked for more detail before review.
-->

## Summary

<!-- What does this PR add, fix, or change? One or two sentences. -->

## Type of change

- [ ] New chapter (`notes/`)
- [ ] New example program (`examples/`)
- [ ] New exercise or solution (`exercises/` / `solutions/`)
- [ ] New project (`projects/`)
- [ ] New cheatsheet, reference, or diagram
- [ ] Bug fix (broken code, wrong output, UB)
- [ ] Documentation fix (typo, clarity, broken link)
- [ ] CI / tooling change

## Related issue

<!-- Closes #123, or "N/A" if this wasn't filed as an issue first. -->

## Checklist

### If this PR adds or changes C code

- [ ] Compiles cleanly with `-Wall -Wextra -Werror`
- [ ] Tested with `-fsanitize=address,undefined` and shows no errors (or the
      errors are intentional and clearly labeled as a teaching example of UB)
- [ ] Formatted with `clang-format` using the repo's `.clang-format`
- [ ] Follows `docs/STYLE_GUIDE.md` naming and commenting conventions
- [ ] Demonstrates exactly one concept (per the "one concept per file" rule)
- [ ] Includes a comment header explaining what the example teaches

### If this PR adds a new chapter

- [ ] Follows the standard chapter template (`README.md`, `examples/`,
      `exercises.md`, `common_mistakes.md`, `best_practices.md`, `quiz.md`,
      `challenge.md`, `solutions/`)
- [ ] Added to the chapter index in the main `README.md`
- [ ] Added to `docs/ROADMAP.md` if it was a planned item

### General

- [ ] I ran markdownlint / spellcheck locally, or am fine with CI catching issues
- [ ] I did not introduce new external dependencies without discussing them first
- [ ] Commit messages are clear and scoped (no "misc fixes" catch-alls)

## Additional notes

<!-- Anything reviewers should know: open questions, alternatives you considered, etc. -->
