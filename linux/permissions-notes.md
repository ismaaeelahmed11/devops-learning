# Permissions & Ownership Notes

## Creating and Running a Script
echo '#!/bin/bash\necho "Hello DevOps"' > hello.sh
chmod +x hello.sh
./hello.sh

Output: Hello DevOps

## Changing Ownership
sudo chown root:root hello.sh
ls -l hello.sh

Output: -rwxr-xr-x 1 root root 32 Nov 29 10:00 hello.sh

## Permission Breakdown
-rwxr-xr-x
- Owner: rwx (read, write, execute)
- Group: r-x (read, execute)
- Others: r-x (read, execute)

## Challenge: File Only I Can Read/Write, Others Read-Only
touch myfile.txt
chmod 644 myfile.txt
ls -l myfile.txt

Output: -rw-r--r--

Breakdown:
- Owner: rw- (read and write)
- Group: r-- (read only)
- Others: r-- (read only)

Command used: chmod 644 myfile.txt
