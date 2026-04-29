## Bandit Level 5 → 6

### Challenge
The password for Level 6 is stored in a file somewhere under the `inhere` directory with these properties:
- Human-readable
- 1033 bytes in size
- Not executable

### Solution
```bash
ssh bandit5@bandit.labs.overthewire.org -p 2220
Password: 4oQYVPkxZOOEOO5pTW81FB8j8lxXGUQw

Once logged in:

ls
cd inhere
find . -type f -size 1033c ! -executable
cat ./maybehere07/.file2

#Explanation
find . searches current directory and all subdirectories

-type f limits results to regular files only

-size 1033c looks for files exactly 1033 bytes (c means bytes)

! -executable excludes files that have execute permissions

The search returned one matching file buried in a subdirectory

cat printed its contents — the password

Password Found
HWasnPhtq9AVKe0dmk45nxy20cvUa6EG

Key Takeaway
The find command is incredibly powerful for locating files by properties — size, type, permissions, modification date. You can chain multiple conditions together for precise results. 
This is a daily tool for system administrators and DevOps engineers
