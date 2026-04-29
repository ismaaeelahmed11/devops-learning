# Linux Module

This module covers the fundamentals of Linux — the foundation of my DevOps learning journey. It includes system navigation, file management, permissions, text processing, process management, and hands-on problem-solving through 
the OverTheWire Bandit wargame.

---

## What I Learned

### File System & Navigation
- Navigating directories with cd, ls, pwd
- Creating, copying, moving, and deleting files and directories
- Understanding hidden files and special characters in filenames

### Permissions & Ownership
- Reading and modifying permissions with chmod
- Understanding the setuid bit and privilege escalation
- Managing SSH keys with proper permissions (chmod 600)

### Text Processing
- Searching with grep and regular expressions
- Sorting and filtering with sort and uniq
- Character translation with tr
- Extracting readable text from binary files with strings
- Encoding and decoding with base64
- Comparing files with diff

### Networking & Security
- SSH for remote connections and command execution
- Port scanning with nmap
- SSL/TLS connections with openssl s_client
- Netcat (nc) for TCP connections and listeners
- Background processes and job control

### File Analysis
- Identifying file types with file
- Working with hexdumps using xxd
- Decompressing multiple archive formats (gzip, bzip2, tar)

---

## Bandit Wargame (Levels 0–20)

Completed 20 levels of the OverTheWire Bandit challenge, progressively building Linux command-line skills. Each level required finding a hidden password using different techniques.

- Solutions documented: bandit/notes/
- Screenshots: bandit/screenshots/

### Key Levels
| Level | Skill Demonstrated |
|-------|-------------------|
| 0–4 | Basic navigation, hidden files, special filenames |
| 5–7 | find with size, user, and group filters |
| 8–10 | grep, sort, uniq, strings, base64 |
| 11–12 | tr for ROT13, hexdumps and layered decompression |
| 13–15 | SSH keys, nc networking, SSL/TLS with openssl |
| 16–17 | nmap port scanning, SSL service identification |
| 18–20 | SSH command injection, setuid binaries, client-server with nc |

---

## Files in This Module
- README.md — This file
- file-system-notes.md — Navigation and file operation notes
- permissions-notes.md — Permissions and ownership notes
- process-management-notes.md — Process monitoring and management notes
- text-processing-notes.md — grep, awk, sed, and piping notes
- bandit/ — Bandit wargame solutions and screenshots

---

## Why Linux Matters in DevOps
Linux runs the vast majority of production servers, cloud infrastructure, and containers. Every tool in the DevOps ecosystem — Docker, Kubernetes, CI/CD pipelines, configuration management — is built on Linux. 
Mastering the command line is non-negotiable.
