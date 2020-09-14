rule rearrange:
    input:
        assembly="output/merge_corrected_4.fasta",
        startfa=config['startGene']
    output:
        "output/B_assembly.fasta"
    shell:
        "python rearrange_startPoint.py {input.assembly} {input.startfa} {output}"
