# Bash Scripting Module

This module covers automation fundamentals using Bash scripting. I learned how to write scripts using variables, conditional statements, user input, and file operations. Below are the 4 core challenges I completed, what I learned, and a challenge I overcame along the way.

---

## Scripts

### 1. Arithmetic Calculator
A script that takes two numbers from the user and performs addition, subtraction, multiplication, and division. Includes a check to prevent division by zero so the script doesn't crash.

### 2. File Operations Script
Automates the process of creating a directory, navigating into it, creating a file, writing a message with the current date into the file, and displaying the contents. Saves time compared to running each command manually.

### 3. File Permission Checker
Prompts the user for a filename, checks if the file exists, and if so tests whether it's readable, writable, and executable. Displays clear results for each permission. If the file doesn't exist, the script exits with an error instead of continuing.

### 4. Backup Script for Text Files
Backs up all .txt files from a user-specified directory into a timestamped backup folder. The timestamp means old backups are never overwritten. Counts how many files were backed up and displays the result. Handles missing directories and empty folders gracefully.

---

## Key Learnings

- `#!/bin/bash` (shebang) tells the system which interpreter to use
- Variables store values and are accessed with `$`
- `read -p` captures user input with a prompt in one line
- `if / else / fi` handles conditional logic
- `$(( ))` performs arithmetic operations
- `-e`, `-r`, `-w`, `-x`, `-d` test file properties and permissions
- `$(command)` captures the output of a command to use elsewhere
- `2>/dev/null` suppresses error messages so output stays clean
- Timestamps with `date` create unique folder names for backups

---

## Challenge I Overcame

I got tripped up by quoting in Bash. I had this line:

`cp "$source_dir/*.txt" "$backup_dir/"`

It didn't work because the `*` wildcard was inside the quotes — Bash treated `*.txt` as a literal filename instead of expanding it to match all text files.
The fix was simple once I understood it: quote the variable, leave the wildcard outside.

`cp "$source_dir"/*.txt "$backup_dir"/`

Small mistake, but now I won't forget how quoting and globbing work together.

---

## Why Bash Matters in DevOps

Bash is the glue that holds infrastructure together. CI/CD pipelines, server provisioning, log rotation, automated backups — all of it runs on Bash scripts. 
It's how you talk to servers, automate repetitive tasks, and orchestrate other tools like Docker and Kubernetes. Mastering Bash means you can automate almost anything.
