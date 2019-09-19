#!/usr/bin/env cwl-runner

class: CommandLineTool
id: sv_utils-0.5.1
label: filters out GenomonSV results outside specified conditions
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

hints:
  - class: DockerRequirement
    dockerPull: genomon/genomon_sv:0.1.0

baseCommand: [ sv_utils, filter ]

inputs:
  in_sv:
    type: File
    label: sv information
  min_tumor_allele_frequency:
    type: double?
    label: removes if the tumor allele frequency is smaller than this value
    inputBinding:
      position: 1
      prefix: --min_tumor_allele_freq
  max_normal_read_pairs:
    type: int?
    label: removes if the number of variant read pairs in the normal sample exceeds this value
    inputBinding:
      position: 2
      # in the following context, 'control' denotes normal sample, not the control panel      
      prefix: --max_control_variant_read_pair
  normal_depth_threshold:
    type: double?
    label: removes if the normal read depth is smaller than this value
    inputBinding:
      position: 3
      # in the following context, 'control' denotes normal sample, not the control panel
      prefix: --control_depth_thres
  inversion_size_threshold:
    type: int?
    label: removes if the size of inversion is smaller than this value
    inputBinding:
      position: 4
      prefix: --inversion_size_thres
  min_overhang_size:
    type: int?
    label: removes if either of overhang sizes for two breakpoints is below this value
    inputBinding:
      position: 5
      prefix: --min_overhang_size
  remove_simple_repeat:
    # it seems that the latest version of sv_utils does not have this option. is it really necessary?
    type: boolean
    default: false
    inputBinding:
      position: 6

  # are there any additional parameters to be implemented?

outputs:
  out_sv:
    type: File
    outputBinding:
      glob: $(inputs.in_sv.nameroot).filt.txt
  log: stderr

stderr: $(inputs.in_sv.nameroot).filt.log
      
arguments:
  - position: 1
    valueFrom: $(inputs.in_sv.path)
  - position: 2
    valueFrom: $(inputs.in_sv.nameroot).filt.txt
