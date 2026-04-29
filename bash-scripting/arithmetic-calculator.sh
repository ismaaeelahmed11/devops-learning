#!/bin/bash
echo "=== Arithmetic Calculator ==="

read -p "Enter first number: " num1
read -p "Enter second number: " num2

echo "Results:"

sum=$((num1 + num2))
echo "$num1 + $num2 = $sum"

sub=$((num1 - num2))
echo "$num1 - $num2 = $sub"

multiplication=$((num1 * num2))
echo "$num1 * $num2 = $multiplication"

if [ "$num2" -eq 0 ]; then
echo "$num1 / $num2 = Error: Division by zero"
else
division=$((num1 / num2))
echo "$num1 / $num2 = $division"
fi


