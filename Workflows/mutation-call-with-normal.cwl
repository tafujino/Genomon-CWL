#!/usr/bin/env cwl-runner

class: Workflow
id: mutation-call-with-normal
label: Calls mutations with both normal and tumor samples
cwlVersion: v1.0

# DISCUSSIONS:
# - Should default values be given to Fisher's exact test parameter fields?

$namespaces:
  edam: 'http://edamontology.org/'

inputs:
  reference:
    type: File
    format: edam:format_1929
    label: FastA file for reference genome
  normal:
    type: File
    format: edam:format_2572
    label: normal sample BAM aligned to the reference
  tumor:
    type: File
    format: edam:format_2572
    label: tumor sample BAM aligned to the reference
  name:
    type: string
    label: sample name
  fisher_pair_samtools:
    type: string?
    label: SAMtools parameters given to GenomonFisher
  fisher_interval_list:
    type: File?
    label: pileup regions list
  fisher_min_depth:
    type: int
  fisher_base_quality:
    type: int
  fisher_min_variant_read:
    type: int
  fisher_min_allele_freq:
    type: double
  fisher_value: 
  hotspot_samtools:
    type: string?
    label: parameters given to GenomonHotspotCall

#fisher_pair_option = --min_depth 8 --base_quality 15 --min_variant_read 4 --min_allele_freq 0.02 --max_allele_freq 0.1 --fisher_value 0.1
#fisher_pair_samtools = -q 20 -BQ0 -d 10000000 --ff UNMAP,SECONDARY,QCFAIL,DUP
# hotspot_call_option = -t 0.1 -c 0.1 -R 0.1 -m 8.0
# hotspot_call_samtools = -B -q 20 -Q2    

steps:
  fisher:
    label: Fishe's exact test
    run: ../Tools/fisher-comparison.cwl

outputs: []
  
