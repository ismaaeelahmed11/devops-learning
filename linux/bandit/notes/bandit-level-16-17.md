## Bandit Level 16 → 17

### Challenge
The credentials for Level 17 are on a port in the range 31000-32000 on localhost. Only one port speaks SSL. Find it, connect, and submit the password.

### Solution
ssh bandit16@bandit.labs.overthewire.org -p 2220
Password: kSkvUpMQ7lBYyCM4GBPvCvT1BfWRy0Dx

Once logged in:
nmap -sV -p 31000-32000 localhost
openssl s_client -connect localhost:31790 -quiet
(Pasted the password and pressed Enter)

Saved the returned RSA private key locally:
nano bandit17.key
chmod 600 bandit17.key
ssh bandit17@bandit.labs.overthewire.org -p 2220 -i bandit17.key

### Explanation
- `nmap -sV -p 31000-32000 localhost` scanned the port range and identified which services were running
- One port showed SSL — 31790
- `openssl s_client -connect localhost:31790` connected to that SSL service
- Submitted the current password and received an RSA private key in response
- Saved the key to a file with `nano` and set permissions with `chmod 600` (owner read/write only)
- Used the key to SSH into Level 17 with `-i bandit17.key`

### Password Found
(Private key saved as bandit17.key)

### Key Takeaway
`nmap` is the industry standard for network discovery and port scanning. `-sV` probes services to identify what's actually running. SSL services can't be talked to with plain `nc` — you need `openssl s_client`. 
SSH private keys must have strict permissions (`600`) or SSH will refuse to use them. This mirrors real infrastructure where services run on various ports and you need to identify and securely connect to them.
