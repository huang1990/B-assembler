rule LongRead_correct_allRead:
    input:
        long=config['longread'],
        short_1=config['illumina']['R1'],
        short_2 = config['illumina']['R2']
    output:
        "output/racon_polish_longread.fastq"        
    shell:
        """
        cat {input.short_1} {input.short_2} > output/shortread.fq
        minimap2 -ax sr {input.long} {input.short_1} {input.short_2} > output/short_long.sam
        racon output/shortread.fq output/short_long.sam {input.long} > output/racon_polish_longread.fasta
        scripts/fa2fq.pl output/racon_polish_longread.fasta > {output}
        """

rule select_longread:
    input:
        "output/racon_polish_longread.fastq"
    output:
        long="output/filter_length.fq",
        short="output/left_filter_length.fq"
    params:
        config['genomesize']
    shell:
        """
        python scripts/SelectLongRead.py {input} {params} {output.long} {output.short}
        """
rule fq_to_fa:
    input:
        "output/filter_length.fq"
    output:
        "output/filter_length.fa"
    shell:
        """
        python scripts/FqToFa.py {input} {output}
        """
##longRead_correct
par=""
readType=config['readtype']
if readType=="ONT":
    par="map-ont"
else:
    par="map-pb"

rule short_to_long:
    input:
        long = "output/filter_length.fa",
        short = "output/left_filter_length.fq"
    output:
        "output/short_to_long.sam"
    params:
        type=par
    shell:
        """
        minimap2 -ax {params.type} {input.long} {input.short} > {output}
        """
rule longread_polish:
    input:
        long = 'output/filter_length.fa',
        short = 'output/left_filter_length.fq',
        sam = 'output/short_to_long.sam'
    output:
        "output/long_read_corrected.fasta"
    shell:
        """
        racon {input.short} {input.sam} {input.long} > {output}
        """
