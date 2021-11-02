
ds=$'200\n200\n100\n200\n200\n200\n100'

rm a/*mp3


#cd a

#for x in *_*wav;do y=`sox $x -n stat 2>&1 | grep Rough | sed -r "s/[^0-9]*([0-9]+)[^0-9]*/\1/"`;if [ $y -lt 10000 ];then echo $y;sox $x ../b/$x vol 0.5 pitch `python3 -c "print((314 - $y) * 3.141)"`;fi;done;for x in ../b/*wav;do sox $x -n stat 2>&1| grep Rough;done

#cd ..

n=$(( $RANDOM % 4 + 1 ))
echo $n
scale1=`echo "$ds" | head -n $n`
scale0=`echo "$ds" | tail -n $(( 7 - $n ))`

echo "$scale0"
echo
echo "$ds"
echo
echo "$scale1"


m=1

while [ $m -le 16 ]; do
echo $m
instrument=`echo a/${m}_*wav`
echo $instrument
m=$(( $m + 1 ))

if [ -f "$instrument" ]; then 

i=0;
pt=0;


rm -f tmp_a/*

for xy in $scale0 `echo "$ds"` $scale1; do 
    echo $i $pt $xy;
    pt=$(( $pt + $xy ))
    sox $instrument tmp_a/$i.wav norm silence 1 0.50 0.1% pitch $pt
    i=$(( $i + 1 ));
done
for k in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
	sox $instrument tmp_a/none$k.wav vol 0
done

for x in tmp_a/*wav; do 
    echo $x;
    ffmpeg -t 200ms -i $x $x.mp3 
done

rm xy;
rm xy.mp3

x=0;
while [ $x -lt 2000 ];do 
    ys=`find tmp_a/ -iname "*mp3" -type f -print -print|shuf`;
    for y in $ys;do 
        cat $y >> xy;
        echo -n .;
        x=$(( $x + 1));
    done;
done;
ffmpeg -i xy -y $instrument.mp3

fi
done

#ffmpeg -i a/1_BitInvader.wav.mp3 -i a/2_FreeBoy.wav.mp3 -i a/3_LB302.wav.mp3 -i a/4_Monstro.wav.mp3 -y -filter_complex amerge=inputs=4  song1.mp3
ffmpeg `ls a/*_*mp3 | shuf | head -4 | sed "s/^/-i /"` -filter_complex "amerge=inputs=4" song$RANDOM.mp3


