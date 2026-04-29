#!/bin/bash

echo "=== File Operations Script ==="
echo ""

mkdir bash_demo
echo "Directory 'bash_demo' created."

cd bash_demo

touch demo.txt

echo "File 'demo.txt' created."
echo ""

echo "This file was created by a Bash script on $(date)" > demo.txt

echo "File contents:"
cat demo.txt
