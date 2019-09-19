#!/usr/bin/env cwl-runner

class: CommandLineTool
id: sv-parse-0.6.0rc1
label: parses breakpoint-containing and improperly aligned read pairs
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

hints:
  - class: DockerRequirement
    dockerPull: genomon/genomon_sv:0.1.0

baseCommand: [ GenomonSV, parse ]

inputs:
  bam:
    type: File
    format: edam:format_2572
    secondaryFiles:
      - .bai
    inputBinding:
      position: 1
  name:
    type: string
    label: sample name
    inputBinding:
      position: 2

outputs:
  junction:
    type: File
    outputBinding:
      glob: $(inputs.name).junction.clustered.bedpe.gz
  junction_index:
    type: File
    format: edam:format_3616
    outputBinding:
      glob: $(inputs.name).junction.clustered.bedpe.gz.tbi
  improper:
    type: File
    outputBinding:
      glob: $(inputs.name).improper.clustered.bedpe.gz
  improper_index:
    type: File
    format: edam:format_3616
    outputBinding:
      glob: $(inputs.name).improper.clustered.bedpe.gz.tbi
  log:
    type: stderr

stderr: $(inputs.name).sv_parse.log

