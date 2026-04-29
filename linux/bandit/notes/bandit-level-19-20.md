## Bandit Level 19 → 20

### Challenge
The password for Level 20 is stored in `/etc/bandit_pass/bandit20`, readable only by user bandit20. However, there is a setuid binary in the home directory that runs commands as bandit20.

### Solution
ssh bandit19@bandit.labs.overthewire.org -p 2220
Password: cGWpMaKXVwDUNgPAVJbKyGUvHn9z13j8

Once logged in:
ls -la
./bandit20-do whoami
./bandit20-do cat /etc/bandit_pass/bandit20

### Explanation
- `ls -la` showed a file called `bandit20-do` with the `s` permission bit set in the owner field (`-rwsr-xr-x`)
- The `s` means setuid — the program runs as the file owner (bandit20), not as the user running it (bandit19)
- `./bandit20-do whoami` confirmed it runs as bandit20
- `./bandit20-do cat /etc/bandit_pass/bandit20` read the password file with bandit20's privileges

### Password Found
0qXahG8ZjOVMN9Ghs7iOWsCfZyXOUbYO

### Key Takeaway
The setuid bit (`s`) allows a program to run with the privileges of the file owner rather than the user executing it. This is how `sudo` works — it's a setuid binary owned by root. 
Understanding setuid is important for Linux security: misconfigured setuid binaries are a common privilege escalation vector.
