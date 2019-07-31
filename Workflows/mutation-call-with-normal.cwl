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
  hotspot_database_directory:
    type: Directory
    label: directory containing hotspot_mutations.txt
  hotspot_min_tumor_misrate:
    label: the minimum amount of tumor allele frequency
    type: double
  hotspot_max_control_misrate:
    label: the maximum amount of control allele frequency
    type: double
  hotspot_TN_ratio_control:
    label: the maximum value of the ratio between normal and tumor
    type: double
  hotspot_min_lod_score:
    label: the minimum lod score
    type: double
  hotspot_samtools_params:
    type: string?
    label: SAMtools parameters given to GenomonHotspotCall

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

  # In GenomonHotspotcall, a tumor BAM is compared with a control BAM.
  # Here 'control BAM' corresponds to the normal BAM in Genomon mutation call,
  # not the control panel.
  hotspotCall:
    label: identifies hotspot mutations
    run: ../Tools/mutation-call-hotspotCall.cwl
    in:
      name: name
      tumor: tumor
      normal: normal
      database_directory: hotspot_database_directory
      min_tumor_misrate: hotspot_min_tumor_misrate
      max_control_misrate: hotspot_max_control_misrate
      TN_ratio_control: hotspot_TN_ratio_control
      min_lod_score: hotspot_min_lod_score
      samtools_params: hotspot_samtools_params
    out:
      [txt, log]

outputs: []

