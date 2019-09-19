#!/usr/bin/env cwl-runner

class: CommandLineTool
id: sv-filter-0.6.0rc1
label: filters and annotates candidate somatic structural variations
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/

hints:
  - class: DockerRequirement
    dockerPull: genomon/genomon_sv:0.1.0

baseCommand: [ GenomonSV, filt ]

requirements:
  InitialWorkDirRequirement:
    listing:
      # this is necessary since GenomonSV filt generates files in the mounted directory
      # inside the container
      - entry: $(inputs.directory)
        writable: true

inputs:
  tumor:
    type: File
    format: edam:format_2572
    label: tumor sample BAM aligned to the reference
    secondaryFiles:
      - .bai
  directory:
    type: Directory
    label: directory containing SV parse result. SV result is also generated here
  name:
    type: string
    label: tumor sample name
  reference:
    type: File
    format: edam:format_1929
    label: FastA file for reference genome
    secondaryFiles:
      - .fai
  normal:
    type: File?
    format: edam:format_2572
    label: tumor sample BAM aligned to the reference
    secondaryFiles:
      - .bai
    inputBinding:
      position: 1
      # in the following context, 'control' denotes normal sample, not the control panel      
      prefix: --matched_control_bam
  min_junctions:
    type: int?
    label: minimum required number of supporting junction read pairs
    inputBinding:
      position: 2
      prefix: --min_junc_num
  max_normal_read_pairs:
    type: int?
    label: maximum allowed number of read pairs in normal sample
    inputBinding:
      position: 3
      # in the following context, 'control' denotes normal sample, not the control panel          
      prefix: --max_control_variant_read_pair
  min_overhang_size:
    type: int?
    label: minimum region size arround each break-point which have to be covered by at least one aligned short read
    inputBinding:
      position: 4
      prefix: --min_overhang_size

  # 'annotation_dir' option is commented out in the current GenomonSV filt implementation
  # and not available

  # are there any additional parameters to be implemented?

outputs:
  out_sv:
    type: File
    outputBinding:
      glob: $(inputs.directory.basename)/$(inputs.name).genomonSV.result.txt
  log:
    type: stderr

stderr: $(inputs.name).genomonSV.result.log

arguments:
  - position: 1
    valueFrom: $(inputs.tumor)
  - position: 2
    valueFrom: $(inputs.directory.path)/$(inputs.name)
  - position: 3
    valueFrom: $(inputs.reference)
