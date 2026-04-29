## Bandit Level 1 → 2

### Challenge
The password for Level 2 is stored in a file named `-`. A file named with a single dash cannot be read the normal way because `-` is interpreted as a command flag.

### Solution
ssh bandit1@bandit.labs.overthewire.org -p 2220

Password: ZjLjTmM6FvvyRnrb2rfNWOZOTa6ip5If

#Once logged in:

ls
cat ./-

#Explanation
ls showed a single file called -

Attempted cat - first — it hung because - tells Linux to read from standard input instead of a file

cat ./- forces Linux to treat - as a file in the current directory (./), not as a flag

This printed the password for Level 2

Password Found
263JGJPfgU6LtdEvgfWU1XP5yac29mFx

Key Takeaway
Files with special characters in their names can cause unexpected behaviour. Prefixing with ./ forces the shell to interpret the argument as a file path rather than a command option. Tab completion also handles these edge cases
 automatically — a real time-saver in production environments.
