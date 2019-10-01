#!/usr/bin/env cwl-runner

class: CommandLineTool
id: mutation-call-hotspot
label: Identifies mutations in cancer hotspot
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

requirements:
  - class: ShellCommandRequirement # samtools_params should be quoted

hints:
  - class: DockerRequirement
    dockerPull: genomon/mutation_call:0.2.5

baseCommand: [ hotspotCall ]

inputs:
  tumor:
    type: File
    format: edam:format_2572
    secondaryFiles:
      - .bai
  control:
    type: File
    format: edam:format_2572
    secondaryFiles:
      - .bai
  database_directory:
    type: Directory
    label: directory containing GRCh37_hotspot_database_v20170919.txt
  min_tumor_misrate:
    type: double?
    label: the minimum amount of tumor allele frequency
    inputBinding:
      position: 1
      prefix: -t
  max_control_misrate:
    type: double?
    label: the maximum amount of control allele frequency
    inputBinding:
      position: 2
      prefix: -c
  TN_ratio_control:
    type: double?
    label: the maximum value of the ratio between normal and tumor
    inputBinding:
      position: 3
      prefix: -R
  min_lod_score:
    type: double?
    label: the minimum lod score
    inputBinding:
      position: 4
      prefix: -m
  samtools_params:
    type: string?
    label: SAMtools parameters given to GenomonHotspotCall
    inputBinding:
      position: 5
      prefix: -S
  
outputs:
  out_mutation:
    type: File
    format: edam:format_3671
    outputBinding:
      glob: hotspot_mutations.txt
  log:
    type: stderr

stderr: hotspot_mutations.log

arguments:
  - position: 6
    valueFrom: $(inputs.tumor.path)
  - position: 7
    valueFrom: $(inputs.control.path)
  - position: 8
    valueFrom: hotspot_mutations.txt
  - position: 9
    valueFrom: $(inputs.database_directory.path)/GRCh37_hotspot_database_v20170919.txt
