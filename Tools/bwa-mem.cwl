#!/usr/bin/env cwl-runner

class: CommandLineTool
id: bwa-mem-0.7.8
label: bwa-mem-0.7.8
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'biocontainers/bwa:v0.7.12_cv3'

requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 6300
    
baseCommand: [ bwa, mem ]

inputs:
  reference:
    type: File
    format: edam:format_1929
    inputBinding:
      position: 4
    doc: FastA file for reference genome
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
      position: 5
    doc: FastQ file from next-generation sequencers
  fastq2:
    type: File
    format: edam:format_1930
    inputBinding:
      position: 6
    doc: FastQ file from next-generation sequencers
  nthreads:
    type: int
    inputBinding:
      prefix: -t
      position: 3
    doc: number of cpu cores to be used
  outprefix:
    type: string

outputs:
  sam:
    type: stdout
    format: edam:format_2573
  log:
    type: stderr

stdout: $(inputs.outprefix).sam
stderr: $(inputs.outprefix).sam.log
    
arguments:
  - position: 1
    prefix: -T # minimum score to output
    valueFrom: "0"

