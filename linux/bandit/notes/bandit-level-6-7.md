## Bandit Level 6 → 7

### Challenge
The password for Level 7 is stored somewhere on the server with these properties:
- Owned by user `bandit7`
- Owned by group `bandit6`
- 33 bytes in size

### Solution
```bash
ssh bandit6@bandit.labs.overthewire.org -p 2220
Password: HWasnPhtq9AVKe0dmk45nxy20cvUa6EG

Once logged in:

find / -user bandit7 -group bandit6 -size 33c 2>/dev/null
cat /var/lib/dpkg/info/bandit7.password

#Explanation
Searched the entire filesystem starting from root /

-user bandit7 filters files owned by user bandit7

-group bandit6 filters files owned by group bandit6

-size 33c filters files exactly 33 bytes

2>/dev/null suppresses permission denied errors so the output is clean

Found the password file in an unusual location and read it

Password Found
morbNTDkSW6jIlUc0ymOdMaLnOlFVAaj

Key Takeaway
You can search the entire filesystem with find /. The 2>/dev/null trick is essential for cleaning up error messages — it redirects stderr to nowhere. 
Searching by owner and group is useful for security audits and tracking down misconfigured files.
