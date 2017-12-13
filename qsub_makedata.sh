#!/bin/bash
#----------------------------------------
#This is code which helps allow the makedata file to generate many data points 
#without upsetting the job managment system of a supercomputer.
#it assumes the file structure to be ~/pMSSM/jobs with makedata_array.sh in the
#pMSSM folder and this file in the jobs folder
#----------------------------------------
#PBS -N pMSSM_pointgen_100x100
#PBS -j oe
#PBS -o /mnt/home/mkuchera/pMSSM/jobs/output.o  
#PBS -l walltime=4:00:00
#PBS -l nodes=1:ppn=1
#PBS -l mem=1gb
#PBS -m a
#PBS -M alkarbo@davidson.edu
#PBS -t 1-150

MAXJOBID=1000

JOBSCRIPT=./jobs/qsub_makedata.sh

n=${PBS_ARRAYID}

OUTPUT_FILE=50points$n.dat

cd ~/pMSSM/

sh makedata_array.sh ${OUTPUT_FILE} 50 $(( $(( $n - 1 )) * 50 ))
 
NEXT=$(( $n + 150 )) #Calculate next job to run
 
#Check to see if next job is past the maximum job id
if [ $NEXT -le $MAXJOBID ]
then
        qsub -t $NEXT $JOBSCRIPT
fi
 
#Check to see if this is the last job and email user
if [ $n -eq $MAXJOBID ]
then
        echo "." | mail -s "Hey hey, check the array" alkarbo@davidson.edu
fi
