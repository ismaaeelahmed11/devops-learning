## Bandit Level 4 → 5

### Challenge
The password for Level 5 is stored in the only human-readable file inside the `inhere` directory. There are 10 files, but most contain binary data.

### Solution
```bash
ssh bandit4@bandit.labs.overthewire.org -p 2220
Password: 2WmrDFRmJIq3IPxneAaMGhap0pFhF3NJ

Once logged in:

ls
cd inhere
ls -la
file ./*
cat ./-file07

#Explanation
Entered the inhere directory

ls -la showed 10 files named -file00 through -file09

file ./* examined each file's type — most were data (binary), but -file07 showed ASCII text

cat ./-file07 printed the human-readable password

Used ./ prefix again because of the dash in the filename

Password Found
4oQYVPkxZOOEOO5pTW81FB8j8lxXGUQw

Key Takeaway
The file command identifies file types by examining content, not extensions. This is critical when dealing with unknown files — never assume a file is safe or readable based on its name alone.
Also reinforced handling dashed filenames with ./.
