#!/bin/bash


profileInfo=$(profiles show -o stdout)
result=$(printf "%s\n" "$profileInfo")
echo "<result>$result</result>"
