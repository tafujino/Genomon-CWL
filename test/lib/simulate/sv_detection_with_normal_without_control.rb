# frozen_string_literal: true

module Simulate
  class SVDetection < AbstractCWLTest
    def initialize(postfix, job_path, deps = [])
      @test_name = "sv-detection-#{postfix}"
      @job_path  = job_path
      super('simulate', 'sv', deps)
    end

    def define_task
      sv_path = @out_dir / 'simulate_T.genomonSV.filt.metadata.txt'
      
      file sv_path => [@out_dir] + @dep_tasks do
        run(
          '../Workflows/sv-detection-without-control.cwl',
          @job_path
        )
      end

      desc 'sv-detection'
      final_task @test_name.gsub(/-/, '_') => sv_path
    end
  end

  class SVDetectionWithNormalWithoutControl < SVDetection
    def initialize(deps = [])
      super(
        'with-normal-without-control',
        'simulate/Jobs/simulate-sv-detection-with-normal-without-control.yaml',
        deps)
    end
  end
end
