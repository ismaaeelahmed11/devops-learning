#!/bin/bash

# File Permission Checker
# Checks if a file exists, then tests read/write/execute permissions
# Exits with error if file not found

echo "==File Checker=="
echo ""

read -p "Enter File Name to Check: " filename

if [ -e "$filename" ]; then
echo "File '$filename' exists "
else
echo "File '$filename' does not exist "
exit 1
fi

if [ -r "$filename" ]; then
echo "File '$filename' is readable"
else
echo "File '$filename' is not readable"
fi

if [ -w "$filename" ]; then
echo "File '$filename' is writable"
else
echo "File '$filename' is not writable"
fi

if [ -x "$filename" ]; then
echo "File '$filename' is executable"
else
echo "File '$filename' is not executable"
fi
