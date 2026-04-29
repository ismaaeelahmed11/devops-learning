## Bandit Level 17 → 18

### Challenge
The password for Level 18 is in `passwords.new` and is the only line that differs between `passwords.old` and `passwords.new`.

### Solution
ssh bandit17@bandit.labs.overthewire.org -p 2220 -i bandit17.key

Once logged in:
ls
diff passwords.old passwords.new

### Explanation
- `ls` showed two files: `passwords.old` and `passwords.new`
- `diff passwords.old passwords.new` compared both files line by line
- The output showed one line that was different — the line from `passwords.new` (marked with `>`) was the password

### Password Found
x2gLTTjFwMOhQ8oWNbMN362QKxfRqGlO

### Key Takeaway
`diff` compares two files and shows the differences between them. It's used constantly in DevOps — comparing config files before and after changes, checking what a deployment will modify, reviewing code diffs in Git. 
Simple but essential.
