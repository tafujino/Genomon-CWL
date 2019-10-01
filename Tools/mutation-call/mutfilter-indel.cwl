#!/usr/bin/env cwl-runner

class: CommandLineTool
id: mutation-call-mutfilter-indel
label: Annotates if the candidate is near indel
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

requirements:
  - class: ShellCommandRequirement # samtools_params should be quoted

hints:
  - class: DockerRequirement
    dockerPull: genomon/mutation_call:0.2.5
    
baseCommand: [ mutfilter, indel ]

inputs:
  in_mutation:
    type: File
    format: edam:format_3671
    label: mutation information
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
      position: 8
      prefix: --samtools_params
  
outputs:
  out_mutation:
    type: File
    format: edam:format_3671
    label: indel mutation information
    outputBinding:
      glob: indel_mutations.txt
  log:
    type: stderr

stderr: indel_mutations.log

arguments:
  - position: 9
    prefix: --output
    valueFrom: indel_mutations.txt
  - position: 10
    prefix: --samtools_path
    valueFrom: /usr/local/bin/samtools
