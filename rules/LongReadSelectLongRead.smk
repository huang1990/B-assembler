rule longread_len:
    input:
        config['nanopore']
    output:
        "output/read_len_distrbution_2.txt"
    shell:
        "python script/read_length_distribution.py {input} {output}"

#echo config['nanopore']
rule select_longread:
    input:
        raw=config['nanopore'],
        lenDis="output/read_len_distrbution_2.txt",
    output:
        long="output/filter_length.fq",
        short="output/left_filter_length.fq"
    params:
        config['genomesize']
    shell:
        'python script/select_long_read.py {input.raw} {input.lenDis} {params} {output.long} {output.short}'

rule fq_to_fa:
    input:
        "output/filter_length.fq"
    output:
        "output/filter_length.fa"
    shell:
        "python script/fq_to_fa.py {input} {output}"

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
        "minimap2 -ax {params.type} {input.long} {input.short} > {output}"

rule longread_polish:
    input:
        long = 'output/filter_length.fa',
        short = 'output/left_filter_length.fq',
        sam = 'output/short_to_long.sam'
    output:
        "output/long_read_corrected.fasta"
    shell:
        "racon {input.short} {input.sam} {input.long} > {output}"
