#!/usr/bin/env cwl-runner

class: CommandLineTool
id: mutation-call-hotspotCall
label: Identifies mutations in cancer hotspot
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'genomon/mutation_call'

requirements:
  - class: ShellCommandRequirement

baseCommand: [ hotspotCall ]

inputs:
  name:
    type: string
    label: sample name
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
  tumor:
    type: File
    format: edam:format_2572
    inputBinding:
      position: 6
  normal:
    type: File
    format: edam:format_2572
    inputBinding:
      position: 7
  
outputs:
  txt:
    type: File
    outputBinding:
      glob: $(inputs.name).hotspot_mutations.txt
  log:
    type: stderr

stderr: $(inputs.name).hotspot_mutations.log

arguments:
  - position: 1
    valueFrom: $(inputs.name).hotspot_mutations.txt
  - position: 2
    valueFrom: $(inputs.hotspot_database_directory)/GRCh37_hotspot_database_v20170919.txt
