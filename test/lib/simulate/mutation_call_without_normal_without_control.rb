# frozen_string_literal: true

module Simulate
  class MutationCallWithoutNormalWithoutControl < AbstractCWLTest
    def initialize(deps = [])
      super('simulate', 'mutation-call-without-normal-without-control', deps)
    end

    def define_task
      file @out_dir / 'genomon_mutation.result.filt.txt' =>
      @dep_tasks + [@out_dir / 'genomon_mutation.result.txt']

      file @out_dir / 'genomon_mutation.result.txt' => @outdir do
        run(
          '../Workflows/mutation-call-without-normal-without-control.cwl',
          'simulate/Jobs/simulate-mutation-call-without-normal-without-control.yaml'
        )
      end

      desc 'mutation-call-with-normal-without-control'
      final_task :mutation_call_without_normal_without_control =>
                 @out_dir / 'genomon_mutation.result.filt.txt'
    end
  end
end
