#!/usr/bin/env cwl-runner

class: CommandLineTool
id: genomon_qc-bamstats
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

hints:
  - class: DockerRequirement
    dockerPull: genomon/genomon_qc:0.1.0

baseCommand: [ genomon_qc, bamstats ]

inputs:
  bam:
    type: File
    format: edam:format_2572
    label: sample BAM aligned to the reference
    secondaryFiles:
      - .bai
    inputBinding:
      position: 1
  name:
    type: string
    label: sample name

outputs:
  bamstats:
    type: File
    outputBinding:
      glob: $(inputs.name).bamstats
  log:
    type: stderr

stderr: genomon_qc-bamstats.log

arguments:
  - position: 2
    # './' is necessary
    # see https://github.com/Genomon-Project/GenomonQC/blob/v2.0.2a/scripts/genomon_qc/run.py#L114
    valueFrom: ./$(inputs.name).bamstats
  - position: 3
    prefix: --perl5lib
    valueFrom: /tools/ICGC/lib/perl5:/tools/ICGC/lib/perl5/x86_64-linux-gnu-thread-multi
  - position: 4
    prefix: --bamstats
    valueFrom: /tools/ICGC/bin/bam_stats.pl
