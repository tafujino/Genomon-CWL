#!/usr/bin/env cwl-runner

class: CommandLineTool
id: mutation-call-merge
label: "Merges hotspot information to Fisher's exact test result"
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

hints:
  - class: DockerRequirement
    dockerPull: genomon/mutation_call:0.2.5

requirements:
  - class: ShellCommandRequirement

baseCommand: [ mutil, merge_hotspot ]

inputs:
  hotspot_mutation:
    type: File
    format: edam:format_3671
    label: GenomonHotspotCall result
    inputBinding:
      position: 1
      prefix: -i
  fisher_mutation:
    type: File
    format: edam:format_3671
    label: GenomonFisher comparison result
    inputBinding:
      position: 2
      prefix: -f      
  
outputs:
  out_mutation:
    type: File
    format: edam:format_3671
    label: "Fisher's exact test result with hotspot information"
    outputBinding:
      glob: fisher_hotspot_mutations.txt
  log:
    type: stderr

stderr: fisher_hotspot_mutations.log

arguments:
  - position: 1
    prefix: -o
    valueFrom: fisher_hotspot_mutations.txt
  - # this option REMOVEs the header from hotspot result file
    position: 2
    valueFrom: --hotspot_header
