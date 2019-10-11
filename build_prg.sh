#!/bin/bash

if [ $# -lt 3 ]; then
   echo "Usage: $0 [raw image data file] [320|640 - width] [2|4 - color depth] [[0,15] - palette]"
   exit 1
fi

if [ -f $1 ]; then
   raw=$1
else
   echo "Error: $1 is not a file"
   exit 1
fi

if [ $2 = 320 ] || [ $2 = 640 ]; then
   width="w$2"
else
   echo "Error: Invalid width: $2; width must be 320 or 640"
   exit 1
fi

if [ $3 = 2 ]; then
   depth="twobit"
   palette="1"
   binexe="./cga2bit.exe"
else 
   if [ $3 = 4 ]; then
      depth="fourbit"
      palette="0"
      binexe="./cga4bit.exe"
   else
      echo "Error: Invalid depth: $3; depth must be 2 or 4"
   fi
fi
   
if [ $# -lt 4 ]; then
   echo "No palette specified, using default offset ${palette}" 
else
   if [ $4 -ge 0 ] && [ $4 -le 15 ]; then
      palette=$4
   else
      echo "Error: Invalid palette offset: $4; palette offset must be between 0 and 15"
   fi
fi

filebase=${raw##*/}
filebase=${filebase%.*}
x16bin="${filebase}.x16"

$binexe $raw $x16bin

rlebin="${filebase}.rle"

./rle.exe $x16bin $rlebin

rleasm="${rlebin}.asm"

./bin2asm.exe $rlebin $rleasm

echo "$depth = 1" > temp.inc
echo "$width = 1" >> temp.inc
echo ".define rlefile \"${rleasm}\"" >> temp.inc
echo "palette = $palette" >> temp.inc

prg="${filebase}.prg"
list="${filebase}.list"

cl65 -o $prg -l $list cgabitmap.asm

