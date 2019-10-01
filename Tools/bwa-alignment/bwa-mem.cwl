#!/usr/bin/env cwl-runner

class: CommandLineTool
id: bwa-mem-0.7.8
label: bwa-mem-0.7.8
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

hints:
  - class: DockerRequirement
    dockerPull: genomon/bwa_alignment:0.1.1

requirements:
  - class: ResourceRequirement
    ramMin: 6300
    
baseCommand: [ /tools/bwa-0.7.8/bwa, mem ]

inputs:
  reference:
    type: File
    format: edam:format_1929
    label: FastA file for reference genome
    inputBinding:
      position: 1
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
  fastq1:
    type: File
    format: edam:format_1930
    inputBinding:
      position: 2
    label: FastQ file from next-generation sequencers
  fastq2:
    type: File
    format: edam:format_1930
    inputBinding:
      position: 3
    label: FastQ file from next-generation sequencers
  nthreads:
    type: int
    inputBinding:
      prefix: -t
      position: 4
    label: number of cpu cores to be used
  name:
    type: string
    label: sample name
  min_score: # should set default value?
    type: int
    label: minimum score to output
    inputBinding:
      prefix: -T
      position: 5

outputs:
  sam:
    type: stdout
    format: edam:format_2573
  log:
    type: stderr

stdout: $(inputs.name).sam
stderr: $(inputs.name).sam.log
