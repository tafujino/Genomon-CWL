#!/usr/bin/env cwl-runner

class: CommandLineTool
id: mutation-call-hotspot
label: Identifies mutations in cancer hotspot
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'genomon/mutation_call:0.2.5'

requirements:
  - class: ShellCommandRequirement

baseCommand: [ hotspotCall ]

inputs:
  name:
    type: string
    label: sample name
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
    label: directory containing hotspot_mutations.txt
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
  txt:
    type: File
    format: edam:format_3671
    outputBinding:
      glob: $(inputs.name).hotspot_mutations.txt
  log:
    type: stderr

stderr: $(inputs.name).hotspot_mutations.log

arguments:
  - position: 1
    valueFrom: $(inputs.tumor.path)
  - position: 1
    valueFrom: $(inputs.control.path)
  - position: 3
    valueFrom: $(inputs.name).hotspot_mutations.txt
  - position: 4
    valueFrom: $(inputs.database_directory.path)/GRCh37_hotspot_database_v20170919.txt