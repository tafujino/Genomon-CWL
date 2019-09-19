# frozen_string_literal: true

module Simulate
  class SVParse < AbstractCWLTest
    def initialize(read_name, job_path, deps = [])
      @read_name = read_name
      @job_path  = job_path
      super('simulate', 'sv', deps)
    end

    def define_task
      junction_path, improper_path = %w[junction improper].map do |type|
        @out_dir / "#{@read_name}.#{type}.clustered.bedpe.gz"
      end

      file junction_path => [@out_dir] + @dep_tasks do
        run(
          '../Workflows/sv-parse.cwl',
          @job_path
        )
      end

      file improper_path => junction_path
      file junction_path.sub_ext('.tbi') => junction_path
      file improper_path.sub_ext('.tbi') => improper_path

      desc 'sv-parse'
      final_task "sv_parse_#{@read_name}" => junction_path
    end
  end

  class SVParseTumor < SVParse
    def initialize(deps = [])
      super(
        'simulate_T',
        'simulate/Jobs/simulate_T-sv-parse.yaml',
      )
    end
  end

  class SVParseNormal < SVParse
    def initialize(deps = [])
      super(
        'simulate_N',
        'simulate/Jobs/simulate_N-sv-parse.yaml',
      )
    end
  end  
end
