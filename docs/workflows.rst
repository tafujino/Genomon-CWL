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
    - Type
    - Description
  * - bam
    - File (BAM)
    - 
  * - name
    - string
    - sample name

output parameters
^^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Type
    - Description
  * - fastq1
    - File (FASTQ)
    - the first pair FastQ extracted from the given BAM
  * - fastq2
    - File (FASTQ)
    - the second pair FastQ extracted from the given BAM
  * - single
    - File (Text)
    - single end reads
  * - orphan1
    - File (Text)
    - the first unmatched pair
  * - orphan2
    - File (Text)
    - the second unmatched pair
  * - summary
    - File (Text)
    - 

bwa-alignment
-------------

Aligns FASTQs to a reference, generates BAM, and removes duplicate entries

input parameters
^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Type
    - Description
  * - reference
    - File (FASTA)
    - FastA file for reference genome
  * - fastq1
    - File (FASTQ)
    - FastQ file from next-generation sequencers
  * - fastq2
    - File (FASTQ)
    - FastQ file from next-generation sequencers
  * - min_score
    - int
    - minimum score to output
  * - nthreads
    - int
    - number of cpu cores to be used for BWA MEM
  * - name
    - string
    - sample name

output parameters
^^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Type
    - Description
  * - markdupbam
    - File (BAM)
    - 
  * - bwa_mem_log
    - File
    - 
  * - sortbam_log
    - File
    - 
  * - metrics
    - File
    - 
  * - bammarkduplicates_log
    - File
    - 

mutation-call-with-normal
-------------------------

Calls mutations with both normal and tumor samples

input parameters
^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Type
    - Description
  * - reference
    - File (FASTA)
    - FastA file for reference genome
  * - tumor
    - File (BAM)
    - tumor sample BAM aligned to the reference
  * - normal
    - File (BAM)
    - normal sample BAM aligned to the reference
  * - fisher_min_depth
    - int?
    - the minimum depth
  * - fisher_base_quality
    - int?
    - base quality threshold
  * - fisher_min_variant_read
    - int?
    - the minimum variant read
  * - fisher_min_allele_freq
    - double?
    - the minimum amount of disease allele frequency
  * - fisher_max_allele_freq
    - double?
    - the maximum amount of control allele frequency
  * - fisher_p_value
    - double?
    - Fisher p-value threshold
  * - fisher_interval_list
    - File? (Text)
    - pileup regions list
  * - fisher_samtools_params
    - string?
    - SAMtools parameters given to GenomonFisher
  * - hotspot_database_directory
    - Directory
    - directory containing GRCh37_hotspot_database_v20170919.txt
  * - hotspot_min_tumor_misrate
    - double?
    - the minimum amount of tumor allele frequency
  * - hotspot_max_control_misrate
    - double?
    - the maximum amount of control allele frequency
  * - hotspot_TN_ratio_control
    - double?
    - the maximum value of the ratio between normal and tumor
  * - hotspot_min_lod_score
    - double?
    - the minimum lod score
  * - hotspot_samtools_params
    - string?
    - SAMtools parameters given to GenomonHotspotCall
  * - mutfilter_realignment_tumor_min_mismatch
    - int?
    - 
  * - mutfilter_realignment_normal_max_mismatch
    - int?
    - 
  * - mutfilter_realignment_score_difference
    - int?
    - 
  * - mutfilter_realignment_window_size
    - int?
    - 
  * - mutfilter_realignment_max_depth
    - int?
    - 
  * - mutfilter_realignment_exclude_sam_flags
    - int?
    - 
  * - mutfilter_indel_search_length
    - int?
    - 
  * - mutfilter_indel_neighbor
    - int?
    - 
  * - mutfilter_indel_min_depth
    - int?
    - 
  * - mutfilter_indel_min_mismatch
    - int?
    - 
  * - mutfilter_indel_allele_frequency_threshold
    - int?
    - 
  * - mutfilter_indel_samtools_params
    - string?
    - SAMtools parameters given to mutfilter indel
  * - mutfilter_breakpoint_max_depth
    - int?
    - 
  * - mutfilter_breakpoint_min_clip_size
    - int?
    - 
  * - mutfilter_breakpoint_junction_num_threshold
    - int?
    - 
  * - mutfilter_breakpoint_mapq_threshold
    - int?
    - 
  * - mutfilter_breakpoint_exclude_sam_flags
    - int?
    - 
  * - annotation_database_directory
    - Directory
    - directory containing simpleRepeat.bed.gz, DBexome20160412.bed.gz and ExAC.r0.3.1.sites.vep.bed.gz
  * - HGVD_2016
    - boolean
    - 
  * - EXAC
    - boolean
    - 
  * - meta
    - string
    - metadata. should begin with '#'
  * - mutil_filter_fisher_p_value
    - double?
    - Fisher test P-value
  * - mutil_filter_realign_p_value
    - double?
    - realignment Fisher test P-value
  * - mutil_filter_ebcall_p_value
    - double?
    - EBCall P-value
  * - mutil_filter_tcount
    - int?
    - read count of tumor
  * - mutil_filter_ncount
    - int?
    - read count of normal

