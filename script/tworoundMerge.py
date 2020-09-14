#!/usr/bin/env python
import sys
import os
import re
import random
import numpy as np
import subprocess

file=sys.argv[1]
first=sys.argv[2]
second=sys.argv[3]
begin=sys.argv[4]
end=sys.argv[5]

##transfer firstrun and secondrun contig to single line
with open(first) as f_input, open('output/firstrun_single', 'w') as f_output:
    block = []
    for line in f_input:
        if line.startswith('>'):
            if block:
                f_output.write(''.join(block) + '\n')
                block = []
        else:
            block.append(line.strip())
    if block:
        f_output.write(''.join(block) + '\n')

with open(second) as s_input, open('output/secondrun_single', 'w') as s_output:
    block = []
    for line in s_input:
        if line.startswith('>'):
            if block:
                s_output.write(''.join(block) + '\n')
                block = []
        else:
            block.append(line.strip())
    if block:
        s_output.write(''.join(block) + '\n')

##merge first and second run contig  
input=open(file,"r")
data=input.readlines()
setA=[]
setB=[]
setC=[]
setD=[]
for line in data:
    line=line.strip()
    elm=line.split("\t")
    setA.append(int(elm[2]))
    setB.append(int(elm[7]))
    setC.append(int(elm[3]))
    setD.append(int(elm[8]))
indexMinA=[i for i, x in enumerate(setA) if x == min(setA)]
indexMinB=[i for i, x in enumerate(setB) if x == min(setB)]
#print(indexMinA)
#print(indexMinB)
N = (int(min(setC))-int(min(setA)))*0.1
#print(N)
M = (int(max(setC))-int(max(setA)))*0.1
#print(M)
O = (int(min(setC))-int(min(setA)))*0.4
P = (int(max(setC))-int(max(setA)))*0.4
#print(O)
if indexMinA == indexMinB:

    cmd = 'cat output/firstrun_single | cut -b '+str(min(setD))+'-'+str(max(setB))+' > '+str(begin)+''
    p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    cmd = 'cat outputsecondrun_single | cut -b '+str(int(min(setA))+int(N))+'-'+str(int(max(setA))-int(N))+' > '+str(end)+''
    o = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
else:
    cmd = 'cat output/firstrun_single | cut -b '+str(int(min(setD))-int(O))+'-'+str(int(max(setB))+int(O))+' > '+str(begin)+''
    p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    cmd = 'cat output/secondrun_single | cut -b '+str(int(min(setA))+int(P))+'-'+str(int(max(setC))-int(P))+' > '+str(end)+''
    o = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    
input.close()
