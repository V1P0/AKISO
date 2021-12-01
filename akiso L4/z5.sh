#! /bin/bash

Points_Left=0
Points_Right=0

Board_W=$(tput cols)
Board_H=$(tput lines)
#TODO minimalny rozmiar
Ball_X=$(($Board_W/2))
Ball_Y=$(($Board_H/2))
Ball_VX=1
Ball_VY=1
Left_pos=$((Board_H/2 - 1))
Right_pos=$((Board_H/2 - 1))
RX=$(($Board_W - 3))

moveR(){
        for i in 0 1 2 3 4 5
        do
        tmp=$((Right_pos + $i))
        echo -en "\033[${tmp};${RX}H "
        done
        (( Right_pos += $1))
        (( Right_pos = Right_pos < 1 ? 1 : Right_pos > Board_H - 5 ? Board_H - 5 : Right_pos))
        for i in 0 1 2 3 4 5
        do
        tmp=$((Right_pos + $i))
        echo -en "\033[${tmp};${RX}H|"
        done
}


moveL(){
        for i in 0 1 2 3 4 5
        do
        tmp=$((Left_pos + $i))
        echo -en "\033[${tmp};3H "
        done
        (( Left_pos += $1))
        (( Left_pos = Left_pos < 1 ? 1 : Left_pos > Board_H - 5 ? Board_H - 5 : Left_pos))
        for i in 0 1 2 3 4 5
        do
        tmp=$((Left_pos + $i))
        echo -en "\033[${tmp};3H|"
        done
}

ResetBall(){
        Ball_X=$(($Board_W/2))
        Ball_Y=$(($Board_H/2))
        Ball_VX=1
        Ball_VY=1
}

tput civis
tput clear
echo
moveL 0
moveR 0
while [[ $q != x ]]
do
echo -e "\033[${Ball_Y};${Ball_X}H@"
read -n 1 -s -t 0.05 q
case "$q" in
        [qQ] ) moveL -2;;
        [aA] ) moveL 2;;
        [pP] ) moveR -2;;
        [lL] ) moveR 2;;
esac
echo -e "\033[${Ball_Y};${Ball_X}H "
if (( Ball_X > Board_W ))
then
((Points_Left++))
ResetBall
fi
if ((Ball_X + Ball_VX <=0 ))
then
((Points_Right++))
ResetBall
fi
if ((Ball_X == 3 && Ball_Y < Left_pos + 6 && Ball_Y > Left_pos - 1))
then
((Ball_VX = - Ball_VX))
fi
if ((Ball_X == RX && Ball_Y < Right_pos + 6 && Ball_Y > Right_pos - 1))
then
((Ball_VX = - Ball_VX))
fi
((Ball_Y <= 1 || Ball_Y > Board_H - 2)) && ((Ball_VY = - Ball_VY))
((Ball_X+=Ball_VX))
((Ball_Y+=Ball_VY))

done
tput clear
echo "L:$Points_Left - R:$Points_Right"
tput cnorm
