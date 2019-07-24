#!/usr/bin/env cwl-runner

class: CommandLineTool
id: biobambam-sort-0.0.191
label: biobambam-sort-0.0.191
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'biobambam:0.0.191'

requirements:
  - class: ShellCommandRequirement
#  - class: ResourceRequirement
#    ramMin: 6300
    
baseCommand: [ bamsort ]

inputs:
  sam:
    type: File
    format: edam:format_2573
    inputBinding:
      prefix: I=
      position: 1
    doc: input SAM
  calmdnmreference:
    type: File
    format: edam:format_1929
    inputBinding:
      prefix: calmdnmreference=
      position: 2
    doc: reference for calculating MD and NM aux fields
#  nthreads:
#    type: int
#    inputBinding:
#      prefix: -t
#      position: 3
#    doc: number of cpu cores to be used
  outprefix:
    type: string

outputs:
  bam:
    type: File
    format: edam:format_2572
    outputBinding:
      glob: $(inputs.outprefix).sorted.bam
  bai:
    type: File
    format: edam:format_3327
  log:
    type: stderr

stderr: $(inputs.outprefix).sorted.bam.log

arguments:
  - position: 1
    prefix: indexfilename=
    valueFrom: $(inputs.outprefix).sorted.bam.bai
  - position: 2
    prefix: O=
    valueFrom: $(inputs.outprefix).sorted.bam
  - position: 3
    prefix: inputformat=
    valueFrom: sam
  - position: 4
    prefix: index=
    valueFrom: "1"
  - position: 5
    prefix: level=
    valueFrom: "1"
  - position: 6
    prefix: inputthreads=
    valueFrom: "2" # is is ok to fix this value?
  - position: 7
    prefix: outputthreads=
    valueFrom: "2" # is is ok to fix this value?
  - position: 8
    prefix: calmdnm=
    valueFrom: "1"
  - position: 9
    prefix: calmdnmrecompindentonly=
    valueFrom: "1"
