#! /bin/bash
echo "" > change.txt
lynx -dump $1 > ./site.txt
echo "obserwowanie strony $1"
sleep $2
while true
do
#echo "checking..."
lynx -dump $1 > ./newsite.txt
#echo "dow"
ch=$(diff --normal "./site.txt" "./newsite.txt")
echo "zmiana: $ch" >> change.txt
if [ ${#ch} != 0 ]
then
cat ./newsite.txt > ./site.txt
echo "nastapila zmiana strony $1"
fi
sleep $2
done
