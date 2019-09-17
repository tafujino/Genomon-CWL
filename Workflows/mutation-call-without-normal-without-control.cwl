#!/usr/bin/env cwl-runner

class: Workflow
id: mutation-call-without-normal-without-control
label: Calls mutations only with tumor samples
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'
inputs:
  reference:
    type: File
    format: edam:format_1929
    label: FastA file for reference genome
    secondaryFiles:
      - .fai
  tumor:
    type: File
    format: edam:format_2572
    label: tumor sample BAM aligned to the reference
    secondaryFiles:
      - .bai

steps:
  fisher:
    label: "Fisher's exact test"
    run: ../Tools/mutation-call/fisher-single.cwl
    in:
      reference: reference
      tumor: tumor
    out: [out_mutation, log]

outputs:
  mutation:
    type: File
    format: edam:format_3671
    label: mutation call result
    outputSource: fisher/out_mutation
  fisher_log:
    type: File
    outputSource: fisher/log
    
