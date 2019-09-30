#!/usr/bin/env cwl-runner

class: CommandLineTool
id: mutaton-call-mutil-filter
label: Filters candidates
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

hints:
  - class: DockerRequirement
    dockerPull: genomon/mutation_call:0.2.5
    
baseCommand: [ mutil, filter ]

inputs:
  in_mutation:
    type: File
    format: edam:format_3671
    label: mutation result before filtering
    inputBinding:
      position: 1
      prefix: -i
  database_directory:
    type: Directory?
    label: directory containing GRCh37_hotspot_database_v20170919.txt
    inputBinding:
      position: 2
      prefix: --hotspot_db
      valueFrom: $(inputs.database_directory.path)/GRCh37_hotspot_database_v20170919.txt
  post10q:
    type: double?
    label: 10% posterior quantile
  realignment_post10q:
    type: double?
    label: realignment 10% posterior quantile
  count:
    type: int?
    label: read count
  tcount:
    type: int?
    label: read count of tumor
  ncount:
    type: int?
    label: read count of normal
  fisher_p_value:
    type: double?
    label: Fisher test P-value
  realign_p_value:
    type: double?
    label: realignment Fisher test P-value
  ebcall_p_value: # is it really needed?
    type: double?
    label: EBCall P-value

outputs:
  out_mutation:
    type: File
    format: edam:format_3671
    outputBinding:
      glob: genomon_mutation.result.filt.txt
  log:
    type: stderr

stderr: genomon_mutation.result.filt.log
    
arguments:
  - position: 3
    prefix: -o
    valueFrom: genomon_mutation.result.filt.txt
