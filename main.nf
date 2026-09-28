nextflow.enable.dsl = 2

params.vcf_dir = params.vcf_dir ?: "filtered_vcfs"
params.outdir  = params.outdir  ?: "split_vcfs"

include { SPLIT_VCF_BY_SAMPLE } from './modules/bcftools'


workflow {

    vcf_ch = Channel
        .fromPath("${params.vcf_dir}/*.PASS.vcf.gz", checkIfExists: true)
        .map { vcf ->

            // Example:
            // FAMILY001.PASS.vcf.gz -> FAMILY001
            vcf_id = vcf.name.replaceFirst(/\.PASS\.vcf\.gz$/, '')

            tuple(vcf_id, vcf)
        }

    SPLIT_VCF_BY_SAMPLE(vcf_ch)
}