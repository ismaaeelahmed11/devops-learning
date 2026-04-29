## Bandit Level 3 → 4

### Challenge
The password for Level 4 is stored in a hidden file inside the `inhere` directory.

### Solution
```bash
ssh bandit3@bandit.labs.overthewire.org -p 2220
Password: MNk8KNH3Usiio41PRUEoDFPqfxLPlSmx

Once logged in:

ls
cd inhere
ls -a
cat ...Hiding-From-You

#Explanation
ls showed a directory called inhere

Changed into it with cd inhere

ls with no flags showed nothing — the directory appeared empty

ls -a revealed a hidden file called ...Hiding-From-You (files starting with . are hidden by default in Linux)

cat read the hidden file and printed the password

Password Found
2WmrDFRmJIq3IPxneAaMGhap0pFhF3NJ

Key Takeaway
Files beginning with a dot are hidden in Linux — they won't appear with a normal ls. The -a flag (all) shows everything, including hidden files.
This is used everywhere in Linux for configuration files like .bashrc, .ssh, and .gitconfig.
