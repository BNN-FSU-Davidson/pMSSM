#!/bin/bash

usage="$(basename "$0") [Flag] [Name] [Number] -- Program to generate pMSSM predictions

    Name    The name of the datafile to be created
    Number  An integer value of points to be generated

    Flags:
      -h    Display this message
      -b    Enable batch datagrouping (currently non-functional)"

while getopts ':hs:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift "$((OPTIND - 1))"

name=$1 #first argument is the number

number=$2 #second argument is the filename

i=1
while [ "$i" -le "$number" ];
do
    #make directories and copy files
    mkdir -p ./susy/point$i
    mkdir -p ./pros/point$i
    cp ~/susyhit/run ./susy/point$i
    cp ~/susyhit/suspect2_lha.in ./susy/point$i
    cp ~/susyhit/susyhit.in ./susy/point$i
    cp -R ~/prospino/* ./pros/point$i
    
    #change the inputs for susyhit
    python pointchange.py ./susy/point$i/suspect2_lha.in
    echo $i/$number Points Created
    i=$(($i+1))
done

echo All Points Created

cd ./susy

i=1
while [ "$i" -le "$number" ];
do
    #run susyhit and copy output
    cd ./point$i/ 
    ./run > /dev/null
    cd ..
    cp ./point$i/susyhit_slha.out ./sus$i.dat
    mv ./point$i/susyhit_slha.out ./../pros/point$i/prospino.in.les_houches
    rm -R ./point$i
    echo $i/$number Susyhit Calculations Complete
    i=$(($i+1))
done

cd ..

echo All Susyhit Calculations Complete

cd ./pros

i=1
while [ "$i" -le "$number" ];
do
    #run prospino and copy output
    cd ./point$i/
    ./prospino_2.run > /dev/null
    cd ..
    cp ./point$i/prospino.dat ./pro$i.dat
    rm -R ./point$i
    python ../datagroup.py $name $i
    rm ./pro$i.dat
    rm ../susy/sus$i.dat
    echo $i/$number Prospino Calculations Complete
    i=$(($i+1))
done

cd ..

echo All Prospino Calculations Complete

rm -R ./susy
rm -R ./pros

echo Temporary Files Cleaned and Output Written to $name
