# File System Navigation Notes

## 5 Useful Commands I Discovered

### 1. ls -lah
Lists all files including hidden ones, with human-readable sizes and detailed info. The `-a` shows hidden files, `-l` gives permissions/owner/size, `-h` makes sizes readable (KB, MB).

### 2. find . -type f -size 1033c
Searches for files by exact size in bytes. The `c` suffix means bytes. Can also use `k` for kilobytes, `M` for megabytes. Add `-user` and `-group` to filter by owner.

### 3. mkdir -p projects/demo
Creates nested directories in one command. The `-p` flag creates parent directories if they don't exist — no need to create each level separately.

### 4. tail -f /var/log/auth.log
Watches a log file in real time as new lines are added. The `-f` means follow — essential for monitoring logs during debugging or deployments.

### 5. cat /etc/passwd
Displays all user accounts on the system. Each line shows username, UID, GID, home directory, and default shell. Useful for auditing who has access to a system.

## Navigation Practice
cd /var/log        ← go to system logs
ls -lah            ← see all log files with details
pwd                ← confirm current directory

## File Operations Practice
touch test.txt                  ← create empty file
mkdir -p projects/demo          ← create nested directories
cp test.txt projects/demo/      ← copy file into directory
mv projects/demo/test.txt projects/demo/backup.txt   ← rename/move
rm projects/demo/backup.txt     ← delete file

## File Viewing Practice
cat /etc/passwd                 ← print entire file
less /var/log/syslog            ← scroll through large file
head -n 20 /etc/services        ← view first 20 lines
tail -f /var/log/auth.log       ← watch file in real time
