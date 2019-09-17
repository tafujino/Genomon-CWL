#!/usr/bin/env cwl-runner

class: Workflow
id: sv-parse
label: Parses breakpoint-containing and improperly aligned read pairs
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

inputs:
  bam:
    type: File
    format: edam:format_2572
    secondaryFiles:
      - .bai
  name:
    type: string
    label: sample name

steps:
  sv_parse:
    label: parses breakpoint-containing and improperly aligned read pairs
    run: ../Tools/sv/sv-parse.cwl
    in:
      bam: bam
      name: name
    out: [junction, junction_index, improper, improper_index, log]

outputs:
  junction:
    type: File
    outputSource: sv_parse/junction
  junction_index:
    type: File
    format: edam:format_3616
    outputSource: sv_parse/junction_index
  improper:
    type: File
    outputSource: sv_parse/improper
  improper_index:
    type: File
    format: edam:format_3616
    outputSource: sv_parse/improper_index
  sv_parse_log:
    type: File
    outputSource: sv_parse/log
