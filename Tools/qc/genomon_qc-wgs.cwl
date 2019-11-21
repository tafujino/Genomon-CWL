#!/usr/bin/env cwl-runner

class: CommandLineTool
id: genomon_qc-wgs
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

hints:
  - class: DockerRequirement
    dockerPull: genomon/genomon_qc:0.1.0

baseCommand: [ genomon_qc, wgs ]

inputs:
  bam:
    type: File
    format: edam:format_2572
    label: sample BAM aligned to the reference
    secondaryFiles:
      - .bai
    inputBinding:
      position: 1
  name:
    type: string
    label: sample name
  genome_size_file:
    type: File
    inputBinding:
      position: 3
      prefix: --genome_size_file
  gap_text:
    type: File
    inputBinding:
      position: 4
      prefix: --gaptxt
  incl_bed_width:
    type: int?
    label: bps for normalize incl_bed (bedtools shuffle -incl)
    inputBinding:
      position: 5
      prefix: --incl_bed_width
  i_bed_lines:
    type: int?
    label: line number of target BED file
    inputBinding:
      position: 7
      prefix: --i_bed_lines
  i_bed_width:
    type: int?
    label: bps par 1 line, number of target BED file
    inputBinding:
      position: 8
      prefix: --i_bed_width    
  samtools_params:
    type: string?
    label: samtools parameters string
    inputBinding:
      position: 12
      prefix: --samtools_params
  coverage_text:
    type: string
    label: coverage depth text separated with comma
    inputBinding:
      position: 13
      prefix: --coverage_text
      
arguments:
  - position: 2
    # './' is necessary
    # see https://github.com/Genomon-Project/GenomonQC/blob/v2.0.2a/scripts/genomon_qc/run.py#L114
    valueFrom: ./$(inputs.name).coverage
  - position: 9
    prefix: --ld_library_path
    valueFrom: /usr/local/bin
  - position: 10
    prefix: --bedtools
    valueFrom: /usr/local/bin/bedtools
  - position: 11
    prefix: --samtools
    valueFrom: /usr/local/bin/samtools
  - position: 14
    prefix: --del_tempfile
    valueFrom: "True" # not boolean, but string

outputs:
  coverage:
    type: File
    outputBinding:
      glob: $(inputs.name).coverage
  log:
    type: stderr

stderr: genomon_qc-wgs.log
