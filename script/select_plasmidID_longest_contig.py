import subprocess, sys
import numpy as np

fa=sys.argv[1]
outfile=sys.argv[2]

##select longest contig
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


##plasmidsID extract
cmd = 'awk \'$0 ~ ">" {if (NR > 1) {print c;} c=0;printf substr($0,2,100) "\t"; } $0 !~ ">" {c+=length($0);} END { print c; }\' '+str(fa)+' | sort -n -rk2,2 | sed 1d | awk \'{print$1}\'>output/plasmidID.txt'
out1 = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
out1_status = out1.wait()

##change mutiline fa to singleline fa
with open(fa) as f_input, open('output/assembly_singleline.fasta', 'w') as f_output:
    block = []

    for line in f_input:
        if line.startswith('>'):
            if block:
                f_output.write(''.join(block) + '\n')
                block = []
            f_output.write(line)
        else:
            block.append(line.strip())

    if block:
        f_output.write(''.join(block) + '\n')

cmd='grep -A 1 --no-group-separator -f output/plasmidID.txt output/assembly_singleline.fasta > output/plasmids_singleLine.fa'
out2 = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
out2_status = out2.wait()

##extract plasmids contigs
with open('output/plasmids_singleLine.fa') as file_input,open('output/plasmids.fa', 'w') as file_output:
     for line in file_input:
        if line.startswith('>'):
            string_name = line
            file_output.write(string_name)
        else:
            seqStr = line
            partition = np.ceil(len(seqStr)/60)
            for idx in range(0,int(partition)):
                sequence=seqStr[60*idx:60*(idx+1)]
                file_output.write(sequence+'\n')
            

file.close()
output.close()

