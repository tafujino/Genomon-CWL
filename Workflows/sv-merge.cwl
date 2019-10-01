#!/usr/bin/env cwl-runner

class: Workflow
id: sv-merge
label: merges non-matched control panel breakpoint-containing read pairs
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

inputs:
  control_info:
    type: File
    label: tab-delimited file on non-matched control
    doc: |
      The 1st column is sample label for each breakpoint information file,
      and can be freely specified. The 2nd column is the output_prefix generated
      at the above parse stage (GenomonSV merge program assumes each
      {output_prefix}.junction.clustered.bedpe.gz file is already generated).
  name:
    type: string
    label: control panel name
  merge_check_margin_size:
    type: int?
    doc: |
      this value should be at least 50 (more than the length of possible
      inserted sequence between break points)

steps:
  sv_merge:
    label: merges non-matched control panel breakpoint-containing read pairs
    run: ../Tools/sv/sv-merge.cwl
    in:
      control_info: control_info
      name: name
      merge_check_margin_size: merge_check_margin_size
    out:
      [merge, log]

outputs:
  merge:
    type: File
    label: merged breakpoint information file
    outputSource: sv_merge/merge
  log:
    type: File
    outputSource: sv_merge/log
