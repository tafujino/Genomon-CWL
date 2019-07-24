#!/usr/bin/env cwl-runner

class: CommandLineTool
id: biobambam-bammarkduplicates-0.0.191
label: biobambam-bammarkduplicates-0.0.191
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'genomon/bwa_alignment'

requirements:
  - class: ShellCommandRequirement
#  - class: ResourceRequirement
#    ramMin: 6300
    
baseCommand: [ bammarkduplicates ]

inputs:
  bam:
    type: File
    format: edam:format_2572
    inputBinding:
      prefix: I=
      position: 1
    doc: input BAM
  outprefix:
    type: string
#  nthreads:
#    type: int
#    inputBinding:
#      prefix: -t
#      position: 3
#    doc: number of cpu cores to be used

outputs:
  markdupbam:
    type: File
    format: edam:format_2572
    outputBinding:
      glob: $(inputs.outprefix).markdup.bam
  metrics:
    type: File
    outputBinding:
      glob: $(inputs.outprefix).metrics
  log:
    type: stderr

stderr: $(inputs.outprefix).markdup.bam.log
    
arguments:
  - position: 1
    prefix: M=
    valueFrom: $(inputs.outprefix).metrics
  - position: 2
    prefix: O=
    valueFrom: $(inputs.outprefix).markdup.bam
  - position: 3
    prefix: markthreads=
    valueFrom: "2" # is is ok to fix this value?
  - position: 4
    prefix: rewritebam=
    valueFrom: "1"
  - position: 5
    prefix: rewritebamlevel=
    valueFrom: "1"
  - position: 6
    prefix: index=
    valueFrom: "1"
  - position: 7
    prefix: md5=
    valueFrom: "1"
