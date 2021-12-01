#! /bin/bash
export LC_NUMERIC="en_US.UTF-8"

tablewrite=(0 0 0 0 0 0 0 0 0 0)
tableread=(0 0 0 0 0 0 0 0 0 0)
writedivs=(1 1 1 1 1 1 1 1 1 1)
readdivs=(1 1 1 1 1 1 1 1 1 1)

LastBytesRead=$(($(cat /proc/diskstats | grep sda | awk '{print $6}')*512))
LastBytesWritten=$(($(cat /proc/diskstats | grep sda | awk '{print $10}')*512))
sleep 1


while true
do
TotSec=$(cat /proc/uptime | awk '{print $1}')
TotSec=$(printf "%.0f" $TotSec)
TimeD=$(($TotSec/86400))
TotSec=$(($TotSec-$TimeD*86400))
TimeH=$(($TotSec/3600))
TotSec=$(($TotSec-$TimeH*3600))
TimeM=$(($TotSec/60))
TotSec=$(($TotSec - $TimeM*60))
BytesRead=$(($(cat /proc/diskstats | grep sda | awk '{print $6}')*512))
BytesWritten=$(($(cat /proc/diskstats | grep sda | awk '{print $10}')*512))
echo "uptime:" $TimeD "d" $TimeH "h" $TimeM "m" $TotSec "s"

echo $(cat /proc/loadavg | awk '{print "average load 1 min:"$1" | 5 min:"$2" | 15 min:"$3}')

if test -f /sys/class/power_supply/BAT1/capacity
then
echo "battery percentage: $(cat /sys/class/power_supply/BAT1/capacity) %"
fi

MemoryTotal=$(awk '{print $2}' /proc/meminfo | head -n1)
MemoryFree=$(awk '{print $2}' /proc/meminfo | head -n2 | tail -n1)
MemoryPer=$(($MemoryFree*100/$MemoryTotal))

echo "Memory usage:" $((100-$MemoryPer)) "%"

for i in 0 1 2 3 4 5 6 7 8
do
tablewrite[$i]=${tablewrite[$(($i+1))]}
tableread[$i]=${tableread[$(($i+1))]}
writedivs[$i]=${writedivs[$(($i+1))]}
readdivs[$i]=${readdivs[$(($i+1))]}
done

Writepersec=$(($BytesWritten - $LastBytesWritten))
LastBytesWritten=$BytesWritten
Readpersec=$(($BytesRead-$LastBytesRead))
LastBytesRead=$BytesRead

tablewrite[9]=$Writepersec
tableread[9]=$Readpersec

if [ $Writepersec -lt 1000 ]
then
WriteSign="B"
WriteDiv=1
elif [ $Writepersec -lt 1000000 ]
then
Writepersec=$(($Writepersec/1000))
WriteSign="KB"
WriteDiv=1000
elif [ $Writepersec -lt 1000000000 ]
then
Writepersec=$(($Writepersec/1000000))
WriteSign="MB"
WriteDiv=1000000
else
Writepersec=$(($Writepersec/1000000000))
WriteSign="GB"
WriteDiv=1000000000
fi

writedivs[9]=$WriteDiv

if [ $Readpersec -lt 1000 ]
then
ReadSign="B"
ReadDiv=1
elif [ $Readpersec -lt 1000000 ]
then
Readpersec=$(($Readpersec/1000))
ReadSign="KB"
ReadDiv=1000
elif [ $Readpersec -lt 1000000000 ]
then
Readpersec=$(($Readpersec/1000000))
ReadSign="MB"
ReadDiv=1000000
else
Readpersec=$(($Readpersec/1000000000))
ReadSign="GB"
ReadDiv=1000000000
fi

readdivs[9]=$ReadDiv


for i in $(seq 0 9)
do
if [ $ReadDiv -lt ${readdivs[$i]} ]
then
ReadDiv=${readdivs[$i]}
fi
if [ $WriteDiv -lt ${writedivs[$i]} ]
then
WriteDiv=${writedivs[$i]}
fi
done


echo "READ:"
for i in $(seq 0 9)
do
./graphline.sh $(((${tableread[$i]}/$ReadDiv)/10))
done
echo "read: " $Readpersec$ReadSign"/s"

echo "WRITE:"
for i in $(seq 0 9)
do
./graphline.sh $(((${tablewrite[$i]}/$WriteDiv)/10))
done
echo "write: " $Writepersec$WriteSign"/s"

echo "--------------------------"
sleep 1
done
