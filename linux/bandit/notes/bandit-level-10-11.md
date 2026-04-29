## Bandit Level 10 → 11

### Challenge
The password for Level 11 is stored in `data.txt`, which contains base64 encoded data.

### Solution
ssh bandit10@bandit.labs.overthewire.org -p 2220
Password: FGUW5ilLVJrxX9kMYMmlN4Mgbpfmiqey

Once logged in:
ls
cat data.txt
base64 -d data.txt

### Explanation
- `cat data.txt` showed a string of seemingly random characters — it was base64 encoded
- `base64 -d data.txt` decoded the file and printed the original content
- The decoded output contained the password

### Password Found
dtR173fZKb0RRsDFSGsg2RWnpNVj3qRr

### Key Takeaway
Base64 is an encoding scheme, not encryption — it can be reversed easily with `base64 -d`. It's commonly used to transmit binary data as text (email attachments, API tokens, Kubernetes secrets).
Knowing how to spot and decode it is a useful skill.
