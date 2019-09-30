#!/usr/bin/env cwl-runner

class: CommandLineTool
id: biobambam-bamtofastq-main-0.0.191
label: Extracts FastQ from BAM using biobambam bamtofastq (main part)
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

baseCommand: [ bamtofastq ]

inputs:
  bam:
    doc: input BAM
    type: File
    streamable: true
    format: edam:format_2572
    inputBinding:
      prefix: filename=
      position: 1
      separate: false
  name:
    type: string
    label: sample name

outputs:
  fastq1:
    type: File
    format: edam:format_1930
    label: the first pair FastQ extracted from the given BAM
    outputBinding:
      glob: $(inputs.name).sequence1.fastq
  fastq2:
    type: File    
    format: edam:format_1930
    label: the second pair FastQ extracted from the given BAM
    outputBinding:
      glob: $(inputs.name).sequence2.fastq
  single:
    type: File
    format: edam:format_3671
    label: single end reads
    outputBinding:
      glob: $(inputs.name).single.txt
  orphan1:
    type: File
    format: edam:format_3671
    label: the first unmached pair
    outputBinding:
      glob: $(inputs.name).orphans1.txt
  orphan2:
    type: File
    format: edam:format_3671    
    label: the first unmached pair
    outputBinding:
      glob: $(inputs.name).orphans2.txt
  summary_tmp:    
    type: stderr
    format: edam:format_3671
    
stderr: $(inputs.name).bamtofastq.summary.txt.tmp

# the following annotations are taken from bamtofastq help
arguments:
  - # matched pairs first mates
    position: 2
    prefix: F=
    valueFrom: $(inputs.name).sequence1.fastq
    separate: false
  - # matched pairs second mates
    position: 3
    prefix: F2=
    valueFrom: $(inputs.name).sequence2.fastq
    separate: false
  - # temporary file name
    position: 4
    prefix: T=
    valueFrom: $(inputs.name).temp.txt
    separate: false
  - # single end
    position: 5
    prefix: S=
    valueFrom: $(inputs.name).single.txt
    separate: false
  - # unmatched pairs first mates
    position: 6
    prefix: O=
    valueFrom: $(inputs.name).orphans1.txt
    separate: false
  - # unmatched pairs second mates
    position: 7
    prefix: O2=
    valueFrom: $(inputs.name).orphans2.txt
    separate: false
