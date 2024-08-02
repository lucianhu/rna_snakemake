rule trim_galore_process:
    input:
        get_cutadapt_input
    output:
        fastq1="results/trimmed/{sample}_{unit}_R1_val_1.fq.gz",
        fastq2="results/trimmed/{sample}_{unit}_R2_val_2.fq.gz",
        html="results/trimmed/{sample}_fastqc.html",
        zip="results/trimmed/{sample}_fastqc.zip",
        versions="results/trimmed/{sample}_versions.yml"
    conda:
        "envs/trimgalore.yaml"
    threads:
        8
    shell:
        """
        prefix={wildcards.sample}_{wildcards.unit}
        ln -s {input[0]} {prefix}_1.fastq.gz
        ln -s {input[1]} {prefix}_2.fastq.gz

        trim_galore \\
            --cores {threads} \\
            --paired \\
            --gzip \\
            {prefix}_1.fastq.gz \\
            {prefix}_2.fastq.gz

        mv {prefix}_1_val_1.fq.gz {output.fastq1}
        mv {prefix}_2_val_2.fq.gz {output.fastq2}

        # Move the FastQC report to the expected output locations
        mv {prefix}_1_fastqc.html {output.html}
        mv {prefix}_1_fastqc.zip {output.zip}

        echo "trim_galore:
            trimgalore: $(echo $(trim_galore --version 2>&1) | sed 's/^.*version //; s/Last.*\$//')
            cutadapt: $(cutadapt --version)" > {output.versions}
        """
