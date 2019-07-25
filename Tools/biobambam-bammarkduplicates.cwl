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
  outdir:
    type: Directory
    label: output directory
  sample:
    type: string
    label: sample name

outputs:
  markdupbam:
    type: File
    format: edam:format_2572
    outputBinding:
      glob: $(inputs.sample).markdup.bam
  metrics:
    type: File
    outputBinding:
      glob: $(inputs.sample).metrics
  log:
    type: stderr

stderr: $(markdupbam).log

# the following annotations are taken from bammarkduplicates help
arguments:
  - # metrics file
    position: 1
    prefix: M=
    valueFrom: metrics
    separate: false
  - # output file
    position: 2
    prefix: O=
    valueFrom: markdupbam
    separate: false
  - # number of helper threads
    position: 3
    prefix: markthreads=
    valueFrom: "2" # is is ok to fix this value?
    separate: false
  - # compression of temporary alignment file when input is via stdin
    # (0=snappy,1=gzip/bam,2=copy)
    position: 4
    prefix: rewritebam=
    valueFrom: "1"
    separate: false
  - # compression setting for rewritten input file if rewritebam=1
    # (-1=zlib default,0=uncompressed,1=fast,9=best)
    position: 5
    prefix: rewritebamlevel=
    valueFrom: "1"
    separate: false
  - # create BAM index (default: 0)
    position: 6
    prefix: index=
    valueFrom: "1"
    separate: false
  - # create md5 check sum (default: 0)
    position: 7
    prefix: md5=
    valueFrom: "1"
    separate: false
