## Bandit Level 11 → 12

### Challenge
The password for Level 12 is stored in `data.txt`, where all lowercase and uppercase letters have been rotated by 13 positions (ROT13 cipher).

### Solution
ssh bandit11@bandit.labs.overthewire.org -p 2220
Password: dtR173fZKb0RRsDFSGsg2RWnpNVj3qRr

Once logged in:
ls
cat data.txt
cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m'

### Explanation
- `cat data.txt` showed garbled text — letters were shifted
- Recognised it as ROT13 (a Caesar cipher rotating letters by 13 places)
- `tr 'A-Za-z' 'N-ZA-Mn-za-m'` translates each letter 13 positions forward in the alphabet (A becomes N, B becomes O, etc.)
- ROT13 is its own inverse — applying it twice returns the original text

### Password Found
7x16WNeHIi5YkIhWsfFIqoognUTyj9Q4

### Key Takeaway
`tr` (translate) is used for character substitution — replacing or shifting characters in text. ROT13 is a simple cipher often used to obfuscate text online (comments, solutions, spoilers). 
Understanding character encoding and basic ciphers is useful for debugging and CTF challenges.
