#!/usr/bin/env cwl-runner

class: Workflow
id: biobambam-bamtofastq
label: Extracts FASTQ from BAM
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

inputs:
  bam:
    doc: input BAM
    type: File
    format: edam:format_2572
  name:
    type: string
    label: sample name

steps:
  main:
    label: Extracts FASTQ from BAM
    run: ../Tools/bwa-alignment/biobambam-bamtofastq-main.cwl
    in:
      bam: bam
      name: name
    out: [fastq1, fastq2, single, orphan1, orphan2, summary_tmp]
  postprocess:
    label: Generates summary text
    run: ../Tools/bwa-alignment/biobambam-bamtofastq-postprocess.cwl
    in:
      summary_tmp: main/summary_tmp
    out: [summary]

outputs:
  fastq1:
    type: File
    format: edam:format_1930
    label: the first pair FastQ extracted from the given BAM
    outputSource: main/fastq1
  fastq2:
    type: File    
    format: edam:format_1930
    label: the second pair FastQ extracted from the given BAM
    outputSource: main/fastq2
  single:
    type: File
    format: edam:data_3671
    label: single end reads
    outputSource: main/single
  orphan1:
    type: File
    format: edam:data_3671
    label: the first unmatched pair
    outputSource: main/orphan1
  orphan2:
    type: File
    format: edam:data_3671    
    label: the second unmatched pair
    outputSource: main/orphan2
  summary:    
    type: File
    format: edam:data_3671
    outputSource: postprocess/summary
