#!/usr/bin/env python

import sys
import numpy as np

fa=sys.argv[1]
outfile=sys.argv[2]

file = open(fa,'r')
output = open(outfile,'w')

current_string=""
current_name =""
max_name=""
maximal = 0
max_string=""
lst=[]

for line in file:
    if line.startswith(">"):
        lst.append(line)
        #last sequence ended:
        if len(current_string) > maximal:
            maximal = len(current_string)
            max_name = current_name
            max_string = current_string
        #start reading a new sequence:
        current_name = line
        current_string=""
    else:
        current_string+=line.strip("\n") 
output.write(max_name)

if len(lst)==1:
    output.write(current_name)

partition = np.ceil(len(max_string)/60)
for idx in range(0,int(partition)):
    sequence=max_string[60*idx:60*(idx+1)]
    output.write(sequence+'\n')

file.close()
output.close()
