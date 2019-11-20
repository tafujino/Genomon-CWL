# frozen_string_literal: true

require 'yaml'

module Simulate
  class << self
    def register_param_file(path)
      @@param_file = path
    end

    def param
      @@param ||= YAML.load_file(@@param_file).with_indifferent_access
    end
  end
end
