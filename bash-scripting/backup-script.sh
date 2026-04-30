#!/bin/bash

# Backup Script for Text Files
# Copies all .txt files from a source directory to a timestamped backup folder
# Displays count of files backed up

# Display title
echo "===Backup script for Text Files==="
echo ""

# Prompt user for source directory
read -p "Enter source directory:" source_dir

# Check if source directory exists
if [ ! -d "$source_dir" ]; then
echo "ERROR: Directory '$source_dir' does not exist"
exit 1
fi

echo ""
# Create timestamped backup directory
backup_dir="backup_$(date +%Y-%m-%d_%H-%M)"
mkdir -p "$backup_dir"
echo "Backup Directory Created: $backup_dir"
echo ""

# Copy all .txt files to backup directory
echo "Copying .txt files..."
cp "$source_dir"/*.txt "$backup_dir"/ 2>/dev/null

# Count backed up files
count=$(ls "$backup_dir"/*.txt 2>/dev/null | wc -l)

# Display results
echo""
echo "Backup complete! Files backed up: $count"
