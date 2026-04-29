## Bandit Level 13 → 14

### Challenge
The password for Level 14 is stored in `/etc/bandit_pass/bandit14` and can only be read by user bandit14. Instead of a password, an SSH private key is provided to log into Level 14.

### Solution
ssh bandit13@bandit.labs.overthewire.org -p 2220
Password: FO5dwFsc0cbaIiH0h8J2eUks2vdTDwAn

Once logged in:
ls
ssh -i sshkey.private bandit14@localhost -p 2220
cat /etc/bandit_pass/bandit14

### Explanation
- `ls` showed a file called `sshkey.private`
- Used `ssh -i sshkey.private` to authenticate with the private key instead of a password
- Connected to `bandit14@localhost` — same server, different user
- Once logged in as bandit14, read the password file directly with `cat`

### Password Found
MU4VWeTyJk8ROof1qqmcBPaLh7lDCPvS

### Key Takeaway
SSH keys provide passwordless authentication — more secure and convenient than typing passwords. The `-i` flag specifies which private key to use. 
Also learned that `/etc/bandit_pass/` stores each level's password, readable only by that level's user. SSH key management is a core DevOps skill for server access and CI/CD pipelines.
