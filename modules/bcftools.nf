process SPLIT_VCF_BY_SAMPLE {

    tag "${vcf_id}"

    cpus 16
    memory '32 GB'
    time '5h'

    publishDir "${params.outdir}", mode: 'copy'

    input:
    tuple val(vcf_id), path(vcf)

    output:
    tuple val(vcf_id), path("${vcf_id}")

    script:
    """
    mkdir -p ${vcf_id}

    bcftools query -l ${vcf} |
    while read -r sample; do

        echo "Splitting sample: \$sample"

        bcftools view \
            -s "\$sample" \
            ${vcf} \
            -Oz \
            -o "${vcf_id}/\${sample}.vcf.gz"

        bcftools index \
            -t \
            "${vcf_id}/\${sample}.vcf.gz"

    done
    """
}
