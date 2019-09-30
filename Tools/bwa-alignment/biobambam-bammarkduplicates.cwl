#!/usr/bin/env cwl-runner

class: CommandLineTool
id: biobambam-bammarkduplicates-0.0.191
label: biobambam-bammarkduplicates-0.0.191
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

hints:
  - class: DockerRequirement
    dockerPull: genomon/bwa_alignment:0.1.1

requirements:
  - class: EnvVarRequirement
    envDef:
      - envName: LD_LIBRARY_PATH
        envValue: /usr/local/lib
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
      separate: false
    doc: input BAM
  name:
    type: string
    label: sample name

outputs:
  markdupbam:
    type: File
    format: edam:format_2572
    outputBinding:
      glob: $(inputs.name).markdup.bam
  markdupbam_index:
    type: File
    format: edam:format_3327
    outputBinding:
      glob: $(inputs.name).markdup.bam.bai
  metrics:
    type: File
    outputBinding:
      glob: $(inputs.name).metrics
  log:
    type: stderr

stderr: $(inputs.name).markdup.bam.log

# the following annotations are taken from bammarkduplicates help
arguments:
  - # metrics file
    position: 2
    prefix: M=
    valueFrom: $(inputs.name).metrics
    separate: false
  - # output file
    position: 3
    prefix: O=
    valueFrom: $(inputs.name).markdup.bam
    separate: false
  - # number of helper threads
    position: 4
    prefix: markthreads=
    valueFrom: "2" # is it ok to fix this value?
    separate: false
  - # compression of temporary alignment file when input is via stdin
    # (0=snappy,1=gzip/bam,2=copy)
    position: 5
    prefix: rewritebam=
    valueFrom: "1"
    separate: false
  - # compression setting for rewritten input file if rewritebam=1
    # (-1=zlib default,0=uncompressed,1=fast,9=best)
    position: 6
    prefix: rewritebamlevel=
    valueFrom: "1"
    separate: false
  - # create BAM index (default: 0)
    position: 7
    prefix: index=
    valueFrom: "1"
    separate: false
  - # create md5 check sum (default: 0)
    position: 8
    prefix: md5=
    valueFrom: "1"
    separate: false
