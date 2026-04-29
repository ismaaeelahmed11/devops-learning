## Bandit Level 8 → 9

### Challenge
The password for Level 9 is stored in `data.txt` and is the only line that occurs only once.

### Solution
ssh bandit8@bandit.labs.overthewire.org -p 2220
Password: dfwvzFQi4mU0wfNbFOe9RoWskMLg7eEc

Once logged in:
ls
sort data.txt | uniq -u

### Explanation
- `ls` showed `data.txt` — a file with many lines, most repeated
- `sort data.txt` sorted all lines alphabetically so identical lines are grouped together
- `|` piped the sorted output into `uniq -u`
- `uniq -u` prints only lines that appear exactly once
- The single unique line was the password

### Password Found
4CKMh1JI91bUIZZPXDqGanal4xvAg0JM

### Key Takeaway
`sort` and `uniq` are a powerful combination for text processing. `sort` orders lines so duplicates are adjacent, then `uniq -u` filters out anything that appears more than once. Piping commands together with `|` is the heart of Linux — small tools combined for powerful results.
