#!/usr/bin/env cwl-runner

class: CommandLineTool
id: mutation-call-mutfilter-simplerepeat
label: Annotates if a candidate is on the simplerepeat
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

hints:
  - class: DockerRequirement
    dockerPull: genomon/mutation_call:0.2.5
    
baseCommand: [ mutfilter, simplerepeat ]

inputs:
  in_mutation:
    type: File
    format: edam:data_3671
    label: mutation information
    inputBinding:
      position: 1
      prefix: --target_mutation_file
  database_directory:
    type: Directory
    label: directory containing simpleRepeat.bed.gz

outputs:
  out_mutation:
    type: File
    format: edam:data_3671
    outputBinding:
      glob: simplerepeat_mutations.txt
  log:
    type: stderr

stderr: simplerepeat_mutations.log

arguments:
  - position: 2
    prefix: --output
    valueFrom: simplerepeat_mutations.txt
  - position: 3
    prefix: --simple_repeat_db
    valueFrom: $(inputs.database_directory.path)/simpleRepeat.bed.gz
