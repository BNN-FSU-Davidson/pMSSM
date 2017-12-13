#!/usr/bin/env python

import sys
import os
import os.path

def main():
    name = sys.argv[1] #name of datafiles to read
    num = int(sys.argv[2]) #which files to read

    outfile = open('./'+str(name)+'.dat', 'a')

    for i in range(num):
        infile = './'+str(name)+str(i+1)+'.dat'
        if os.path.isfile(infile):
            content = (open(infile, 'r')).read()
            outfile.write(content)
            os.remove(infile)

main()
