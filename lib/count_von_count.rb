require 'pathname'
require_relative "count_von_count/counter"
require_relative "count_von_count/stat"
require_relative "count_von_count/formatter"
module CountVonCount
  def self.new(path, code_paths=[], test_paths=[], no_default=false, format=:txt, output = nil)
    path = Pathname.new(path)
    unless no_default
      code_paths = default_code_paths + code_paths
      test_paths = default_test_paths + test_paths
    end

    CountVonCount::Counter.new(path, code_paths, test_paths, formatters[format].new(path, output))
  end

  def self.default_code_paths
    return [
      "app/**/*.rb",
      "lib/**/*.rb"
    ]
  end

  def self.default_test_paths
    return [
      "spec/**/*_spec.rb"
    ]
  end

  def self.formatters
    {
      txt: CountVonCount::Formatters::Text,
      json: CountVonCount::Formatters::Json,
      yaml: CountVonCount::Formatters::Yaml
    }
  end
end
