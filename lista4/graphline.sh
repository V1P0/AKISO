#! /bin/bash

for i in $(seq 1 $1)
do
echo -n "|"
done
for i in $(seq $(($1+1)) 100)
do
echo -n " "
done
echo "]"