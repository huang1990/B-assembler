rule tworun_align:
    input:
        sec="output/secondrun.fa",
        fir="output/firstrun.fa"
    output:
        "output/first_second.paf"
    shell:
        "minimap2 -cx asm20 {input.fir} {input.sec} > {output}"

rule merge:
    input:
        paf="output/first_second.paf",
        first="output/firstrun.fa",
        second="output/secondrun.fa"
    output:
        begin="output/BeginSeq",
        end="output/EndSeq"
    shell:
        "python script/tworoundMerge.py {input.paf} {input.first} {input.second} {output.begin} {output.end}"

rule mergeFa:
    input:
        Begin="output/BeginSeq",
        End="output/EndSeq"
    output:
        "output/First_second_merge.fa"
    shell:
        "python script/printPrettyFa.py {input.Begin} {input.End} {output}"
