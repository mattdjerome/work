#!/bin/bash

currentOS=$(sw_vers -productVersion)

if [[ "$currentOS" > "13" ]]; then # True if string s1 comes after s2 based on the binary value TLDR; good for comparing decmials of their characters.
    echo "greater than 13"
else
    echo "less than or equal to 13"
fi