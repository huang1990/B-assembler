#secondrun size
firstrun=open('output/firstrun.fa', 'r')
current_string=""
for line in firstrun:
    if line.startswith("A") or line.startswith("T") or line.startswith("C") or line.startswith("G"):
        current_string+=line.strip("\n")
Flen=len(current_string)
resize=int(Flen//2.5)

rule second_assembly:
    input:
        "output/EndReads_dupl_remove.fa"
    output:
        "output/secondrun/assembly.fasta"
    params:
        dir="output/secondrun/",
        size=resize
    shell:
        "flye --nano-raw {input} --min-overlap 1000 --asm-coverage 50 --genome-size {params.size} --out-dir {params.dir}"

rule select_longContig:
    input:
        "output/secondrun/assembly.fasta"
    output:
        "output/secondrun.fa"
    shell:
        "python script/select_longest_contig.py {input} {output}"

