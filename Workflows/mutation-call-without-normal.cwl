#!/usr/bin/env cwl-runner

class: Workflow
id: mutation-call-without-normal-without-control
label: Calls mutations only with tumor samples
cwlVersion: v1.0

$namespaces:
  edam: http://edamontology.org/
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
  fisher_10_percent_posterior_quantile_threshold:
    type: double?
  fisher_interval_list:
    type: File?
    format: edam:data_3671
    label: pileup regions list
  fisher_samtools_params:
    type: string?
    label: SAMtools parameters given to GenomonFisher
  mutfilter_realignment_tumor_min_mismatch: # is it really needed?
    type: int?
  mutfilter_realignment_score_difference:
    type: int?
  mutfilter_realignment_window_size:
    type: int?
  mutfilter_realignment_max_depth:
    type: int?
  mutfilter_realignment_exclude_sam_flags:
    type: int?
  annotation_database_directory:
    type: Directory
    label: directory containing simpleRepeat.bed.gz, DBexome20160412.bed.gz and ExAC.r0.3.1.sites.vep.bed.gz
  HGVD_2016:
    # Use of this HGVD database is subject to compliance with the terms of use.
    # Please refer to the site below:
    # http://www.genome.med.kyoto-u.ac.jp/SnpDB/about.html
    type: boolean
    default: false
  EXAC:
    # Use of this ExAC database is subject to compliance with the terms of use.
    # Please refer to the site below:
    # http://exac.broadinstitute.org/faq
    type: boolean
    default: false
  meta:
    type: string
    label: "metadata. should begin with '#'"
  mutil_filter_post10q:
    type: double?
    label: 10% posterior quantile
  mutil_filter_realignment_post10q:
    type: double?
    label: realignment 10% posterior quantile
  mutil_filter_count:
    type: int?
    label: read count

steps:
  fisher:
    label: "Fisher's exact test"
    run: ../Tools/mutation-call/fisher-single.cwl
    in:
      reference: reference
      tumor: tumor
      min_depth: fisher_min_depth
      base_quality: fisher_base_quality
      min_variant_read: fisher_min_variant_read
      min_allele_freq: fisher_min_allele_freq
      10_percent_posterior_quantile_threshold: fisher_10_percent_posterior_quantile_threshold
      interval_list: fisher_interval_list
      samtools_params: fisher_samtools_params
    out: [out_mutation, log]

  mutfilter_realignment:
    label: Local realignment using blat. The candidate mutations are validated.
    run: ../Tools/mutation-call/mutfilter-realignment.cwl
    in:
      reference: reference
      in_mutation: fisher/out_mutation
      tumor: tumor
      tumor_min_mismatch: mutfilter_realignment_tumor_min_mismatch
      score_difference: mutfilter_realignment_score_difference
      window_size: mutfilter_realignment_window_size
      max_depth: mutfilter_realignment_max_depth
      exclude_sam_flags: mutfilter_realignment_exclude_sam_flags
      # currently number of threads cannot be specified
    out: [out_mutation, log]

  mutfilter_simplerepeat:
    label: Annotates if the candidate is on the simplerepeat
    run: ../Tools/mutation-call/mutfilter-simplerepeat.cwl
    in:
      in_mutation: mutfilter_realignment/out_mutation
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
        default: false
      control:
        default: false
      meta: meta

    out: [out_mutation, log]

  mutil_filter:
    run: ../Tools/mutation-call/mutil-filter.cwl
    in:
      in_mutation: annotation/out_mutation
      post10q: mutil_filter_post10q
      realignment_post10q: mutil_filter_realignment_post10q
      count: mutil_filter_count
    out:
      [out_mutation, log]

outputs:
  mutation:
    type: File
    format: edam:data_3671
    label: mutation call result
    outputSource: mutil_filter/out_mutation
  fisher_log:
    type: File
    outputSource: fisher/log
  mutfilter_realignment_log:
    type: File
    outputSource: mutfilter_realignment/log
  mutfilter_simplerepeat_log:
    type: File
    outputSource: mutfilter_simplerepeat/log
  mutil_filter_log:
    type: File
    outputSource: mutil_filter/log
