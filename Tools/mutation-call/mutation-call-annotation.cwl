#!/usr/bin/env cwl-runner

class: CommandLineTool
id: mutaton-call-annotation
label: Annotates
cwlVersion: v1.0

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerImageId: 'mutation-call-annotation.simg'
    
requirements:
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement
  - class: EnvVarRequirement
    envDef:
      - envName: ACTIVE_HGVD_2016_FLAG
        envValue: |-
          $(inputs.HGVD_2016 ? "True" : "False")
      - envName: ACTIVE_EXAC_2016_FLAG
        envValue: |-
          $(inputs.EXAC ? "True" : "False")
      - envName: ANNOTATION_DB
        envValue: $(inputs.database_directory.path)
      - envName: SAMPLE2_FLAG
        envValue: |-
          $(inputs.normal ? "True" : "False")

baseCommand: [ /usr/local/bin/mutation-call-annotation.sh ]

inputs:
  in_mutation:
    type: File
    format: edam:format_3671
    label: mutation information
    inputBinding:
      position: 1
  database_directory:
    type: Directory
    label: directory containing DBexome20160412.bed.gz and ExAC.r0.3.1.sites.vep.bed.gz
  HGVD_2016:
    type: boolean
    default: false
  EXAC:
    type: boolean
    default: false
  normal:
    type: boolean
    label: true iff normal sample exists
    default: false
  control:
    type: boolean
    default: false
  meta:
    type: string

outputs:
  out_mutation:
    type: File
    format: edam:format_3671
    outputBinding:
      glob: genomon_mutation.result.txt
  log:
    type: stderr

stderr: genomon_mutation.result.log