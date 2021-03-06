#!/bin/bash

#------------------------------------------------------------------------
#makedata.sh, a code written by Karbo in the summer of 2017.
#This code generates pMSSM datapoints using the programs susyhit and prospino. 
#The program takes two arguments. First the name of the datafiel to be written,
#and second the number of points to be generated. 
#This file relies on pointchange.py and datagroup.py. 
#View Readme.txt for more info.
#------------------------------------------------------------------------

a=0
b=0

usage="$(basename "$0") [Flags] [Name] [Number] -- Program to generate pMSSM predictions

    Name    The name of the datafile to be created
    Number  An integer value of points to be generated

    Flags(optional):
      -h    Display this message
      -b    Enable batch datagrouping
      -a    Append data to an existing datafile"

warning="-a and -b flags cannot be active simultaneously 
Program Aborted"

while getopts ':hb:a:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    b) b=1
       if [ "$a" = "1" ]
       then
	   echo "$warning"
	   exit
       fi
       ;;
    a) a=1
       if [ "$b" = "1" ]
       then
	   echo "$warning"
	   exit
       fi
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
shift "$((OPTIND - 2))"
done


name=$1 #first argument is the name

number=$2 #second argument is the number

shift=0 #no shift by default
shift=$3 #third argument shifts the points over

i=$((1+$shift))
while [ "$i" -le "$(($number+$shift))" ];
do
    #make directories and copy files
    mkdir -p ./susy/point$i
    mkdir -p ./pros/point$i
    cp ./susyhit/run ./susy/point$i
    cp ./susyhit/suspect2_lha.in ./susy/point$i
    cp ./susyhit/susyhit.in ./susy/point$i
    cp -R ./prospino/* ./pros/point$i

    #change the inputs for susyhit
    python pointchange.py ./susy/point$i/suspect2_lha.in
    echo $i/$number Points Created

    cd ./susy

    #run susyhit and copy output
    cd ./point$i/ 
    ./run > /dev/null
    cd ..
    cp ./point$i/susyhit_slha.out ./sus$i.dat
    mv ./point$i/susyhit_slha.out ./../pros/point$i/prospino.in.les_houches
    rm -R ./point$i
    echo $i/$number Susyhit Calculations Complete

    cd ../pros

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
    cd ..

    i=$(($i+1))

    done