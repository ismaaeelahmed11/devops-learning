## Bandit Level 7 → 8

### Challenge
The password for Level 8 is stored in a file called `data.txt` next to the word `millionth`.

### Solution
```bash
ssh bandit7@bandit.labs.overthewire.org -p 2220
Password: morbNTDkSW6jIlUc0ymOdMaLnOlFVAaj

Once logged in:

ls
grep "millionth" data.txt

#Explanation
ls showed a file called data.txt

The file was huge — too big to read line by line

grep "millionth" data.txt searched the file for the word millionth and printed the matching line

The line contained the password

Password Found
dfwvzFQi4mU0wfNbFOe9RoWskMLg7eEc

Key Takeaway
grep searches through text and returns lines matching a pattern. It's one of the most used commands in Linux — for log analysis, configuration parsing, and filtering output.
Piping output into grep will become second nature in DevOps work.
