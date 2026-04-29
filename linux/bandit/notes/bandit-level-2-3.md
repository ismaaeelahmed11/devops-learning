## Bandit Level 2 → 3

### Challenge
The password for Level 3 is stored in a file called `spaces in this filename`. Spaces in filenames can confuse the shell if not handled correctly.

### Solution
```bash
ssh bandit2@bandit.labs.overthewire.org -p 2220

Password: 263JGJPfgU6LtdEvgfWU1XP5yac29mFx

#Once logged in:

ls
cat "spaces in this filename"
Explanation
ls showed a file with spaces in its name

First attempt cat spaces in this filename failed — the shell tried to read four separate files: spaces, in, this, and filename

Wrapping the filename in quotes tells the shell to treat it as a single argument

Also discovered tab completion automatically escapes spaces by pressing Tab after typing the first few letters

Password Found
MNk8KNH3Usiio41PRUEoDFPqfxLPlSmx

Key Takeaway
Spaces in filenames are common in real-world systems. Always quote filenames with spaces or use tab completion to handle them safely.
 This is especially important when writing scripts that process files — unquoted variables with spaces will break.
