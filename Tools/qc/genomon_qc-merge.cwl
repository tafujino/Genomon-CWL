#!/usr/bin/env cwl-runner

class: CommandLineTool
id: genomon_qc-merge
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

requirements:
  - class: ShellCommandRequirement  

hints:
  - class: DockerRequirement
    dockerPull: genomon/genomon_qc:0.1.0

baseCommand: [ genomon_qc, merge ]

inputs:
  name:
    type: string
    label: sample name
  bamstats:
    type: File
    inputBinding:
      position: 1
  coverage:
    type: File
    inputBinding:
      position: 2
  meta:
    type: string?
    label: "metadata. should begin with '#'"
    inputBinding:
      prefix: --meta
      
arguments:
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
    
