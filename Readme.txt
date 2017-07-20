This is the Readme for makedata.sh, a script to generate pMSSM data using SUSYHIT and PROSPINO.
Thre file is divided into two sections. The first section, SETUP, describes how to download and configure SUSYHIT and PROSPINO. The second section, RUN, describes the usage of makedata.sh.

SETUP
-----------------------------------------------------------
First, download SUSYHIT and PROSPINO. 

SUSYHIT: https://www.itp.kit.edu/~maggie/SUSY-HIT/

PROSPINO: http://www.thphys.uni-heidelberg.de/~plehn/index.php?show=prospino&visible=tools

Next, unpack SUSYHIT into a folder in the user's home directory named "susyhit" and PROSPINO into a folder name "prospino" also in the user's home directory.

Finally, ensure that makedata.sh, datagroup.py, and pointchange.py are in the same working directory. 

The program will now run correctly and output data into the working directory. The program will not, however, output the values needed for pMSSM.

To configure the program to work in pMSSM one must open ~/susyhit/suspect2_lha.in and make some changes. Specifically, the first line of code (which has the comment mSUGRA) should have its second value changed from a 1 to a 0. As the list above this line states, the 0 tells the program to use MSSM. 

Next one should comment out the lines in the MINPAR block and uncomment all of the lines in the EXTPARexcept for those numbered 14 15 and 16 (A_u A_d and A_e.)

Finally, one should open ~/prospino/prospino_main.f90 and change the collider energy to the approptiate value. The default is 14 TeV. This line is found in the third value block. 

RUN
----------------------------------------------------------
The program should now be ready to execute. It should be executed from the directory in which it and the two python scripts are located.

A WARNING: This prgram creates AND THEN DELETES temporary directories at its location named "susy" and "pros". If the user has directories in the script's directory which have these names THEY WILL BE DELETED when the script finishes executing.

Usage: makedata.sh [FLAG] [NAME] [NUMBER]

     Name     The name of the datafile to be created
     Number   An integer value of points to be generated

     Flags(optional):
       -h     Display help message
       -b     Enable batch datagrouping (currently non-functional) 
