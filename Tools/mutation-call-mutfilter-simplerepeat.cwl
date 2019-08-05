#!/usr/bin/env cwl-runner

class: CommandLineTool
id: mutation-call-mutfilter-simplerepeat
label: Annotates if the candidate is on the simplerepeat
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'genomon/mutation_call:0.2.5'
    
requirements:
  - class: ShellCommandRequirement

baseCommand: [ mutfilter, simplerepeat ]

inputs:
  name:
    type: string
    label: sample name
  mutation:
    type: File
    format: edam:format_3671
    label: mutation information
    inputBinding:
      position: 1
      prefix: --target_mutation_file
  database_directory:
    type: Directory
    label: directory containing simpleRepeat.bed.gz

outputs:
  txt:
    type: File
    format: edam:format_3671
    outputBinding:
      glob: $(inputs.name).simplerepeat_mutations.txt
  log:
    type: stderr

stderr: $(inputs.name).simplerepeat_mutations.log

arguments:
  - position: 1
    prefix: --output
    valueFrom: $(inputs.name).simplerepeat_mutations.txt
  - position: 2
    prefix: --simple_repeat_db
    valueFrom: $(inputs.database_directory.path)/simpleRepeat.bed.gz
