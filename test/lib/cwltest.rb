# frozen_string_literal: true

# @abstract
class AbstractCWLTest
  include Rake::DSL

  # @return [Rake::Task]
  attr_reader :final_tasks

  # @param sample   [String] sample name
  # @param workflow [String] workflow name
  # @param deps     [AbstractCWLTest, Array<AbstractCWLTest>] dependent tests
  def initialize(sample, workflow, deps = [])
    @sample      = sample
    @workflow    = workflow
    @out_dir     = Pathname.new("#{sample}/output/#{workflow}")
    deps         = [deps] unless deps.is_a?(Array)
    @dep_tasks   = deps.map(&:final_tasks).flatten
    @final_tasks = []
    namespace @sample do
      directory @out_dir
      define_task
    end
  end

  private

  def define_task
    raise NotImplementedError
  end

  # decompose { final task name => dependent task name(s) } into key and value
  # @param hash [Hash{ String => [String, Array<String>] }]
  # @return     [Array<String, [String, Array<String>]>]
  def resolve_hash(hash)
    if hash.is_a?(Hash)
      unless hash.keys.length == 1
        warn 'hash key should be single'
        exit 1
      end
      return hash.to_a.first
    else
      [hash, nil]
    end    
  end

  # @param hash [Hash{ String => [String, Array<String>] }]
  def final_task(hash)
    name, deps = resolve_hash(hash)
    deps = [deps] unless deps.is_a?(Array)
    task name => deps
    @final_tasks = deps.map { |dep| Rake::Task[dep] }
  end

  # @param workflow_path [Pathname]
  # @param job_path      [Pathname]
  def run(workflow_path, job_path)
    sh "cwltool --tmp-outdir-prefix tmp --singularity --outdir #{@out_dir} #{workflow_path} #{job_path}"
  end
end
