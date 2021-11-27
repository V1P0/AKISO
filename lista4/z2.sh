#! /bin/bash

echo "USER      |  PID  | PPID |  TTY  | Nr fd | %MEM | COMMAND"

for proc in $(ls -l /proc | awk '{print $9}' | grep -Eo '[0-9]{1,9}' | sort -n)
do
if test -f /proc/$proc/status; then

USERID=$(getent passwd "$(cat /proc/$proc/status 2> /dev/null | awk '{print $2}' | head -n9 | tail -n>PID=$(cat /proc/$proc/status 2> /dev/null | awk '{print $2}' | head -n6 | tail -n1)
ParPID=$(cat /proc/$proc/status 2> /dev/null | awk '{print $2}' | head -n7 | tail -n1)
TTY=$(cat /proc/$proc/stat 2> /dev/null | awk '{print $7}')
MEM=$(($(cat /proc/$proc/status 2> /dev/null | awk '{print $2}' | head -n18 | tail -n1)*1000/$(cat /p>MEM=$(($MEM/10)).$(($MEM%10))
NrFd=$(sudo ls /proc/$proc/fd | wc -l)
COMMAND=$(cat /proc/$proc/cmdline | tr -d "\0")

useridsize=10
echo -n "$USERID"
useridsize=$(($useridsize-${#USERID}))
for i in $(seq 1 $useridsize)
do
echo -n " "
done
echo -n "|"

PIDsize=7
PIDsize=$(($PIDsize-${#PID}))
for i in $(seq 1 $PIDsize)
do
echo -n " "
done
echo -n "$PID|"

PPIDsize=6
PPIDsize=$(($PPIDsize-${#ParPID}))
for i in $(seq 1 $PPIDsize)
do
echo -n " "
done
echo -n "$ParPID|"

TTYsize=7
TTYsize=$((TTYsize-${#TTY}))
for i in $(seq 1 $TTYsize)
do
echo -n " "
done
echo -n "$TTY|"

fdsize=7
fdsize=$(($fdsize-${#NrFd}))
for i in $(seq 1 $fdsize)
do
echo -n " "
done
echo -n "$NrFd|"

MEMsize=6
MEMsize=$(($MEMsize-${#MEM}))
for i in $(seq 1 $MEMsize)
do
echo -n " "
done
echo -n "$MEM|"
echo " $COMMAND"
fi
done
