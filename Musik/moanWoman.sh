#!/bin/bash

rm -f moanWoman/*
cd moanWoman


x=80;i=0;while [ $x -le 100 ];do espeak -v mb-de7 "haaaach ?"  -p $x -s 1 -w xy$i.wav;x=$(( $x + 10 ));i=$(( $i + 1 ));done
x0=$(( $i - 1 ))
i=1
x=$x0;while [ $x -lt 12 ];do sox xy$x0.wav xy$(( $x + 1 )).wav bend 0,$(( 200 * $i )),1.0 norm vol 0.4;i=$(( $i + 1 ));x=$(( $x + 1));done
sox xy1.wav none0.wav vol 0
for x in xy*wav;do ffmpeg -y -i $x -af silenceremove=1:0:0.01 $x.mp3;done
for x in none*.wav;do ffmpeg -y -i $x $x.mp3;done
x=0;while [ $x -lt 5000 ];do ys=`ls xy*mp3 none*mp3|shuf`;for y in $ys;do cat $y >> moanWoman;echo -n .;x=$(( $x + 1));done;done
ffmpeg -threads 5 -i moanWoman -threads 5 -af loudnorm -threads 5 moanWoman.mp3

cd ..

