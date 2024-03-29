#!/usr/bin/env cwl-runner

class: Workflow
id: bwa-alignment
label: Aligns FASTQs to a reference, generates BAM, and removes duplicate entries
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/
  
inputs:
  reference:
    type: File
    format: edam:format_1929
    label: FastA file for reference genome
    secondaryFiles:
      - .fai
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
  fastq1:
    type: File
    format: edam:format_1930
    label: FastQ file from next-generation sequencers
  fastq2:
    type: File
    format: edam:format_1930
    label: FastQ file from next-generation sequencers
  min_score:
    type: int
    label: minimum score to output
  nthreads:
    type: int
    label: number of cpu cores to be used for BWA MEM
  name:
    type: string
    label: sample name
    
steps:
  # directry piping to the next step without an intermediate file
  # is not currently supported by any of existing cwl runners
  bwa_mem:
    label: Mapping onto reference using BWA MEM
    run: ../Tools/bwa-alignment/bwa-mem.cwl
    in:
      reference: reference
      fastq1: fastq1
      fastq2: fastq2
      min_score: min_score
      nthreads: nthreads
      name: name
    out: [sam, log]
    
  bamsort:
    label: Sorts SAM by position and converts to BAM
    run: ../Tools/bwa-alignment/biobambam-bamsort.cwl
    in: 
      sam: bwa_mem/sam
      calmdnmreference: reference
    out: [bam, bai, log]

  bammarkduplicates:
    label: Detects duplicate BAM entries
    run: ../Tools/bwa-alignment/biobambam-bammarkduplicates.cwl
    in:
      bam: bamsort/bam
      name: name
    out: [markdupbam, metrics, log]

outputs:
  markdupbam:
    type: File
    format: edam:format_2572
    outputSource: bammarkduplicates/markdupbam
    secondaryFiles:
      - .bai
  bwa_mem_log:
    type: File
    format:
    outputSource: bwa_mem/log
  sortbam_log:
    type: File
    format:
    outputSource: bamsort/log
  metrics:
    type: File
    outputSource: bammarkduplicates/metrics
  bammarkduplicates_log:
    type: File
    outputSource: bammarkduplicates/log
