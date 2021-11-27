#! /bin/bash
wget -O catpic $(echo $(curl https://api.thecatapi.com/v1/images/search 2> /dev/null | jq -r '.[].url')) 2>/dev/null
img2txt catpic
echo $(curl api.icndb.com/jokes/random 2>/dev/null | jq '.value.joke')