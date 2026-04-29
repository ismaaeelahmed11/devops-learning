# Text Processing Notes

## grep Examples
grep "error" /var/log/syslog
grep -r "TODO" ~/projects/
grep -i "failed" /var/log/auth.log | wc -l

grep searches for patterns. -r searches recursively, -i ignores case, wc -l counts lines.

## awk Examples
ps aux | awk '{print $1, $11}'
cat /etc/passwd | awk -F: '{print $1, $6}'

awk processes columns of text. -F: sets the delimiter to colon. First example prints username and command, second prints username and home directory.

## sed Examples
sed 's/old/new/g' file.txt
sed -n '10,20p' file.txt

sed edits text streams. s/old/new/g replaces all occurrences. -n '10,20p' prints only lines 10 to 20.

## Piping Chains
cat /var/log/syslog | grep "error" | awk '{print $1, $2, $3}' | sort | uniq

Chains small tools together: read file → filter errors → extract date fields → sort → remove duplicates.

## Challenge: List All Users with /bin/bash Shell
grep "/bin/bash" /etc/passwd | awk -F: '{print $1}'

Explanation:
- grep "/bin/bash" /etc/passwd filters lines containing /bin/bash
- | pipes results into awk
- awk -F: '{print $1}' splits each line by colon and prints the first field (username)
- This lists every user on the system that has bash as their default shell
