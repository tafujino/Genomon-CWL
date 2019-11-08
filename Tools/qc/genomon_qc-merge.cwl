#!/usr/bin/env cwl-runner

class: CommandLineTool
id: genomon_qc-merge:0.1.0
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

requirements:
  - class: ShellCommandRequirement  

hints:
  - class: DockerRequirement
    dockerPull: genomon/genomon_sv:0.1.0

baseCommand: [ genomon_qc, merge ]

inputs:
  name:
    type: string
    label: sample name
  meta:
    type: string?
    label: "metadata. should begin with '#'"
    inputBinding:
      type: string
      prefix: --meta
      
arguments:
  - position: 1
    valueFrom: $(inputs.name).coverage
  - position: 2
    valueFrom: $(inputs.name).bamstats
  - position: 3
    valueFrom: $(inputs.name).genomonQC.result.txt

outputs:
  result:
    type: File
    outputBinding:
      glob: $(inputs.name).genomonQC.result.txt
  log:
    type: stderr

stderr: genomon_qc-merge.log
    
