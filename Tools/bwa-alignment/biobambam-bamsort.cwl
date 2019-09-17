#!/usr/bin/env cwl-runner

class: CommandLineTool
id: biobambam-sort-0.0.191
label: biobambam-sort-0.0.191
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

hints:
  - class: DockerRequirement
    dockerPull: genomon/bwa_alignment:0.1.1

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

outputs:
  bam:
    type: File
    format: edam:format_2572
    outputBinding:
      glob: $(inputs.sam.nameroot).sorted.bam
  bai:
    type: File
    format: edam:format_3327
    outputBinding:
      glob: $(inputs.sam.nameroot).sorted.bam.bai
  log:
    type: stderr

stderr: $(inputs.sam.nameroot).sorted.bam.log

# the following annotations are taken from bamsort help
arguments:
  - # file name for BAM index file
    position: 1
    prefix: indexfilename=
    valueFrom: $(inputs.sam.nameroot).sorted.bam.bai
    separate: false
  - # output filename
    position: 2
    prefix: O=
    valueFrom: $(inputs.sam.nameroot).sorted.bam
    separate: false
  - # input format (bam,maussam,sam)
    position: 3
    prefix: inputformat=
    valueFrom: sam
    separate: false
  - # create BAM index (default: 0)
    position: 4
    prefix: index=
    valueFrom: "1"
    separate: false
  - # compression settings for output bam file
    # (-1=zlib default,0=uncompressed,1=fast,9=best)
    position: 5
    prefix: level=
    valueFrom: "1"
    separate: false
  - # input helper threads (for inputformat=bam only, default: 1)
    position: 6
    prefix: inputthreads=
    valueFrom: "2" # is it ok to fix this value?
    separate: false
  - # output helper threads (for outputformat=bam only, default: 1)
    position: 7
    prefix: outputthreads=
    valueFrom: "2" # is it ok to fix this value?
    separate: false
  - # calculate MD and NM aux fields (for coordinate sorted output only)
    position: 8
    prefix: calmdnm=
    valueFrom: "1"
    separate: false
  - # only recalculate MD and NM in the presence of indeterminate bases
    # (calmdnm=1 only)
    position: 9
    prefix: calmdnmrecompindentonly=
    valueFrom: "1"
    separate: false
