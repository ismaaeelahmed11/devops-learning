## Bandit Level 15 → 16

### Challenge
The password for Level 16 can be retrieved by submitting the current password to port 30001 on localhost using SSL/TLS encryption.

### Solution
ssh bandit15@bandit.labs.overthewire.org -p 2220
Password: 8xCjnmgoKbGLhHFAZlGE5Tmu4M2tKJQo

Once logged in:
cat /etc/bandit_pass/bandit15
openssl s_client -connect localhost:30001 -quiet
(Pasted the password and pressed Enter)

### Explanation
- Read the current password from `/etc/bandit_pass/bandit15`
- `openssl s_client` connects to an SSL/TLS service, similar to how HTTPS works
- `-connect localhost:30001` specifies the host and port
- `-quiet` reduces the verbose SSL handshake output
- Pasted the password and the server returned the Level 16 credentials
- Unlike Level 14, `nc` would not work here because the service expects an encrypted connection

### Password Found
kSkvUpMQ7lBYyCM4GBPvCvT1BfWRy0Dx

### Key Takeaway
SSL/TLS encrypts network traffic — `nc` handles plain text, `openssl s_client` handles encrypted connections. This is the foundation of HTTPS, secure APIs, and encrypted database connections. 
Understanding the difference between encrypted and unencrypted protocols is essential for security-conscious DevOps.
