nextflow.enable.dsl = 2

include { SPLIT_VCF_BY_SAMPLE } from './modules/bcftools'


params.vcf_dir = params.vcf_dir ?: "/path/to/vcfs"
params.outdir  = params.outdir  ?: "split_vcfs"


workflow {

    vcf_ch = Channel
        .fromPath("${params.vcf_dir}/*PASS.vcf", checkIfExists: true)
        .map { vcf ->

            // Example:
            // FAMILY001_PASS.vcf -> FAMILY001
            vcf_id = vcf.name.replaceFirst(/_?PASS\.vcf$/, '')

            tuple(vcf_id, vcf)
        }

    SPLIT_VCF_BY_SAMPLE(vcf_ch)
}