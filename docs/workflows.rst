Workflows
=========


biobambam-bamtofastq
--------------------

Extracts FASTQ from BAM

input parameters
^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Description
  * - bam
    - 
  * - name
    - sample name

output parameters
^^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Description
  * - fastq1
    - the first pair FastQ extracted from the given BAM
  * - fastq2
    - the second pair FastQ extracted from the given BAM
  * - single
    - single end reads
  * - orphan1
    - the first unmatched pair
  * - orphan2
    - the second unmatched pair
  * - summary
    - 

bwa-alignment
-------------

Aligns FASTQs to a reference, generates BAM, and removes duplicate entries

input parameters
^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Description
  * - reference
    - FastA file for reference genome
  * - fastq1
    - FastQ file from next-generation sequencers
  * - fastq2
    - FastQ file from next-generation sequencers
  * - min_score
    - minimum score to output
  * - nthreads
    - number of cpu cores to be used for BWA MEM
  * - name
    - sample name

output parameters
^^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Description
  * - markdupbam
    - 
  * - bwa_mem_log
    - 
  * - sortbam_log
    - 
  * - metrics
    - 
  * - bammarkduplicates_log
    - 

mutation-call-with-normal
-------------------------

Calls mutations with both normal and tumor samples

input parameters
^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Description
  * - reference
    - FastA file for reference genome
  * - tumor
    - tumor sample BAM aligned to the reference
  * - normal
    - normal sample BAM aligned to the reference
  * - fisher_min_depth
    - the minimum depth
  * - fisher_base_quality
    - base quality threshold
  * - fisher_min_variant_read
    - the minimum variant read
  * - fisher_min_allele_freq
    - the minimum amount of disease allele frequency
  * - fisher_max_allele_freq
    - the maximum amount of control allele frequency
  * - fisher_p_value
    - Fisher p-value threshold
  * - fisher_interval_list
    - pileup regions list
  * - fisher_samtools_params
    - SAMtools parameters given to GenomonFisher
  * - hotspot_database_directory
    - directory containing GRCh37_hotspot_database_v20170919.txt
  * - hotspot_min_tumor_misrate
    - the minimum amount of tumor allele frequency
  * - hotspot_max_control_misrate
    - the maximum amount of control allele frequency
  * - hotspot_TN_ratio_control
    - the maximum value of the ratio between normal and tumor
  * - hotspot_min_lod_score
    - the minimum lod score
  * - hotspot_samtools_params
    - SAMtools parameters given to GenomonHotspotCall
  * - mutfilter_realignment_tumor_min_mismatch
    - 
  * - mutfilter_realignment_normal_max_mismatch
    - 
  * - mutfilter_realignment_score_difference
    - 
  * - mutfilter_realignment_window_size
    - 
  * - mutfilter_realignment_max_depth
    - 
  * - mutfilter_realignment_exclude_sam_flags
    - 
  * - mutfilter_indel_search_length
    - 
  * - mutfilter_indel_neighbor
    - 
  * - mutfilter_indel_min_depth
    - 
  * - mutfilter_indel_min_mismatch
    - 
  * - mutfilter_indel_allele_frequency_threshold
    - 
  * - mutfilter_indel_samtools_params
    - SAMtools parameters given to mutfilter indel
  * - mutfilter_breakpoint_max_depth
    - 
  * - mutfilter_breakpoint_min_clip_size
    - 
  * - mutfilter_breakpoint_junction_num_threshold
    - 
  * - mutfilter_breakpoint_mapq_threshold
    - 
  * - mutfilter_breakpoint_exclude_sam_flags
    - 
  * - annotation_database_directory
    - directory containing simpleRepeat.bed.gz, DBexome20160412.bed.gz and ExAC.r0.3.1.sites.vep.bed.gz
  * - HGVD_2016
    - 
  * - EXAC
    - 
  * - meta
    - metadata. should begin with '#'
  * - mutil_filter_fisher_p_value
    - Fisher test P-value
  * - mutil_filter_realign_p_value
    - realignment Fisher test P-value
  * - mutil_filter_ebcall_p_value
    - EBCall P-value
  * - mutil_filter_tcount
    - read count of tumor
  * - mutil_filter_ncount
    - read count of normal

output parameters
^^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Description
  * - mutation
    - mutation call result
  * - mutation_filtered
    - filtered mutation call result
  * - fisher_log
    - 
  * - hotspot_log
    - 
  * - fisher_with_hotspot_log
    - 
  * - mutfilter_realignment_log
    - 
  * - mutfilter_indel_log
    - 
  * - mutfilter_breakpoint_log
    - 
  * - mutfilter_simplerepeat_log
    - 
  * - mutfilter_annotation_log
    - 
  * - mutil_filter_log
    - 

mutation-call-without-normal-without-control
--------------------------------------------

