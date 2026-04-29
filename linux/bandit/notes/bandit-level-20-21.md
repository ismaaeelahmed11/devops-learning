## Bandit Level 20 → 21

### Challenge
A setuid binary called `suconnect` connects to a specified port on localhost. If it receives the correct Level 20 password, it returns the Level 21 password.

### Solution
ssh bandit20@bandit.labs.overthewire.org -p 2220
Password: 0qXahG8ZjOVMN9Ghs7iOWsCfZyXOUbYO

Once logged in:
ls -la
cat /etc/bandit_pass/bandit20
echo "0qXahG8ZjOVMN9Ghs7iOWsCfZyXOUbYO" | nc -l -p 4444 &
./suconnect 4444

### Explanation
- `ls -la` showed the `suconnect` binary with setuid permissions
- Read the current password from `/etc/bandit_pass/bandit20`
- Set up a `nc` listener on port 4444 that sends the password when someone connects
- `&` ran the listener in the background so I could continue using the terminal
- `./suconnect 4444` connected to my listener, received the password, verified it, and printed the Level 21 password

### Password Found
EeoULMCra2q0dSkYj561DX7s1CpBuOBt

### Key Takeaway
This level combined several skills: setuid binaries, netcat listeners, background processes with `&`, and inter-process communication over localhost. 
It simulated a basic client-server authentication model — a listener waits, a client connects and sends credentials, the server responds. This pattern is fundamental to network services and API design.
