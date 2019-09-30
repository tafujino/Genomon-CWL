#!/usr/bin/env cwl-runner

class: CommandLineTool
id: biobambam-bamtofastq-postprocess-0.0.191
label: Extracts FastQ from BAM using biobambam bamtofastq (postprocess part)
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

# this is probably unnecessary  
hints:
  - class: DockerRequirement
    dockerPull: genomon/bwa_alignment:0.1.1

requirements:
#  - class: ResourceRequirement
#    ramMin: -
baseCommand: [ grep ]

inputs:
  summary_tmp: 
    doc: bamtofastq summary file. The file extension is supposed to be .tmp
    type: File
    format: edam:format_3671
    inputBinding:
      position: 1

outputs:
  summary:
    type: stdout
    format: edam:format_3671
    
stdout: $(inputs.summary_tmp.nameroot)

arguments:
  - position: 2
    prefix: -E
    valueFrom: ^\[C\]

# success even if exit code is 1 (empty match)
successCodes: [0, 1]
