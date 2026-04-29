## Bandit Level 0 → 1

### Challenge
The password for Level 1 is stored in a file called `readme` in the home directory. Locate and read it.

### Solution

ssh bandit0@bandit.labs.overthewire.org -p 2220
password bandit0

#Once logged in:
ls
cat readme

#Explanation

ls listed the contents of the home directory — found a single file named readme

cat readme printed the file's contents, revealing the password for Level 1

Password Found
ZjLjTmM6FvvyRnrb2rfNWOZOTa6ip5If

Key Takeaway
The fundamental Linux workflow: connect via SSH, explore with ls, read files with cat. These two commands are the foundation of navigating any Linux system.
