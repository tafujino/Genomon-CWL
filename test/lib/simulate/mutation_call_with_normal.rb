# frozen_string_literal: true

module Simulate
  class MutationCallWithNormal < AbstractCWLTest
    def initialize(deps = [])
      super('simulate', 'mutation-call-with-normal', deps)
    end

    def define_task
      file @out_dir / 'genomon_mutation.result.filt.txt' =>
      @dep_tasks + [@out_dir / 'genomon_mutation.result.txt']

      file @out_dir / 'genomon_mutation.result.txt' => @outdir do
        run(
          '../Workflows/mutation-call-with-normal.cwl',
          'simulate/Jobs/simulate-mutation-call-with-normal.yaml'
        )
      end

      desc 'mutation-call'
      final_task :mutation_call_with_normal_without_control =>
                 @out_dir / 'genomon_mutation.result.filt.txt'

      desc 'validation'
      task 'mutation_call_with_normal_without_control:validate' =>
           :mutation_call_with_normal_without_control do
        validate(
          @out_dir / 'genomon_mutation.result.txt',
          '/home/fujino/data/genomon/_GRCh37/output/dna/mutation/tumor/tumor.genomon_mutation.result.txt'
        )
      end
    end

    # @param result_path [String]
    # @param comp_path   [String]
    def validate(result_path, comp_path)
      result = MutationMap.new('result', result_path)
      comp   = MutationMap.new('comp',   comp_path)
      result.regions.union(comp.regions).each do |region|
        next unless [result, comp].all? { |mut| mut.exists_value?(region) }

        compare_row(region, result[region], comp[region])
      end
    end

    # @param region [ChrRegion]
    # @param result [CSV::Row]
    # @param comp   [CSV::Row]
    def compare_row(region, row_result, row_comp)
      # the following fields in comp are not used for comparison:
      #   HGVD_20131010:#Sample
      #   HGVD_20131010:Filter
      #   HGVD_20131010:NR
      #   HGVD_20131010:NA
      #   HGVD_20131010:Frequency(NA/(NA+NR))
      [
        'Ref',
        'Alt',
        'depth_tumor',
        'variantNum_tumor',
        'depth_normal',
        'variantNum_normal',
        'bases_tumor',
        'bases_normal',
        'A_C_G_T_tumor',
        'A_C_G_T_normal',
        'misRate_tumor',
        'strandRatio_tumor',
        'misRate_normal',
        'strandRatio_normal',
        'P-value(fisher)',
        'score(hotspot)',
        'readPairNum_tumor',
        'variantPairNum_tumor',
        'otherPairNum_tumor',
        'readPairNum_normal',
        'variantPairNum_normal',
        'otherPairNum_normal',
        'P-value(fisher_realignment)',
        'indel_mismatch_count',
        ['indel_mismatch_rate', ->x { sprintf('%4.3f', x) }],
        'bp_mismatch_count',
        'distance_from_breakpoint',
        'simple_repeat_pos',
        'simple_repeat_seq',
        'HGVD_20160412:#Sample',
        'HGVD_20160412:Filter',
        'HGVD_20160412:NR',
        'HGVD_20160412:NA',
        'HGVD_20160412:Frequency(NA/(NA+NR))',
        'ExAC:Filter',
        'ExAC:AC_Adj',
        'ExAC:AN_Adj',
        'ExAC:Frequency(AC_Adj/AN_Adj)',
        'ExAC:AC_POPMAX',
        'ExAC:AN_POPMAX',
        'ExAC:Frequency(AC_POPMAX/AN_POPMAX)',
        'ExAC:POPMAX'
      ].each do |field, formatter|
        formatter ||= ->x { x }
        field_result = row_result[field]
        field_comp   = row_comp[field]
        next if formatter[field_result] == formatter[field_comp]

        puts "#{region}, #{field}, result = #{field_result}, comp = #{field_comp}"
      end
    end
  end
end
