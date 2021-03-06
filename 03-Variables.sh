#!/bin/bash

# If we assign a name to some data, that name is called variable.

#When it comes to data, we have different types, 1. Numbers. 2. Floating Values, 3. Characters. 4. Strings. 5. Booleans

a=10
b=xyz
c=true
d=9.999999

# Shell by default does not support data types, everything is a string.

# Access variable : ${a} or $a

echo $a

# In some scenarios, we use {}

echo $a000
echo ${a}000

DATE=08-06-2020
echo Good Morning, todays date is ${DATE}

DATE1=$(date +%F)
echo Good Morning. Todays date is ${DATE1}

## Executing a command and storing that particular output in a variable is called command substitution
# Syntax: VAR=$(commands)
# Same way, we can do arithmetic expression as well but with $(( expression ))

ADD=$((247+365))
echo $ADD
