#!/bin/bash

# Variable holds data, Function holds commands. When you call function, it execute all the commands declare in function

# Declare function

sample() {
  a=30
  echo Hello World from function
  echo a in Function = $a
  b=20
}

# Call the function

# Main Program
a=10
sample
echo a in Main Program = $a
echo b in Main Program = $b

# Observations
# 1. Functions are always before main program
# 2. Variables in main programs can be assessed in function and vice-versa
# 3. Variables from Main program can be overwritten by function and vice-versa