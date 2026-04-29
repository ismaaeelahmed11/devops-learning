## Bandit Level 18 → 19

### Challenge
The password for Level 19 is stored in a `readme` file in the home directory. However, attempting to log in normally results in being instantly kicked out because `.bashrc` has been modified to log you out immediately.

### Solution
ssh bandit18@bandit.labs.overthewire.org -p 2220 "cat readme"
Password: x2gLTTjFwMOhQ8oWNbMN362QKxfRqGlO

### Explanation
- A normal SSH login immediately showed "Byebye!" and closed the connection
- The `.bashrc` file had been set up to terminate the session on login
- Bypassed this by telling SSH to run a command directly instead of spawning an interactive shell
- `ssh user@host "command"` executes the command and returns the output without loading `.bashrc`
- `cat readme` printed the password, then the connection closed

### Password Found
cGWpMaKXVwDUNgPAVJbKyGUvHn9z13j8

### Key Takeaway
SSH can execute single commands remotely without opening an interactive shell. This bypasses login scripts like `.bashrc` or `.profile`. 
It's a useful trick for troubleshooting systems where the shell has been misconfigured, and it's also how automation tools run commands on remote servers.
