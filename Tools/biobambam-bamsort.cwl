#!/usr/bin/env cwl-runner

class: CommandLineTool
id: biobambam-sort-0.0.191
label: biobambam-sort-0.0.191
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'genomon/bwa_alignment'

requirements:
  - class: ShellCommandRequirement
#  - class: ResourceRequirement
#    ramMin: -
  - class: EnvVarRequirement
    envDef:
      - envName: LD_LIBRARY_PATH
        envValue: /usr/local/lib
baseCommand: [ bamsort ]

inputs:
  sam:
    doc: input SAM
    type: File
    streamable: true
    format: edam:format_2573
    inputBinding:
      prefix: I=
      position: 1
      separate: false
  calmdnmreference:
    doc: reference for calculating MD and NM aux fields
    type: File
    format: edam:format_1929
    inputBinding:
      prefix: calmdnmreference=
      position: 2
      separate: false
    secondaryFiles:
      - .fai
#  nthreads:
#    type: int
#    inputBinding:
#      prefix: -t
#      position: 4
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
    outputBinding:
      glob: $(inputs.outprefix).sorted.bam.bai
  log:
    type: stderr

stderr: $(inputs.outprefix).sorted.bam.log

arguments:
  - position: 1
    prefix: indexfilename=
    valueFrom: $(inputs.outprefix).sorted.bam.bai
    separate: false
  - position: 2
    prefix: O=
    valueFrom: $(inputs.outprefix).sorted.bam
    separate: false
  - position: 3
    prefix: inputformat=
    valueFrom: sam
    separate: false
  - position: 4
    prefix: index=
    valueFrom: "1"
    separate: false
  - position: 5
    prefix: level=
    valueFrom: "1"
    separate: false
  - position: 6
    prefix: inputthreads=
    valueFrom: "2" # is is ok to fix this value?
    separate: false
  - position: 7
    prefix: outputthreads=
    valueFrom: "2" # is is ok to fix this value?
    separate: false
  - position: 8
    prefix: calmdnm=
    valueFrom: "1"
    separate: false
  - position: 9
    prefix: calmdnmrecompindentonly=
    valueFrom: "1"
    separate: false
