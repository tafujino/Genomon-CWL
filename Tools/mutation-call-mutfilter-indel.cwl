#!/usr/bin/env cwl-runner

class: CommandLineTool
id: mutation-call-mutfilter-indel
label: Annotates if the candidate is near indel
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'genomon/mutation_call:0.2.5'
    
requirements:
  - class: ShellCommandRequirement

baseCommand: [ mutfilter, indel ]

inputs:
  name:
    type: string
    label: sample name
  mutation:
    type: File
    format: edam:format_3671
    label: mutation information after realignment
    inputBinding:
      position: 1
      prefix: --target_mutation_file
  normal:
    type: File?
    format: edam:format_2572
    label: normal sample BAM aligned to the reference
    inputBinding:
      position: 2
      prefix: "-2"
  search_length:
    type: int?
    inputBinding:
      position: 3
      prefix: --search_length
  neighbor:
    type: int?
    inputBinding:
      position: 4
      prefix: --neighbor
  min_depth:
    type: int?
    inputBinding:
      position: 5
      prefix: --min_depth
  min_mismatch:
    type: int?
    inputBinding:
      position: 6
      prefix: --min_mismatch
  allele_frequency_threshold:
    type: int?
    inputBinding:
      position: 7
      prefix: --af_thres
  samtools_params:
    type: string?
    inputBinding:
      position: 3
      prefix: --samtools_params
  
outputs:
  txt:
    type: File
    format: edam:format_3671
    label: indel mutation information
    outputBinding:
      glob: $(inputs.name).indel_mutations.txt
  log:
    type: stderr

stderr: $(inputs.name).indel_mutations.log

arguments:
  - position: 1
    prefix: --output
    valueFrom: $(inputs.name).indel_mutations.txt
  - position: 2
    prefix: --samtools_path
    valueFrom: /usr/local/bin/samtools
