#!/usr/bin/env cwl-runner

class: Workflow
id: mutation-call-with-normal
label: Calls mutations with both normal and tumor samples
cwlVersion: v1.0

# DISCUSSIONS:
# - Should default values be given to input parameters?

$namespaces:
  edam: 'http://edamontology.org/'

inputs:
  name:
    type: string
    label: sample name
  reference:
    type: File
    format: edam:format_1929
    label: FastA file for reference genome
  tumor:
    type: File
    format: edam:format_2572
    label: tumor sample BAM aligned to the reference
  normal:
    type: File
    format: edam:format_2572
    label: normal sample BAM aligned to the reference
  fisher_min_depth:
    type: int
  fisher_base_quality:
    type: int
  fisher_min_variant_read:
    type: int
  fisher_min_allele_freq:
    type: double
  fisher_max_allele_freq:
    type: double
  fisher_p_value:
    type: double
  fisher_interval_list:
    type: File?
    label: pileup regions list
  fisher_samtools_params:
    type: string?
    label: SAMtools parameters given to GenomonFisher
  hotspot_min_tumor_misrate: # The minimum amount of tumor allele frequency (default 0.1)
    type: double
  hotspot_max_control_misrate: # The maximum amount of control allele frequency (default 0.1)
    type: double
  hotspot_TN_ratio_control: # The maximum value of the ratio between normal and tumor (default 0.1 )
    type: double
  hotspot_min_lod_score: # The minimum lod score (default 8.0)
    type: double
  hotspot_samtools:
    type: string?
    label: parameters given to GenomonHotspotCall

#fisher_pair_option = --min_depth 8 --base_quality 15 --min_variant_read 4 --min_allele_freq 0.02 --max_allele_freq 0.1 --fisher_value 0.1
#fisher_pair_samtools = -q 20 -BQ0 -d 10000000 --ff UNMAP,SECONDARY,QCFAIL,DUP
# hotspot_call_option = -t 0.1 -c 0.1 -R 0.1 -m 8.0
# hotspot_call_samtools = -B -q 20 -Q2    

steps:
  fisher:
    label: Fisher's exact test
    run: ../Tools/mutation-call-fisher-comparison.cwl
    in:
      name: name
      reference: reference
      tumor: tumor
      normal: normal
      min_depth: fisher_min_depth
      base_quality: fisher_base_quality
      min_variant_read: fisher_min_variant_read
      min_allele_freq: fisher_min_allele_freq
      max_allele_freq: fisher_max_allele_freq
      p_value: fisher_p_value
      interval_list: fisher_interval_list
      samtools_params: fisher_samtools_params
    out:
      [txt, log]

outputs: []
  
