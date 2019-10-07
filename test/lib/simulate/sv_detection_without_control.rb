# frozen_string_literal: true

module Simulate
  class SVDetection < AbstractCWLTest
    def initialize(postfix, job_path, deps = [])
      @test_name = "sv-detection-#{postfix}"
      @job_path  = job_path
      super('simulate', @test_name, deps)
    end

    def define_task
      # SV parse results are symlinked to the current working directory
      @dep_tasks.map! do |t|
        next t unless t.name =~ /\.bedpe\.gz(?:\.tbi)?$/
        file @out_dir / File.basename(t.name) => [t.name, @out_dir] do |u|
          File.symlink(File.absolute_path(u.prerequisites[0]), u.name)
        end
      end
      
      sv_path = @out_dir / 'simulate_T.genomonSV.result.metadata.filt.txt'

      file sv_path => [@out_dir] + @dep_tasks do
        run(
          "../Workflows/sv-detection.cwl",
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
        deps
      )
    end
  end

  class SVDetectionWithoutNormalWithoutControl < SVDetection
    def initialize(deps = [])
      super(
        'without-normal-without-control',
        'simulate/Jobs/simulate-sv-detection-without-normal-without-control.yaml',
        deps
      )
    end
  end
end
