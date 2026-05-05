---
name: git-commit
description: Draft thoughtful Git commit messages that follow Chris Beams's "How to Write a Git Commit Message" guidance, and use this skill whenever the user asks to create a commit, prepare a commit message, stage-and-commit work, or clean up commit history. Always show the proposed message to the user for review before committing, prefer opening the draft in the editor, and never run `git commit` until the user explicitly approves it.
---

# Git Commit

Use this skill when the user wants help turning local changes into a Git commit.

## Goals

- Produce a commit message that follows the rules described in Chris Beams's article as documented in the "Git Commit Message Guide" section below
- Make the review step visible and easy for the user.

## Required workflow

1. Inspect the repo state before drafting anything.
2. Review the staged diff first. If nothing is staged, review the working tree
3. Summarize the change in plain language for yourself before writing the commit message.
4. Draft the commit message with:
   - a subject line,
   - an body,
5. Write the draft to `.git/CODEX_COMMIT_EDITMSG` and show the proposed message in a `gitcommit` block.
6. Ask for review and wait. The user may suggest edits or edit the file directly.

## Draft file workflow

1. Write the proposed message to `.git/CODEX_COMMIT_EDITMSG`.
2. Show the message in chat and point the user to the file path.
3. Tell the user exactly which file contains the draft.


## Review message workflow

After writing the draft file, print out the message to the user and point them to the file for review.

`I drafted the commit message in .git/CODEX_COMMIT_EDITMSG. It is as follows.`


# Git Commit Message Guide

Based on [Chris Beams' seven rules](https://cbea.ms/git-commit/) for writing great commit messages.

---

## The Seven Rules

### 1. Separate subject from body with a blank line

```
Short summary (50 chars max)

Detailed explanation wrapped at 72 characters per line.
Explains why this change was needed and provides context.
```

### 2. Limit subject line to 50 characters

Forces clarity and conciseness. GitHub truncates at 72 characters.

### 3. Capitalize the subject line

- ❌ `add user validation`
- ✅ `Add user validation`

### 4. Do not end subject line with a period

Subject lines are titles, not sentences.

### 5. Use imperative mood in subject line and body

**Test**: "If applied, this commit will _____"

- ❌ `Fixed bug`, `Fixes bug`, `Fixing bug`
- ✅ `Fix bug`

**Common imperative verbs**:
- Add, Remove, Fix, Refactor, Update, Implement, Optimize, Document, Test, Revert, Merge

### 6. Wrap body at 72 characters

Git doesn't auto-wrap text. Hard-wrap for readability in `git log`.

### 7. Explain *what* and *why*, not *how*

**Include**:
- What changed (high-level summary)
- Why this change was necessary
- Context or background
- Trade-offs or side effects

**Exclude**:
- Line-by-line code explanations (visible in diff)
- Implementation details

---

## Subject Line Guidelines

### Strong Imperative Verbs

**New functionality**:
- `Add` - New feature, file, or capability
- `Implement` - Complete feature implementation

**Modifications**:
- `Update` - Modify existing feature (not a fix)
- `Refactor` - Restructure without behavior change
- `Optimize` - Performance improvement

**Fixes**:
- `Fix` - Bug fix
- `Revert` - Undo previous commit

**Non-code**:
- `Document` - Documentation only
- `Test` - Add or modify tests

### Examples

```
Add user authentication middleware
Fix token expiration race condition
Refactor database connection pooling
Update API error handling
Optimize image loading performance
Document deployment process
Test authentication flow
```

---

## Body Structure

## Anti-Patterns

### ❌ Vague Messages
```
Update code
Fix stuff
Changes
WIP
```

### ❌ Over-detailed (visible in diff)
```
Change variable userAuthenticationToken to userToken on
line 45 of auth.js and update function call on line 67
```

### ❌ Explaining HOW instead of WHY
```
Add if statement to check token expiry before processing
request and return 401 if expired
```

---

## Quick Checklist

Before dispatching the commit, ensure:

- [ ] Subject completes "If applied, this commit will..."
- [ ] Subject ≤50 characters
- [ ] Subject capitalized, no period
- [ ] Imperative mood
- [ ] Body explains WHY, not HOW
- [ ] Message useful 6 months from now

## Guidelines

### Technology References

Use proper casing for technologies:
- ✅ Next.js, NextAuth.js, Prisma, SQLite, PostgreSQL
- ✅ TypeScript, JavaScript, Tailwind CSS
- ✅ Latvian (lv), English (en)

### File Path References

When mentioning file paths, use backticks:
- ✅ Changes `lib/prisma.ts` configuration
- ✅ Updates `messages/lv.json` with new translations

## Common Mistakes to Avoid and FORBIDDEN Content

❌ **Vague messages**:
- "update code"
- "fix stuff"
- "changes"
- "wip"

❌ **Too much detail in subject**:
- "feat: add user profile page with edit functionality and validation and error handling and loading states and success messages"


❌ **Non-working commits**:
- Code that doesn't compile
- Tests that fail
- Runtime errors

❌ **AI attribution** (CRITICAL):
- Don't mention AI tools anywhere in commit message
- Don't add Co-Authored-By tags for AI
- Commits should appear as regular developer work

❌ **Past tense**:
- "added feature" → Use "add feature"
- "fixed bug" → Use "fix bug"

❌ **Periods in subject**:
- "feat: add feature." → Use "feat: add feature"

## Guardrails

- Never invent details that are not supported by the diff or user context.
- Do not write the body as a second imperative headline or a list of command-like fragments.
- If the diff is too large or unclear to summarize responsibly, pause and inspect more before writing.
- Never use emojis in commit messages.

## References

- [How to Write a Git Commit Message](https://chris.beams.io/posts/git-commit/)

## Remember

1. **NEVER mention AI in commits** - This is the most critical rule
2. Commits should tell a story of project evolution
3. Future developers will read these commits
4. Clear commits make debugging easier
5. Good commits are documentation

Every commit message should answer: **What changed and why?**

## Example Commits

See [commit-examples.md](./references/commit-examples.md) for detailed examples on good commit messages that should be used as reference.
