#!/usr/bin/env cwl-runner

class: Workflow
id: mutation-call-with-normal-without-control
label: Calls mutations with both normal and tumor samples
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
    label: directory containing GRCh37_hotspot_database_v20170919.txt
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
  annotation_database_directory:
    type: Directory
    label: directory containing simpleRepeat.bed.gz, DBexome20160412.bed.gz and ExAC.r0.3.1.sites.vep.bed.gz
  HGVD_2016:
    type: boolean
    default: false
  EXAC:
    type: boolean
    default: false
  meta:
    type: string
    label: metadata. should begin with '#'
  mutil_filter_fisher_p_value:
    type: double?
    label: Fisher test P-value
  mutil_filter_realign_p_value:
    type: double?
    label: realignment Fisher test P-value
  mutil_filter_ebcall_p_value:
    type: double?
    label: EBCall P-value
  mutil_filter_tcount:
    type: int?
    label: read count of tumor
  mutil_filter_ncount:
    type: int?
    label: read count of normal
    
steps:
  fisher:
    label: Fisher's exact test
    run: ../Tools/mutation-call/fisher-comparison.cwl
    in:
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
    out: [out_mutation, log]

  # In GenomonHotspotcall, a tumor BAM is compared with a control BAM.
  # Here 'control BAM' corresponds to the normal BAM in Genomon mutation call,
  # not the control panel.
  hotspot:
    label: Identifies hotspot mutations
    run: ../Tools/mutation-call/hotspot.cwl
    in:
      tumor: tumor
      control: normal
      database_directory: hotspot_database_directory
      min_tumor_misrate: hotspot_min_tumor_misrate
      max_control_misrate: hotspot_max_control_misrate
      TN_ratio_control: hotspot_TN_ratio_control
      min_lod_score: hotspot_min_lod_score
      samtools_params: hotspot_samtools_params
    out: [out_mutation, log]

  fisher_with_hotspot:
    label: Merges hotspot information to Fisher's exact test result
    run: ../Tools/mutation-call/merge-fisher-hotspot.cwl
    in:
      hotspot_mutation: hotspot/out_mutation
      fisher_mutation: fisher/out_mutation
    out: [out_mutation, log]

  mutfilter_realignment:
    label: Local realignment using blat. The candidate mutations are validated.
    run: ../Tools/mutation-call/mutfilter-realignment.cwl
    in:
      reference: reference
      in_mutation: fisher_with_hotspot/out_mutation
      tumor: tumor
      normal: normal
      tumor_min_mismatch: mutfilter_realignment_tumor_min_mismatch
      normal_max_mismatch: mutfilter_realignment_normal_max_mismatch
      score_difference: mutfilter_realignment_score_difference
      window_size: mutfilter_realignment_window_size
      max_depth: mutfilter_realignment_max_depth
      exclude_sam_flags: mutfilter_realignment_exclude_sam_flags
      # currently number of threads cannot be specified
    out: [out_mutation, log]

  mutfilter_indel:
    label: Annotates if the candidate is near indel
    run: ../Tools/mutation-call/mutfilter-indel.cwl
    in:
      in_mutation: mutfilter_realignment/out_mutation
      normal: normal
      search_length: mutfilter_indel_search_length
      neighbor: mutfilter_indel_neighbor
      min_depth: mutfilter_indel_min_depth
      min_mismatch: mutfilter_indel_min_mismatch
      allele_frequency_threshold: mutfilter_indel_allele_frequency_threshold
      samtools_params: mutfilter_indel_samtools_params
    out: [out_mutation, log]

  mutfilter_breakpoint:
    label: Annotates if the candidate is near the breakpoint
    run: ../Tools/mutation-call/mutfilter-breakpoint.cwl
    in:
      in_mutation: mutfilter_indel/out_mutation
      normal: normal
      max_depth: mutfilter_breakpoint_max_depth
      min_clip_size: mutfilter_breakpoint_min_clip_size
      junction_num_threshold: mutfilter_breakpoint_junction_num_threshold
      mapq_threshold: mutfilter_breakpoint_mapq_threshold
      exclude_sam_flags: mutfilter_breakpoint_exclude_sam_flags
    out: [out_mutation, log]

  mutfilter_simplerepeat:
    label: Annotates if the candidate is on the simplerepeat
    run: ../Tools/mutation-call/mutfilter-simplerepeat.cwl
    in:
      in_mutation: mutfilter_breakpoint/out_mutation
      database_directory: annotation_database_directory
    out: [out_mutation, log]

  annotation:
    run: ../Tools/mutation-call/annotation.cwl
    in:
      in_mutation: mutfilter_simplerepeat/out_mutation
      database_directory: annotation_database_directory
      HGVD_2016: HGVD_2016
      EXAC: EXAC
      normal:
        default: true
      control:
        default: false
      meta: meta
      
    out: [out_mutation, log]

  mutil_filter:
    run: ../Tools/mutation-call/mutil-filter.cwl
    in:
      in_mutation: annotation/out_mutation
      database_directory: hotspot_database_directory
      fisher_p_value: mutil_filter_fisher_p_value
      realign_p_value: mutil_filter_realign_p_value
      ebcall_p_value: mutil_filter_ebcall_p_value
      tcount: mutil_filter_tcount
      ncount: mutil_filter_ncount
    out:
      [out_mutation, log]

outputs:
  mutation:
    type: File
    format: edam:format_3671
    label: mutation call result
    outputSource: annotation/out_mutation
  mutation_filtered:
    type: File
    format: edam:format_3671
    label: filtered mutation call result
    outputSource: mutil_filter/out_mutation
  fisher_log:
    type: File
    outputSource: fisher/log
  hotspot_log:
    type: File
    outputSource: hotspot/log
  fisher_with_hotspot_log:
    type: File
    outputSource: fisher_with_hotspot/log
  mutfilter_realignment_log:
    type: File
    outputSource: mutfilter_realignment/log
  mutfilter_indel_log:
    type: File
    outputSource: mutfilter_indel/log
  mutfilter_breakpoint_log:
    type: File
    outputSource: mutfilter_breakpoint/log
  mutfilter_simplerepeat_log:
    type: File
    outputSource: mutfilter_simplerepeat/log
  mutfilter_annotation_log:
    type: File
    outputSource: annotation/log
  mutil_filter_log:
    type: File
    outputSource: mutil_filter/log
