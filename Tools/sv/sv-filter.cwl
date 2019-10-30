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
  - class: InitialWorkDirRequirement
    listing:
      # this is necessary since GenomonSV filt generates files in the mounted directory
      # inside the container
      - entry: $(inputs.directory)
        writable: true

inputs:
  tumor_bam:
    type: File
    format: edam:format_2572
    label: tumor sample BAM aligned to the reference
    secondaryFiles:
      - .bai
    inputBinding:
      position: 1
  tumor_name:
    type: string
    label: tumor sample name
  directory:
    type: Directory
    label: directory containing SV parse result. SV result is also generated here
  reference:
    type: File
    format: edam:format_1929
    label: FastA file for reference genome
    secondaryFiles:
      - .fai
    inputBinding:
      position: 3
  control_panel_bedpe:
    type: File?
    label: merged control panel. filename is usually XXX.merged.junction.control.bedpe.gz
    inputBinding:
      position: 4
      prefix: --non_matched_control_junction
  normal_bam:
    type: File?
    format: edam:format_2572
    label: tumor sample BAM aligned to the reference
    secondaryFiles:
      - .bai
    inputBinding:
      position: 5
      # in the following context, 'control' denotes normal sample, not the control panel      
      prefix: --matched_control_bam
  normal_name: # in the origial genomon_pipeline_cloud, this option is enabled only when control panel exists
    type: string?
    label: normal sample name
    inputBinding:
      position: 6
      prefix: --matched_control_label
  min_junctions:
    type: int?
    label: minimum required number of supporting junction read pairs
    inputBinding:
      position: 7
      prefix: --min_junc_num
  max_normal_read_pairs:
    type: int?
    label: maximum allowed number of read pairs in normal sample
    inputBinding:
      position: 8
      # in the following context, 'control' denotes normal sample, not the control panel          
      prefix: --max_control_variant_read_pair
  min_overhang_size:
    type: int?
    label: minimum region size arround each break-point which have to be covered by at least one aligned short read
    inputBinding:
      position: 9
      prefix: --min_overhang_size

  # 'annotation_dir' option is commented out in the current GenomonSV filt implementation
  # and not available

  # are there any additional parameters to be implemented?

outputs:
  out_sv:
    type: File
    outputBinding:
      # the following is the relative path from the staging directory.
      # 1. At staging, $(inputs.directory) is copied to the staging directory
      #    and made writable.
      # 2. GenomonSV filt output prefix = $(inputs.directory)
      # 3. Thus GenomonSV filt outputs the result into $(inputs.directory.basename)
      #    relative from the staging directory.
      glob: $(inputs.directory.basename)/$(inputs.tumor_name).genomonSV.result.txt
  log:
    type: stderr

stderr: $(inputs.tumor_name).genomonSV.result.log

arguments:
  - position: 2
    valueFrom: $(inputs.directory.path)/$(inputs.tumor_name)
