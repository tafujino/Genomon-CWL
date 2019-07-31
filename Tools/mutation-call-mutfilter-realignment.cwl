#!/usr/bin/env cwl-runner

class: CommandLineTool
id: mutation-call-mutfilter-realignment
label: Local realignment using blat. The candidate mutations are validated.
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'genomon/mutation_call:0.2.5'
    
requirements:
  - class: ShellCommandRequirement

baseCommand: [ mutfilter, realignment ]

inputs:
  name:
    type: string
    label: sample name
  reference:
    type: File
    format: edam:format_1929
    label: FastA file for reference genome
    inputBinding:
      position: 1
      prefix: --ref_genome
  mutation:
    type: File
    format: edam:format_3671
    label: Fisher's exact test result, possibly with hotspot information
    inputBinding:
      position: 2
      prefix: --target_mutation_file
  tumor:
    type: File
    format: edam:format_2572
    label: tumor sample BAM aligned to the reference
    inputBinding:
      position: 3
      prefix: "-1"
  normal:
    type: File?
    format: edam:format_2572
    label: normal sample BAM aligned to the reference
    inputBinding:
      position: 4
      prefix: "-2"
  tumor_min_mismatch:
    type: int?
    inputBinding:
      position: 5
      prefix: --tumor_min_mismatch
  normal_max_mismatch:
    type: int?
    inputBinding:
      position: 6
      prefix: --normal_max_mismatch
  score_difference:
    type: int?
    inputBinding:
      position: 7
      prefix: --score_difference
  window_size:
    type: int?
    inputBinding:
      position: 8
      prefix: --window_size
  max_depth:
    type: int?
    inputBinding:
      position: 9
      prefix: --max_depth
  exclude_sam_flags:
    type: int?
    inputBinding:
      position: 10
      prefix: --exclude_sam_flags
  nthreads:
    type: int?
    label: number of threads
    inputBinding:
      position: 11
      prefix: --thread_num
  
outputs:
  txt:
    type: File
    format: edam:format_3671
    label: Fisher's exact test result with hotspot information
    outputBinding:
      glob: $(inputs.name).realignment_mutations.txt 
  log:
    type: stderr

stderr: $(inputs.name).realignment_mutations.log

arguments:
  - position: 1
    prefix: --output
    valueFrom: $(inputs.name).realignment_mutations.txt 
  - position: 2
    prefix: --blat_path
    valueFrom: /tools/userApps/bin/blat
