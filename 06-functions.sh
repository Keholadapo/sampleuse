#!/bin/bash

# Variable holds data, Function holds commands. When you call function, it execute all the commands declare in function

# Declare function

sample() {
  echo Hello World from function
  echo a = $a

}

# Call the function

# Main Program
a=10
sample

# Observations
# 1. Functions are always before main program