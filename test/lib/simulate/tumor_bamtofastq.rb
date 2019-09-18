# frozen_string_literal: true

module Simulate
  class TumorBAMToFASTQ < AbstractCWLTest
    def initialize(deps = [])
      super('simulate', 'bwa-alignment', deps)
    end

    def define_task
      fq1_path, fq2_path = [1, 2].map do |i|
        @out_dir / "simulate_T.sequence#{i}.fastq"
      end

      file fq1_path => @dep_tasks do
        run(
          '../Workflows/bamtofastq.cwl',
          'simulate/Jobs/simulate_T-bamtofastq.yaml'
        )
      end

      file fq2_path => fq1_path

      desc 'bam2fastq'
      final_task :bamtofastq => [fq1_path, fq2_path]
    end
  end
end
