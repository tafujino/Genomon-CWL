#!/usr/bin/env cwl-runner

class: CommandLineTool
id: mutation-call-mutfilter-breakpoint
label: Annotates if the candidate is near the breakpoint
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

hints:
  - class: DockerRequirement
    dockerPull: genomon/mutation_call:0.2.5
    
baseCommand: [ mutfilter, breakpoint ]

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
  max_depth:
    type: int?
    inputBinding:
      position: 3
      prefix: --max_depth
  min_clip_size:
    type: int?
    inputBinding:
      position: 4
      prefix: --min_clip_size
  junction_num_threshold:
    type: int?
    inputBinding:
      position: 5
      prefix: --junc_num_thres
  mapq_threshold:
    type: int?
    inputBinding:
      position: 6
      prefix: --mapq_thres
  exclude_sam_flags:
    type: int?
    inputBinding:
      position: 7
      prefix: --exclude_sam_flags

outputs:
  out_mutation:
    type: File
    format: edam:format_3671
    label: mutation information annotated with breakpoint information
    outputBinding:
      glob: breakpoint_mutations.txt
  log:
    type: stderr

stderr: breakpoint_mutations.log

arguments:
  - position: 8
    prefix: --output
    valueFrom: breakpoint_mutations.txt