output parameters
^^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Type
    - Description
  * - mutation
    - File (Text)
    - mutation call result
  * - mutation_filtered
    - File (Text)
    - filtered mutation call result
  * - fisher_log
    - File
    - 
  * - hotspot_log
    - File
    - 
  * - fisher_with_hotspot_log
    - File
    - 
  * - mutfilter_realignment_log
    - File
    - 
  * - mutfilter_indel_log
    - File
    - 
  * - mutfilter_breakpoint_log
    - File
    - 
  * - mutfilter_simplerepeat_log
    - File
    - 
  * - mutfilter_annotation_log
    - File
    - 
  * - mutil_filter_log
    - File
    - 

mutation-call-without-normal-without-control
--------------------------------------------

Calls mutations only with tumor samples

input parameters
^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Type
    - Description
  * - reference
    - File (FASTA)
    - FastA file for reference genome
  * - tumor
    - File (BAM)
    - tumor sample BAM aligned to the reference
  * - fisher_min_depth
    - int?
    - the minimum depth
  * - fisher_base_quality
    - int?
    - base quality threshold
  * - fisher_min_variant_read
    - int?
    - the minimum variant read
  * - fisher_min_allele_freq
    - double?
    - the minimum amount of disease allele frequency
  * - fisher_10_percent_posterior_quantile_threshold
    - double?
    - 
  * - fisher_interval_list
    - File? (Text)
    - pileup regions list
  * - fisher_samtools_params
    - string?
    - SAMtools parameters given to GenomonFisher
  * - mutfilter_realignment_tumor_min_mismatch
    - int?
    - 
  * - mutfilter_realignment_score_difference
    - int?
    - 
  * - mutfilter_realignment_window_size
    - int?
    - 
  * - mutfilter_realignment_max_depth
    - int?
    - 
  * - mutfilter_realignment_exclude_sam_flags
    - int?
    - 
  * - annotation_database_directory
    - Directory
    - directory containing simpleRepeat.bed.gz, DBexome20160412.bed.gz and ExAC.r0.3.1.sites.vep.bed.gz
  * - HGVD_2016
    - boolean
    - 
  * - EXAC
    - boolean
    - 
  * - meta
    - string
    - metadata. should begin with '#'
  * - mutil_filter_post10q
    - double?
    - 10% posterior quantile
  * - mutil_filter_realignment_post10q
    - double?
    - realignment 10% posterior quantile
  * - mutil_filter_count
    - int?
    - read count

output parameters
^^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Type
    - Description
  * - mutation
    - File (Text)
    - mutation call result
  * - fisher_log
    - File
    - 
  * - mutfilter_realignment_log
    - File
    - 
  * - mutfilter_simplerepeat_log
    - File
    - 
  * - mutil_filter_log
    - File
    - 

