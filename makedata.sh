#!/bin/bash

echo -n "Enter number of datapoints to generate and press [ENTER]: "
read number

echo -n "Enter name to be used for the output file and press [ENTER]: "
read name

i=1
while [ "$i" -le "$number" ];
do
    #make directories and copy files
    mkdir -p ./susyhit/point$i
    mkdir -p ./prospino/point$i
    cp ~/susyhit/run ./susyhit/point$i
    cp ~/susyhit/suspect2_lha.in ./susyhit/point$i
    cp ~/susyhit/susyhit.in ./susyhit/point$i
    cp -R ~/prospino/* ./prospino/point$i
    
    #change the inputs for susyhit
    python pointchange.py ./susyhit/point$i/suspect2_lha.in
    echo $i/$number Points Created
    i=$(($i+1))
done

echo All Points Created

cd ./susyhit

i=1
while [ "$i" -le "$number" ];
do
    #run susyhit and copy output
    cd ./point$i/ 
    ./run >/dev/null
    cd ..
    cp ./point$i/susyhit_slha.out ./sus$i.dat
    mv ./point$i/susyhit_slha.out ./../prospino/point$i/prospino.in.les_houches
    #rm -R ./point$i
    echo $i/$number Susyhit Calculations Complete
    i=$(($i+1))
done

cd ..

echo All Susyhit Calculations Complete

cd ./prospino

i=1
while [ "$i" -le "$number" ];
do
    #run prospino and copy output
    cd ./point$i/
    ./prospino_2.run
    cd ..
    cp ./point$i/prospino.dat ./pro$i.dat
    #rm -R ./point$i
    echo $i/$number Prospino Calculations Complete
    i=$(($i+1))
done

cd ..

echo All Prospino Calculations Complete

python datagroup.py $name $number #consolidate output into one file

#rm -R ./susyhit
#rm -R ./prospino

echo Temporary Files Cleaned and Output Written to $name
