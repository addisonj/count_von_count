require 'pathname'
require_relative "count_von_count/counter"
require_relative "count_von_count/stat"
require_relative "count_von_count/formatter"
module CountVonCount
  def self.new(path, code_paths=nil, test_paths=nil, no_default=false, format=:txt, output = nil)
    code_paths = code_paths || []
    test_paths = test_paths || []
    path = Pathname.new(path).realpath
    unless no_default
      code_paths = default_code_paths + code_paths
      test_paths = default_test_paths + test_paths
    end
    raise "No code paths given" if code_paths.empty?

    formatter = formatters[format].new(path, output)
    CountVonCount::Counter.new(path, code_paths, test_paths, formatter)
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
