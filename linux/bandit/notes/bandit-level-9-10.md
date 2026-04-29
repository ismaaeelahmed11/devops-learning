## Bandit Level 9 → 10

### Challenge
The password for Level 10 is stored in `data.txt` as one of the few human-readable strings, preceded by several `=` characters.

### Solution
ssh bandit9@bandit.labs.overthewire.org -p 2220
Password: 4CKMh1JI91bUIZZPXDqGanal4xvAg0JM

Once logged in:
ls
strings data.txt | grep "==="

### Explanation
- `ls` showed `data.txt` — mostly binary data, not readable with `cat`
- `strings data.txt` extracted all human-readable text from the binary file
- `|` piped the readable strings into `grep "==="` to find lines containing multiple equals signs
- One of the results was the password

### Password Found
FGUW5ilLVJrxX9kMYMmlN4Mgbpfmiqey

### Key Takeaway
`strings` extracts readable text from binary files — essential for analysing compiled programs, logs mixed with binary, or unknown file formats.
Combined with `grep`, you can pinpoint specific patterns buried in otherwise unreadable data.