Calls mutations only with tumor samples

input parameters
^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Description
  * - reference
    - FastA file for reference genome
  * - tumor
    - tumor sample BAM aligned to the reference
  * - fisher_min_depth
    - the minimum depth
  * - fisher_base_quality
    - base quality threshold
  * - fisher_min_variant_read
    - the minimum variant read
  * - fisher_min_allele_freq
    - the minimum amount of disease allele frequency
  * - fisher_10_percent_posterior_quantile_threshold
    - 
  * - fisher_interval_list
    - pileup regions list
  * - fisher_samtools_params
    - SAMtools parameters given to GenomonFisher
  * - mutfilter_realignment_tumor_min_mismatch
    - 
  * - mutfilter_realignment_score_difference
    - 
  * - mutfilter_realignment_window_size
    - 
  * - mutfilter_realignment_max_depth
    - 
  * - mutfilter_realignment_exclude_sam_flags
    - 
  * - annotation_database_directory
    - directory containing simpleRepeat.bed.gz, DBexome20160412.bed.gz and ExAC.r0.3.1.sites.vep.bed.gz
  * - HGVD_2016
    - 
  * - EXAC
    - 
  * - meta
    - metadata. should begin with '#'
  * - mutil_filter_post10q
    - 10% posterior quantile
  * - mutil_filter_realignment_post10q
    - realignment 10% posterior quantile
  * - mutil_filter_count
    - read count

output parameters
^^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Description
  * - mutation
    - mutation call result
  * - fisher_log
    - 
  * - mutfilter_realignment_log
    - 
  * - mutfilter_simplerepeat_log
    - 
  * - mutil_filter_log
    - 

qc-wgs
------

QC for WGS data

input parameters
^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Description
  * - bam
    - sample BAM aligned to the reference
  * - name
    - sample name
  * - genome_size_file
    - 
  * - gap_text
    - 
  * - incl_bed_width
    - bps for normalize incl_bed (bedtools shuffle -incl)
  * - i_bed_lines
    - line number of target BED file
  * - i_bed_width
    - bps par 1 line, number of target BED file
  * - samtools_params
    - samtools parameters string
  * - coverage_text
    - coverage depth text separated with comma
  * - meta
    - metadata. should begin with '#'

output parameters
^^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Description
  * - result
    - 
  * - qc-bamstats_log
    - 
  * - qc-wgs_log
    - 
  * - qc-merge_log
    - 

sv-detection
------------

SV detection without control panels

input parameters
^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Description
  * - tumor_bam
    - tumor sample BAM aligned to the reference
  * - tumor_name
    - tumor sample name
  * - directory
    - directory containing SV parse result. SV detection result is also generated here
  * - reference
    - FastA file for reference genome
  * - control_panel_bedpe
    - merged control panel. filename is usually XXX.merged.junction.control.bedpe.gz
  * - normal_bam
    - normal sample BAM aligned to the reference
  * - normal_name
    - normal sample name
  * - sv_filter_min_junctions
    - minimum required number of supporting junction read pairs
  * - sv_filter_max_normal_read_pairs
    - maximum allowed number of read pairs in normal sample
  * - sv_filter_min_overhang_size
    - minimum region size arround each break-point which have to be covered by at least one aligned short read
  * - meta
    - metadata. should begin with '#'
  * - sv_utils_filter_min_tumor_allele_frequency
    - removes if the tumor allele frequency is smaller than this value
  * - sv_utils_filter_max_normal_read_pairs
    - removes if the number of variant read pairs in the normal sample exceeds this value
  * - sv_utils_filter_normal_depth_threshold
    - removes if the normal read depth is smaller than this value
  * - sv_utils_filter_inversion_size_threshold
    - removes if the size of inversion is smaller than this value
  * - sv_utils_filter_min_overhang_size
    - removes if either of overhang sizes for two breakpoints is below this value
  * - sv_utils_filter_remove_simple_repeat
    - 
  * - grc
    - 

output parameters
^^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Description
  * - sv
    - SV detection result
  * - sv_filter_log
    - 
  * - prepend-metadata_log
    - 
  * - sv_utils_filter_log
    - 

sv-merge
--------

merges non-matched control panel breakpoint-containing read pairs

input parameters
^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Description
  * - control_info
    - tab-delimited file on non-matched control
  * - name
    - control panel name
  * - merge_check_margin_size
    - 

output parameters
^^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Description
  * - merge
    - merged breakpoint information file
  * - log
    - 

sv-parse
--------

Parses breakpoint-containing and improperly aligned read pairs

input parameters
^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Description
  * - bam
    - 
  * - name
    - sample name

output parameters
^^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Description
  * - junction
    - 
  * - junction_index
    - 
  * - improper
    - 
  * - improper_index
    - 
  * - sv_parse_log
    - 