qc-wgs
------

QC for WGS data

input parameters
^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Type
    - Description
  * - bam
    - File (BAM)
    - sample BAM aligned to the reference
  * - name
    - string
    - sample name
  * - genome_size_file
    - File
    - 
  * - gap_text
    - File
    - 
  * - incl_bed_width
    - int?
    - bps for normalize incl_bed (bedtools shuffle -incl)
  * - i_bed_lines
    - int?
    - line number of target BED file
  * - i_bed_width
    - int?
    - bps par 1 line, number of target BED file
  * - samtools_params
    - string?
    - samtools parameters string
  * - coverage_text
    - string
    - coverage depth text separated with comma
  * - meta
    - string?
    - metadata. should begin with '#'

output parameters
^^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Type
    - Description
  * - result
    - File
    - 
  * - qc-bamstats_log
    - File
    - 
  * - qc-wgs_log
    - File
    - 
  * - qc-merge_log
    - File
    - 

sv-detection
------------

SV detection without control panels

input parameters
^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Type
    - Description
  * - tumor_bam
    - File (BAM)
    - tumor sample BAM aligned to the reference
  * - tumor_name
    - string
    - tumor sample name
  * - directory
    - Directory
    - directory containing SV parse result. SV detection result is also generated here
  * - reference
    - File (FASTA)
    - FastA file for reference genome
  * - control_panel_bedpe
    - File?
    - merged control panel. filename is usually XXX.merged.junction.control.bedpe.gz
  * - normal_bam
    - File? (BAM)
    - normal sample BAM aligned to the reference
  * - normal_name
    - string?
    - normal sample name
  * - sv_filter_min_junctions
    - int?
    - minimum required number of supporting junction read pairs
  * - sv_filter_max_normal_read_pairs
    - int?
    - maximum allowed number of read pairs in normal sample
  * - sv_filter_min_overhang_size
    - int?
    - minimum region size arround each break-point which have to be covered by at least one aligned short read
  * - meta
    - string
    - metadata. should begin with '#'
  * - sv_utils_filter_min_tumor_allele_frequency
    - double?
    - removes if the tumor allele frequency is smaller than this value
  * - sv_utils_filter_max_normal_read_pairs
    - int?
    - removes if the number of variant read pairs in the normal sample exceeds this value
  * - sv_utils_filter_normal_depth_threshold
    - double?
    - removes if the normal read depth is smaller than this value
  * - sv_utils_filter_inversion_size_threshold
    - int?
    - removes if the size of inversion is smaller than this value
  * - sv_utils_filter_min_overhang_size
    - int?
    - removes if either of overhang sizes for two breakpoints is below this value
  * - sv_utils_filter_remove_simple_repeat
    - boolean
    - 
  * - grc
    - boolean?
    - 

output parameters
^^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Type
    - Description
  * - sv
    - File
    - SV detection result
  * - sv_filter_log
    - File
    - 
  * - prepend-metadata_log
    - File
    - 
  * - sv_utils_filter_log
    - File
    - 

sv-merge
--------

merges non-matched control panel breakpoint-containing read pairs

input parameters
^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Type
    - Description
  * - control_info
    - File
    - tab-delimited file on non-matched control
  * - name
    - string
    - control panel name
  * - merge_check_margin_size
    - int?
    - 

output parameters
^^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Type
    - Description
  * - merge
    - File
    - merged breakpoint information file
  * - log
    - File
    - 

sv-parse
--------

Parses breakpoint-containing and improperly aligned read pairs

input parameters
^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Type
    - Description
  * - bam
    - File (BAM)
    - 
  * - name
    - string
    - sample name

output parameters
^^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1

  * - ID
    - Type
    - Description
  * - junction
    - File
    - 
  * - junction_index
    - File (tabix)
    - 
  * - improper
    - File
    - 
  * - improper_index
    - File (tabix)
    - 
  * - sv_parse_log
    - File
    - 

