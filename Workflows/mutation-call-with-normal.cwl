#!/usr/bin/env cwl-runner

class: Workflow
id: mutation-call-with-normal
label: Calls mutations with both normal and tumor samples
cwlVersion: v1.0

# DISCUSSIONS:
# - Should default values be given to input parameters?

$namespaces:
  edam: 'http://edamontology.org/'

inputs:
  name:
    type: string
    label: sample name
  reference:
    type: File
    format: edam:format_1929
    label: FastA file for reference genome
  tumor:
    type: File
    format: edam:format_2572
    label: tumor sample BAM aligned to the reference
    secondaryFiles:
      - .bai
  normal:
    type: File
    format: edam:format_2572
    label: normal sample BAM aligned to the reference
    secondaryFiles:
      - .bai
  fisher_min_depth:
    type: int?
    label: the minimum depth
  fisher_base_quality:
    type: int?
    label: base quality threshold
  fisher_min_variant_read:
    type: int?
    label: the minimum variant read
  fisher_min_allele_freq:
    type: double?
    label: the minimum amount of disease allele frequency
  fisher_max_allele_freq:
    type: double?
    label: the maximum amount of control allele frequency
  fisher_p_value:
    type: double?
    label: Fisher p-value threshold
  fisher_interval_list:
    type: File?
    format: edam:format_3671
    label: pileup regions list
  fisher_samtools_params:
    type: string?
    label: SAMtools parameters given to GenomonFisher
  hotspot_database_directory:
    type: Directory
    label: directory containing hotspot_mutations.txt
  hotspot_min_tumor_misrate:
    label: the minimum amount of tumor allele frequency
    type: double?
  hotspot_max_control_misrate:
    label: the maximum amount of control allele frequency
    type: double?
  hotspot_TN_ratio_control:
    label: the maximum value of the ratio between normal and tumor
    type: double?
  hotspot_min_lod_score:
    label: the minimum lod score
    type: double?
  hotspot_samtools_params:
    type: string?
    label: SAMtools parameters given to GenomonHotspotCall
  mutfilter_realignment_tumor_min_mismatch:
    type: int?
  mutfilter_realignment_normal_max_mismatch:
    type: int?
  mutfilter_realignment_score_difference:
    type: int?
  mutfilter_realignment_window_size:
    type: int?
  mutfilter_realignment_max_depth:
    type: int?
  mutfilter_realignment_exclude_sam_flags:
    type: int?
  mutfilter_indel_search_length:
    type: int?
  mutfilter_indel_neighbor:
    type: int?
  mutfilter_indel_min_depth:
    type: int?
  mutfilter_indel_min_mismatch:
    type: int?
  mutfilter_indel_allele_frequency_threshold:
    type: int?
  mutfilter_indel_samtools_params:
    type: string?
    label: SAMtools parameters given to mutfilter indel 
  mutfilter_breakpoint_max_depth:
    type: int?
  mutfilter_breakpoint_min_clip_size:
    type: int?
  mutfilter_breakpoint_junction_num_threshold:
    type: int?
  mutfilter_breakpoint_mapq_threshold:
    type: int?
  mutfilter_breakpoint_exclude_sam_flags:
    type: int?

steps:
  fisher:
    label: Fisher's exact test
    run: ../Tools/mutation-call-fisher-comparison.cwl
    in:
      name: name
      reference: reference
      tumor: tumor
      normal: normal
      min_depth: fisher_min_depth
      base_quality: fisher_base_quality
      min_variant_read: fisher_min_variant_read
      min_allele_freq: fisher_min_allele_freq
      max_allele_freq: fisher_max_allele_freq
      p_value: fisher_p_value
      interval_list: fisher_interval_list
      samtools_params: fisher_samtools_params
    out: [txt, log]

  # In GenomonHotspotcall, a tumor BAM is compared with a control BAM.
  # Here 'control BAM' corresponds to the normal BAM in Genomon mutation call,
  # not the control panel.
  hotspot:
    label: Identifies hotspot mutations
    run: ../Tools/mutation-call-hotspot.cwl
    in:
      name: name
      tumor: tumor
      control: normal
      database_directory: hotspot_database_directory
      min_tumor_misrate: hotspot_min_tumor_misrate
      max_control_misrate: hotspot_max_control_misrate
      TN_ratio_control: hotspot_TN_ratio_control
      min_lod_score: hotspot_min_lod_score
      samtools_params: hotspot_samtools_params
    out: [txt, log]

  fisher_with_hotspot:
    label: Merges hotspot information to Fisher's exact test result
    run: ../Tools/mutation-call-merge.cwl
    in:
      name: name
      hotspot: hotspot/txt
      fisher: fisher/txt
    out: [txt, log]

  mutfilter_realignment:
    label: Local realignment using blat. The candidate mutations are validated.
    run: ../Tools/mutation-call-mutfilter-realignment.cwl
    in:
      name: name
      reference: reference
      mutation: fisher_with_hotspot/txt
      tumor: tumor
      normal: normal
      tumor_min_mismatch: mutfilter_realignment_tumor_min_mismatch
      normal_max_mismatch: mutfilter_realignment_normal_max_mismatch
      score_difference: mutfilter_realignment_score_difference
      window_size: mutfilter_realignment_window_size
      max_depth: mutfilter_realignment_max_depth
      exclude_sam_flags: mutfilter_realignment_exclude_sam_flags
      # currently number of threads cannot be specified
    out: [txt, log]

  mutfilter_indel:
    label: Annotates if the candidate is near indel
    run: ../Tools/mutation-call-mutfilter-indel.cwl
    in:
      name: name
      mutation: mutfilter_realignment/txt
      normal: normal
      search_length: mutfilter_indel_search_length
      neighbor: mutfilter_indel_neighbor
      min_depth: mutfilter_indel_min_depth
      min_mismatch: mutfilter_indel_min_mismatch
      allele_frequency_threshold: mutfilter_indel_allele_frequency_threshold
      samtools_params: mutfilter_indel_samtools_params
    out: [txt, log]

  mutfilter_breakpoint:
    label: Annotates if the candidate is near the breakpoint
    run: ../Tools/mutation-call-mutfilter-breakpoint.cwl
    in:
      name: name
      mutation: mutfilter_indel/txt
      normal: normal
      max_depth: mutfilter_breakpoint_max_depth
      min_clip_size: mutfilter_breakpoint_min_clip_size
      junction_num_threshold: mutfilter_breakpoint_junction_num_threshold
      mapq_threshold: mutfilter_breakpoint_mapq_threshold
      exclude_sam_flags: mutfilter_breakpoint_exclude_sam_flags
    out: [txt, log]

outputs: []

