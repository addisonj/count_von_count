require 'code_metrics/code_statistics'
module CountVonCount
  attr_accessor :path
  attr_accessor :code_paths
  attr_accessor :test_paths
  attr_accessor :all_dirs
  attr_accessor :all_dir_pairs

  class Counter
    def initialize(path, code_paths, test_paths, formatter)
      @path = path
      @code_paths = code_paths
      @test_paths = test_paths
      @formatter = formatter
      dirs = CodeMetrics::StatsDirectories.new
      code_paths.each do |cp|
        dirs.add_directories cp
      end
      test_paths.each do |tp|
        dirs.add_test_directories(tp, "spec")
      end
      @all_dir_pairs = dirs.directories
      @all_dirs = @aill_dir_pairs.map(&:last)
    end

    def run
      metrics = CodeMetrics::Statistics.new(*@all_dir_pairs)
      puts metrics.statistics
    end
  end
end
