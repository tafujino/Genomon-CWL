#!/usr/bin/env cwl-runner

class: Workflow
id: sv-detection
label: SV detection without control panels
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

inputs:
  tumor:
    type: File
    format: edam:format_2572
    label: tumor sample BAM aligned to the reference
    secondaryFiles:
      - .bai
  directory:
    type: Directory
    label: directory containing SV parse result. SV result is also generated here
  name:
    type: string
    label: tumor sample name
  reference:
    type: File
    format: edam:format_1929
    label: FastA file for reference genome
    secondaryFiles:
      - .fai
  normal:
    type: File?    
    format: edam:format_2572
    label: normal sample BAM aligned to the reference
    secondaryFiles:
      - .bai
  sv_filter_min_junctions:
    type: int?
    label: minimum required number of supporting junction read pairs
  sv_filter_max_normal_read_pairs:
    type: int?
    label: maximum allowed number of read pairs in normal sample
  sv_filter_min_overhang_size:
    type: int?
    label: minimum region size arround each break-point which have to be covered by at least one aligned short read
  meta:
    type: string
    label: "metadata. should begin with '#'"

steps:
  sv_filter:
    label: filters and annotates candidate somatic structural variations
    run: ../Tools/sv/sv-filter.cwl
    in:
      tumor: tumor
      name: name
      directory: directory
      reference: reference
      normal: normal
      min_junctions: sv_filter_min_junctions
      max_normal_read_pairs: sv_filter_max_normal_read_pairs
      min_overhang_size: sv_filter_min_overhang_size
    out: [out_sv, log]
  preprend_metadata:
    label: prepends metedata to the GenomonSV result
    run: ../Tools/sv/prepend-metadata.cwl
    in:
      meta: meta
      in_sv: sv_filter/out_sv
    out: [out_sv, log]
    
outputs:
  sv:
    type: File
    label: SV detection result
    outputSource: preprend_metadata/out_sv
  sv_filter_log:
    type: File
    outputSource: sv_filter/log
  prepend-metadata_log:
    type: File
    outputSource: preprend_metadata/log
