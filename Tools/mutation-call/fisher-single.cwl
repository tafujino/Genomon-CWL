#!/usr/bin/env cwl-runner

class: CommandLineTool
id: mutation-call-fisher-comparison
label: "Fisher's exact test (tumor only) in mutation call"
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

hints:
  - class: DockerRequirement
    dockerPull: genomon/mutation_call:0.2.5

baseCommand: [ fisher, single ]

inputs:
  reference:
    type: File
    format: edam:format_1929
    label: FastA file for reference genome
    secondaryFiles:
      - .fai
    inputBinding:
      position: 1
      prefix: --ref_fa
  tumor:
    type: File
    format: edam:format_2572
    label: tumor sample BAM aligned to the reference
    inputBinding:
      position: 2
      prefix: "-1"
  min_depth:
    type: int?
    label: the minimum depth
    inputBinding:
      position: 3
      prefix: --min_depth
  base_quality:
    type: int?
    label: base quality threshold
    inputBinding:
      position: 4
      prefix: --base_quality
  min_variant_read:
    type: int?
    label: the minimum variant read
    inputBinding:
      position: 5
      prefix: --min_variant_read
  min_allele_freq:
    type: double?
    label: the minimum amount of disease allele frequency
    inputBinding:
      position: 6
      prefix: --min_allele_freq
  10_percent_posterior_quantile_threshold:
    type: double?
    label: 10 percent posterior quantile threshold
  interval_list:
    type: File?
    format: edam:format_3671
    label: pileup regions list
    inputBinding:
      position: 7
      prefix: -L
  samtools_params:
    type: string?
    label: samtools parameters string
    inputBinding:
      position: 8
      prefix: --samtools_params

outputs:
  out_mutation:
    type: File
    format: edam:format_3671
    outputBinding:
      glob: fisher_mutations.txt
  log:
    type: stderr

stderr: fisher_mutations.log

arguments:
  - position: 9
    prefix: -o
    valueFrom: fisher_mutations.txt
  - position: 10
    prefix: --samtools_path
    valueFrom: /usr/local/bin/samtools

    
