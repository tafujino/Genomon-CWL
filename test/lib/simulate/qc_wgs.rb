# frozen_string_literal: true

module Simulate
  class QCWGS < AbstractCWLTest
    def initialize(read_name, job_path, deps = [])
      @read_name = read_name
      @job_path  = job_path
      super('simulate', 'qc', deps)
    end

    def define_task
      qc_path = @out_dir / "#{@read_name}.coverage"

      file qc_path => [@out_dir] + @dep_tasks do
        run(
          "../Workflows/qc-wgs.cwl",
          @job_path
        )
      end

      desc 'qc-wgs'
      final_task "qc_wgs_#{@read_name}" => qc_path
    end
  end

  class QCWGSTumor < QCWGS
    def initialize(deps = [])
      super(
        'simulate_T',
        'simulate/Jobs/simulate_T-qc-wgs.yaml',
        deps
      )
    end
  end

  class QCWGSNormal < SVDetection
    def initialize(deps = [])
      super(
        'simulate_N',
        'simulate/Jobs/simulate_N-qc-wgs.yaml',
        deps
      )
    end
  end
end
