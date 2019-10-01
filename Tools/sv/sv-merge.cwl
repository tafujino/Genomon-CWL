#!/usr/bin/env cwl-runner

class: CommandLineTool
id: sv-merge-0.6.0rc1
label: merges non-matched control panel breakpoint-containing read pairs
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

hints:
  - class: DockerRequirement
    dockerPull: genomon/genomon_sv:0.1.0

baseCommand: [ GenomonSV, merge ]

inputs:
  control_info:
    type: File
    label: tab-delimited file on non-matched control
    doc: |
      The 1st column is sample label for each breakpoint information file,
      and can be freely specified. The 2nd column is the output_prefix generated
      at the above parse stage (GenomonSV merge program assumes each
      {output_prefix}.junction.clustered.bedpe.gz file is already generated).
    inputBinding:
      position: 1
  name:
    type: string
    label: control panel name
  merge_check_margin_size:
    type: int?
    doc: |
      this value should be at least 50 (more than the length of possible
      inserted sequence between break points)
    inputBinding:
      position: 3
      valueFrom: --merge_check_margin_size

outputs:
  merge:
    type: File
    outputBinding:
      glob: $(inputs.name).merged.junction.control.bedpe.gz
  log:
    type: stderr

stderr: $(inputs.name).merged.junction.control.log

arguments:
  - position: 2
    valueFrom: $(inputs.name).merged.junction.control.bedpe.gz
      
      
