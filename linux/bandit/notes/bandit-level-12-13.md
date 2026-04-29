## Bandit Level 12 → 13

### Challenge
The password for Level 13 is stored in `data.txt`, which is a hexdump of a file that has been repeatedly compressed. It needs to be reversed through multiple layers of compression.

### Solution
ssh bandit12@bandit.labs.overthewire.org -p 2220
Password: 7x16WNeHIi5YkIhWsfFIqoognUTyj9Q4

Once logged in:
mkdir /tmp/mydir
cp data.txt /tmp/mydir/
cd /tmp/mydir
xxd -r data.txt > data
file data
mv data data.gz
gzip -d data.gz
file data
mv data data.bz2
bzip2 -d data.bz2
file data
mv data data.gz
gzip -d data.gz
file data
mv data data.tar
tar -xf data.tar
file data5.bin
mv data5.bin data5.tar
tar -xf data5.tar
file data6.bin
mv data6.bin data6.bz2
bzip2 -d data6.bz2
file data6
mv data6 data6.tar
tar -xf data6.tar
file data8.bin
mv data8.bin data8.gz
gzip -d data8.gz
file data8
cat data8

### Explanation
- `xxd -r` reversed the hexdump back into a binary file
- Used `file` repeatedly to check what type of compression each layer was (gzip, bzip2, tar)
- Renamed the file with the correct extension each time so the decompression tool could process it
- Had to work through 8 layers of compression to reach the original file
- `cat` finally read the password from the decompressed text file

### Password Found
FO5dwFsc0cbaIiH0h8J2eUks2vdTDwAn

### Key Takeaway
Always check a file's actual type with `file` — never trust extensions. The `xxd` command converts between hexdumps and binary. 
This level was a great lesson in patience and methodical problem-solving: identify the type, rename appropriately, decompress, repeat. Real-world data recovery often involves similar layered extraction.
