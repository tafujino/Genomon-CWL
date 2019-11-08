#!/usr/bin/env cwl-runner

class: Workflow
id: qc-wgs
label: QC for WGS data
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

inputs:
  bam:
    type: File
    format: edam:format_2572
    label: sample BAM aligned to the reference
    secondaryFiles:
      - .bai
  name:
    type: string
    label: sample name
  genome_size_file:
    type: File
  gap_text:
    type: File
  incl_bed_width:
    type: int?
    label: bps for normalize incl_bed (bedtools shuffle -incl)
  i_bed_lines:
    type: int?
    label: line number of target BED file
  i_bed_width:
    type: int?
    label: bps par 1 line, number of target BED file
  samtools_params:
    type: string?
    label: samtools parameters string
  coverage_text:
    type: string?
    label: coverage depth text separated with comma
  meta:
    type: string?
    label: "metadata. should begin with '#'"
    
steps:
  bamstats:
    run: ../Tools/qc/genomon_qc-bamstats.cwl
    in:
      bam: bam
      name: name
    out: [bamstats, log]
  wgs:
    run: ../Tools/qc/genomon_qc-wgs.cwl
    in:
      bam: bam
      name: name
      genome_size_file: genome_size_file
      gap_text: gap_text
      incl_bed_width: incl_bed_width
      i_bed_lines: i_bed_lines
      samtools_params: samtools_params
      coverage_text: coverage_text
    out: [coverage, log]
  merge:
    run: ../Tools/qc/genomon_qc-merge.cwl
    in:
      name: name
      meta: meta
    out: [result, log]
    
outputs:
  result:
    type: File
    outputSource: merge/result
  qc-bamstats_log:
    type: File
    outputSource: bamstats/log
  qc-wgs_log:
    type: File
    outputSource: wgs/log
  qc-merge_log:
    type: File
    outputSource: merge/log

    
