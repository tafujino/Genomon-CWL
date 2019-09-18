# frozen_string_literal: true

module Simulate
  class BWAAlignment < AbstractCWLTest
    def initialize(read_name, job_path, deps = [])
      @read_name = read_name
      @job_path  = job_path
      super('simulate', 'bwa-alignment', deps)
    end

    def define_task
      bam_path = @out_dir / "#{@read_name}.markdup.bam"

      file bam_path => [@out_dir] + @dep_tasks do
        run('../Workflows/bwa-alignment.cwl', @job_path)
      end

      desc 'bwa-alignment'
      final_task "bwa_alignment_#{@read_name}" => bam_path
    end
  end
  
  class BWAAlignmentTumor < BWAAlignment
    def initialize(deps = [])
      super(
        'simulate_T',
        'simulate/Jobs/simulate_T-bwa-alignment.yam',
        deps
      )
    end
  end

  class BWAAlignmentNormal < BWAAlignment
    def initialize(deps = [])
      super(
        'simulate_N',
        'simulate/Jobs/simulate_N-bwa-alignment.yaml',
        deps
      )
    end
  end
end
