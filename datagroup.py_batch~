#!/usr/bin/env python

import sys
import linecache

def main():
    name = sys.argv[1] #name of datafile to be created
    num = int(sys.argv[2]) #number of points to read

    outfile = open(str(name), 'w') #create datafile

    #get input names from a sus file and write to datafile
    for j in range(24):
        if not (j == 10 or j == 13 or j == 16 or j == 19 or j == 22):
            row = linecache.getline('./susyhit/sus1.dat', j+64)
            outfile.write("{0:>16}".format(row.split()[3]))
    
    #get target names from a pro file and write to datafile
    row = linecache.getline('./prospino/pro1.dat', 3)
    outfile.write("{0:>14}".format(row.split()[13]))
    outfile.write("{0:>14}".format(row.split()[14]))
    outfile.write("\n")

    #cycle through specified number of  sus and pro files
    for i in range(num):
	row = linecache.getline('./prospino/pro'+str(i+1)+'.dat',1)
	if not (float(row.split()[14]) == float(0.610)):
            #read and write the sus data
            for j in range(24):
                if not (j == 10 or j == 13 or j == 16 or j == 19 or j == 22):
                    row = linecache.getline('./susyhit/sus'+str(i+1)+'.dat', j+64)
                    outfile.write("{0:>16}".format(row.split()[1]))
            #read and write the pro data
            row = linecache.getline('./prospino/pro'+str(i+1)+'.dat', 1) 
            outfile.write("{0:>14}".format(row.split()[14]))
            outfile.write("{0:>14}".format(row.split()[15]))
            outfile.write("\n")
        
main()
