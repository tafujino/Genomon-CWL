#!/usr/bin/env cwl-runner

class: CommandLineTool
id: prepend-metadata
label: prepends metedata to the GenomonSV result
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

requirements:
  - class: ShellCommandRequirement  

hints:
  - class: DockerRequirement
    dockerPull: genomon/genomon_sv:0.1.0

baseCommand: [ sed ]

inputs:
  meta:
    type: string
    label: "metadata. should begin with '#'"
  in_sv:
    type: File
    label: SV information

outputs:
  out_sv:
    type: stdout
  log:
    type: stderr

stdout: $(inputs.in_sv.nameroot).metadata.txt
stderr: $(inputs.in_sv.nameroot).metadata.log

arguments:
  - position: 1
    valueFrom: 1i$(inputs.meta)
  - position: 2
    valueFrom: $(inputs.in_sv.path)
