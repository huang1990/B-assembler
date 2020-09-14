#choose Read type ONT or pacbio
par=""
readType=config['readtype']
if readType=="ONT":
    par="--nano-raw"
    mini="map-ont"
else:
    par="--pacbio-raw"
    mini="map-pb"
rule first_assemble:
    input:
        "output/long_read_corrected.fasta"
    output:
        "output/assembly.fasta"
    params:
        dir="output/",
        genoSize=config['genomesize'],
        type=par 
    shell:
        "flye {params.type} {input} --min-overlap 1000 --asm-coverage 50 --genome-size {params.genoSize} --out-dir {params.dir}"

##extract plasmid sequence
rule select_longestContig:
    input:
        "output/assembly.fasta"
    output:
        "output/firstrun.fa"
    shell:
        "python script/select_plasmidID_longest_contig.py {input} {output}"

rule rawfq_firstrun:
    input:
        firstrun="output/firstrun.fa",
        rawfq=config['nanopore']
    output:
        bam = "output/rawfq-firstrun-srt.bam",
        bai = "output/rawfq-firstrun-srt.bam.bai"
    params:
        type=mini
    shell:
        "minimap2 -ax {params.type} {input.firstrun} {input.rawfq} | samtools view -Sb - | samtools sort - -o {output.bam} && samtools index {output.bam} > {output.bai}"


