## Bandit Level 14 → 15

### Challenge
The password for Level 15 can be retrieved by submitting the current password to port 30000 on localhost.

### Solution
ssh bandit14@bandit.labs.overthewire.org -p 2220
Password: MU4VWeTyJk8ROof1qqmcBPaLh7lDCPvS

Once logged in:
cat /etc/bandit_pass/bandit14
nc localhost 30000
(Pasted the password and pressed Enter)

### Explanation
- Read the current level's password from `/etc/bandit_pass/bandit14`
- Used `nc` (netcat) to connect to port 30000 on localhost
- Pasted the password and hit Enter
- The service verified it and returned the Level 15 password

### Password Found
8xCjnmgoKbGLhHFAZlGE5Tmu4M2tKJQo

### Key Takeaway
`nc` (netcat) is a versatile networking tool — it can connect to any port, send data, and read responses. This is a simple API interaction: send credentials, receive a response. 
The same concept applies to HTTP APIs, database connections, and microservice communication.
